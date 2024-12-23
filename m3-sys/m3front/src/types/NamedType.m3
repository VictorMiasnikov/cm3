(* Copyright (C) 1992, Digital Equipment Corporation           *)
(* All rights reserved.                                        *)
(* See the file COPYRIGHT for a full description.              *)

(* File: NamedType.m3                                          *)
(* Last modified on Tue Jul 19 10:05:49 PDT 1994 by kalsow     *)
(*      modified on Fri Dec 21 01:25:25 1990 by muller         *)

MODULE NamedType;

IMPORT M3, M3ID, Token, Type, TypeRep, Scanner, ObjectType;
IMPORT Error, Scope, Brand, Value, ErrType, Target;
IMPORT RTIO, RTParams;
FROM M3 IMPORT QID;

VAR debug := FALSE;

TYPE
  P = Type.T BRANDED "NamedType.T" OBJECT
        scope      : Scope.T := NIL;
        qid        : QID;
        type       : Type.T := NIL;
        obj        : Value.T := NIL;
      OVERRIDES
        check      := Check;
        no_straddle:= NoStraddle;
        isEqual    := TypeRep.NeverEqual;
        isSubtype  := TypeRep.NoSubtypes;
        compile    := Compiler;
        initCost   := InitCoster;
        initValue  := GenInit;
        mapper     := GenMap;
        gen_desc   := GenDesc;
        fprint     := FPrinter;
      END;

