MODULE TokenGraph;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:09:21
    TokenGraph.m3,v
# Revision 1.1  1994/11/30  15:09:21  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- TokenGraph -------------------------------------------------------------
  * Assumptions about hashing
  *  edges: edges of same dynamic type have equal hash values
  *  nodes: no assumption
  * ----------------------------------------------------------------------------
  **)

IMPORT BaseGraph, BaseNode;
IMPORT Token, TokenEdge, TokenAnchor;


REVEAL
  T = Public BRANDED OBJECT
      OVERRIDES
        insertAnchor  := InsertAnchor;
        findAnchor    := FindAnchor;
        appendToken   := AppendToken;
        prependToken  := PrependToken;
        getFirstToken := GetFirstToken;
        getNextToken  := GetNextToken;
        getPrevToken  := GetPrevToken;
      END;


(* sample edge to minimize allocations *)
VAR sampleEdge := NEW(TokenEdge.T);


PROCEDURE InsertAnchor (self: T; anchor: TokenAnchor.T)
  RAISES {BaseGraph.NodeInGraph} =
  BEGIN
    (* insert anchor in graph *)
    self.insertNode(anchor);
  END InsertAnchor;


PROCEDURE FindAnchor (self: T; token: Token.T): TokenAnchor.T
  RAISES {BaseGraph.NodeNotInGraph} =
  <* FATAL BaseGraph.ResultNotUnique *>

  VAR prev: BaseNode.T;

  BEGIN
    IF (token = NIL) THEN RETURN NIL; END;
    prev := token;
    REPEAT                       (* Go to anchor in stream *)
      prev := self.getPrevNode(prev, sampleEdge);
    UNTIL ((prev = NIL) OR (TYPECODE(prev) # TYPECODE(token)));
    IF (prev = NIL) THEN
      RETURN NIL;
    ELSE
      RETURN NARROW(prev, TokenAnchor.T);
    END;
  END FindAnchor;


PROCEDURE AppendToken (self    : T;
                       anchor  : TokenAnchor.T;
                       token   : Token.T;
                       previous: Token.T        )
  RAISES {NoAnchor, BaseGraph.NodeInGraph, BaseGraph.NodeNotInGraph} =
  (* No test if previous belongs to the token stream pointed by anchor *)
  VAR
    prev, next: BaseNode.T;
    edge      : TokenEdge.T;

  BEGIN
    IF (anchor = NIL) THEN RAISE NoAnchor; END;
    IF (token = NIL) THEN RETURN; END;
    TRY
      self.insertNode(token);
      IF (previous = NIL) THEN   (* append token to all other tokens in
                                    stream *)
        prev := self.getPrevNode(anchor, sampleEdge);
        IF (prev = NIL) THEN     (* first token in stream *)
          self.insertEdge(NEW(TokenEdge.T), anchor, token);
          self.insertEdge(NEW(TokenEdge.T), token, anchor);
        ELSE
          (* No test for NIL necessary *)
          self.insertEdge(NEW(TokenEdge.T), token, anchor);
          self.insertEdge(NEW(TokenEdge.T), prev, token);
          edge := self.getEdge(prev, anchor);
          (* No test for NIL necessary *)
          self.deleteEdge(edge);
        END;
      ELSE
        (* append token to previous *)
        next := self.getNextNode(previous, sampleEdge);
        self.insertEdge(NEW(TokenEdge.T), previous, token);
        self.insertEdge(NEW(TokenEdge.T), token, next);
        edge := self.getEdge(previous, next);
        self.deleteEdge(edge);
      END;
    EXCEPT
      BaseGraph.EdgeNotInGraph, BaseGraph.EdgeInGraph,
          BaseGraph.ResultNotUnique => <*ASSERT FALSE *>
      (* Graph structure damaged *)
    END;
  END AppendToken;


PROCEDURE PrependToken (self  : T;
                        anchor: TokenAnchor.T;
                        token : Token.T;
                        follow: Token.T        )
  RAISES {NoAnchor, BaseGraph.NodeInGraph, BaseGraph.NodeNotInGraph} =
  VAR
    prev, next: BaseNode.T;
    edge      : TokenEdge.T;

  BEGIN
    IF (anchor = NIL) THEN RAISE NoAnchor; END;
    IF (token = NIL) THEN RETURN; END;
    TRY
      self.insertNode(token);
      IF (follow = NIL) THEN     (* insert token before all other tokens in
                                    stream *)
        next := self.getNextNode(anchor, sampleEdge);
        IF (next = NIL) THEN     (* first token in stream *)
          self.insertEdge(NEW(TokenEdge.T), anchor, token);
          self.insertEdge(NEW(TokenEdge.T), token, anchor);
        ELSE
          self.insertEdge(NEW(TokenEdge.T), token, next);
          self.insertEdge(NEW(TokenEdge.T), anchor, token);
          edge := self.getEdge(anchor, next);
          self.deleteEdge(edge);
        END;
      ELSE                       (* insert token before follow in stream *)
        prev := self.getPrevNode(follow, sampleEdge);
        edge := self.getEdge(prev, follow);
        self.insertEdge(NEW(TokenEdge.T), token, follow);
        self.insertEdge(NEW(TokenEdge.T), prev, token);
        self.deleteEdge(edge);
      END;
    EXCEPT
      BaseGraph.EdgeInGraph, BaseGraph.EdgeNotInGraph,
          BaseGraph.ResultNotUnique => <*ASSERT FALSE *>
      (* Graph structure damaged *)
    END;
  END PrependToken;


PROCEDURE GetFirstToken (self    : T;
                         anchor  : TokenAnchor.T;
                         language: Token.Language ): Token.T
  RAISES {NoAnchor, BaseGraph.NodeNotInGraph} =
  <* FATAL BaseGraph.ResultNotUnique *>
  VAR next: BaseNode.T;

  BEGIN
    IF (anchor = NIL) THEN RAISE NoAnchor; END;
    next := self.getNextNode(anchor, sampleEdge);
    WHILE (TYPECODE(next) # TYPECODE(anchor)) DO
      IF (next = NIL) THEN RETURN NIL; END;
      IF (language IN NARROW(next, Token.T).getLanguages()) THEN
        RETURN next;
      END;
      next := self.getNextNode(next, sampleEdge);
    END;
    RETURN NIL;
  END GetFirstToken;


PROCEDURE GetNextToken (self: T; source: Token.T; language: Token.Language):
  Token.T RAISES {BaseGraph.NodeNotInGraph} =
  <* FATAL BaseGraph.ResultNotUnique *>
  VAR next: BaseNode.T;

  BEGIN
    IF (source = NIL) THEN RETURN NIL; END;
    next := self.getNextNode(source, sampleEdge);
    WHILE (TYPECODE(next) = TYPECODE(source)) DO
      (* search next token with correct language, abort if no more tokens
         in stream *)
      IF (next = NIL) THEN RETURN NIL END;
      IF (language IN NARROW(next, Token.T).getLanguages()) THEN
        RETURN NARROW(next, Token.T);
      END;
      next := self.getNextNode(next, sampleEdge);
    END;
    RETURN NIL;
  END GetNextToken;


PROCEDURE GetPrevToken (self: T; source: Token.T; language: Token.Language):
  Token.T RAISES {BaseGraph.NodeNotInGraph} =
  <* FATAL BaseGraph.ResultNotUnique *>

  VAR prev: BaseNode.T;

  (* method is equal to GetNextToken *)
  BEGIN
    IF (source = NIL) THEN RETURN NIL; END;
    prev := self.getPrevNode(source, sampleEdge);
    WHILE TYPECODE(prev) = TYPECODE(source) DO
      IF (prev = NIL) THEN RETURN NIL; END;
      IF (language IN NARROW(prev, Token.T).getLanguages()) THEN
        RETURN NARROW(prev, Token.T);
      END;
      prev := self.getPrevNode(prev, sampleEdge);
    END;
    RETURN NIL;
  END GetPrevToken;

BEGIN
END TokenGraph.
