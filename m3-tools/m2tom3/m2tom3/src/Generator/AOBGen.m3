MODULE AOBGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Peter Klein                                               *)

(** pk
    1.1
    1994/11/30 15:04:37
    AOBGen.m3,v
# Revision 1.1  1994/11/30  15:04:37  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT BaseGraph, TokenGraph, SourceGraph, IdentifierLinker, Syntax, Token,
       Symbol;

IMPORT ActualToFormalType, SyntaxSupport, ImportSupport,
       CopyTokenSubstream, ExprSupport;

IMPORT Text, Fmt;


<* FATAL BaseGraph.NodeNotInGraph, BaseGraph.NodeInGraph, TokenGraph.NoAnchor,
         TokenGraph.NotInStream *>


VAR currentDesignatorNo := 0;


PROCEDURE CastAOBs (graph : SourceGraph.T;
                    anchor: SourceGraph.Anchor;
                    symbol: Syntax.T            ) =
  BEGIN
    WITH scope = graph.getChildSymbol(symbol, no := 3),
         formalParametersOpt = graph.getChildSymbol(
                                 scope, no := 1,
                                 expectedKind :=
                                   Symbol.Kind.SyntaxFormalParametersOpt) DO
      IF (NARROW(formalParametersOpt, Syntax.T).getNoOfChildren() = 0) THEN
        RETURN;
      END;
      WITH formalParameters = graph.getChildSymbol(
                                formalParametersOpt, no := 1,
                                expectedKind :=
                                  Symbol.Kind.SyntaxFormalParameters),
           parameterSectionSeqOpt = graph.getChildSymbol(
                                      formalParameters, no := 2,
                                      expectedKind :=
                                        Symbol.Kind.SyntaxParameterSectionSeqOpt) DO
        IF (NARROW(parameterSectionSeqOpt, Syntax.T).getNoOfChildren() = 0) THEN
          RETURN;
        END;
        WITH parameterSection = graph.getChildSymbol(
                                  parameterSectionSeqOpt, no := 1,
                                  expectedKind :=
                                    Symbol.Kind.SyntaxParameterSection),
             parameterSectionList = graph.getChildSymbol(
                                      parameterSectionSeqOpt, no := 2,
                                      expectedKind :=
                                        Symbol.Kind.SyntaxParameterSectionList) DO
          CheckParameters(
            graph, anchor, parameterSection, parameterSectionList);
        END;
      END;
    END;
  END CastAOBs;


PROCEDURE CheckParameters (graph               : SourceGraph.T;
                           anchor              : SourceGraph.Anchor;
                           parameterSection    : Syntax.T;
                           parameterSectionList: Syntax.T            ) =
  BEGIN
    WITH formalType = graph.getChildSymbol(
                        parameterSection, no := 5,
                        expectedKind := Symbol.Kind.SyntaxFormalType),
         arrayOpt = graph.getChildSymbol(
                      formalType, no := 1,
                      expectedKind := Symbol.Kind.SyntaxArrayOpt) DO
      IF (NARROW(arrayOpt, Syntax.T).getNoOfChildren() > 0) THEN
        WITH qualIdent = graph.getChildSymbol(
                           formalType, no := 2,
                           expectedKind := Symbol.Kind.SyntaxQualIdent) DO
          IF (IsByte(graph, qualIdent)) THEN
            CastParameters(graph, anchor, formalType);
          END;
        END;
      END;
      IF (parameterSectionList.getNoOfChildren() > 0) THEN
        WITH newSection = graph.getChildSymbol(
                            parameterSectionList, no := 2,
                            expectedKind :=
                              Symbol.Kind.SyntaxParameterSection),
             newSectionList = graph.getChildSymbol(
                                parameterSectionList, no := 3,
                                expectedKind :=
                                  Symbol.Kind.SyntaxParameterSectionList) DO
          CheckParameters(graph, anchor, newSection, newSectionList);
        END;
      END;
    END;
  END CheckParameters;


PROCEDURE CastParameters (graph     : SourceGraph.T;
                          anchor    : SourceGraph.Anchor;
                          formalType: Syntax.T            ) =
  VAR
    iterator  : ActualToFormalType.EdgeIterator;
    actualExpr: Syntax.T;
    qualIdent : Syntax.T;
    realType  : Symbol.T;

  BEGIN
    iterator := ActualToFormalType.IterateActuals(graph, formalType);
    actualExpr := iterator.next();
    WHILE (actualExpr # NIL) DO
      qualIdent := ExprSupport.GetQualIdentInExpr(graph, actualExpr);
      IF (qualIdent # NIL) THEN
        WITH ident = ExprSupport.GetIdentInQualIdent(graph, qualIdent),
             type  = IdentifierLinker.FindTypeOfAppl(graph, ident)      DO
          realType := IdentifierLinker.FindRealType(graph, type);
        END;
      ELSE
        realType := NIL;
      END;
      IF (qualIdent = NIL) THEN
        (* is a real expression: create surrounding with statement *)
        CastToDesignator(graph, anchor, actualExpr);
      ELSIF ((realType = NIL)
               OR (realType.getKind() # Symbol.Kind.SyntaxFormalType)) THEN
        (* is a qualIdent but not a formal parameter: just cast *)
        CastInPlace(graph, anchor, actualExpr);
      ELSE
        WITH arrayOpt = graph.getChildSymbol(
                          realType, no := 1,
                          expectedKind := Symbol.Kind.SyntaxArrayOpt),
             formalIdent = graph.getChildSymbol(
                             realType, no := 2,
                             expectedKind := Symbol.Kind.SyntaxQualIdent) DO
          IF (NARROW(arrayOpt, Syntax.T).getNoOfChildren() = 0) THEN
            (* is a formal parameter, but not an open array: just cast *)
            CastInPlace(graph, anchor, actualExpr);
          ELSE
            IF (NOT IsByte(graph, formalIdent)) THEN
              (* is an open array, but not of byte: copy parameter *)
              CastToFixedDesignator(graph, anchor, actualExpr, formalIdent);
            ELSE
              (* is already an open AOB: relax *)
            END;
          END;
        END;
      END;
      WITH currentAnchor = graph.findAnchor(actualExpr) DO
        ImportSupport.AddImport(graph, currentAnchor, "SYSTEM", "BYTE");
      END;
      actualExpr := iterator.next();
    END;
  END CastParameters;


PROCEDURE CastToDesignator (graph : SourceGraph.T;
                            anchor: SourceGraph.Anchor;
                            expr  : Syntax.T            ) =
  VAR
    start, end    : Token.T;
    insertionPoint: Token.T;
    statement     : Syntax.T;

  BEGIN
    statement := GetStatement(graph, expr);
    WITH statementStart = SyntaxSupport.FindLeftmostToken(graph, statement),
         newToken = NEW(Token.T).init(
                      Symbol.Kind.GenText,
                      "WITH " & CurrentDesignator() & " = ", Token.M3Only) DO
      graph.prependToken(anchor, newToken, statementStart);
      insertionPoint := newToken;
    END;
    GetTokenRange(graph, expr, start, end);
    WITH newToken = NEW(Token.T).init(Symbol.Kind.GenText,
                                      "LOOPHOLE(" & CurrentDesignator()
                                        & ",ARRAY OF BYTE)", Token.M3Only) DO
      graph.prependToken(anchor, newToken, start);
    END;
    CopyTokenSubstream.F(
      graph, anchor, syntax := NIL, begin := start, end := end,
      insertionPoint := insertionPoint, resetM3 := TRUE);
    WITH newToken = NEW(Token.T).init(
                      Symbol.Kind.GenText, " DO\n", Token.M3Only) DO
      graph.appendToken(anchor, newToken, insertionPoint);
    END;
    WITH statementEnd = SyntaxSupport.FindRightmostToken(graph, statement),
         newToken = NEW(Token.T).init(
                      Symbol.Kind.GenText, "\nEND", Token.M3Only) DO
      graph.appendToken(anchor, newToken, statementEnd);
    END;
    INC(currentDesignatorNo);
  END CastToDesignator;


PROCEDURE CastToFixedDesignator (graph     : SourceGraph.T;
                                 anchor    : SourceGraph.Anchor;
                                 expr      : Syntax.T;
                                 formalType: Syntax.T;           ) =
  VAR
    start, end    : Token.T;
    subarrayStart : Token.T;
    subarrayEnd   : Token.T;
    loopholeStart : Token.T;
    loopholeEnd   : Token.T;
    forStart      : Token.T;
    forEnd        : Token.T;
    insertionPoint: Token.T;
    statement     : Syntax.T;

  BEGIN
    statement := GetStatement(graph, expr);
    GetTokenRange(graph, expr, start, end);
    WITH statementStart = SyntaxSupport.FindLeftmostToken(graph, statement),
         newToken = NEW(Token.T).init(
                      Symbol.Kind.GenText,
                      "WITH " & CurrentDesignator()
                        & " = NEW(REF ARRAY OF BYTE, BYTESIZE(",
                      Token.M3Only) DO
      graph.prependToken(anchor, newToken, statementStart);
      insertionPoint := newToken;
    END;
    CopyTokenSubstream.F(
      graph, anchor, syntax := NIL, begin := start, end := end,
      insertionPoint := insertionPoint, resetM3 := FALSE);
    WITH newToken = NEW(Token.T).init(
                      Symbol.Kind.GenText, ")) DO", Token.M3Only) DO
      graph.appendToken(anchor, newToken, insertionPoint);
      insertionPoint := newToken;
      forStart := newToken;
    END;
    WITH newToken = NEW(Token.T).init(
                      Symbol.Kind.GenText, "\nFOR i := 0 TO LAST(",
                      Token.M3Only) DO
      graph.appendToken(anchor, newToken, insertionPoint);
      insertionPoint := newToken;
      forStart := newToken;
    END;
    CopyTokenSubstream.F(
      graph, anchor, syntax := NIL, begin := start, end := end,
      insertionPoint := insertionPoint, resetM3 := FALSE);
    WITH newToken = NEW(Token.T).init(
                      Symbol.Kind.GenText, ") DO\n", Token.M3Only) DO
      graph.appendToken(anchor, newToken, insertionPoint);
      insertionPoint := newToken;
      forEnd := newToken;
    END;
    WITH newToken = NEW(Token.T).init(Symbol.Kind.GenText,
                                      "SUBARRAY(" & CurrentDesignator()
                                        & "^,i*BYTESIZE(", Token.M3Only) DO
      graph.appendToken(anchor, newToken, insertionPoint);
      insertionPoint := newToken;
      subarrayStart := newToken;
    END;
    CopyTokenSubstream.F(
      graph, anchor, syntax := formalType,
      insertionPoint := insertionPoint, resetM3 := FALSE);
    WITH newToken = NEW(Token.T).init(
                      Symbol.Kind.GenText, "),BYTESIZE(", Token.M3Only) DO
      graph.appendToken(anchor, newToken, insertionPoint);
      insertionPoint := newToken;
    END;
    CopyTokenSubstream.F(
      graph, anchor, syntax := formalType,
      insertionPoint := insertionPoint, resetM3 := FALSE);
    WITH newToken = NEW(Token.T).init(
                      Symbol.Kind.GenText, "))", Token.M3Only) DO
      graph.appendToken(anchor, newToken, insertionPoint);
      insertionPoint := newToken;
      subarrayEnd := newToken;
    END;
    WITH newToken = NEW(Token.T).init(
                      Symbol.Kind.GenText, " := ", Token.M3Only) DO
      graph.appendToken(anchor, newToken, insertionPoint);
      insertionPoint := newToken;
    END;
    WITH newToken = NEW(Token.T).init(
                      Symbol.Kind.GenText, "LOOPHOLE(", Token.M3Only) DO
      graph.appendToken(anchor, newToken, insertionPoint);
      insertionPoint := newToken;
      loopholeStart := newToken;
    END;
    CopyTokenSubstream.F(
      graph, anchor, syntax := NIL, begin := start, end := end,
      insertionPoint := insertionPoint, resetM3 := TRUE);
    WITH newToken = NEW(Token.T).init(Symbol.Kind.GenText,
                                      "[i],ARRAY OF BYTE)", Token.M3Only) DO
      graph.appendToken(anchor, newToken, insertionPoint);
      insertionPoint := newToken;
      loopholeEnd := newToken;
    END;
    WITH newToken = NEW(Token.T).init(
                      Symbol.Kind.GenText, ";\nEND;\n", Token.M3Only) DO
      graph.appendToken(anchor, newToken, insertionPoint);
      insertionPoint := newToken;
    END;
    WITH newToken = NEW(Token.T).init(
                      Symbol.Kind.GenText, CurrentDesignator() & "^",
                      Token.M3Only) DO
      graph.prependToken(anchor, newToken, start);
    END;
    WITH statementEnd = SyntaxSupport.FindRightmostToken(graph, statement),
         newToken = NEW(Token.T).init(
                      Symbol.Kind.GenText, ";", Token.M3Only) DO
      graph.appendToken(anchor, newToken, statementEnd);
      insertionPoint := newToken;
    END;
    CopyTokenSubstream.F(
      graph, anchor, syntax := NIL, begin := forStart, end := forEnd,
      insertionPoint := insertionPoint, resetM3 := FALSE);
    CopyTokenSubstream.F(
      graph, anchor, syntax := NIL, begin := loopholeStart,
      end := loopholeEnd, insertionPoint := insertionPoint,
      resetM3 := FALSE);
    WITH newToken = NEW(Token.T).init(
                      Symbol.Kind.GenText, " := ", Token.M3Only) DO
      graph.appendToken(anchor, newToken, insertionPoint);
      insertionPoint := newToken;
    END;
    CopyTokenSubstream.F(
      graph, anchor, syntax := NIL, begin := subarrayStart,
      end := subarrayEnd, insertionPoint := insertionPoint,
      resetM3 := FALSE);
    WITH newToken = NEW(Token.T).init(
                      Symbol.Kind.GenText, ";\nEND;\nEND", Token.M3Only) DO
      graph.appendToken(anchor, newToken, insertionPoint);
      insertionPoint := newToken;
    END;
    INC(currentDesignatorNo);
  END CastToFixedDesignator;


PROCEDURE CastInPlace (graph : SourceGraph.T;
                       anchor: SourceGraph.Anchor;
                       expr  : Syntax.T            ) =
  VAR start, end: Token.T;

  BEGIN
    GetTokenRange(graph, expr, start, end);
    WITH newToken = NEW(Token.T).init(
                      Symbol.Kind.GenText, "LOOPHOLE(", Token.M3Only) DO
      graph.prependToken(anchor, newToken, start);
    END;
    WITH newToken = NEW(Token.T).init(
                      Symbol.Kind.GenText, ",ARRAY OF BYTE)", Token.M3Only) DO
      graph.appendToken(anchor, newToken, end);
    END;
  END CastInPlace;


PROCEDURE GetStatement (graph: SourceGraph.T; expr: Syntax.T): Syntax.T =
  VAR current: Syntax.T;

  BEGIN
    current := graph.getParentSyntax(expr);
    WHILE (current.getKind() # Symbol.Kind.SyntaxStatement) DO
      current := graph.getParentSyntax(current);
    END;
    RETURN current;
  END GetStatement;


(* Unfortunately, FindLeft/RightmostToken from expr does not neccessarily
   enclose the expression anymore (due to previous transformations).  So we
   have to navigate over expr's neighbours. *)
PROCEDURE GetTokenRange (    graph: SourceGraph.T;
                             expr : Syntax.T;
                         VAR start: Token.T;
                         VAR end  : Token.T        ) =
  VAR
    exprList           : Syntax.T;
    firstFollowingToken: Token.T;
    current            : Syntax.T;

  BEGIN
    WITH parent = graph.getParentSyntax(expr) DO
      CASE parent.getKind() OF
        Symbol.Kind.SyntaxExprSeqOpt =>
          WITH actualParameters = graph.getParentSyntax(
                                    parent,
                                    expectedKind :=
                                      Symbol.Kind.SyntaxActualParameters),
               bracket = graph.getChildSymbol(
                           actualParameters, no := 1,
                           expectedKind := Symbol.Kind.LBracket) DO
            exprList := graph.getChildSymbol(
                          parent, no := 2,
                          expectedKind := Symbol.Kind.SyntaxExprList);
            start := graph.getNextToken(bracket, Token.Language.M3);
          END;
      | Symbol.Kind.SyntaxExprList =>
          WITH comma = graph.getChildSymbol(parent, no := 1,
                                            expectedKind :=
                                              Symbol.Kind.Comma) DO
            exprList := graph.getChildSymbol(
                          parent, no := 3,
                          expectedKind := Symbol.Kind.SyntaxExprList);
            start := graph.getNextToken(comma, Token.Language.M3);
          END;
      ELSE
        <* ASSERT FALSE *>
      END;
    END;

    firstFollowingToken :=
      SyntaxSupport.FindLeftmostToken(graph, exprList);
    IF (firstFollowingToken = NIL) THEN
      current := exprList;
      WHILE (current.getKind() # Symbol.Kind.SyntaxActualParameters) DO
        current := graph.getParentSyntax(current);
      END;
      firstFollowingToken :=
        graph.getChildSymbol(
          current, no := 3, expectedKind := Symbol.Kind.RBracket);
    END;
    end := graph.getPrevToken(firstFollowingToken, Token.Language.M3);
  END GetTokenRange;


PROCEDURE IsByte (graph: SourceGraph.T; qualIdent: Syntax.T): BOOLEAN =
  BEGIN
    WITH ident    = ExprSupport.GetIdentInQualIdent(graph, qualIdent),
         type     = IdentifierLinker.FindTypeOfAppl(graph, ident),
         realType = IdentifierLinker.FindRealType(graph, type)         DO
      RETURN
        ((realType # NIL) AND (realType.getKind() = Symbol.Kind.Identifier)
           AND (Text.Equal(NARROW(realType, Token.T).getText(), "BYTE")));
    END;
  END IsByte;


PROCEDURE CurrentDesignator (): TEXT =
  BEGIN
    RETURN "m2tom3_desig_" & Fmt.Int(currentDesignatorNo);
  END CurrentDesignator;

BEGIN
END AOBGen.
