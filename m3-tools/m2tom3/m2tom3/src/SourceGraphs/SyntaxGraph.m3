MODULE SyntaxGraph;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.2
    1995/02/14 12:17:04
    SyntaxGraph.m3,v
# Revision 1.2  1995/02/14  12:17:04  pk
# Some unnecessary exception handling removed.
#
# Revision 1.1  1994/11/30  15:08:56  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- SyntaxGraph ------------------------------------------------------------
  * Assumptions about hashing
  *  edges: edges of same dynamic type have equal hash values
  *  nodes: no assumption
  * ----------------------------------------------------------------------------
  **)

(* subsystem Sourcegraph *)
IMPORT BaseNode, BaseGraph, BaseEdge;
IMPORT Symbol;
IMPORT Token, TokenGraph;
IMPORT Syntax, SyntaxEdge, SyntaxAnchor;


REVEAL
  T = Public BRANDED OBJECT
      OVERRIDES
        insertSyntax     := InsertSyntax;
        insertSyntaxEdge := InsertSyntaxEdge;
        getChildSymbol   := GetChildSymbol;
        getParentSyntax  := GetParentSyntax;
        iterateChildren  := IterateChildren;
        setRoot          := SetRoot;
        getRoot          := GetRoot;
        findAnchor       := FindAnchor;
      END;


  ChildIterator = ChildIteratorPublic BRANDED OBJECT
                    current          : Symbol.T;
                    source           : Syntax.T;
                    graph            : T;
                    currentNo        : CARDINAL   := 1;
                    noOfFoundChildren: CARDINAL   := 0;
                  OVERRIDES
                    next := NextSymbol;
                  END;


(* sample edge to minimize allocations *)
VAR sampleEdge := NEW(SyntaxEdge.T).init(0);


PROCEDURE InsertSyntax (self: T; syntax: Syntax.T)
  RAISES {BaseGraph.NodeInGraph} =
  BEGIN
    IF (syntax = NIL) THEN RETURN; END;
    self.insertNode(syntax);
  END InsertSyntax;


PROCEDURE InsertSyntaxEdge (self  : T;
                            source: Syntax.T;
                            target: Symbol.T;
                            no    : CARDINAL  )
  RAISES {BaseGraph.EdgeInGraph, BaseGraph.NodeNotInGraph, NumberNotUnique} =
  VAR
    edge  : SyntaxEdge.T;
    symbol: Symbol.T;

  BEGIN
    (* test if edge with number no already exists *)
    symbol := self.getChildSymbol(source, no);
    IF (symbol # NIL) THEN RAISE NumberNotUnique; END;
    edge := NEW(SyntaxEdge.T).init(no);
    TRY                          (* test if syntaxnode has no incoming
                                    edges of type SyntaxEdge.T *)
      IF (self.getPrevNode(target, edge) # NIL) THEN
        RAISE BaseGraph.EdgeInGraph;
      END;
    EXCEPT
      BaseGraph.ResultNotUnique => RAISE BaseGraph.EdgeInGraph;
    END;
    self.insertEdge(edge, source, target);
    WITH noOfChildren = source.getNoOfChildren() DO
      source.setNoOfChildren(noOfChildren + 1);
    END;
  END InsertSyntaxEdge;


PROCEDURE GetChildSymbol (self        : T;
                          parent      : Syntax.T;
                          no          : CARDINAL;
                          expectedKind: Symbol.Kind): Symbol.T
  RAISES {BaseGraph.NodeNotInGraph} =
  (* Edge Predicate *)
  PROCEDURE hasNumber (edge: BaseEdge.T): BOOLEAN =
    BEGIN
      RETURN NARROW(edge, SyntaxEdge.T).getNo() = no;
    END hasNumber;

  <* FATAL BaseGraph.ResultNotUnique *>

  BEGIN
    sampleEdge.setNo(no);
    WITH result = self.getNextNode(parent, sampleEdge, hasNumber) DO
      IF ((expectedKind = Symbol.Kind.NoToken)
            OR (NARROW(result, Symbol.T).getKind() = expectedKind)) THEN
        RETURN result;
      END;
      RAISE BaseGraph.NodeNotInGraph;
    END;
  END GetChildSymbol;


PROCEDURE GetParentSyntax (self        : T;
                           child       : Symbol.T;
                           expectedKind: Symbol.Kind): Syntax.T
  RAISES {BaseGraph.NodeNotInGraph} =
  VAR result: BaseNode.T;

  <* FATAL BaseGraph.ResultNotUnique *>

  BEGIN
    result := self.getPrevNode(child, sampleEdge);
    IF ISTYPE(result, Syntax.T) THEN
      IF ((expectedKind # Symbol.Kind.NoToken)
            AND (expectedKind # NARROW(result, Symbol.T).getKind())) THEN
        RAISE BaseGraph.NodeNotInGraph;
      END;

      RETURN result;
    END;
    RETURN NIL;
  END GetParentSyntax;


PROCEDURE SetRoot (self: T; anchor: SyntaxAnchor.T; root: Syntax.T)
  RAISES {BaseGraph.NodeNotInGraph, BaseGraph.EdgeInGraph} =
  VAR edge: SyntaxEdge.T;

  BEGIN
    edge := NEW(SyntaxEdge.T).init(99);
    self.insertEdge(edge, anchor, root);
  END SetRoot;


PROCEDURE GetRoot (self: T; anchor: SyntaxAnchor.T): Syntax.T
  RAISES {BaseGraph.NodeNotInGraph} =
  PROCEDURE HasNumber (edge: BaseEdge.T): BOOLEAN =
    BEGIN
      RETURN (NARROW(edge, SyntaxEdge.T).getNo() = 99);
    END HasNumber;

  <* FATAL BaseGraph.ResultNotUnique *>

  BEGIN
    sampleEdge.setNo(99);
    RETURN self.getNextNode(anchor, sampleEdge, HasNumber);
  END GetRoot;


PROCEDURE IterateChildren (self: T; source: Syntax.T): ChildIterator =
  VAR iterator: ChildIterator;

  BEGIN
    iterator := NEW(ChildIterator);
    iterator.source := source;
    iterator.graph := self;
    RETURN iterator;
  END IterateChildren;


PROCEDURE NextSymbol (self: ChildIterator): Symbol.T =
  <* FATAL BaseGraph.NodeNotInGraph *>

  BEGIN
    IF (self.noOfFoundChildren < self.source.getNoOfChildren()) THEN
      REPEAT                     (* search for next child *)
        self.current :=
          self.graph.getChildSymbol(self.source, self.currentNo);
        INC(self.currentNo);
      UNTIL self.current # NIL;
      INC(self.noOfFoundChildren);
    ELSE
      RETURN NIL;
    END;
    RETURN self.current;
  END NextSymbol;


PROCEDURE FindAnchor (self: T; symbol: Symbol.T): SyntaxAnchor.T
  RAISES {BaseGraph.NodeNotInGraph} =
  <* FATAL BaseGraph.ResultNotUnique *>

  VAR result: BaseNode.T;

  BEGIN
    (* search up whithin the syntax tree *)
    result := self.getPrevNode(symbol, sampleEdge);
    WHILE ((result # NIL) AND ISTYPE(result, Syntax.T)) DO
      result := self.getPrevNode(result, sampleEdge);
    END;

    (* try the alternate way using the token stream *)
    IF ((result = NIL) AND ISTYPE(symbol, Token.T)) THEN
      result := NARROW(self, TokenGraph.T).findAnchor(symbol);
    END;

    RETURN NARROW(result, SyntaxAnchor.T);
  END FindAnchor;

BEGIN
END SyntaxGraph.
