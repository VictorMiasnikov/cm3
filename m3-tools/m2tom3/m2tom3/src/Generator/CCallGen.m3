MODULE CCallGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Kai Michael Degner                                        *)

(** pk
    1.1
    1994/11/30 15:04:45
    CCallGen.m3,v
# Revision 1.1  1994/11/30  15:04:45  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT BaseGraph, TokenGraph, SourceGraph;
IMPORT Token, TokenSupport;
IMPORT Symbol;
IMPORT ImportSupport;
IMPORT Text;


PROCEDURE HandleCCall (graph : SourceGraph.T;
                       anchor: SourceGraph.Anchor;
                       ccall : Token.T             ) =
  <* FATAL BaseGraph.NodeInGraph,
           BaseGraph.NodeNotInGraph,
           TokenGraph.NoAnchor,
           TokenGraph.NotInStream *>

  VAR token: Token.T;

  CONST
    M3 = Token.Language.M3;
    M2 = Token.Language.M2;

  BEGIN
    <* ASSERT Text.Equal(ccall.getText(),"CCALL") *>

    IF (Token.Usage.Decl IN ccall.getUsageSet()) THEN

      (* Delete import of CCALL from module SYSTEM *)
      ImportSupport.RemoveImport(graph, anchor, "SYSTEM", "CCALL");

      (* Insert Import of module CCall.*)
      ImportSupport.AddImport(graph, anchor, "CCALL");

      RETURN;
    END;

    (* Change syntax from CCALL("xyz",p1,..,pn) to CCALL.xyz (p1,..,pn) *)

    (* search '(' and replace with "." *)
    token := TokenSupport.SkipWhiteSpaceAndComment(graph, ccall);
    (* '(' *)
    token.removeLanguage(M3);
    WITH point = NEW(Token.T).init(Symbol.Kind.Period, ".",
                                   Token.LanguageSet{Token.Language.M3}) DO
      graph.appendToken(anchor, point, token);
    END;

    (* search '"xyz"' and replace with 'xyz' *)
    (* search only for modula 2 token because of inserted point above *)
    token := TokenSupport.SkipWhiteSpaceAndComment(graph, token, M2);
    (* '"xyz"' *)
    token.removeLanguage(M3);

    (* get identifier of called function (without '"') and insert new
       identifier token.*)

    WITH function = NEW(Token.T).init(
                      Symbol.Kind.Identifier,
                      Text.Sub(token.getText(), 1,
                               Text.Length(token.getText()) - 2),
                      Token.LanguageSet{Token.Language.M3}) DO
      graph.appendToken(anchor, function, token);
    END;

    (* If next token is a ',' replace it with '(' otherwise it must be a
       ')'.  In this case insert a missing '(' before it. *)
    token := TokenSupport.SkipWhiteSpaceAndComment(graph, token, M2);
    (* first ',' *)
    IF (token.getKind() = Symbol.Kind.Comma) THEN
      token.removeLanguage(M3);
    END;
    WITH lbracket = NEW(Token.T).init(Symbol.Kind.CLBracket, "(",
                                      Token.LanguageSet{Token.Language.M3}) DO
      graph.prependToken(anchor, lbracket, token);
    END;
  END HandleCCall;

BEGIN
END CCallGen.
