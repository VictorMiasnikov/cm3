MODULE ImportClosure;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Kai Michael Degner                                        *)

(** pk
    1.1
    1994/11/30 15:03:50
    ImportClosure.m3,v
# Revision 1.1  1994/11/30  15:03:50  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT SourceGraph;
IMPORT BaseGraph, MakeGraph, TokenGraph;
IMPORT UnitAnchor;
IMPORT SyntaxSupport;
IMPORT Syntax, Token, Symbol;


(** --- MakeImportClosure-------------------------------------------------------
  * This Procedure makes the transitive closure over all imports and
  * establishs a make order over all units.
  *
  * For further information on parameters see interface.
  *
  * Line of action:
  *
  * - If actual unit is no definition unit load the corresponding definition
  *   unit.
  * - Search all imports in actual unit. Call readUnit to read in the mising
  *   unit and call MakeImportClosure recursively to handle the unit.
  * - If all imports are treated, put the actual unit into the make order.
  *   It must be the last unit in make order.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE MakeImportClosure (graph   : SourceGraph.T;
                             unit    : SourceGraph.Anchor;
                             readUnit: ReadProc            ) RAISES ANY =

  (** --- IsImplementationModule -----------------------------------------------
    * Checks whether the unit given by it's anchor is a implementation module.
    * --------------------------------------------------------------------------
    **)
  PROCEDURE IsImplementationModule (graph: SourceGraph.T;
                                    unit : SourceGraph.Anchor): BOOLEAN =
    VAR symbol: Symbol.T;

    BEGIN
      symbol := graph.getChildSymbol(graph.getRoot(unit), 1);
      IF ((symbol = NIL)
            OR (symbol.getKind() # Symbol.Kind.SyntaxProgramModule)) THEN
        RETURN FALSE;
      END;

      RETURN (NARROW(graph.getChildSymbol(
                       symbol, 1, Symbol.Kind.SyntaxImplementationOpt),
                     Syntax.T).getNoOfChildren() > 0);
    END IsImplementationModule;


  (** --- FindFirstImport-------------------------------------------------------
    * Searches the first import of the given unit.
    * Returns the identifier of import unit or NIL if no import is needed.
    * --------------------------------------------------------------------------
    **)
  PROCEDURE FindFirstImport (graph: SourceGraph.T;
                             unit : SourceGraph.Anchor;
                             VAR iterator: SyntaxSupport.SyntaxTreeIterator;
                             VAR current: Syntax.T): Token.T =
    VAR
      root         : Syntax.T;
      symbol       : Symbol.T;
      numberOfChild: CARDINAL;

    BEGIN
      (* search first syntax node with kind Symbol.Kind.Syntax.ImportList
         to get entry point for a tree iterator*)
      root := graph.getRoot(unit); (* CompilationUnit *)
      symbol := graph.getChildSymbol(root, 1); (* DefinitionModule or
                                                  ProgrammModule *)

      IF (symbol.getKind() = Symbol.Kind.SyntaxDefinitionModule) THEN
        numberOfChild := 4;
      ELSE                       (* For numbers see rules *)
        numberOfChild := 3;      (* of copper - grammar *)
      END;

      symbol :=
        graph.getChildSymbol(NARROW(symbol, Syntax.T), numberOfChild);
      (* PublicScope or PrivateScope *)

      symbol := graph.getChildSymbol(NARROW(symbol, Syntax.T), 3);
      (* DefinitionScope or ProgramScope *)

      symbol := graph.getChildSymbol(NARROW(symbol, Syntax.T), 1,
                                     Symbol.Kind.SyntaxImportList);
      (* ImportList *)

      iterator :=
        NEW(SyntaxSupport.SyntaxTreeIterator).init(graph, symbol);

      WHILE ((symbol # NIL)
               AND (symbol.getKind() # Symbol.Kind.SyntaxQEntryScope)
               AND (symbol.getKind() # Symbol.Kind.SyntaxUEntryScope)) DO
        symbol := iterator.next();
      END;

      IF (symbol = NIL) THEN     (* empty import list *)
        current := NIL;
        RETURN NIL;
      END;

      current := NARROW(symbol, Syntax.T);

      RETURN NARROW(graph.getChildSymbol(
                      current, 1, Symbol.Kind.Identifier), Token.T);
    END FindFirstImport;


  (** --- FindNextImport--------------------------------------------------------
    * Searches for the next import.
    * Returns the identifier of import unit or NIL if no further import is
    * needed.
    * --------------------------------------------------------------------------
    **)
  PROCEDURE FindNextImport (graph   : SourceGraph.T;
                            iterator: SyntaxSupport.SyntaxTreeIterator;
                            VAR current: Syntax.T): Token.T =
    VAR symbol: Symbol.T;

    BEGIN
      CASE current.getKind() OF
      | Symbol.Kind.SyntaxQEntryScope, Symbol.Kind.SyntaxDAIdentList =>
          (* examine DAIdentList (Child of QEntryScope / DAIdentList) *)
          (* two calls of iterator.next() are necessary. *)
          (* see copper - grammar for information of rules. *)
          (* if current has kind DAIdentList a additional next is
             necessary. *)

          IF (current.getKind() = Symbol.Kind.SyntaxDAIdentList) THEN
            symbol := iterator.next();
          END;
          symbol := iterator.next();
          symbol := iterator.next();

          IF (NARROW(symbol, Syntax.T).getNoOfChildren() = 0) THEN
            (* empty DAIdentList => search next (Un)QualifiedImport *)
            WHILE ((symbol # NIL)
                     AND (symbol.getKind() # Symbol.Kind.SyntaxQEntryScope)
                     AND (symbol.getKind() # Symbol.Kind.SyntaxUEntryScope)) DO
              symbol := iterator.next();
            END;

            IF (symbol = NIL) THEN (* empty import list *)
              current := NIL;
              RETURN NIL;
            END;
          END;

      | Symbol.Kind.SyntaxUEntryScope =>
          (* this import complete handled. *)
          symbol := iterator.skip();
          WHILE ((symbol # NIL)
                   AND (symbol.getKind() # Symbol.Kind.SyntaxQEntryScope)
                   AND (symbol.getKind() # Symbol.Kind.SyntaxUEntryScope)) DO
            symbol := iterator.next();
          END;

          IF (symbol = NIL) THEN current := NIL; RETURN NIL; END;
      ELSE
      END;

      current := NARROW(symbol, Syntax.T);

      IF (current.getKind() = Symbol.Kind.SyntaxDAIdentList) THEN
        RETURN NARROW(graph.getChildSymbol(
                        current, 2, Symbol.Kind.Identifier), Token.T);
      ELSE
        RETURN NARROW(graph.getChildSymbol(
                        current, 1, Symbol.Kind.Identifier), Token.T);
      END;
    END FindNextImport;


  CONST
    isDefinition = TRUE;
    isNotWork    = FALSE;

  VAR
    import  : Token.T;
    newUnit : UnitAnchor.T;
    iterator: SyntaxSupport.SyntaxTreeIterator;
    current : Syntax.T;

  <* FATAL BaseGraph.NodeNotInGraph, MakeGraph.UnitInMakeOrder *>

  (* MakeImportClosure *)
  BEGIN
    IF (unit = NIL) THEN RAISE TokenGraph.NoAnchor; END;

    (* Check no definition unit *)
    IF (IsImplementationModule(graph, unit)) THEN
      (* Read in unit *)
      newUnit := readUnit(graph, unit.getName(), isDefinition, isNotWork);
      (* Treat unit only if read in *)
      IF (newUnit # NIL) THEN
        MakeImportClosure(graph, newUnit, readUnit);
      END;
    END;

    import := FindFirstImport(graph, unit, iterator, current);

    WHILE (import # NIL) DO

      (* Read in unit *)
      newUnit :=
        readUnit(graph, import.getText(), isDefinition, isNotWork);
      (* Treat unit only if read in *)
      IF (newUnit # NIL) THEN
        MakeImportClosure(graph, newUnit, readUnit);
      END;
      import := FindNextImport(graph, iterator, current);
    END;

    (* put unit in make order *)
    graph.appendMake(unit);
  END MakeImportClosure;

BEGIN
END ImportClosure.
