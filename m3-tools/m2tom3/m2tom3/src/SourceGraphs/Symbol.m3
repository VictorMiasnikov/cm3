MODULE Symbol;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:08:39
    Symbol.m3,v
# Revision 1.1  1994/11/30  15:08:39  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- Symbol -----------------------------------------------------------------
  * Assumptions about hashing:
  *  hashing is yet irrelevant
  * ----------------------------------------------------------------------------
  **)

IMPORT BaseNode;


REVEAL
  T = Public BRANDED OBJECT
        kind: Kind;

      OVERRIDES
        init        := Init;
        getKind     := GetKind;
        getKindText := GetKindText;
      END;


PROCEDURE Init (self: T; kind: Kind): T =
  BEGIN
    self := NARROW(self, BaseNode.T).init();
    self.kind := kind;
    RETURN self;
  END Init;


PROCEDURE GetKind (self: T): Kind =
  BEGIN
    RETURN self.kind;
  END GetKind;


PROCEDURE GetKindText (self: T): TEXT =
  CONST
    KindText = ARRAY Kind OF
                 TEXT{           (* used for special things *)
                 "NoToken", "BadToken", "Comment", "WhiteSpace", "GenText",

                 (* used for declaration graph *)
                 "SyntaxEnvScope",

                 (* used for Modula-2 token *)
                 "ProgramModule", "DefinitionModule", "Block",
                 "Declaration", "StatementSequence", "Identifier",
                 "StringConst", "IntegerConst", "LongConst", "RealConst",
                 "CharConst", "Plus", "Minus", "Mult", "Division",
                 "Assign", "Ampersand", "Period", "Comma", "Semicolon",
                 "LBracket", "ALBracket", "CLBracket", "RBracket",
                 "ARBracket", "CRBracket", "Arrow", "Equal", "NEqual",
                 "Less", "Greater", "LEqual", "GEqual", "Range", "Colon",
                 "Bar", "And", "Array", "Begin", "By", "Case", "Const",
                 "Definition", "Div", "Do", "Else", "Elsif", "End", "Exit",
                 "Export", "For", "Forward", "From", "If",
                 "Implementation", "Import", "In", "Loop", "Mod", "Module",
                 "Not", "Of", "Or", "Pointer", "Procedure", "Qualified",
                 "Rem", "Record", "Repeat", "Return", "Set", "Then", "To",
                 "Type", "Until", "Var", "While", "With",

                 (* used for Modula-2 syntax *)
                 "SyntaxCompilationUnit", "SyntaxDefinitionModule",
                 "SyntaxPublicScope", "SyntaxForIdentOpt",
                 "SyntaxDefinitionScope", "SyntaxProgramModule",
                 "SyntaxPrivateScope", "SyntaxImplementationOpt",
                 "SyntaxProgramScope", "SyntaxDefinitionList",
                 "SyntaxDefinition", "SyntaxConstDefinition",
                 "SyntaxConstList", "SyntaxTypeDefinition",
                 "SyntaxTypeOptList", "SyntaxTypeOpt",
                 "SyntaxVarDefinition", "SyntaxVarList",
                 "SyntaxProcedureDefinition", "SyntaxFormalScope",
                 "SyntaxImportList", "SyntaxImport",
                 "SyntaxQualifiedImport", "SyntaxQEntryScope",
                 "SyntaxUnqualifiedImport", "SyntaxUEntryScope",
                 "SyntaxImportScope", "SyntaxExportList",
                 "SyntaxExportOpt", "SyntaxExport", "SyntaxQualifiedOpt",
                 "SyntaxExportScope", "SyntaxBlock",
                 "SyntaxBlockStatementsOpt", "SyntaxDeclarationList",
                 "SyntaxDeclaration", "SyntaxTypeDeclaration",
                 "SyntaxTypeDeclarationList", "SyntaxModuleDeclaration",
                 "SyntaxPriorityOpt", "SyntaxModuleScope",
                 "SyntaxProcedureDeclaration", "SyntaxOuterScope",
                 "SyntaxProcedureTail", "SyntaxProcedureBody",
                 "SyntaxInnerScope", "SyntaxExtraScope",
                 "SyntaxFormalParametersOpt", "SyntaxFormalParameters",
                 "SyntaxReturnParameterOpt",
                 "SyntaxParameterSectionSeqOpt",
                 "SyntaxParameterSectionList", "SyntaxParameterSection",
                 "SyntaxVarOpt", "SyntaxType", "SyntaxProcedureType",
                 "SyntaxFormalSignatureOpt", "SyntaxFormalSignature",
                 "SyntaxReturnSignatureOpt",
                 "SyntaxSignatureSectionSeqOpt",
                 "SyntaxSignatureSectionList", "SyntaxSignatureSection",
                 "SyntaxFormalType", "SyntaxArrayOpt", "SyntaxPointerType",
                 "SyntaxSetType", "SyntaxArrayType",
                 "SyntaxSimpleTypeList", "SyntaxRecordType",
                 "SyntaxRecordScope", "SyntaxFieldOptSeq",
                 "SyntaxFieldOptList", "SyntaxFieldOpt", "SyntaxField",
                 "SyntaxSimpleField", "SyntaxCaseField",
                 "SyntaxElseFieldOpt", "SyntaxVariantOptList",
                 "SyntaxVariantOpt", "SyntaxSimpleType",
                 "SyntaxEnumeration", "SyntaxEnumerationScope",
                 "SyntaxSubrange", "SyntaxQualIdentOrSubrange",
                 "SyntaxSubrangeOpt", "SyntaxStatementOptSeq",
                 "SyntaxStatementOptList", "SyntaxStatementOpt",
                 "SyntaxStatement", "SyntaxAssignmentOrCallStatement",
                 "SyntaxAssignmentOrCall", "SyntaxAssignment",
                 "SyntaxExitStatement", "SyntaxReturnStatement",
                 "SyntaxIfStatement", "SyntaxElseIfList", "SyntaxElseOpt",
                 "SyntaxCaseStatement", "SyntaxCaseOptSeq",
                 "SyntaxCaseOptList", "SyntaxCaseOpt", "SyntaxCase",
                 "SyntaxCaseLabelSeq", "SyntaxCaseLabelList",
                 "SyntaxCaseLabel", "SyntaxCaseRangeOpt",
                 "SyntaxWhileStatement", "SyntaxRepeatStatement",
                 "SyntaxForStatement", "SyntaxByExprOpt",
                 "SyntaxLoopStatement", "SyntaxWithStatement",
                 "SyntaxWithScope", "SyntaxDesignator",
                 "SyntaxDesignatorTailList", "SyntaxDesignatorTail",
                 "SyntaxDesignatorScope", "SyntaxReference",
                 "SyntaxSubscriptionScope", "SyntaxActualParametersOpt",
                 "SyntaxActualParameters", "SyntaxExprSeqOpt",
                 "SyntaxExprList", "SyntaxExprOpt", "SyntaxExpr",
                 "SyntaxRelationOpt", "SyntaxRelation", "SyntaxSimpleExpr",
                 "SyntaxUnaryAddOpt", "SyntaxUnaryAdd",
                 "SyntaxAddTermList", "SyntaxBinaryAdd", "SyntaxTerm",
                 "SyntaxMulFactorList", "SyntaxMul", "SyntaxFactor",
                 "SyntaxFactorExpr", "SyntaxNotFactor",
                 "SyntaxQualSetOrCall", "SyntaxSetOrCall", "SyntaxCall",
                 "SyntaxSet", "SyntaxElementSeqOpt", "SyntaxElementList",
                 "SyntaxElement", "SyntaxElementRangeOpt",
                 "SyntaxConstExprSeqOpt", "SyntaxConstExprList",
                 "SyntaxConstExpr", "SyntaxSimpleRelationOpt",
                 "SyntaxSimpleConstExpr", "SyntaxAddSimpleTermList",
                 "SyntaxConstTerm", "SyntaxMulConstFactorList",
                 "SyntaxConstFactor", "SyntaxConstFactorExpr",
                 "SyntaxNotConstFactor", "SyntaxQualConstSetOrCall",
                 "SyntaxConstSetOrCall", "SyntaxConstActualParametersOpt",
                 "SyntaxConstSet", "SyntaxConstElementSeqOpt",
                 "SyntaxConstElementList", "SyntaxConstElement",
                 "SyntaxConstRangeOpt", "SyntaxDIdentOpt",
                 "SyntaxDIdentList", "SyntaxDAIdentList",
                 "SyntaxQualIdent", "SyntaxQualificationScope", "ImpArrow",
                 "Branded", "Ref", "Interface", "EmptyString", "Unsafe",
                 "Untraced", "Subtype"};

  BEGIN
    RETURN KindText[self.kind];
  END GetKindText;

BEGIN
END Symbol.
