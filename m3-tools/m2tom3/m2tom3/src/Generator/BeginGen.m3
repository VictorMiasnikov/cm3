MODULE BeginGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Alexander Poensgen                                        *)

(** pk
    1.1
    1994/11/30 15:04:40
    BeginGen.m3,v
# Revision 1.1  1994/11/30  15:04:40  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT BaseGraph;
IMPORT Symbol;
IMPORT Token, TokenGraph;
IMPORT Syntax;
IMPORT SourceGraph;


(** --- InsertBegin-----------------------------------------------------------
  * This procedure inserts a missing BEGIN into the token stream.
  * In Modula-2 grammar a BEGIN statement is unnecessary if the statement
  * sequence is empty (see rule Block of copper - grammar).
  * In Modula-3 this BEGIN statement is obligatory.
  *
  * Line of action:
  *
  * - Find occurence of BlockStatementsOpt.
  * - if this node has no children insert Modula-3 token BEGIN before token END.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE InsertBegin (graph   : SourceGraph.T;
                       anchor  : SourceGraph.Anchor;
                       stateopt: Syntax.T            ) =
  <* FATAL TokenGraph.NoAnchor, BaseGraph.NodeInGraph,
          BaseGraph.NodeNotInGraph, TokenGraph.NotInStream *>

  VAR
    parent        : Syntax.T;
    endStatement  : Token.T;
    beginStatement: Token.T;
    whiteSpace    : Token.T;

  BEGIN
    parent := graph.getParentSyntax(stateopt, Symbol.Kind.SyntaxBlock);

    endStatement := NARROW(graph.getChildSymbol(
                             parent, parent.getNoOfChildren(),
                             Symbol.Kind.End), Token.T);

    beginStatement :=
      NEW(Token.T).init(
        Symbol.Kind.Begin, "BEGIN", Token.LanguageSet{Token.Language.M3});

    graph.prependToken(anchor, beginStatement, endStatement);

    whiteSpace := NEW(Token.T).init(Symbol.Kind.WhiteSpace, "\n",
                                    Token.LanguageSet{Token.Language.M3});

    graph.prependToken(anchor, whiteSpace, endStatement);
  END InsertBegin;

BEGIN
END BeginGen.
