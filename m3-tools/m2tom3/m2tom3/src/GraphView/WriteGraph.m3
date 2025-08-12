MODULE WriteGraph;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Thomas Stockheim                                          *)

(** pk
    1.1
    1994/11/30 15:06:58
    WriteGraph.m3,v
# Revision 1.1  1994/11/30  15:06:58  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT SourceGraph, SyntaxEdge, Token, TokenEdge, TokenAnchor, UnitAnchor,
       SyntaxAnchor, Symbol, Syntax, ScopeToDeclEdge, DeclToApplEdge,
       ServerToClientEdge, BaseGraph, BaseNode, Fmt, Wr, BaseEdge, IO;


<* FATAL ANY *>

VAR
  file    : Wr.T;
  num     : INTEGER    := 1;
  anchor  : BaseNode.T;
  oldToken: BaseNode.T := NIL;


PROCEDURE WriteEdge (         edge       : BaseEdge.T;
                              in, out    : BaseNode.T;
                     READONLY whichNodes : Symbol.KindSet;
                              unseenNodes: CARDINAL        ) =
  BEGIN
    IF (WriteMe(in, whichNodes) AND WriteMe(out, whichNodes)) THEN
      IF ((in # NIL) AND (out # NIL)) THEN
        TYPECASE edge OF
          TokenEdge.T =>
            Wr.PutText(
              file,
              "edge: {\n\tlinestyle: dotted\n\tthickness: 1\n\tsourcename: \""
                & Fmt.Int(in.getNumber()) & "\"\n\ttargetname: \""
                & Fmt.Int(out.getNumber()) & "\"\n}\n");

        | SyntaxEdge.T =>
            Wr.PutText(
              file, "edge: {\n\tthickness: 1\n\tlabel: \""
                      & Fmt.Int(NARROW(edge, SyntaxEdge.T).getNo())
                      & "\"\n\tsourcename: \"" & Fmt.Int(in.getNumber())
                      & "\"\n\ttargetname: \"" & Fmt.Int(out.getNumber())
                      & "\"\n}\n");

        | DeclToApplEdge.T =>
            unseenNodes := unseenNodes + 1;
            Wr.PutText(file, "node: {\n");
            Wr.PutText(file, "\ttitle: \"" & Fmt.Int(unseenNodes)
                               & "UN\"\n\tlabel : \" \""
                               & "\n\tborderwidth: 0\n\twidth: 14\n}\n");
            Wr.PutText(
              file,
              "edge: {\n\tlinestyle: dashed\n\tthickness: 1\n\tsourcename: \""
                & Fmt.Int(in.getNumber()) & "\"\n\ttargetname: \""
                & Fmt.Int(unseenNodes) & "UN\"\n\tarrowstyle: none"
                & "\n}\n");
            Wr.PutText(
              file,
              "edge: {\n\tlinestyle: dashed\n\tthickness: 1\n\tsourcename: \""
                & Fmt.Int(unseenNodes) & "UN\"\n\ttargetname: \""
                & Fmt.Int(out.getNumber()) & "\"\n}\n");

        | ScopeToDeclEdge.T =>
            Wr.PutText(
              file, "edge: {\n\tlinestyle: dashed\n\tthickness: 2"
                      & "\n\tsourcename: \"" & Fmt.Int(in.getNumber())
                      & "\"\n\ttargetname: \"" & Fmt.Int(out.getNumber())
                      & "\"\n}\n");

        | ServerToClientEdge.T =>
            Wr.PutText(
              file, "edge: {\n\tthickness: 2" & "\n\tsourcename: \""
                      & Fmt.Int(in.getNumber()) & "\"\n\ttargetname: \""
                      & Fmt.Int(out.getNumber()) & "\"\n}\n");
        ELSE
          Wr.PutText(file, "edge: {\n");
          Wr.PutText(file, "\n\tthickness: 1\tlinestyle: dashed\n");
          Wr.PutText(
            file, "\t\tsourcename: \"" & Fmt.Int(in.getNumber()) & "\"\n");
          Wr.PutText(
            file, "\t\ttargetname: \"" & Fmt.Int(out.getNumber()) & "\"\n");
          Wr.PutText(file, "\t}\n");
        END;
      END;
    END;
  END WriteEdge;


PROCEDURE WriteMe (node: BaseNode.T; READONLY whichNodes: Symbol.KindSet):
  BOOLEAN =
  BEGIN
    RETURN (ISTYPE(node, Symbol.T)
              AND (NARROW(node, Symbol.T).getKind() IN whichNodes))
             OR NOT ISTYPE(node, Symbol.T);
  END WriteMe;


PROCEDURE WriteNode (         node       : BaseNode.T;
                              graph      : SourceGraph.T;
                              depth      : INTEGER;
                     READONLY whichNodes : Symbol.KindSet;
                              unseenNodes: CARDINAL        ) =
  VAR
    iterator, iterator1   : BaseGraph.EdgeIterator;
    edge                  : BaseEdge.T;
    in, out, oldout, dummy: BaseNode.T             := NIL;
    found                 : BOOLEAN;
    fileAnchorName        : TEXT;

  BEGIN
    IF (node # NIL) THEN
      IF (node.getNumber() = 0) THEN
        node.setNumber(num);
        num := num + 1;
        IF (WriteMe(node, whichNodes)) THEN
          Wr.PutText(file, "node: {\n");
          Wr.PutText(
            file, "\ttitle: \"" & Fmt.Int(node.getNumber()) & "\"\n");
          TYPECASE node OF
            Token.T =>

              Wr.PutText(file, "\tborderwidth : 1\nlabel: \""
                                 (* & Fmt.Int(node.getNumber())*)
                                 & NARROW(node, Token.T).getText());

              CASE NARROW(node, Symbol.T).getKind() OF
                Symbol.Kind.Identifier => Wr.PutText(file, "\nIdent");
              | Symbol.Kind.RealConst => Wr.PutText(file, "\nRealC");
              | Symbol.Kind.StringConst => Wr.PutText(file, "\nStringC");
              | Symbol.Kind.IntegerConst => Wr.PutText(file, "\nIntC");
              | Symbol.Kind.LongConst => Wr.PutText(file, "\nLongC");
              | Symbol.Kind.CharConst => Wr.PutText(file, "\nCharC");
              ELSE
                Wr.PutText(file, "\n");
              END;

              Wr.PutText(file, "\n");
              IF (Token.Usage.Decl IN NARROW(node, Token.T).getUsageSet()) THEN
                Wr.PutText(file, "Decl ");
              END;
              IF (Token.Usage.Appl IN NARROW(node, Token.T).getUsageSet()) THEN
                Wr.PutText(file, "Appl");
              END;

              Wr.PutText(file, "\n");
              IF (Token.Language.M2 IN NARROW(node, Token.T).getLanguages()) THEN
                Wr.PutText(file, "m2 ");
              END;
              IF (Token.Language.M3 IN NARROW(node, Token.T).getLanguages()) THEN
                Wr.PutText(file, "m3");
              END;
              Wr.PutText(file, "\"\n");

          | Syntax.T =>
              Wr.PutText(file, "\tlabel: \"");
              CASE NARROW(node, Symbol.T).getKind() OF
                Symbol.Kind.SyntaxCompilationUnit =>
                  Wr.PutText(file, "Compilation Unit");
              | Symbol.Kind.SyntaxProgramModule =>
                  Wr.PutText(file, "ProgramModul");
              | Symbol.Kind.SyntaxDeclaration =>
                  Wr.PutText(file, "Declaration");
              | Symbol.Kind.SyntaxDefinition =>
                  Wr.PutText(file, "Definition");
              | Symbol.Kind.SyntaxExport => Wr.PutText(file, "Export");
              | Symbol.Kind.SyntaxModuleDeclaration =>
                  Wr.PutText(file, "ModuleDeclaration");
              | Symbol.Kind.SyntaxProcedureDeclaration =>
                  Wr.PutText(file, "ProcedureDeclaration");
              | Symbol.Kind.SyntaxType => Wr.PutText(file, "Type");
              | Symbol.Kind.SyntaxSetType => Wr.PutText(file, "SetType");
              | Symbol.Kind.SyntaxArrayType =>
                  Wr.PutText(file, "ArrayType");
              | Symbol.Kind.SyntaxRecordType =>
                  Wr.PutText(file, "RecordType");
              | Symbol.Kind.SyntaxWithStatement =>
                  Wr.PutText(file, "With");
              | Symbol.Kind.SyntaxLoopStatement =>
                  Wr.PutText(file, "Loop");
              | Symbol.Kind.SyntaxForStatement => Wr.PutText(file, "For");
              | Symbol.Kind.SyntaxRepeatStatement =>
                  Wr.PutText(file, "Repeat");
              | Symbol.Kind.SyntaxTerm => Wr.PutText(file, "Term");
              | Symbol.Kind.SyntaxWhileStatement =>
                  Wr.PutText(file, "While");
              | Symbol.Kind.SyntaxPointerType =>
                  Wr.PutText(file, "PointerType");
              | Symbol.Kind.SyntaxProcedureType =>
                  Wr.PutText(file, "ProcedureType");
              | Symbol.Kind.SyntaxBlock => Wr.PutText(file, "Block");
              | Symbol.Kind.SyntaxDefinitionModule =>
                  Wr.PutText(file, "DefinitionModule");
              | Symbol.Kind.SyntaxImport => Wr.PutText(file, "Import");
              | Symbol.Kind.SyntaxForIdentOpt =>
                  Wr.PutText(file, "ForIdentOpt");
              | Symbol.Kind.SyntaxDefinitionScope =>
                  Wr.PutText(file, "DefinitionScope");
              | Symbol.Kind.SyntaxProgramScope =>
                  Wr.PutText(file, "ProgramScope");
              | Symbol.Kind.SyntaxDefinitionList =>
                  Wr.PutText(file, "DefinitionList");
              | Symbol.Kind.SyntaxImplementationOpt =>
                  Wr.PutText(file, "ImplementationOpt");
              | Symbol.Kind.SyntaxTypeOptList =>
                  Wr.PutText(file, "TypeOptList");
              | Symbol.Kind.SyntaxConstList =>
                  Wr.PutText(file, "ConstList");
              | Symbol.Kind.SyntaxTypeOpt => Wr.PutText(file, "TypeOpt");
              | Symbol.Kind.SyntaxConstDefinition =>
                  Wr.PutText(file, "ConstDefinition");
              | Symbol.Kind.SyntaxTypeDefinition =>
                  Wr.PutText(file, "TypeDefinition");
              | Symbol.Kind.SyntaxVarDefinition =>
                  Wr.PutText(file, "VarDefinition");
              | Symbol.Kind.SyntaxVarList => Wr.PutText(file, "VarList");
              | Symbol.Kind.SyntaxProcedureDefinition =>
                  Wr.PutText(file, "ProcedureDefinition");
              | Symbol.Kind.SyntaxFormalScope =>
                  Wr.PutText(file, "FormalScope ");
              | Symbol.Kind.SyntaxImportList =>
                  Wr.PutText(file, "ImportList");
              | Symbol.Kind.SyntaxQualifiedImport =>
                  Wr.PutText(file, "QualifiedImport");
              | Symbol.Kind.SyntaxUnqualifiedImport =>
                  Wr.PutText(file, "UnqualifiedImport");
              | Symbol.Kind.SyntaxImportScope =>
                  Wr.PutText(file, "ImportScope");
              | Symbol.Kind.SyntaxExportList =>
                  Wr.PutText(file, "ExportList");
              | Symbol.Kind.SyntaxExportOpt =>
                  Wr.PutText(file, "ExportOpt");
              | Symbol.Kind.SyntaxQualifiedOpt =>
                  Wr.PutText(file, "QualifiedOpt");
              | Symbol.Kind.SyntaxExportScope =>
                  Wr.PutText(file, "ExportScope");
              | Symbol.Kind.SyntaxBlockStatementsOpt =>
                  Wr.PutText(file, "BlockStatementsOpt");
              | Symbol.Kind.SyntaxDeclarationList =>
                  Wr.PutText(file, "DeclarationList");
              | Symbol.Kind.SyntaxTypeDeclaration =>
                  Wr.PutText(file, "TypeDeclaration");
              | Symbol.Kind.SyntaxTypeDeclarationList =>
                  Wr.PutText(file, "TypeDeclarationList");
              | Symbol.Kind.SyntaxPriorityOpt =>
                  Wr.PutText(file, "PriorityOpt");
              | Symbol.Kind.SyntaxModuleScope =>
                  Wr.PutText(file, "ModuleScope");
              | Symbol.Kind.SyntaxOuterScope =>
                  Wr.PutText(file, "OuterScope");
              | Symbol.Kind.SyntaxProcedureTail =>
                  Wr.PutText(file, "ProcedureTail");
              | Symbol.Kind.SyntaxProcedureBody =>
                  Wr.PutText(file, "ProcedureBody");
              | Symbol.Kind.SyntaxInnerScope =>
                  Wr.PutText(file, "InnerScope");
              | Symbol.Kind.SyntaxExtraScope =>
                  Wr.PutText(file, "ExtraScope");
              | Symbol.Kind.SyntaxFormalParametersOpt =>
                  Wr.PutText(file, "FormalParametersOpt");
              | Symbol.Kind.SyntaxFormalParameters =>
                  Wr.PutText(file, "FormalParameters");
              | Symbol.Kind.SyntaxReturnParameterOpt =>
                  Wr.PutText(file, "ReturnParameterOpt");
              | Symbol.Kind.SyntaxParameterSectionSeqOpt =>
                  Wr.PutText(file, "ParameterSectionSeqOpt");
              | Symbol.Kind.SyntaxParameterSectionList =>
                  Wr.PutText(file, "ParameterSectionList");
              | Symbol.Kind.SyntaxParameterSection =>
                  Wr.PutText(file, "ParameterSection");
              | Symbol.Kind.SyntaxVarOpt => Wr.PutText(file, "VarOpt");
              | Symbol.Kind.SyntaxFormalSignatureOpt =>
                  Wr.PutText(file, "FormalSignatureOpt");
              | Symbol.Kind.SyntaxFormalSignature =>
                  Wr.PutText(file, "FormalSignature");
              | Symbol.Kind.SyntaxReturnSignatureOpt =>
                  Wr.PutText(file, "xReturnSignatureOpt");
              | Symbol.Kind.SyntaxSignatureSectionSeqOpt =>
                  Wr.PutText(file, "SignatureSectionSeqOpt");
              | Symbol.Kind.SyntaxSignatureSectionList =>
                  Wr.PutText(file, "SignatureSectionList");
              | Symbol.Kind.SyntaxSignatureSection =>
                  Wr.PutText(file, "SignatureSection");
              | Symbol.Kind.SyntaxFormalType =>
                  Wr.PutText(file, "FormalType");
              | Symbol.Kind.SyntaxArrayOpt => Wr.PutText(file, "ArrayOpt");
              | Symbol.Kind.SyntaxSimpleTypeList =>
                  Wr.PutText(file, "SimpleTypeList");
              | Symbol.Kind.SyntaxRecordScope =>
                  Wr.PutText(file, "RecordScope");
              | Symbol.Kind.SyntaxFieldOptSeq =>
                  Wr.PutText(file, "FieldOptSeq");
              | Symbol.Kind.SyntaxFieldOptList =>
                  Wr.PutText(file, "FieldOptList");
              | Symbol.Kind.SyntaxFieldOpt => Wr.PutText(file, "FieldOpt");
              | Symbol.Kind.SyntaxField => Wr.PutText(file, "Field");
              | Symbol.Kind.SyntaxSimpleField =>
                  Wr.PutText(file, "SimpleField");
              | Symbol.Kind.SyntaxCaseField =>
                  Wr.PutText(file, "CaseField");
              | Symbol.Kind.SyntaxElseFieldOpt =>
                  Wr.PutText(file, "ElseFieldOpt");
              | Symbol.Kind.SyntaxVariantOptList =>
                  Wr.PutText(file, "VariantOptList");
              | Symbol.Kind.SyntaxVariantOpt =>
                  Wr.PutText(file, "VariantOpt");
              | Symbol.Kind.SyntaxSimpleType =>
                  Wr.PutText(file, "SimpleType");
              | Symbol.Kind.SyntaxEnumeration =>
                  Wr.PutText(file, "Enumeration");
              | Symbol.Kind.SyntaxSubrange => Wr.PutText(file, "Subrange");
              | Symbol.Kind.SyntaxQualIdentOrSubrange =>
                  Wr.PutText(file, "QualIdentOrSubrange ");
              | Symbol.Kind.SyntaxSubrangeOpt =>
                  Wr.PutText(file, "SubrangeOpt");
              | Symbol.Kind.SyntaxStatementOptSeq =>
                  Wr.PutText(file, "StatementOptSeq");
              | Symbol.Kind.SyntaxStatementOptList =>
                  Wr.PutText(file, "StatementOptList");
              | Symbol.Kind.SyntaxStatementOpt =>
                  Wr.PutText(file, "StatementOpt");
              | Symbol.Kind.SyntaxStatement =>
                  Wr.PutText(file, "Statement");
              | Symbol.Kind.SyntaxAssignmentOrCallStatement =>
                  Wr.PutText(file, "AssignmentOrCallStatement");
              | Symbol.Kind.SyntaxAssignmentOrCall =>
                  Wr.PutText(file, "AssignmentOrCall");
              | Symbol.Kind.SyntaxAssignment =>
                  Wr.PutText(file, "Assignment");
              | Symbol.Kind.SyntaxExitStatement =>
                  Wr.PutText(file, "ExitStatement");
              | Symbol.Kind.SyntaxReturnStatement =>
                  Wr.PutText(file, "ReturnStatement");
              | Symbol.Kind.SyntaxIfStatement => Wr.PutText(file, "If");
              | Symbol.Kind.SyntaxElseIfList =>
                  Wr.PutText(file, "ElseIfList");
              | Symbol.Kind.SyntaxElseOpt => Wr.PutText(file, "ElseOpt ");
              | Symbol.Kind.SyntaxCaseStatement =>
                  Wr.PutText(file, "CaseStatement");
              | Symbol.Kind.SyntaxCaseOptSeq =>
                  Wr.PutText(file, "CaseOptSeq");
              | Symbol.Kind.SyntaxCaseOptList =>
                  Wr.PutText(file, "CaseOptList");
              | Symbol.Kind.SyntaxCaseOpt => Wr.PutText(file, "CaseOpt");
              | Symbol.Kind.SyntaxCase => Wr.PutText(file, "Case");
              | Symbol.Kind.SyntaxCaseLabelSeq =>
                  Wr.PutText(file, "CaseLabelSeq");
              | Symbol.Kind.SyntaxCaseLabelList =>
                  Wr.PutText(file, "CaseLabelList");
              | Symbol.Kind.SyntaxCaseLabel =>
                  Wr.PutText(file, "CaseLabel");
              | Symbol.Kind.SyntaxCaseRangeOpt =>
                  Wr.PutText(file, "CaseRangeOpt");
              | Symbol.Kind.SyntaxByExprOpt =>
                  Wr.PutText(file, "ByExprOpt");
              | Symbol.Kind.SyntaxWithScope =>
                  Wr.PutText(file, "WithScope");
              | Symbol.Kind.SyntaxDesignator =>
                  Wr.PutText(file, "Designator");
              | Symbol.Kind.SyntaxDesignatorTailList =>
                  Wr.PutText(file, "DesignatorTailList");
              | Symbol.Kind.SyntaxDesignatorTail =>
                  Wr.PutText(file, "DesignatorTail");
              | Symbol.Kind.SyntaxDesignatorScope =>
                  Wr.PutText(file, "DesignatorScope");
              | Symbol.Kind.SyntaxReference =>
                  Wr.PutText(file, "Reference");
              | Symbol.Kind.SyntaxSubscriptionScope =>
                  Wr.PutText(file, "SubscriptionScope");
              | Symbol.Kind.SyntaxActualParametersOpt =>
                  Wr.PutText(file, "ActualParametersOpt");
              | Symbol.Kind.SyntaxActualParameters =>
                  Wr.PutText(file, "ActualParameters");
              | Symbol.Kind.SyntaxExprSeqOpt =>
                  Wr.PutText(file, "ExprSeqOpt");
              | Symbol.Kind.SyntaxExprList => Wr.PutText(file, "ExprList");
              | Symbol.Kind.SyntaxExprOpt => Wr.PutText(file, "ExprOpt");
              | Symbol.Kind.SyntaxExpr => Wr.PutText(file, "Expr");
              | Symbol.Kind.SyntaxRelationOpt =>
                  Wr.PutText(file, "RelationOpt");
              | Symbol.Kind.SyntaxRelation => Wr.PutText(file, "Relation");
              | Symbol.Kind.SyntaxSimpleExpr =>
                  Wr.PutText(file, "SimpleExpr");
              | Symbol.Kind.SyntaxUnaryAddOpt =>
                  Wr.PutText(file, "UnaryAddOpt");
              | Symbol.Kind.SyntaxUnaryAdd => Wr.PutText(file, "UnaryAdd");
              | Symbol.Kind.SyntaxAddTermList =>
                  Wr.PutText(file, "AddTermList");
              | Symbol.Kind.SyntaxBinaryAdd =>
                  Wr.PutText(file, "BinaryAdd");
              | Symbol.Kind.SyntaxMulFactorList =>
                  Wr.PutText(file, "MulFactorList");
              | Symbol.Kind.SyntaxMul => Wr.PutText(file, "Mul");
              | Symbol.Kind.SyntaxFactor => Wr.PutText(file, "Factor");
              | Symbol.Kind.SyntaxFactorExpr =>
                  Wr.PutText(file, "FactorExpr");
              | Symbol.Kind.SyntaxNotFactor =>
                  Wr.PutText(file, "NotFactor");
              | Symbol.Kind.SyntaxQualSetOrCall =>
                  Wr.PutText(file, "QualSetOrCall");
              | Symbol.Kind.SyntaxSetOrCall =>
                  Wr.PutText(file, "SetOrCall");
              | Symbol.Kind.SyntaxCall => Wr.PutText(file, "Call");
              | Symbol.Kind.SyntaxSet => Wr.PutText(file, "Set");
              | Symbol.Kind.SyntaxElementSeqOpt =>
                  Wr.PutText(file, "ElementSeqOpt");
              | Symbol.Kind.SyntaxElementList =>
                  Wr.PutText(file, "ElementList ");
              | Symbol.Kind.SyntaxElement => Wr.PutText(file, "Element");
              | Symbol.Kind.SyntaxElementRangeOpt =>
                  Wr.PutText(file, "ElementRangeOpt");
              | Symbol.Kind.SyntaxConstExprSeqOpt =>
                  Wr.PutText(file, "ConstExprSeqOpt");
              | Symbol.Kind.SyntaxConstExprList =>
                  Wr.PutText(file, "ConstExprList");
              | Symbol.Kind.SyntaxConstExpr =>
                  Wr.PutText(file, "ConstExpr");
              | Symbol.Kind.SyntaxSimpleRelationOpt =>
                  Wr.PutText(file, "SimpleRelationOpt");
              | Symbol.Kind.SyntaxSimpleConstExpr =>
                  Wr.PutText(file, "SimpleConstExpr");
              | Symbol.Kind.SyntaxAddSimpleTermList =>
                  Wr.PutText(file, "AddSimpleTermList");
              | Symbol.Kind.SyntaxConstTerm =>
                  Wr.PutText(file, "ConstTerm");
              | Symbol.Kind.SyntaxMulConstFactorList =>
                  Wr.PutText(file, "MulConstFactorList ");
              | Symbol.Kind.SyntaxConstFactor =>
                  Wr.PutText(file, "ConstFactor");
              | Symbol.Kind.SyntaxConstFactorExpr =>
                  Wr.PutText(file, "ConstFactorExpr ");
              | Symbol.Kind.SyntaxNotConstFactor =>
                  Wr.PutText(file, "NotConstFactor");
              | Symbol.Kind.SyntaxQualConstSetOrCall =>
                  Wr.PutText(file, "QualConstSetOrCall");
              | Symbol.Kind.SyntaxConstSetOrCall =>
                  Wr.PutText(file, "ConstSetOrCall");
              | Symbol.Kind.SyntaxConstActualParametersOpt =>
                  Wr.PutText(file, "ConstActualParameters");
              | Symbol.Kind.SyntaxConstSet => Wr.PutText(file, "ConstSet");
              | Symbol.Kind.SyntaxConstElementSeqOpt =>
                  Wr.PutText(file, "ConstElementSeqOpt ");
              | Symbol.Kind.SyntaxConstElementList =>
                  Wr.PutText(file, "ConstElementList");
              | Symbol.Kind.SyntaxConstElement =>
                  Wr.PutText(file, "ConstElement");
              | Symbol.Kind.SyntaxConstRangeOpt =>
                  Wr.PutText(file, "ConstRangeOpt");
              | Symbol.Kind.SyntaxDIdentOpt =>
                  Wr.PutText(file, "DIdentOpt");
              | Symbol.Kind.SyntaxDIdentList =>
                  Wr.PutText(file, "DIdentList");
              | Symbol.Kind.SyntaxDAIdentList =>
                  Wr.PutText(file, "DAIdentList");
              | Symbol.Kind.SyntaxQualIdent =>
                  Wr.PutText(file, "QualIdent");
              | Symbol.Kind.SyntaxQualificationScope =>
                  Wr.PutText(file, "QualificationScope");
              | Symbol.Kind.SyntaxEnvScope => Wr.PutText(file, "EnvScope");
              ELSE
                Wr.PutText(file, "unknown");
              END;
              Wr.PutText(file, "\"\n");

          | TokenAnchor.T, SyntaxAnchor.T =>
              fileAnchorName := NARROW(node, UnitAnchor.T).getName();
              Wr.PutText(file, "\tborderwidth : 3\n\tlabel: \""
                                 & "ANCHOR\n" & fileAnchorName & "\"\n");
          ELSE                   (* what's it ??? *)
            Wr.PutText(
              file, "\tborderwidth : 3\n\tlabel: \"" & "??? " & "\"\n");
          END;
          Wr.PutText(file, "}\n");
        END;

        IF (depth > 0) THEN
          iterator := graph.iterateOutEdges(node);
          found := TRUE;
          WHILE (found) DO
            IF (out # NIL) THEN
              TYPECASE out OF Syntax.T, Token.T => oldout := out; ELSE END;
            END;

            edge := iterator.next();
            found := (edge # NIL);
            IF (found) THEN
              in := edge.getSourceNode();
              out := edge.getTargetNode();
            ELSE
              in := NIL;
              out := NIL;
            END;

            IF (found) THEN
              LOOP
                TYPECASE out OF
                  Token.T =>
                    IF (NARROW(out, Symbol.T).getKind()
                          = Symbol.Kind.WhiteSpace
                          OR NARROW(out, Symbol.T).getKind()
                               = Symbol.Kind.Comment) THEN
                      iterator1 := graph.iterateOutEdges(out);
                      out := graph.getNextToken(
                               NARROW(out, Token.T), Token.Language.M2);

                      IF (out = NIL) THEN
                        edge := iterator1.next();
                        found := (edge # NIL);
                        IF found THEN
                          dummy := edge.getSourceNode();
                          out := edge.getTargetNode();
                        ELSE
                          dummy := NIL;
                          out := NIL
                        END
                      END;
                    ELSE
                      EXIT;
                    END;
                ELSE
                  EXIT;
                END;
              END;

              WriteNode(out, graph, depth - 1, whichNodes, unseenNodes);

              (* print child n+1 right of child n*)
              TYPECASE out OF
                Syntax.T (*, Token.T *) =>
                  IF (oldout # NIL) THEN
                    WriteConstraint(
                      oldout, out, "right", "x", whichNodes, 2);
                  END;
              ELSE
              END;

              (* print all token equal every higher syntax node higher *)
              TYPECASE out OF
                Token.T => oldToken := out;
              | Syntax.T =>
                  IF ((oldToken # NIL) AND (oldToken # out)) THEN
                    WriteConstraint(
                      out, oldToken, "smaller", "y", whichNodes);
                  END;
              ELSE
              END;

              (* anchor above all *)
              TYPECASE node OF
                Syntax.T =>
                  WriteConstraint(node, out, "smaller", "y", whichNodes);
              | Token.T =>
              | TokenAnchor.T, SyntaxAnchor.T =>
                  WriteConstraint(node, out, "smaller", "y", whichNodes);
              ELSE
              END;
              WriteEdge(edge, in, out, whichNodes, unseenNodes);
            END;
          END;
        END;
      END;
    END;
  END WriteNode;


PROCEDURE WriteConstraint (         node1, node2: BaseNode.T;
                                    name        : TEXT;
                                    dim         : TEXT;
                           READONLY whichNodes  : Symbol.KindSet;
                                    priority    : CARDINAL         := 0) =
  BEGIN
    IF (WriteMe(node1, whichNodes) AND WriteMe(node2, whichNodes)) THEN
      Wr.PutText(
        file, "constraint: {\n\tname:" & name & "\n\tdimension:" & dim
                & "\n\tnodes: {\"" & Fmt.Int(node1.getNumber()) & "\",\""
                & Fmt.Int(node2.getNumber()) & "\"}\n\tpriority:"
                & Fmt.Int(priority) & "\n}\n");
    END;
  END WriteConstraint;


PROCEDURE WriteTokenConstraint (         graph     : SourceGraph.T;
                                         anchor    : BaseNode.T;
                                READONLY whichNodes: Symbol.KindSet ) =
  VAR secondTokenM2, firstTokenM2, theTokenM3: BaseNode.T := NIL;

  BEGIN
    secondTokenM2 := graph.getFirstToken(
                       NARROW(anchor, TokenAnchor.T), Token.Language.M2);

    IF ((secondTokenM2 # NIL) AND (secondTokenM2 # anchor)) THEN
      firstTokenM2 := FindNextRegularToken(
                        graph, anchor, secondTokenM2, Token.Language.M2);
    END;

    WHILE ((firstTokenM2 # NIL) AND (firstTokenM2 # anchor)) DO
      (* constraints about m2 tokens *)
      IF ((firstTokenM2 # secondTokenM2) AND (firstTokenM2.getNumber() # 0)
            AND (secondTokenM2.getNumber() # 0)) THEN
        WriteConstraint(
          firstTokenM2, secondTokenM2, "right", "x", whichNodes, 2);
        WriteConstraint(
          firstTokenM2, secondTokenM2, "equal", "y", whichNodes, 2);
        theTokenM3 := graph.getPrevToken(firstTokenM2, Token.Language.M3);

        (* constraints between m2 and m3 tokens *)
        WHILE ((theTokenM3 # NIL) AND (theTokenM3 # anchor)
                 AND (NARROW(theTokenM3, Symbol.T).getKind()
                        = Symbol.Kind.WhiteSpace
                        OR NARROW(theTokenM3, Symbol.T).getKind()
                             = Symbol.Kind.Comment)) DO
          theTokenM3 := graph.getPrevToken(theTokenM3, Token.Language.M3);
        END;
        IF ((theTokenM3 # NIL) AND (secondTokenM2 # NIL)
              AND (theTokenM3 # secondTokenM2)
              AND (theTokenM3.getNumber() # 0)) THEN
          WriteConstraint(
            theTokenM3, secondTokenM2, "right", "x", whichNodes, 1);
          WriteConstraint(
            theTokenM3, secondTokenM2, "equal", "y", whichNodes, 1);
          WriteConstraint(
            firstTokenM2, theTokenM3, "right", "x", whichNodes, 1);
          WriteConstraint(
            firstTokenM2, theTokenM3, "equal", "y", whichNodes, 1);
        END;
      END;
      secondTokenM2 := firstTokenM2;
      firstTokenM2 := FindNextRegularToken(
                        graph, anchor, firstTokenM2, Token.Language.M2);
    END;
  END WriteTokenConstraint;


PROCEDURE FindNextRegularToken (graph   : SourceGraph.T;
                                anchor  : BaseNode.T;
                                aktToken: Token.T;
                                lang    : Token.Language ): Token.T =
  BEGIN
    IF (aktToken # NIL) THEN
      aktToken := graph.getNextToken(aktToken, lang);
    END;
    WHILE ((aktToken # NIL) AND (aktToken # anchor)
             AND (NARROW(aktToken, Symbol.T).getKind()
                    = Symbol.Kind.WhiteSpace
                    OR NARROW(aktToken, Symbol.T).getKind()
                         = Symbol.Kind.Comment)) DO
      aktToken := graph.getNextToken(aktToken, lang);
    END;
    RETURN aktToken;
  END FindNextRegularToken;


PROCEDURE WriteGrl (graph          : SourceGraph.T;
                    filename       : TEXT;
                    node           : BaseNode.T;
                    depth          : CARDINAL;
                    dumpRestriction: BOOLEAN        ) RAISES {} =

  VAR
    unseenNodes: CARDINAL       := 0;
    whichNodes : Symbol.KindSet;

  BEGIN
    IF (dumpRestriction) THEN
      whichNodes :=
        Symbol.KindSet{
          Symbol.Kind.ProgramModule.. Symbol.Kind.With,
          Symbol.Kind.SyntaxEnvScope, Symbol.Kind.SyntaxDefinitionScope,
          Symbol.Kind.SyntaxProgramScope, Symbol.Kind.SyntaxFormalScope,
          Symbol.Kind.SyntaxImportScope, Symbol.Kind.SyntaxExportScope,
          Symbol.Kind.SyntaxModuleScope, Symbol.Kind.SyntaxOuterScope,
          Symbol.Kind.SyntaxInnerScope, Symbol.Kind.SyntaxExtraScope,
          Symbol.Kind.SyntaxRecordScope, Symbol.Kind.SyntaxWithScope,
          Symbol.Kind.SyntaxDesignatorScope,
          Symbol.Kind.SyntaxSubscriptionScope,
          Symbol.Kind.SyntaxQualificationScope};
    ELSE
      whichNodes := Symbol.KindSet{FIRST(Symbol.Kind).. LAST(Symbol.Kind)};
    END;

    anchor := node;
    file := IO.OpenWrite(filename);
    Wr.PutText(file, "graph: {\n");
    Wr.PutText(file, "\tlayoutalgorithm: constraints\n");
    Wr.PutText(file, "\txspace : 20\n\tyspace : 20\n");
    Wr.PutText(file, "\twidth : 1000\n\theight : 800\n\tx:20\n\ty:20\n");
    WITH iter = graph.iterateUnits() DO
      anchor := iter.next();
      WHILE anchor # NIL DO
        WriteNode(anchor, graph, depth, whichNodes, unseenNodes);
        WriteTokenConstraint(graph, anchor, whichNodes);
        Wr.PutText(file, "\n");
        anchor := iter.next();
      END;
    END;
    WriteNode(graph.getEnvScope(), graph, depth, whichNodes, unseenNodes);
    Wr.Close(file);
  END WriteGrl;

BEGIN
END WriteGraph.
