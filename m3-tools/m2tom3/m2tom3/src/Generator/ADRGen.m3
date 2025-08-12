MODULE ADRGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Peter Klein                                               *)

(** pk
    1.2
    1995/01/24 11:43:27
    ADRGen.m3,v
# Revision 1.2  1995/01/24  11:43:27  pk
# Copying the array identifier into the FIRST expression now respects
# the fact that there might be m3 source generated before the
# identifier.
#
# Revision 1.1  1994/11/30  15:04:33  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT SourceGraph, TokenGraph, BaseGraph, Token, Syntax, Symbol, Message,
       IdentifierLinker, ExprSupport, SyntaxSupport, CopyTokenSubstream;


<* FATAL BaseGraph.NodeNotInGraph *>


PROCEDURE HandleADR (graph : SourceGraph.T;
                     anchor: SourceGraph.Anchor;
                     token : Token.T             ) =
  VAR
    qualIdent    : Syntax.T;
    currentSyntax: Syntax.T;
    currentToken : Token.T;

  BEGIN
    currentSyntax := graph.getParentSyntax(token);
    WHILE (NOT (currentSyntax.getKind()
                  IN Symbol.KindSet{Symbol.Kind.SyntaxQualSetOrCall,
                                    Symbol.Kind.SyntaxQualConstSetOrCall,
                                    Symbol.Kind.SyntaxCompilationUnit})) DO
      currentSyntax := graph.getParentSyntax(currentSyntax);
    END;
    CASE currentSyntax.getKind() OF
      Symbol.Kind.SyntaxQualSetOrCall =>
        qualIdent := GetQualIdentFromSetOrCall(graph, currentSyntax);
    | Symbol.Kind.SyntaxQualConstSetOrCall =>
        qualIdent := GetQualIdentFromConstSetOrCall(graph, currentSyntax);
    ELSE
      (* we're not interested *)
      RETURN;
    END;

    IF (qualIdent = NIL) THEN
      Message.Write(
        graph, token := token, code := Message.Code.UnhandledADR);
      RETURN;
    END;

    currentToken := ExprSupport.GetIdentInQualIdent(graph, qualIdent);

    WITH type     = IdentifierLinker.FindTypeOfAppl(graph, currentToken),
         realType = IdentifierLinker.FindRealType(graph, type)            DO
      IF (realType = NIL) THEN
        Message.Write(
          graph, token := currentToken, code := Message.Code.UnhandledADR);
        RETURN;
      END;
      CASE realType.getKind() OF
        Symbol.Kind.SyntaxArrayType =>
          IndexAppl(graph, anchor, currentToken, qualIdent);
      | Symbol.Kind.SyntaxFormalType =>
          WITH arrayOpt = graph.getChildSymbol(
                            realType, no := 1,
                            expectedKind := Symbol.Kind.SyntaxArrayOpt) DO
            IF (NARROW(arrayOpt, Syntax.T).getNoOfChildren() > 0) THEN
              IndexAppl(graph, anchor, currentToken, qualIdent);
            END;
          END;
      ELSE
        (* relax *)
      END;
    END;
  END HandleADR;


PROCEDURE GetQualIdentFromSetOrCall (graph        : SourceGraph.T;
                                     qualSetOrCall: Syntax.T       ):
  Syntax.T =
  VAR expr: Syntax.T;

  BEGIN
    WITH setOrCall = graph.getChildSymbol(
                       qualSetOrCall, no := 2,
                       expectedKind := Symbol.Kind.SyntaxSetOrCall),
         call = graph.getChildSymbol(
                  setOrCall, no := 1,
                  expectedKind := Symbol.Kind.SyntaxCall),
         actualParametersOpt = graph.getChildSymbol(
                                 call, no := 2,
                                 expectedKind :=
                                   Symbol.Kind.SyntaxActualParametersOpt),
         actualParameters = graph.getChildSymbol(
                              actualParametersOpt, no := 1,
                              expectedKind :=
                                Symbol.Kind.SyntaxActualParameters),
         exprSeqOpt = graph.getChildSymbol(
                        actualParameters, no := 2,
                        expectedKind := Symbol.Kind.SyntaxExprSeqOpt) DO
      IF (NARROW(exprSeqOpt, Syntax.T).getNoOfChildren() = 0) THEN
        RETURN NIL;              (* ADR without parameters ?! *)
      END;
      WITH exprList = graph.getChildSymbol(
                        exprSeqOpt, no := 2,
                        expectedKind := Symbol.Kind.SyntaxExprList) DO
        IF (NARROW(exprList, Syntax.T).getNoOfChildren() > 0) THEN
          RETURN NIL;
        END;
      END;
      expr := graph.getChildSymbol(exprSeqOpt, no := 1,
                                   expectedKind := Symbol.Kind.SyntaxExpr);
    END;
    RETURN ExprSupport.GetQualIdentInExpr(graph, expr);
  END GetQualIdentFromSetOrCall;


PROCEDURE GetQualIdentFromConstSetOrCall (graph: SourceGraph.T;
                                          qualConstSetOrCall: Syntax.T):
  Syntax.T =
  VAR constExpr: Syntax.T;

  BEGIN
    WITH constSetOrCall = graph.getChildSymbol(
                            qualConstSetOrCall, no := 2,
                            expectedKind :=
                              Symbol.Kind.SyntaxConstSetOrCall),
         constSetOrCallNode = graph.getChildSymbol(constSetOrCall, no := 1) DO
      IF ((constSetOrCallNode.getKind() = Symbol.Kind.SyntaxConstSet)
            OR (NARROW(constSetOrCallNode, Syntax.T).getNoOfChildren() = 0)) THEN
        RETURN NIL;
      END;
      WITH constExprSeqOpt = graph.getChildSymbol(
                               constSetOrCallNode, no := 2,
                               expectedKind :=
                                 Symbol.Kind.SyntaxConstExprSeqOpt) DO
        IF (NARROW(constExprSeqOpt, Syntax.T).getNoOfChildren() = 0) THEN
          RETURN NIL;
        END;
        constExpr := graph.getChildSymbol(
                       constExprSeqOpt, no := 1,
                       expectedKind := Symbol.Kind.SyntaxConstExpr);
        WITH constExprList = graph.getChildSymbol(
                               constExprSeqOpt, no := 2,
                               expectedKind :=
                                 Symbol.Kind.SyntaxConstExprList) DO
          IF (NARROW(constExprList, Syntax.T).getNoOfChildren() > 0) THEN
            RETURN NIL;
          END;
        END;
      END;
    END;
    RETURN ExprSupport.GetQualIdentInConstExpr(graph, constExpr);
  END GetQualIdentFromConstSetOrCall;


PROCEDURE IndexAppl (graph    : SourceGraph.T;
                     anchor   : SourceGraph.Anchor;
                     ident    : Token.T;
                     qualIdent: Syntax.T            ) =
  VAR
    insertionPoint: Token.T;
    current       : Token.T;
    first, last   : Token.T;

  <* FATAL BaseGraph.NodeInGraph, TokenGraph.NoAnchor, TokenGraph.NotInStream *>

  BEGIN
    WITH newToken = NEW(Token.T).init(
                      Symbol.Kind.GenText, "[FIRST(", Token.M3Only) DO
      graph.appendToken(anchor, newToken, ident);
      insertionPoint := newToken;
    END;

    (* move qualIdent pointer to the left if there is already generated m3
       source before the original qualIdent *)
    current := SyntaxSupport.FindLeftmostToken(graph, qualIdent);
    REPEAT
      first := current;
      current := graph.getPrevToken(current, Token.Language.M3);
    UNTIL (Token.Language.M2 IN current.getLanguages());
    last := SyntaxSupport.FindRightmostToken(graph, qualIdent);

    CopyTokenSubstream.F(
      graph, anchor, syntax := NIL, begin := first, end := last,
      insertionPoint := insertionPoint, resetM3 := FALSE);
    WITH newToken = NEW(Token.T).init(
                      Symbol.Kind.GenText, ")]", Token.M3Only) DO
      graph.appendToken(anchor, newToken, insertionPoint);
    END;
  END IndexAppl;

BEGIN
END ADRGen.