PROCEDURE Parse (): Type.T =
  TYPE TK = Token.T;
  VAR p: P;  t: Type.T;
      case := 0;
  BEGIN
    IF (Scanner.cur.token = TK.tIDENT)
      AND (Scanner.cur.defn # NIL)
      AND (Value.ClassOf (Scanner.cur.defn) = Value.Class.Type) THEN
      (* this identifier is reserved! *)
      t := Value.ToType (Scanner.cur.defn);
      Scanner.GetToken (); (* IDENT *)
      case := 1;
    ELSE
      case := 2;
      (* this is a non-reserved ID *)
      p := NEW (P);
      TypeRep.Init (p, Type.Class.Named);
      p.scope    := Scope.Top ();
      p.qid.item := Scanner.MatchID ();
      IF (Scanner.cur.token = TK.tDOT) THEN
        Scanner.GetToken (); (* . *)
        p.qid.module := p.qid.item;
        p.qid.item   := Scanner.MatchID ();
      END;
      t := p;
    END;

    case := case * 10;
 
    IF (Scanner.cur.token = TK.tBRANDED) THEN
      case := case + 1;
      t := ObjectType.Parse (t, FALSE, Brand.Parse ());
    ELSIF (Scanner.cur.token = TK.tOBJECT) THEN
      case := case + 2;
      t := ObjectType.Parse (t, FALSE, NIL);
    END;

    IF debug THEN
      RTIO.PutText ("NamedType.Parse t:");
      RTIO.PutRef (t);
      RTIO.PutText (" p:");
      RTIO.PutRef (p);
      RTIO.PutText (" ");
      RTIO.PutInt (case);
      RTIO.PutText (" ");
      IF p # NIL AND p.qid.module # 0 THEN
        RTIO.PutText (M3ID.ToText (p.qid.module));
        RTIO.PutText ("__");
      END;
      IF p # NIL AND p.qid.item # 0 THEN
        RTIO.PutText (M3ID.ToText (p.qid.item));
      END;
      RTIO.PutText ("\n");
      RTIO.Flush ();
    END;

    RETURN t;
  END Parse;

PROCEDURE New (t: Type.T): Type.T =
  VAR p: P;
  BEGIN
    p := NEW (P);
    TypeRep.Init (p, Type.Class.Named);
    p.type       := t;
    RETURN p;
  END New;

PROCEDURE Create (module, name: M3ID.T): Type.T =
  VAR p: P;
  BEGIN
    p := NEW (P);
    TypeRep.Init (p, Type.Class.Named);
    p.scope        := Scope.Top ();
    p.qid.module := module;
    p.qid.item   := name;
    RETURN p;
  END Create;

PROCEDURE Reduce (t: Type.T): P =
  BEGIN
    IF (t = NIL) THEN RETURN NIL END;
    IF (t.info.class # Type.Class.Named) THEN RETURN NIL END;
    RETURN t;
  END Reduce;

PROCEDURE Split (t: Type.T;  VAR name: QID): BOOLEAN =
  VAR p := Reduce (t);
  BEGIN
    IF (p = NIL) THEN RETURN FALSE END;
    Resolve (p);
    name := p.qid;
    RETURN TRUE;
  END Split;

PROCEDURE SplitV (t: Type.T;  VAR v: Value.T): BOOLEAN =
(* return V for Value *)
  VAR p := Reduce (t);
  BEGIN
    IF (p = NIL) THEN RETURN FALSE END;
    Resolve (p);
    v := p.obj;
    RETURN TRUE;
  END SplitV;

PROCEDURE Resolve (p: P) =
  VAR o: Value.T;  t: Type.T;  save: INTEGER;
  BEGIN
    IF (p.type = NIL) THEN
      o := Scope.LookUpQID (p.scope, p.qid);
      p.obj := o;
      IF (o = NIL) THEN
        save := Scanner.offset;
        Scanner.offset := p.origin;
        Error.QID (p.qid, "undefined");
        Scanner.offset := save;
        t := ErrType.T;
      ELSIF (Value.ClassOf (o) = Value.Class.Type) THEN
        t := Value.ToType (o);
        IF Target.Typenames THEN
          p.info.name := M3ID.Add (Value.GlobalName (o, dots := FALSE (*underscores instead*)));
        END;
      ELSE
        save := Scanner.offset;
        Scanner.offset := p.origin;
        Error.QID (p.qid, "name isn\'t bound to a type");
        Scanner.offset := save;
        t := ErrType.T;
      END;
      p.type := t;
    END;
  END Resolve;

PROCEDURE Strip (t: Type.T): Type.T =
  (* Identity, if t is not a named type. *)
  VAR p: P := Reduce (t);
  BEGIN
    IF p = NIL THEN RETURN t END;
    Resolve (p);
    RETURN p.type;
  END Strip;

PROCEDURE Check (p: P) =
  VAR cs := M3.OuterCheckState;  nErrs, nWarns, nErrsB: INTEGER;
      name := M3ID.NoID;
      type: Type.T := NIL;
  BEGIN
    Resolve (p);         (* Resolve can fill in name. *)
    name := p.info.name; (* Preserve name around Type.CheckInfo. *)
    nErrs := 0;  nErrsB := 0;
    IF (p.obj # NIL) THEN
      Error.Count (nErrs, nWarns);
      Value.TypeCheck (p.obj, cs);
      Error.Count (nErrsB, nWarns);
    END;
    IF (nErrs = nErrsB) THEN
      (* no errors yet... *)
      type := Type.CheckInfo (p.type, p.info);
    ELSE (* some sort of error (probably illegal recursion...) *)
      EVAL Type.CheckInfo (ErrType.T, p.info);
    END;
    p.info.class := Type.Class.Named; (* this node is still a Named node *)
    p.info.name  := name;
  END Check;

PROCEDURE
  NoStraddle (p: P;  offset: INTEGER; IsEltOrField: BOOLEAN): BOOLEAN =
  BEGIN
    Resolve (p);
    RETURN Type.StraddleFreeScalars (p.type, offset, IsEltOrField);
  END NoStraddle;

PROCEDURE Compiler (p: P) =
  BEGIN
    Resolve (p);
    (*** Type.Compile (p.type);  ***)
    IF (p.type # NIL) THEN
      Scanner.offset := p.type.origin;
      p.type.compile ();
    END;
  END Compiler;

PROCEDURE InitCoster (p: P;  zeroed: BOOLEAN): INTEGER =
  BEGIN
    Resolve (p);
    RETURN Type.InitCost (p.type, zeroed);
  END InitCoster;

PROCEDURE GenInit (p: P;  zeroed: BOOLEAN) =
  BEGIN
    Resolve (p);
    Type.InitValue (p.type, zeroed);
  END GenInit;

PROCEDURE GenMap (p: P;  offset, size: INTEGER;  refs_only: BOOLEAN) =
  BEGIN
    Resolve (p);
    Type.GenMap (p.type, offset, size, refs_only);
  END GenMap;

PROCEDURE GenDesc (p: P) =
  BEGIN
    Resolve (p);
    Type.GenDesc (p.type);
  END GenDesc;

PROCEDURE FPrinter (p: P;  VAR x: M3.FPInfo) =
  BEGIN
    Error.QID (p.qid, "INTERNAL ERROR: fingerprint of named type");
    Resolve (p);
    IF (p.type # NIL) THEN p.type.fprint (x); END;
  END FPrinter;

BEGIN
  debug := RTParams.IsPresent ("m3front-debug-namedtype");
END NamedType.
