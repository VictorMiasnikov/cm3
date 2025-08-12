MODULE TokenSupport;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Roland Baumann                                            *)

(** pk
    1.1
    1994/11/30 15:09:26
    TokenSupport.m3,v
# Revision 1.1  1994/11/30  15:09:26  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT BaseGraph;
IMPORT Token, TokenGraph, Symbol;


PROCEDURE SkipWhiteSpaceAndComment (graph: TokenGraph.T;
                                    token: Token.T;
                                    lang: Token.Language := Token.Language.M3):
  Token.T RAISES {} =
  <* FATAL BaseGraph.NodeNotInGraph *>

  CONST
    SkipSet = Symbol.KindSet{Symbol.Kind.WhiteSpace, Symbol.Kind.Comment};

  VAR t: Token.T;

  BEGIN
    t := token;
    REPEAT
      t := graph.getNextToken(t, lang);
    UNTIL ((t = NIL) OR (NOT (t.getKind() IN SkipSet)));
    RETURN t;
  END SkipWhiteSpaceAndComment;


PROCEDURE FindSymbolOfKind (graph: TokenGraph.T;
                            token: Token.T;
                            symb : Symbol.Kind;
                            lang : Token.Language := Token.Language.M3):
  Token.T RAISES {} =
  <* FATAL BaseGraph.NodeNotInGraph *>

  VAR t: Token.T;

  BEGIN
    t := token;
    REPEAT
      t := graph.getNextToken(t, lang);
    UNTIL ((t = NIL) OR (t.getKind() = symb));
    RETURN t;
  END FindSymbolOfKind;


PROCEDURE TextBetweenTokens (graph: TokenGraph.T; first, last: Token.T):
  TEXT =
  <* FATAL BaseGraph.NodeNotInGraph *>

  VAR t: TEXT;

  BEGIN
    WHILE ((first # last) AND (first.getKind()
                                 IN Symbol.KindSet{Symbol.Kind.Comment,
                                                   Symbol.Kind.WhiteSpace})) DO
      first := graph.getNextToken(first, Token.Language.M3);
    END;
    WHILE ((first # last)
             AND (last.getKind() IN Symbol.KindSet{Symbol.Kind.Comment,
                                                   Symbol.Kind.WhiteSpace})) DO
      last := graph.getPrevToken(last, Token.Language.M3);
    END;
    t := first.getText();
    WHILE (first # last) DO
      first := graph.getNextToken(first, Token.Language.M3);
      IF (first.getKind() # Symbol.Kind.Comment) THEN
        t := t & first.getText();
      END;
    END;
    RETURN t;
  END TextBetweenTokens;

BEGIN
END TokenSupport.
