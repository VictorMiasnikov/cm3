MODULE ActualToFormalType;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Peter Klein                                               *)

(** pk
    1.3
    1995/01/24 16:16:03
    ActualToFormalType.m3,v
# Revision 1.3  1995/01/24  16:16:03  pk
# Short parameter list check now also for empty actual parameter list.
#
# Revision 1.2  1995/01/17  10:51:56  pk
# Short actual parameter lists now produce a warning instead of a crash
# (thanks to Rodney Bates).
#
# Revision 1.1  1994/11/30  15:03:39  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT SourceGraph, DeclSupport, BaseGraph, Token, Syntax, Symbol, Message;


TYPE ActualToFormalTypeEdge = BaseGraph.Edge BRANDED OBJECT END;


EXCEPTION NavigationError;


<* FATAL NavigationError *>


REVEAL
  EdgeIterator = EdgeIteratorPublic BRANDED OBJECT
                   baseEdgeIterator: BaseGraph.EdgeIterator;
                 OVERRIDES
                   next := IteratorNext;
                 END;


PROCEDURE Bind (graph: SourceGraph.T) =
  VAR node: BaseGraph.Node;

  BEGIN
    TRY
      WITH iterator = graph.iterateNodes() DO
        node := iterator.next();
        WHILE (node # NIL) DO
          TYPECASE node OF
            Syntax.T (syntaxNode) =>
              IF (syntaxNode.getKind()
                    IN Symbol.KindSet{
                         Symbol.Kind.SyntaxProcedureDeclaration,
                         Symbol.Kind.SyntaxProcedureDefinition}) THEN
                BindAppls(graph, syntaxNode);
              END;
          ELSE
            (* we're not interested *)
          END;
          node := iterator.next();
        END;
      END;
    EXCEPT
      BaseGraph.NodeNotInGraph => RAISE NavigationError;
    END;
  END Bind;


PROCEDURE Get (graph: SourceGraph.T; actualParam: Syntax.T): Syntax.T =
  VAR
    iterator: BaseGraph.EdgeIterator;
    edge    : BaseGraph.Edge;

  <* FATAL BaseGraph.NodeNotInGraph *>

  BEGIN
    iterator := graph.iterateOutEdges(actualParam);
    edge := iterator.next();
    LOOP
      IF (edge = NIL) THEN RETURN NIL; END;
      IF (ISTYPE(edge, ActualToFormalTypeEdge)) THEN
        RETURN edge.getTargetNode();
      END;
      edge := iterator.next();
    END;
  END Get;


PROCEDURE IterateActuals (graph: SourceGraph.T; formalType: Syntax.T):
  EdgeIterator =
  VAR iterator: EdgeIterator;

  <* FATAL BaseGraph.NodeNotInGraph *>

  BEGIN
    iterator := NEW(EdgeIterator);
    iterator.baseEdgeIterator := graph.iterateInEdges(formalType);
    RETURN iterator;
  END IterateActuals;


PROCEDURE IteratorNext (iterator: EdgeIterator): Syntax.T =
  VAR edge: BaseGraph.Edge;

  BEGIN
    edge := iterator.baseEdgeIterator.next();
    LOOP
      IF (edge = NIL) THEN RETURN NIL; END;
      IF (ISTYPE(edge, ActualToFormalTypeEdge)) THEN
        RETURN edge.getSourceNode();
      END;
      edge := iterator.baseEdgeIterator.next();
    END;
  END IteratorNext;


PROCEDURE BindAppls (graph: SourceGraph.T; procDeclOrDef: Syntax.T)
  RAISES {BaseGraph.NodeNotInGraph} =
  VAR applIdent: Token.T;

  BEGIN
    WITH procIdent = graph.getChildSymbol(
                       procDeclOrDef, no := 2,
                       expectedKind := Symbol.Kind.Identifier),
         iterator = DeclSupport.IterateProcCalls(graph, procIdent) DO
      applIdent := iterator.next();
      WHILE (applIdent # NIL) DO
        BindParams(graph, procIdent, applIdent);
        applIdent := iterator.next();
      END;
    END;
  END BindAppls;


PROCEDURE BindParams (graph    : SourceGraph.T;
                      declIdent: Token.T;
                      applIdent: Token.T        )
  RAISES {BaseGraph.NodeNotInGraph} =
  VAR
    parameterSectionSeqOpt: Syntax.T;
    actualParametersOpt   : Syntax.T;
    currentSection        : Syntax.T;
    currentSectionList    : Syntax.T;
    currentType           : Syntax.T;
    currentDecl           : Token.T;
    currentDeclList       : Syntax.T;
    currentActual         : Syntax.T;
    currentActualList     : Syntax.T;

  <* FATAL BaseGraph.EdgeInGraph *>

  BEGIN
    parameterSectionSeqOpt := GetParamDecls(graph, declIdent);
    IF (parameterSectionSeqOpt = NIL) THEN RETURN; END;
    actualParametersOpt := GetParamAppls(graph, applIdent);
    IF ((actualParametersOpt = NIL)
          OR (actualParametersOpt.getNoOfChildren() = 0)) THEN
      RETURN;
    END;

    currentSection :=
      graph.getChildSymbol(
        parameterSectionSeqOpt, no := 1,
        expectedKind := Symbol.Kind.SyntaxParameterSection);
    currentSectionList :=
      graph.getChildSymbol(
        parameterSectionSeqOpt, no := 2,
        expectedKind := Symbol.Kind.SyntaxParameterSectionList);
    currentType :=
      graph.getChildSymbol(currentSection, no := 5,
                           expectedKind := Symbol.Kind.SyntaxFormalType);
    currentDecl :=
      graph.getChildSymbol(
        currentSection, no := 2, expectedKind := Symbol.Kind.Identifier);
    currentDeclList :=
      graph.getChildSymbol(currentSection, no := 3,
                           expectedKind := Symbol.Kind.SyntaxDIdentList);
    WITH actualParameters = graph.getChildSymbol(
                              actualParametersOpt, no := 1,
                              expectedKind :=
                                Symbol.Kind.SyntaxActualParameters),
         exprSeqOpt = graph.getChildSymbol(
                        actualParameters, no := 2,
                        expectedKind := Symbol.Kind.SyntaxExprSeqOpt) DO
      IF (NARROW(exprSeqOpt, Syntax.T).getNoOfChildren() = 0) THEN
        Message.Write(graph := graph, token := applIdent,
                      code := Message.Code.ShortActualParameterList);
        RETURN;
      END;
      currentActual :=
        graph.getChildSymbol(
          exprSeqOpt, no := 1, expectedKind := Symbol.Kind.SyntaxExpr);
      currentActualList :=
        graph.getChildSymbol(
          exprSeqOpt, no := 2, expectedKind := Symbol.Kind.SyntaxExprList);
    END;

    LOOP
      WITH edge = NEW(ActualToFormalTypeEdge).init() DO
        graph.insertEdge(edge, currentActual, currentType);
      END;
      IF (currentDeclList.getNoOfChildren() = 0) THEN
        IF (currentSectionList.getNoOfChildren() = 0) THEN EXIT; END;
        currentSection :=
          graph.getChildSymbol(
            currentSectionList, no := 2,
            expectedKind := Symbol.Kind.SyntaxParameterSection);
        currentSectionList :=
          graph.getChildSymbol(
            currentSectionList, no := 3,
            expectedKind := Symbol.Kind.SyntaxParameterSectionList);
        currentType := graph.getChildSymbol(
                         currentSection, no := 5,
                         expectedKind := Symbol.Kind.SyntaxFormalType);
        currentDecl :=
          graph.getChildSymbol(currentSection, no := 2,
                               expectedKind := Symbol.Kind.Identifier);
        currentDeclList := graph.getChildSymbol(
                             currentSection, no := 3,
                             expectedKind := Symbol.Kind.SyntaxDIdentList);
      ELSE
        currentDecl :=
          graph.getChildSymbol(currentDeclList, no := 2,
                               expectedKind := Symbol.Kind.Identifier);
        currentDeclList := graph.getChildSymbol(
                             currentDeclList, no := 3,
                             expectedKind := Symbol.Kind.SyntaxDIdentList);
      END;
      IF (currentActualList.getNoOfChildren() = 0) THEN
        Message.Write(graph := graph, token := applIdent,
                      code := Message.Code.ShortActualParameterList);
        RETURN;
      END;
      currentActual :=
        graph.getChildSymbol(currentActualList, no := 2,
                             expectedKind := Symbol.Kind.SyntaxExpr);
      currentActualList :=
        graph.getChildSymbol(currentActualList, no := 3,
                             expectedKind := Symbol.Kind.SyntaxExprList);
    END;
  END BindParams;


(* Compute declaration's ParameterSectionSeqOpt. *)
PROCEDURE GetParamDecls (graph: SourceGraph.T; declIdent: Token.T):
  Syntax.T RAISES {BaseGraph.NodeNotInGraph} =
  BEGIN
    WITH declOrDef = graph.getParentSyntax(declIdent) DO
      <* ASSERT declOrDef.getKind()
                    IN Symbol.KindSet{
                         Symbol.Kind.SyntaxProcedureDeclaration,
                         Symbol.Kind.SyntaxProcedureDefinition} *>
      WITH scope = graph.getChildSymbol(declOrDef, no := 3) DO
        <* ASSERT scope.getKind()
                         IN Symbol.KindSet{
                              Symbol.Kind.SyntaxFormalScope,
                              Symbol.Kind.SyntaxOuterScope} *>
        WITH formalParametersOpt = graph.getChildSymbol(
                                     scope, no := 1,
                                     expectedKind :=
                                       Symbol.Kind.SyntaxFormalParametersOpt) DO
          IF (NARROW(formalParametersOpt, Syntax.T).getNoOfChildren() = 0) THEN
            RETURN NIL;
          END;
          WITH formalParameters = graph.getChildSymbol(
                                    formalParametersOpt, no := 1,
                                    expectedKind :=
                                      Symbol.Kind.SyntaxFormalParameters),
               parameterSectionSeqOpt = graph.getChildSymbol(
                                          formalParameters, no := 2,
                                          expectedKind :=
                                            Symbol.Kind.SyntaxParameterSectionSeqOpt) DO
            IF (NARROW(parameterSectionSeqOpt, Syntax.T).getNoOfChildren()
                  = 0) THEN
              RETURN NIL;
            END;
            RETURN parameterSectionSeqOpt;
          END;
        END;
      END;
    END;
  END GetParamDecls;


(* Compute application's ActualParametersOpt. *)
PROCEDURE GetParamAppls (graph: SourceGraph.T; applIdent: Token.T):
  Syntax.T RAISES {BaseGraph.NodeNotInGraph} =
  VAR current: Syntax.T;

  BEGIN
    current := graph.getParentSyntax(applIdent);
    WHILE ((current # NIL)
             AND (NOT (current.getKind()
                         IN Symbol.KindSet{
                              Symbol.Kind.SyntaxQualSetOrCall,
                              Symbol.Kind.SyntaxAssignmentOrCallStatement,
                              Symbol.Kind.SyntaxExtraScope}))) DO
      current := graph.getParentSyntax(current);
    END;
    IF (current = NIL) THEN RETURN NIL; END;
    IF (current.getKind() = Symbol.Kind.SyntaxQualSetOrCall) THEN
      WITH setOrCall = graph.getChildSymbol(
                         current, no := 2,
                         expectedKind := Symbol.Kind.SyntaxSetOrCall),
           call = graph.getChildSymbol(
                    setOrCall, no := 1,
                    expectedKind := Symbol.Kind.SyntaxCall) DO
        RETURN graph.getChildSymbol(
                 call, no := 2,
                 expectedKind := Symbol.Kind.SyntaxActualParametersOpt);
      END;
    ELSIF (current.getKind() = Symbol.Kind.SyntaxAssignmentOrCallStatement) THEN
      WITH assignmentOrCall = graph.getChildSymbol(
                                current, no := 2,
                                expectedKind :=
                                  Symbol.Kind.SyntaxAssignmentOrCall),
           node = graph.getChildSymbol(assignmentOrCall, no := 1) DO
        IF (node.getKind() = Symbol.Kind.SyntaxActualParametersOpt) THEN
          RETURN node;
        ELSE
          (* application ident in an expression *)
          RETURN NIL;
        END;
      END;
    ELSE
      (* application ident in END x *)
      RETURN NIL;
    END;
  END GetParamAppls;

BEGIN
END ActualToFormalType.
