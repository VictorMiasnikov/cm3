MODULE ExprSupport;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Peter Klein                                               *)

(** pk
    1.1
    1994/11/30 15:05:07
    ExprSupport.m3,v
# Revision 1.1  1994/11/30  15:05:07  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT SourceGraph, BaseGraph, Token, Syntax, Symbol;


<* FATAL BaseGraph.NodeNotInGraph *>


PROCEDURE GetQualIdentInExpr (graph: SourceGraph.T; expr: Syntax.T):
  Syntax.T =
  VAR
    simpleExpr: Syntax.T;
    term      : Syntax.T;
    factor    : Syntax.T;
    factorType: Syntax.T;

  BEGIN
    simpleExpr :=
      graph.getChildSymbol(
        expr, no := 1, expectedKind := Symbol.Kind.SyntaxSimpleExpr);
    WITH relationOpt = graph.getChildSymbol(
                         expr, no := 2,
                         expectedKind := Symbol.Kind.SyntaxRelationOpt) DO
      IF (NARROW(relationOpt, Syntax.T).getNoOfChildren() > 0) THEN
        RETURN NIL;
      END;
    END;
    WITH unaryAddOpt = graph.getChildSymbol(
                         simpleExpr, no := 1,
                         expectedKind := Symbol.Kind.SyntaxUnaryAddOpt),
         addTermList = graph.getChildSymbol(
                         simpleExpr, no := 3,
                         expectedKind := Symbol.Kind.SyntaxAddTermList) DO
      IF ((NARROW(unaryAddOpt, Syntax.T).getNoOfChildren() > 0)
            OR (NARROW(addTermList, Syntax.T).getNoOfChildren() > 0)) THEN
        RETURN NIL;
      END;
    END;
    term := graph.getChildSymbol(
              simpleExpr, no := 2, expectedKind := Symbol.Kind.SyntaxTerm);
    factor := graph.getChildSymbol(
                term, no := 1, expectedKind := Symbol.Kind.SyntaxFactor);
    WITH mulFactorList = graph.getChildSymbol(
                           term, no := 2,
                           expectedKind := Symbol.Kind.SyntaxMulFactorList) DO
      IF (NARROW(mulFactorList, Syntax.T).getNoOfChildren() > 0) THEN
        RETURN NIL;
      END;
    END;
    factorType := graph.getChildSymbol(factor, no := 1);
    IF (factorType.getKind() # Symbol.Kind.SyntaxQualSetOrCall) THEN
      RETURN NIL;
    END;
    WITH setOrCall = graph.getChildSymbol(
                       factorType, no := 2,
                       expectedKind := Symbol.Kind.SyntaxSetOrCall),
         setOrCallNode = graph.getChildSymbol(setOrCall, no := 1) DO
      IF (setOrCallNode.getKind() = Symbol.Kind.SyntaxSet) THEN
        RETURN NIL;
      END;
      WITH designatorTailList = graph.getChildSymbol(
                                  setOrCallNode, no := 1,
                                  expectedKind :=
                                    Symbol.Kind.SyntaxDesignatorTailList),
           actualParametersOpt = graph.getChildSymbol(
                                   setOrCallNode, no := 2,
                                   expectedKind :=
                                     Symbol.Kind.SyntaxActualParametersOpt) DO
        IF ((NARROW(designatorTailList, Syntax.T).getNoOfChildren() > 0)
              OR (NARROW(actualParametersOpt, Syntax.T).getNoOfChildren()
                    > 0)) THEN
          RETURN NIL;
        END;
      END;
    END;
    RETURN
      graph.getChildSymbol(
        factorType, no := 1, expectedKind := Symbol.Kind.SyntaxQualIdent);
  END GetQualIdentInExpr;


PROCEDURE GetQualIdentInConstExpr (graph    : SourceGraph.T;
                                   constExpr: Syntax.T       ): Syntax.T =
  VAR
    simpleConstExpr: Syntax.T;
    constTerm      : Syntax.T;
    constFactor    : Syntax.T;
    constFactorType: Syntax.T;

  BEGIN
    simpleConstExpr :=
      graph.getChildSymbol(
        constExpr, no := 1,
        expectedKind := Symbol.Kind.SyntaxSimpleConstExpr);
    WITH simpleRelationOpt = graph.getChildSymbol(
                               constExpr, no := 2,
                               expectedKind :=
                                 Symbol.Kind.SyntaxSimpleRelationOpt) DO
      IF (NARROW(simpleRelationOpt, Syntax.T).getNoOfChildren() > 0) THEN
        RETURN NIL;
      END;
    END;
    WITH unaryAddOpt = graph.getChildSymbol(
                         simpleConstExpr, no := 1,
                         expectedKind := Symbol.Kind.SyntaxUnaryAddOpt),
         addSimpleTermList = graph.getChildSymbol(
                               simpleConstExpr, no := 3,
                               expectedKind :=
                                 Symbol.Kind.SyntaxAddSimpleTermList) DO
      IF ((NARROW(unaryAddOpt, Syntax.T).getNoOfChildren() > 0)
            OR (NARROW(addSimpleTermList, Syntax.T).getNoOfChildren() > 0)) THEN
        RETURN NIL;
      END;
    END;
    constTerm :=
      graph.getChildSymbol(simpleConstExpr, no := 2,
                           expectedKind := Symbol.Kind.SyntaxConstTerm);
    constFactor :=
      graph.getChildSymbol(
        constTerm, no := 1, expectedKind := Symbol.Kind.SyntaxConstFactor);
    WITH mulConstFactorList = graph.getChildSymbol(
                                constTerm, no := 2,
                                expectedKind :=
                                  Symbol.Kind.SyntaxMulConstFactorList) DO
      IF (NARROW(mulConstFactorList, Syntax.T).getNoOfChildren() > 0) THEN
        RETURN NIL;
      END;
    END;
    constFactorType := graph.getChildSymbol(constFactor, no := 1);
    IF (constFactorType.getKind() # Symbol.Kind.SyntaxQualConstSetOrCall) THEN
      RETURN NIL;
    END;
    WITH constSetOrCall = graph.getChildSymbol(
                            constFactorType, no := 2,
                            expectedKind :=
                              Symbol.Kind.SyntaxConstSetOrCall),
         constSetOrCallNode = graph.getChildSymbol(constSetOrCall, no := 1) DO
      IF ((constSetOrCallNode.getKind() = Symbol.Kind.SyntaxConstSet)
            OR (NARROW(constSetOrCallNode, Syntax.T).getNoOfChildren() > 0)) THEN
        RETURN NIL;
      END;
    END;
    RETURN
      graph.getChildSymbol(constFactorType, no := 1,
                           expectedKind := Symbol.Kind.SyntaxQualIdent);
  END GetQualIdentInConstExpr;


PROCEDURE GetIdentInQualIdent (graph: SourceGraph.T; qualIdent: Syntax.T):
  Token.T =
  VAR
    current           : Token.T;
    qualificationScope: Syntax.T;

  BEGIN
    current :=
      graph.getChildSymbol(
        qualIdent, no := 1, expectedKind := Symbol.Kind.Identifier);
    qualificationScope :=
      graph.getChildSymbol(
        qualIdent, no := 2,
        expectedKind := Symbol.Kind.SyntaxQualificationScope);
    WHILE (qualificationScope.getNoOfChildren() > 0) DO
      current :=
        graph.getChildSymbol(qualificationScope, no := 2,
                             expectedKind := Symbol.Kind.Identifier);
      qualificationScope :=
        graph.getChildSymbol(
          qualificationScope, no := 3,
          expectedKind := Symbol.Kind.SyntaxQualificationScope);
    END;
    RETURN current;
  END GetIdentInQualIdent;

BEGIN
END ExprSupport.
