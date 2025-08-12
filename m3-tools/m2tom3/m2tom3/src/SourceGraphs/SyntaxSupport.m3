MODULE SyntaxSupport;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Alexander Poensgen                                        *)

(** pk
    1.2
    1995/02/14 12:17:08
    SyntaxSupport.m3,v
# Revision 1.2  1995/02/14  12:17:08  pk
# Some unnecessary exception handling removed.
#
# Revision 1.1  1994/11/30  15:09:05  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT BaseGraph;
IMPORT Symbol;
IMPORT Token;
IMPORT SyntaxStack, Syntax, SyntaxGraph;


REVEAL
  SyntaxTreeIterator = SyntaxTreeIteratorPublic BRANDED OBJECT
                         graph  : SyntaxGraph.T;
                         current: Symbol.T;
                         stack  : SyntaxStack.T;
                       OVERRIDES
                         init := InitLeft;
                         next := TreeNextLeft;
                         skip := TreeSkipLeft;
                       END;


  RightMostIterator = RightMostIteratorPublic BRANDED OBJECT
                        graph  : SyntaxGraph.T;
                        current: Symbol.T;
                        stack  : SyntaxStack.T;
                      OVERRIDES
                        init := InitRight;
                        next := TreeNextRight;
                        skip := TreeSkipRight;
                      END;


(*
  --- SyntaxTreeIterator -------------------------------------------------------
*)
PROCEDURE InitLeft (self : SyntaxTreeIterator;
                    graph: SyntaxGraph.T;
                    node : Symbol.T            ): SyntaxTreeIterator =
  BEGIN
    self.graph := graph;
    self.current := node;
    self.stack := NEW(SyntaxStack.T).init();
    RETURN self;
  END InitLeft;


PROCEDURE TreeNextLeft (self: SyntaxTreeIterator): Symbol.T =
  <* FATAL ANY *>

  BEGIN
    IF (ISTYPE(self.current, Syntax.T)
          AND NARROW(self.current, Syntax.T).getNoOfChildren() > 0) THEN
      self.stack.push(self.current, 1);
      self.current :=
        self.graph.getChildSymbol(NARROW(self.current, Syntax.T), 1);
      RETURN self.current;
    ELSE
      RETURN self.skip();
    END;
  END TreeNextLeft;


PROCEDURE TreeSkipLeft (self: SyntaxTreeIterator): Symbol.T =
  <* FATAL ANY *>

  VAR
    oldval, number: CARDINAL;
    parent        : Symbol.T;

  BEGIN
    IF (self.stack.isEmpty()) THEN RETURN NIL; END;
    REPEAT
      self.stack.pop(parent, oldval);
      self.current := parent;
      number := NARROW(parent, Syntax.T).getNoOfChildren();
    UNTIL ((oldval < number)     (* search for next Subtree *)
             OR (self.stack.isEmpty()));
    (* tree finished *)
    IF (oldval < number) THEN
      self.current := self.graph.getChildSymbol(parent, oldval + 1);
      self.stack.push(parent, oldval + 1);
      RETURN self.current;
    END;
    RETURN NIL;
  END TreeSkipLeft;


(*
  --- RightMostIterator --------------------------------------------------------
*)
PROCEDURE InitRight (self : RightMostIterator;
                     graph: SyntaxGraph.T;
                     node : Symbol.T           ): RightMostIterator =
  BEGIN
    self.graph := graph;
    self.current := node;
    self.stack := NEW(SyntaxStack.T).init();
    RETURN self;
  END InitRight;


PROCEDURE TreeNextRight (self: RightMostIterator): Symbol.T =
  <* FATAL ANY *>

  BEGIN
    IF (ISTYPE(self.current, Syntax.T)
          AND NARROW(self.current, Syntax.T).getNoOfChildren() > 0) THEN
      WITH number = NARROW(self.current, Syntax.T).getNoOfChildren() DO
        self.stack.push(self.current, number);
        self.current := self.graph.getChildSymbol(
                          NARROW(self.current, Syntax.T), number);
      END;
      RETURN self.current;
    ELSE
      RETURN self.skip();
    END;
  END TreeNextRight;


PROCEDURE TreeSkipRight (self: RightMostIterator): Symbol.T =
  <* FATAL ANY *>

  VAR
    oldval: CARDINAL;
    parent: Symbol.T;

  BEGIN
    IF (self.stack.isEmpty()) THEN RETURN NIL; END;
    REPEAT
      self.stack.pop(parent, oldval);
      self.current := parent;
    UNTIL ((oldval > 1)          (* search for next Subtree *)
             OR (self.stack.isEmpty()));
    (* tree finished *)
    IF (oldval > 1) THEN
      self.current := self.graph.getChildSymbol(parent, oldval - 1);
      self.stack.push(parent, oldval - 1);
      RETURN self.current;
    END;
    RETURN NIL;
  END TreeSkipRight;


(*
  --- FindLeftMostToken --------------------------------------------------------
*)
PROCEDURE FindLeftmostToken (graph: SyntaxGraph.T; start: Syntax.T):
  Token.T =
  VAR child: Symbol.T;

  BEGIN
    WITH i = NEW(SyntaxTreeIterator).init(graph, start) DO
      child := i.next();
      WHILE ((child # NIL) AND (NOT (ISTYPE(child, Token.T)))) DO
        child := i.next();
      END;
      IF (child = NIL) THEN RETURN NIL; END;
      RETURN NARROW(child, Token.T);
    END;
  END FindLeftmostToken;


(*
  --- FindRightMostToken -------------------------------------------------------
*)
PROCEDURE FindRightmostToken (graph: SyntaxGraph.T; start: Syntax.T):
  Token.T =
  VAR child: Symbol.T;

  BEGIN
    WITH i = NEW(RightMostIterator).init(graph, start) DO
      child := i.next();
      WHILE ((child # NIL) AND (NOT (ISTYPE(child, Token.T)))) DO
        child := i.next();
      END;
      IF (child = NIL) THEN RETURN NIL; END;
      RETURN NARROW(child, Token.T);
    END;
  END FindRightmostToken;


(*
  --- FindPath -----------------------------------------------------------------
*)
PROCEDURE FindPath (         graph : SyntaxGraph.T;
                             actual: Symbol.T;
                    READONLY path  : ARRAY OF Symbol.Kind;
                    READONLY down  : BOOLEAN               ): Symbol.T
  RAISES {BaseGraph.NodeNotInGraph} =
  VAR
    hs     : Symbol.T := NIL;
    childnr: CARDINAL := 1;

  BEGIN
    IF (NUMBER(path) < 1) THEN RETURN actual; END;
    IF (down) THEN
      IF (ISTYPE(actual, Syntax.T)) THEN
        hs := graph.getChildSymbol(actual, childnr);
      END;
      WHILE ((hs # NIL) AND (hs.getKind() # path[0])) DO
        hs := graph.getChildSymbol(hs, childnr);
      END;
    ELSE
      hs := graph.getParentSyntax(actual);
      IF ((hs # NIL) AND (hs.getKind() # path[0])) THEN hs := NIL END;
    END;
    IF (hs # NIL) THEN
      RETURN
        FindPath(graph, hs, SUBARRAY(path, 1, NUMBER(path) - 1), down);
    ELSE
      RETURN NIL;
    END;
  END FindPath;

BEGIN
END SyntaxSupport.
