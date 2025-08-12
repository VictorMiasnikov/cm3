MODULE SyntaxGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Juergen Goebbels                                          *)

(** pk
    1.1
    1994/11/30 15:06:05
    SyntaxGen.m3,v
# Revision 1.1  1994/11/30  15:06:05  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT BaseGraph, TokenGraph, SourceGraph;
IMPORT UnitAnchor;
IMPORT Symbol, Token, Syntax;
IMPORT Text, Word;
IMPORT Message, ImportSupport, Standard;
IMPORT SyntaxSupport, TokenSupport, GeneratorSupport, IdentifierLinker;


VAR
  token    : Token.T;
  newToken : Token.T;
  tokenKind: Symbol.Kind;


(* deletes EXPORT statement *)
PROCEDURE DeleteExportStatement (graph: SourceGraph.T) =
  BEGIN
    TRY
      REPEAT
        token.removeLanguage(Token.Language.M3);
        token := graph.getNextToken(token, Token.Language.M2);
        tokenKind := token.getKind();
      UNTIL tokenKind = Symbol.Kind.Semicolon;
      token.removeLanguage(Token.Language.M3);
    EXCEPT
      BaseGraph.NodeNotInGraph =>
        Message.Write(token := token, code := Message.Code.GraphError);
    END;
  END DeleteExportStatement;


(* deletes FORWARD statement *)
PROCEDURE DeleteForwardStatement (graph: SourceGraph.T) =
  VAR helpToken: Token.T := token;

  BEGIN
    TRY
      REPEAT
        (* delete FORWARD and WhiteSpaces *)
        token.removeLanguage(Token.Language.M3);
        token := graph.getNextToken(token, Token.Language.M2);
        tokenKind := token.getKind();
      UNTIL (tokenKind = Symbol.Kind.Semicolon);
      helpToken := token;
      REPEAT
        (* delete backwards up to PROCEDURE *)
        helpToken := graph.getPrevToken(helpToken, Token.Language.M2);
        helpToken.removeLanguage(Token.Language.M3);
        tokenKind := helpToken.getKind();
      UNTIL (tokenKind = Symbol.Kind.Procedure);
      helpToken.removeLanguage(Token.Language.M3);
      REPEAT
        (* delete M3 token *)
        helpToken := graph.getNextToken(helpToken, Token.Language.M3);
        helpToken.removeLanguage(Token.Language.M3);
        tokenKind := helpToken.getKind();
      UNTIL (tokenKind = Symbol.Kind.Semicolon);
      helpToken.removeLanguage(Token.Language.M3);
    EXCEPT
      BaseGraph.NodeNotInGraph =>
        Message.Write(token := token, code := Message.Code.GraphError);
    END;
  END DeleteForwardStatement;


(* changes Cardinal to Word.T .  Inserts IMPORT WORD if necessary *)
PROCEDURE CardinalToWordT (graph : SourceGraph.T;
                           anchor: UnitAnchor.T;
                           token : Token.T        ) =
  BEGIN
    TRY
      ImportSupport.AddImport(graph, anchor, "Word");
      (* normal case: Word.T must be inserted after CARDINAL *)
      token.removeLanguage(Token.Language.M3);
      newToken :=
        NEW(Token.T).init(Symbol.Kind.Identifier, "Word.T", Token.M3Only);
      graph.appendToken(anchor, newToken, token);
    EXCEPT
      BaseGraph.NodeInGraph =>
        Message.Write(token := token, code := Message.Code.GraphError);
    | BaseGraph.NodeNotInGraph =>
        Message.Write(token := token, code := Message.Code.GraphError);
    | TokenGraph.NoAnchor => Message.Write(code := Message.Code.NoAnchor);
    | TokenGraph.NotInStream =>
        Message.Write(token := token, code := Message.Code.GraphError);
    END;
  END CardinalToWordT;


PROCEDURE ConvertCardinal (graph : SourceGraph.T;
                           anchor: UnitAnchor.T;
                           token : Token.T        ) =
  VAR
    c      : CHAR;
    num    : Word.T := 0;
    base   : Word.T := 10;
    numtext: Text.T;
  BEGIN
    (* if text is a character representation -> do nothing *)
    IF (Text.GetChar(token.getText(), 0) = '\'') THEN RETURN END;

    (* else if text contains an underscore -> literal is based M3 compiler
       reads based literals as Word (!) hence conversion is not
       necessary. *)
    IF (Text.FindChar(token.getText(), '_') >= 0) THEN RETURN END;

    (* store value as Word.T *)
    FOR i := 0 TO Text.Length(token.getText()) - 1 DO
      c := Text.GetChar(token.getText(), i);
      num := Word.Plus(Word.Times(base, num), Word.Minus(ORD(c), 48));
    END;

    (* base literal with '10_' if num>LAST(INTEGER) *)
    IF (Word.GT(num, LAST(INTEGER))) THEN
      numtext := "10_" & token.getText();
      token.removeLanguage(Token.Language.M3);
      TRY
        graph.appendToken(anchor,
                          NEW(Token.T).init(Symbol.Kind.IntegerConst,
                                            numtext, Token.M3Only), token);
      EXCEPT
        BaseGraph.NodeInGraph =>
          Message.Write(token := token, code := Message.Code.GraphError);
      | BaseGraph.NodeNotInGraph =>
          Message.Write(token := token, code := Message.Code.GraphError);
      | TokenGraph.NoAnchor =>
          Message.Write(code := Message.Code.NoAnchor);
      | TokenGraph.NotInStream =>
          Message.Write(token := token, code := Message.Code.GraphError);
      END;
    END;
  END ConvertCardinal;


PROCEDURE CheckIdentifier (graph : SourceGraph.T;
                           anchor: UnitAnchor.T;
                           token : Token.T        ) =
  VAR
    name               : TEXT;
    typeName           : TEXT     := "No_Type";
    helpToken, newToken: Token.T  := NIL;
    type               : Symbol.T := NIL;
    parent             : Syntax.T := NIL;
    symbol             : Symbol.T := NIL;

  BEGIN
    TRY
      name := token.getText();
      IF ((Token.Language.M3 IN token.getLanguages())
            AND Text.Equal(name, "TSIZE")) THEN
        (* changes "TSIZE" to "BYTESIZE" *)
        token.removeLanguage(Token.Language.M3);
        newToken := NEW(Token.T).init(
                      Symbol.Kind.Identifier, "BYTESIZE", Token.M3Only);
        graph.appendToken(anchor, newToken, token);
      ELSIF (Text.Equal(name, "SIZE")) THEN
        (* changes "SIZE" to "BYTESIZE" *)
        token.removeLanguage(Token.Language.M3);
        newToken := NEW(Token.T).init(
                      Symbol.Kind.Identifier, "BYTESIZE", Token.M3Only);
        graph.appendToken(anchor, newToken, token);
      ELSIF (Text.Equal(name, "CARDINAL")) THEN
        (* changes Cardinal to Word.T .  Inserts IMPORT WORD if
           necessary *)
        CardinalToWordT(graph, anchor, token);
      ELSIF (Text.Equal(name, "SHORTCARD")) THEN
        (* import from SYSTEM *)
        ImportSupport.AddImport(graph, anchor, "SYSTEM", "SHORTCARD");
      ELSIF (Text.Equal(name, "SHORTINT")) THEN
        (* import from SYSTEM *)
        ImportSupport.AddImport(graph, anchor, "SYSTEM", "SHORTINT");
      ELSIF (Text.Equal(name, "BITSET")) THEN
        (* import from SYSTEM *)
        ImportSupport.AddImport(graph, anchor, "SYSTEM", "BITSET");
      ELSIF (Text.Equal(name, "MAX")) THEN
        (* changes "MAX" to "LAST" *)
        token.removeLanguage(Token.Language.M3);
        newToken :=
          NEW(Token.T).init(Symbol.Kind.Identifier, "LAST", Token.M3Only);
        graph.appendToken(anchor, newToken, token);
      ELSIF (Text.Equal(name, "MIN")) THEN
        (* changes "MIN" to "FIRST" *)
        token.removeLanguage(Token.Language.M3);
        newToken :=
          NEW(Token.T).init(Symbol.Kind.Identifier, "FIRST", Token.M3Only);
        graph.appendToken(anchor, newToken, token);
      ELSIF (Text.Equal(name, "HIGH")) THEN
        (* changes "HIGH" to "LAST" *)
        token.removeLanguage(Token.Language.M3);
        newToken :=
          NEW(Token.T).init(Symbol.Kind.Identifier, "LAST", Token.M3Only);
        graph.appendToken(anchor, newToken, token);
      ELSIF (Text.Equal(name, "ODD")) THEN
        (* import "ODD" from "SYSTEM" *)
        ImportSupport.AddImport(graph, anchor, "SYSTEM", "ODD");
      ELSIF (Text.Equal(name, "HALT")) THEN
        (* Import Halt-Procedure from System *)
        ImportSupport.AddImport(graph, anchor, "SYSTEM", "HALT");
      ELSIF (Text.Equal(name, "NEW") OR Text.Equal(name, "DISPOSE")) THEN
        token.removeLanguage(Token.Language.M3);
        IF (Text.Equal(name, "NEW")) THEN
          newToken := NEW(Token.T).init(
                        Symbol.Kind.Identifier, "ALLOCATE", Token.M3Only);
        ELSE
          newToken :=
            NEW(Token.T).init(
              Symbol.Kind.Identifier, "DEALLOCATE", Token.M3Only);
        END;
        graph.appendToken(anchor, newToken, token);
        helpToken := TokenSupport.SkipWhiteSpaceAndComment(
                       graph, token, Token.Language.M2);
        IF (helpToken.getKind() = Symbol.Kind.LBracket) THEN
          graph.prependToken(
            anchor, NEW(Token.T).init(
                      Symbol.Kind.GenText, "(LOOPHOLE", Token.M3Only),
            helpToken);
          helpToken := TokenSupport.SkipWhiteSpaceAndComment(
                         graph, helpToken, Token.Language.M2);
          IF ((helpToken # NIL)
                AND (helpToken.getKind() = Symbol.Kind.Identifier)) THEN
            type := IdentifierLinker.FindTypeOfAppl(graph, helpToken);
            IF (type # NIL) THEN
              type := IdentifierLinker.FindRealType(graph, type);
              IF (type # NIL) THEN
                type := IdentifierLinker.FindTypeOfType(graph, type);
                IF (type # NIL) THEN
                  symbol := IdentifierLinker.FindTypeName(graph, type);
                END;
              END;
            END;
            IF (symbol # NIL) THEN
              typeName := GeneratorSupport.GetTextOfType(graph, symbol);
            ELSE
              IF (type # NIL) THEN
                typeName :=
                  TokenSupport.TextBetweenTokens(
                    graph, SyntaxSupport.FindLeftmostToken(graph, type),
                    SyntaxSupport.FindRightmostToken(graph, type));
              ELSE
                typeName := "NoType";
              END;
            END;
          END;

          parent := graph.getParentSyntax(helpToken);
          WHILE (parent.getKind() # Symbol.Kind.SyntaxActualParameters) DO
            parent := graph.getParentSyntax(parent);
          END;
          WITH bracket = graph.getChildSymbol(
                           parent, 3, Symbol.Kind.RBracket) DO
            graph.prependToken(
              anchor, NEW(Token.T).init(Symbol.Kind.GenText,
                                        ",ADDRESS),BYTESIZE(" & typeName
                                          & ")", Token.M3Only),
              NARROW(bracket, Token.T));
          END;
        END;
      ELSIF (Text.Equal(name, "ALLOCATE") OR Text.Equal(name, "DEALLOCATE")) THEN
        helpToken := TokenSupport.SkipWhiteSpaceAndComment(
                       graph, token, Token.Language.M2);
        IF (helpToken.getKind() = Symbol.Kind.LBracket) THEN
          graph.prependToken(
            anchor, NEW(Token.T).init(
                      Symbol.Kind.GenText, "(LOOPHOLE", Token.M3Only),
            helpToken);
          parent := graph.getParentSyntax(
                      helpToken, Symbol.Kind.SyntaxActualParameters);
          parent :=
            graph.getChildSymbol(parent, 2, Symbol.Kind.SyntaxExprSeqOpt);
          parent :=
            graph.getChildSymbol(parent, 2, Symbol.Kind.SyntaxExprList);
          WITH comma = graph.getChildSymbol(parent, 1, Symbol.Kind.Comma) DO
            graph.prependToken(
              anchor, NEW(Token.T).init(
                        Symbol.Kind.GenText, ",ADDRESS)", Token.M3Only),
              NARROW(comma, Token.T));
          END;
        END;
      ELSIF (TestReservedWord(name)) THEN
        (* rename token if it's a reserved word in Modula-3 *)
        token.renameText("m2tom3_" & name);
      END;

      (* check for type-conversion *)
      helpToken := graph.getDeclOfAppl(token);
      (* Is the identifier a type ? *)
      IF (((helpToken # NIL)
             AND (graph.getParentSyntax(helpToken).getKind()
                    = Symbol.Kind.SyntaxTypeDeclarationList))
            OR Standard.IsPredefinedType(graph, token)) THEN
        helpToken := TokenSupport.SkipWhiteSpaceAndComment(
                       graph, token, Token.Language.M2);
        (* is it a typecast ? *)
        IF (helpToken.getKind() = Symbol.Kind.LBracket) THEN
          (* was token changed earlier ?  cardinal -> word.T *)
          IF (NOT (Token.Language.M3 IN token.getLanguages())) THEN
            token := TokenSupport.SkipWhiteSpaceAndComment(
                       graph, token, Token.Language.M3);
            name := token.getText();
          END;
          token.removeLanguage(Token.Language.M3);
          graph.appendToken(
            anchor, NEW(Token.T).init(
                      Symbol.Kind.Identifier, "LOOPHOLE", Token.M3Only),
            token);
          (* goto closing bracket of typecast *)
          token := graph.getChildSymbol(graph.getParentSyntax(helpToken),
                                        3, Symbol.Kind.RBracket);
          graph.prependToken(
            anchor,
            NEW(Token.T).init(Symbol.Kind.Comma, ",", Token.M3Only), token);
          graph.prependToken(
            anchor,
            NEW(Token.T).init(Symbol.Kind.Identifier, name, Token.M3Only),
            token);
        END;
      END;
    EXCEPT
      BaseGraph.NodeInGraph =>
        Message.Write(token := token, code := Message.Code.GraphError);
    | BaseGraph.NodeNotInGraph =>
        Message.Write(token := token, code := Message.Code.GraphError);
    | TokenGraph.NoAnchor => Message.Write(code := Message.Code.NoAnchor);
    | TokenGraph.NotInStream =>
        Message.Write(token := token, code := Message.Code.GraphError);
    END;
  END CheckIdentifier;


PROCEDURE AppendM3toM2Syntax (graph: SourceGraph.T; anchor: UnitAnchor.T) =
  BEGIN
    TRY
      (* remove ADR, ADDRESS and TSIZE from import list *)
      ImportSupport.RemoveImport(graph, anchor, "SYSTEM", "ADR");
      ImportSupport.RemoveImport(graph, anchor, "SYSTEM", "ADDRESS");
      ImportSupport.RemoveImport(graph, anchor, "SYSTEM", "TSIZE");
      token := graph.getFirstToken(anchor, Token.Language.M2);
      WHILE (token # NIL) DO
        tokenKind := token.getKind();
        CASE tokenKind OF
        | Symbol.Kind.Identifier => CheckIdentifier(graph, anchor, token);
        | Symbol.Kind.Forward => DeleteForwardStatement(graph);
        | Symbol.Kind.Export => DeleteExportStatement(graph);
        | Symbol.Kind.NEqual =>
            token.removeLanguage(Token.Language.M3);
            graph.prependToken(
              anchor,
              NEW(Token.T).init(Symbol.Kind.NEqual, "#", Token.M3Only),
              token);
        | Symbol.Kind.Not =>
            (* Make sure Symbol.Kind.Not is NOT, not ~ *)
            IF (Text.Equal(token.getText(), "~")) THEN
              token.removeLanguage(Token.Language.M3);
              graph.prependToken(
                anchor,
                NEW(Token.T).init(Symbol.Kind.Not, "NOT ", Token.M3Only),
                token);
            END;
        | Symbol.Kind.IntegerConst =>
            (* Change CARDINAL-Literals x > 2^31 - 1 to based
               INTEGER-Literal -2^32 + x *)
            ConvertCardinal(graph, anchor, token);
        ELSE
        END;
        token := graph.getNextToken(token, Token.Language.M2);
      END;
    EXCEPT
      BaseGraph.NodeInGraph =>
        Message.Write(token := token, code := Message.Code.GraphError);
    | BaseGraph.NodeNotInGraph =>
        Message.Write(token := token, code := Message.Code.GraphError);
    | TokenGraph.NoAnchor => Message.Write(code := Message.Code.NoAnchor);
    | TokenGraph.NotInStream =>
        Message.Write(token := token, code := Message.Code.GraphError);
    END;
  END AppendM3toM2Syntax;


CONST HashTableSize = 97;


TYPE
  HashTableIndex = [0 .. HashTableSize - 1];
  HashTableEntry = RECORD
                     used: BOOLEAN := FALSE;
                     id  : TEXT    := "";
                   END;


VAR table: ARRAY HashTableIndex OF HashTableEntry;


PROCEDURE InitHashTable () =
  PROCEDURE AddToHash (s: TEXT) =
    VAR h, d: HashTableIndex;

    BEGIN
      h := 0;
      FOR i := 0 TO Text.Length(s) - 1 DO
        h := (2 * h + ORD(Text.GetChar(s, i))) MOD HashTableSize;
      END;
      d := 1;
      WHILE table[h].used DO
        h := (h + d) MOD HashTableSize;
        d := d + 2;
      END;
      table[h] := HashTableEntry{used := TRUE, id := s};
    END AddToHash;

  (* InitHashTable *)
  BEGIN
    FOR i := 0 TO HashTableSize - 1 DO
      table[i].used := FALSE;
      table[i].id := "";
    END;
    AddToHash("ANY");
    AddToHash("AS");
    AddToHash("BITS");
    AddToHash("BRANDED");
    AddToHash("EVAL");
    AddToHash("EXCEPT");
    AddToHash("EXCEPTION");
    AddToHash("EXPORTS");
    AddToHash("FINALLY");
    AddToHash("GENERIC");
    AddToHash("INTERFACE");
    AddToHash("LOCK");
    AddToHash("LOOP");
    AddToHash("METHODS");
    AddToHash("OBJECT");
    AddToHash("OVERRIDES");
    AddToHash("RAISE");
    AddToHash("RAISES");
    AddToHash("READONLY");
    AddToHash("REF");
    AddToHash("REVEAL");
    AddToHash("ROOT");
    AddToHash("TRY");
    AddToHash("TYPECASE");
    AddToHash("UNTRACED");
    AddToHash("VALUE");
    AddToHash("ADRSIZE");
    AddToHash("BITSIZE");
    AddToHash("BYTESIZE");
    AddToHash("FIRST");
    AddToHash("ISTYPE");
    AddToHash("LAST");
    AddToHash("LOOPHOLE");
    AddToHash("MUTEX");
    AddToHash("NARROW");
    AddToHash("NULL");
    AddToHash("NUMBER");
    AddToHash("REFANY");
    AddToHash("SUBARRAY");
    AddToHash("TEXT");
    AddToHash("TYPECODE");
    AddToHash("SUBARRAY");
  END InitHashTable;


PROCEDURE TestReservedWord (name: TEXT): BOOLEAN =
  VAR h, d: HashTableIndex;

  BEGIN
    h := 0;
    FOR i := 0 TO Text.Length(name) - 1 DO
      h := (2 * h + ORD(Text.GetChar(name, i))) MOD HashTableSize;
    END;
    d := 1;
    WHILE (table[h].used AND (NOT Text.Equal(name, table[h].id))) DO
      h := (h + d) MOD HashTableSize;
      d := d + 2;
    END;
    RETURN table[h].used;
  END TestReservedWord;

BEGIN
  InitHashTable();
END SyntaxGen.
