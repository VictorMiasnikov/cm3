MODULE VALGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Peter Klein                                               *)

(** pk
    1.1
    1994/11/30 15:06:11
    VALGen.m3,v
# Revision 1.1  1994/11/30  15:06:11  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT SourceGraph, Token, Syntax, Symbol, SyntaxSupport, BaseGraph,
       TokenGraph, CopyTokenSubstream;

IMPORT Text;


EXCEPTION NavigationError;


PROCEDURE HandleVAL (graph : SourceGraph.T;
                     anchor: SourceGraph.Anchor;
                     val   : Token.T             ) =
  VAR
    exprList     : Syntax.T;
    firstOperand : Syntax.T;
    secondOperand: Syntax.T;

  <* FATAL NavigationError, BaseGraph.NodeNotInGraph *>

  BEGIN
    IF (Token.Language.M2 IN val.getLanguages()) THEN
      FindOperands(graph, val, exprList, firstOperand, secondOperand);
      CheckEmbeddedVals(graph, anchor, firstOperand);
      CheckEmbeddedVals(graph, anchor, secondOperand);
      SwapParameters(graph, anchor, exprList, firstOperand, secondOperand);
      val.removeLanguage(Token.Language.M2);
    END;
  END HandleVAL;


PROCEDURE FindOperands (    graph        : SourceGraph.T;
                            val          : Token.T;
                        VAR exprList     : Syntax.T;
                        VAR firstOperand : Syntax.T;
                        VAR secondOperand: Syntax.T       )
  RAISES {NavigationError, BaseGraph.NodeNotInGraph} =
  VAR qualCall: Syntax.T;

  BEGIN
    WITH qualIdent = graph.getParentSyntax(
                       val, expectedKind := Symbol.Kind.SyntaxQualIdent) DO
      qualCall := graph.getParentSyntax(qualIdent);
    END;
    IF (qualCall.getKind() = Symbol.Kind.SyntaxQualConstSetOrCall) THEN
      WITH call = graph.getChildSymbol(
                    qualCall, no := 2,
                    expectedKind := Symbol.Kind.SyntaxConstSetOrCall),
           actParameters = graph.getChildSymbol(
                             call, no := 1,
                             expectedKind :=
                               Symbol.Kind.SyntaxConstActualParametersOpt),
           exprSeq = graph.getChildSymbol(
                       actParameters, no := 2,
                       expectedKind := Symbol.Kind.SyntaxConstExprSeqOpt) DO
        exprList := graph.getChildSymbol(
                      exprSeq, no := 2,
                      expectedKind := Symbol.Kind.SyntaxConstExprList);
        firstOperand :=
          graph.getChildSymbol(
            exprSeq, no := 1, expectedKind := Symbol.Kind.SyntaxConstExpr);
        secondOperand := graph.getChildSymbol(
                           exprList, no := 2,
                           expectedKind := Symbol.Kind.SyntaxConstExpr);
      END;
    ELSIF (qualCall.getKind() = Symbol.Kind.SyntaxQualSetOrCall) THEN
      WITH setOrCall = graph.getChildSymbol(
                         qualCall, no := 2,
                         expectedKind := Symbol.Kind.SyntaxSetOrCall),
           call = graph.getChildSymbol(
                    setOrCall, no := 1,
                    expectedKind := Symbol.Kind.SyntaxCall),
           actParametersOpt = graph.getChildSymbol(
                                call, no := 2,
                                expectedKind :=
                                  Symbol.Kind.SyntaxActualParametersOpt),
           actParameters = graph.getChildSymbol(
                             actParametersOpt, no := 1,
                             expectedKind :=
                               Symbol.Kind.SyntaxActualParameters),
           exprSeq = graph.getChildSymbol(
                       actParameters, no := 2,
                       expectedKind := Symbol.Kind.SyntaxExprSeqOpt) DO
        exprList :=
          graph.getChildSymbol(
            exprSeq, no := 2, expectedKind := Symbol.Kind.SyntaxExprList);
        firstOperand :=
          graph.getChildSymbol(
            exprSeq, no := 1, expectedKind := Symbol.Kind.SyntaxExpr);
        secondOperand :=
          graph.getChildSymbol(
            exprList, no := 2, expectedKind := Symbol.Kind.SyntaxExpr);
      END;
    ELSE
      RAISE NavigationError;
    END;
  END FindOperands;


PROCEDURE SwapParameters (graph        : SourceGraph.T;
                          anchor       : SourceGraph.Anchor;
                          exprList     : Syntax.T;
                          firstOperand : Syntax.T;
                          secondOperand: Syntax.T            ) =
  VAR insertionPoint: Token.T;

  <* FATAL BaseGraph.NodeNotInGraph,  BaseGraph.NodeInGraph,
           TokenGraph.NoAnchor, TokenGraph.NotInStream *>

  BEGIN
    WITH comma = graph.getChildSymbol(
                   exprList, no := 1, expectedKind := Symbol.Kind.Comma) DO
      NARROW(comma, Token.T).removeLanguage(Token.Language.M3);
    END;
    insertionPoint :=
      SyntaxSupport.FindRightmostToken(graph, secondOperand);
    WITH newComma = NEW(Token.T).init(Symbol.Kind.Comma, ",", Token.M3Only,
                                      line := insertionPoint.getLine()) DO
      graph.appendToken(anchor, newComma, insertionPoint);
      insertionPoint := newComma;
    END;
    CopyTokenSubstream.F(graph, anchor, firstOperand,
                         insertionPoint := insertionPoint, resetM3 := TRUE);
  END SwapParameters;


PROCEDURE CheckEmbeddedVals (graph  : SourceGraph.T;
                             anchor : SourceGraph.Anchor;
                             operand: Syntax.T            )
  RAISES {BaseGraph.NodeNotInGraph} =
  VAR current: Token.T;

  BEGIN
    WITH start = SyntaxSupport.FindLeftmostToken(graph, operand),
         end   = SyntaxSupport.FindRightmostToken(graph, operand) DO
      current := start;
      LOOP
        IF (Text.Equal(current.getText(), "VAL")) THEN
          HandleVAL(graph, anchor, current);
        END;
        IF (current = end) THEN EXIT; END;
        current := graph.getNextToken(current, Token.Language.M3);
      END;
    END;
  END CheckEmbeddedVals;

BEGIN
END VALGen.
