MODULE ParameterGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Thomas Stockheim                                          *)

(** pk
    1.1
    1994/11/30 15:05:44
    ParameterGen.m3,v
# Revision 1.1  1994/11/30  15:05:44  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT BaseGraph;
IMPORT Symbol;
IMPORT Token, TokenGraph, TokenSupport;
IMPORT Syntax;
IMPORT SourceGraph;


(** --- InserParentheses -------------------------------------------------------
  * In Modula 2, a procedure call doesn't need brackets if no arguments are
  * given, in Modula 3, they allways have to be used.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE InsertParentheses (graph : SourceGraph.T;
                             anchor: SourceGraph.Anchor;
                             syntax: Syntax.T            ) =
  <* FATAL BaseGraph.NodeNotInGraph, BaseGraph.NodeInGraph,
  TokenGraph.NoAnchor, TokenGraph.NotInStream *>

  VAR
    token, oldToken      : Token.T;
    runSyntax, designator: Syntax.T;

  BEGIN
    designator :=
      graph.getChildSymbol(syntax, 1, Symbol.Kind.SyntaxDesignator);
    runSyntax :=
      graph.getChildSymbol(syntax, 2, Symbol.Kind.SyntaxAssignmentOrCall);
    runSyntax := graph.getChildSymbol(runSyntax, 1);
    IF (runSyntax.getKind() = Symbol.Kind.SyntaxActualParametersOpt) THEN
      IF (graph.getChildSymbol(runSyntax, 1) = NIL) THEN
        token :=
          graph.getChildSymbol(designator, 1, Symbol.Kind.Identifier);
        REPEAT
          oldToken := token;
          token := TokenSupport.SkipWhiteSpaceAndComment(graph, token);
        UNTIL (token.getKind()
                 IN Symbol.KindSet{Symbol.Kind.Semicolon, Symbol.Kind.End,
                                   Symbol.Kind.Bar, Symbol.Kind.Else,
                                   Symbol.Kind.Elsif, Symbol.Kind.Until});
        graph.appendToken(
          anchor, NEW(Token.T).init(Symbol.Kind.RBracket, ")",
                                    Token.LanguageSet{Token.Language.M3}),
          oldToken);
        graph.appendToken(
          anchor, NEW(Token.T).init(Symbol.Kind.LBracket, "(",
                                    Token.LanguageSet{Token.Language.M3}),
          oldToken);
      END;
    END;
  END InsertParentheses;

BEGIN
END ParameterGen.
