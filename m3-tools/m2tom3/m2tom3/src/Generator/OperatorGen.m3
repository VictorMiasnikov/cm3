MODULE OperatorGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Alexander Poensgen                                        *)

(** pk
    1.1
    1994/11/30 15:05:40
    OperatorGen.m3,v
# Revision 1.1  1994/11/30  15:05:40  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT BaseGraph;
IMPORT Symbol;
IMPORT Token, TokenGraph;
IMPORT Syntax, SyntaxSupport;
IMPORT SourceGraph;


(** --- HandleOperatorPrecedence -----------------------------------------------
  * In this procedure expressions and simple expressions are checked to insert
  * parentheses to preserve the same evaluation of expressions due to the
  * changed operator precedences from Modula-2 to Modula-3.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE HandleOperatorPrecedence (graph : SourceGraph.T;
                                    anchor: SourceGraph.Anchor;
                                    expr  : Syntax.T            ) =
  <* FATAL BaseGraph.NodeNotInGraph *>

  VAR
    relationOpt   : Syntax.T;
    relationExists: BOOLEAN;

  BEGIN
    (* check if optional relation exists *)
    relationOpt := graph.getChildSymbol(expr, 2);
    relationExists := (relationOpt.getNoOfChildren() > 0);

    (* handle first simple expression *)
    HandleSimpleExpr(graph, anchor, graph.getChildSymbol(expr, 1),
                     atomicItem := relationExists);

    IF (relationExists) THEN
      (* handle second simple expressions *)
      HandleSimpleExpr(graph, anchor, graph.getChildSymbol(relationOpt, 2),
                       atomicItem := TRUE);
    END;
  END HandleOperatorPrecedence;


PROCEDURE HandleSimpleExpr (graph     : SourceGraph.T;
                            anchor    : SourceGraph.Anchor;
                            simpleExpr: Syntax.T;
                            atomicItem: BOOLEAN             ) =
  <* FATAL BaseGraph.NodeNotInGraph *>

  VAR
    addTermList   : Syntax.T;
    termListExists: BOOLEAN;

  BEGIN
    (* check if optional AddTermList exists *)
    addTermList := graph.getChildSymbol(simpleExpr, 3);
    termListExists := (0 < addTermList.getNoOfChildren());

    IF (atomicItem AND termListExists) THEN
      InsertParentheses(graph, anchor, simpleExpr);
    END;

    (* check if atomicItem should be propagated to terms *)
    atomicItem := ((atomicItem AND (NOT termListExists))
                     OR ((NOT atomicItem) AND termListExists));

    (* handle first term *)
    HandleTerm(
      graph, anchor, graph.getChildSymbol(simpleExpr, 2), atomicItem);

    IF (termListExists) THEN
      (* handle further terms *)
      REPEAT
        HandleTerm(
          graph, anchor, graph.getChildSymbol(addTermList, 2), atomicItem);
        addTermList := graph.getChildSymbol(addTermList, 3);
      UNTIL (addTermList.getNoOfChildren() = 0);
    END;
  END HandleSimpleExpr;


PROCEDURE HandleTerm (graph     : SourceGraph.T;
                      anchor    : SourceGraph.Anchor;
                      term      : Syntax.T;
                      atomicItem: BOOLEAN             ) =
  <* FATAL BaseGraph.NodeNotInGraph *>

  VAR
    mulFactorList      : Syntax.T;
    mulFactorListExists: BOOLEAN;

  BEGIN
    (* check if optional MulFactorList exists *)
    mulFactorList := graph.getChildSymbol(term, 2);
    mulFactorListExists := (0 < mulFactorList.getNoOfChildren());

    IF (atomicItem AND mulFactorListExists) THEN
      InsertParentheses(graph, anchor, term);
    END;

    (* check if atomicItem should be propagated to factors *)
    atomicItem := ((atomicItem OR mulFactorListExists)
                     OR ((NOT atomicItem) AND mulFactorListExists));

    (* handle first factor *)
    HandleFactor(graph, anchor, graph.getChildSymbol(term, 1), atomicItem);

    IF (mulFactorListExists) THEN
      (* handle further terms *)
      REPEAT
        HandleFactor(graph, anchor, graph.getChildSymbol(mulFactorList, 2),
                     atomicItem);
        mulFactorList := graph.getChildSymbol(mulFactorList, 3);
      UNTIL (mulFactorList.getNoOfChildren() = 0);
    END;
  END HandleTerm;


PROCEDURE HandleFactor (graph     : SourceGraph.T;
                        anchor    : SourceGraph.Anchor;
                        factor    : Syntax.T;
                        atomicItem: BOOLEAN             ) =
  <* FATAL BaseGraph.NodeNotInGraph *>

  CONST
    notKindSet = Symbol.KindSet{Symbol.Kind.SyntaxNotFactor,
                                Symbol.Kind.SyntaxNotConstFactor};

  BEGIN
    IF (atomicItem) THEN
      WITH factorChild = graph.getChildSymbol(factor, 1) DO
        IF (factorChild.getKind() IN notKindSet) THEN
          InsertParentheses(graph, anchor, factorChild);
        END;
      END;
    END;
  END HandleFactor;


PROCEDURE InsertParentheses (graph : SourceGraph.T;
                             anchor: SourceGraph.Anchor;
                             syntax: Syntax.T            ) =
  <* FATAL BaseGraph.NodeInGraph, BaseGraph.NodeNotInGraph,
  TokenGraph.NoAnchor, TokenGraph.NotInStream *>

  VAR token, parenthesis: Token.T;

  BEGIN
    (* inserting left parenthesis *)
    parenthesis := NEW(Token.T).init(Symbol.Kind.LBracket, "(",
                                     Token.LanguageSet{Token.Language.M3});
    token := SyntaxSupport.FindLeftmostToken(graph, syntax);

    (* there has to be an leftmost token *)
    <* ASSERT (token # NIL) *>

    (* check if token is qualified *)
    WITH prevToken = graph.getPrevToken(token, Token.Language.M3) DO
      IF ((prevToken # NIL) AND (prevToken.getKind() = Symbol.Kind.Period)
            AND (graph.getParentSyntax(prevToken) = NIL)) THEN
        token := graph.getPrevToken(prevToken, Token.Language.M3);
      END;
    END;

    graph.prependToken(anchor, parenthesis, token);

    (* inserting right parenthesis *)
    parenthesis := NEW(Token.T).init(Symbol.Kind.RBracket, ")",
                                     Token.LanguageSet{Token.Language.M3});
    token := SyntaxSupport.FindRightmostToken(graph, syntax);

    (* there has to be an rightmost token *)
    <* ASSERT (token # NIL) *>
    graph.appendToken(anchor, parenthesis, token);
  END InsertParentheses;

BEGIN
END OperatorGen.
