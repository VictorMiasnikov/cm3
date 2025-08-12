MODULE CopyTokenSubstream;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Peter Klein                                               *)

(** pk
    1.1
    1994/11/30 15:04:58
    CopyTokenSubstream.m3,v
# Revision 1.1  1994/11/30  15:04:58  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT SourceGraph, TokenGraph, BaseGraph, Syntax, Token, SyntaxSupport;


<* FATAL BaseGraph.NodeInGraph, BaseGraph.NodeNotInGraph,
         TokenGraph.NoAnchor, TokenGraph.NotInStream *>


PROCEDURE F (    graph         : SourceGraph.T;
                 anchor        : SourceGraph.Anchor;
                 syntax        : Syntax.T;
                 begin         : Token.T              := NIL;
                 end           : Token.T              := NIL;
             VAR insertionPoint: Token.T;
                 resetM3       : BOOLEAN                      ) =
  VAR fromToken: Token.T;

  BEGIN
    IF (syntax # NIL) THEN
      begin := SyntaxSupport.FindLeftmostToken(graph, syntax);
      end := SyntaxSupport.FindRightmostToken(graph, syntax);
    END;
    fromToken := begin;
    LOOP
      WITH newToken = NEW(Token.T).init(
                        fromToken.getKind(), fromToken.getText(),
                        fromToken.getLanguages(), fromToken.getUsageSet(),
                        fromToken.getLine()) DO
        graph.appendToken(anchor, newToken, insertionPoint);
        insertionPoint := newToken;
      END;
      IF (resetM3) THEN fromToken.removeLanguage(Token.Language.M3); END;
      IF (fromToken = end) THEN EXIT; END;
      fromToken := graph.getNextToken(fromToken, Token.Language.M3);
    END;
  END F;

BEGIN
END CopyTokenSubstream.
