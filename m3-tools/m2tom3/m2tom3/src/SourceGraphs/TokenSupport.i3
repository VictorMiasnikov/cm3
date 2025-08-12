INTERFACE TokenSupport;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Roland Baumann                                            *)

(** pk
    1.1
    1994/11/30 15:09:24
    TokenSupport.i3,v
# Revision 1.1  1994/11/30  15:09:24  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT TokenGraph, Token, Symbol;


PROCEDURE SkipWhiteSpaceAndComment (graph: TokenGraph.T;
                                    token: Token.T;
                                    lang: Token.Language := Token.Language.M3):
  Token.T RAISES {};
  (* SkipWhiteSpaceAndComment reads the next tokens from the token stream
     until it finds a token that is neither WhiteSpace nor Comment.  It
     skips at least the token given as argument so token #
     SkipWhiteSpaceAndComment(graph, token) always holds (except when token
     is NIL). *)


PROCEDURE FindSymbolOfKind (graph: TokenGraph.T;
                            token: Token.T;
                            symb : Symbol.Kind;
                            lang : Token.Language := Token.Language.M3):
  Token.T RAISES {};
  (* FindSymbolOfKind reads the next tokens of the token stream until it
     finds a token which has kind 'symb'.  It skips at least one token so
     again token # FindSymbolOfKind(graph, token, s) holds *)


PROCEDURE TextBetweenTokens (graph: TokenGraph.T; first, last: Token.T):
  TEXT;
  (* TextBetweenTokens delivers a text, that corresponds all of the text
     fields of the tokens betwenn and including first and last.  It skips
     comments and leading or trailing white space. *)

END TokenSupport.
