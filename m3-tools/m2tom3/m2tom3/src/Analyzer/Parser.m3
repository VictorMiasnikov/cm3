MODULE Parser;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Thomas Stockheim                                          *)

(** pk
    1.1
    1994/11/30 15:03:56
    Parser.m3,v
# Revision 1.1  1994/11/30  15:03:56  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT BaseGraph;
IMPORT Symbol;
IMPORT TokenGraph, Token;
IMPORT Syntax, SyntaxAnchor, SyntaxGraph;
IMPORT Message;


PROCEDURE Parse (syntaxGraph: SyntaxGraph.T; anchor: SyntaxAnchor.T)
  RAISES {SyntaxError, OutOfTokens, GraphError, TokenGraph.NoAnchor} =
  CONST
    SkipIt = Symbol.KindSet{Symbol.Kind.WhiteSpace, Symbol.Kind.Comment};

  VAR
    nextToken    : Token.T;
    nextTokenKind: Symbol.Kind;

  (*
    --- utility procedures ---
  *)
  PROCEDURE Insert (out: Syntax.T; in: Symbol.T; number: INTEGER)
    RAISES {GraphError} =
    BEGIN
      TRY
        syntaxGraph.insertSyntaxEdge(out, in, number);
      EXCEPT
        BaseGraph.NodeNotInGraph, BaseGraph.EdgeInGraph,
            SyntaxGraph.NumberNotUnique =>
          RAISE GraphError;
      END;
    END Insert;


  PROCEDURE Match (expected: Symbol.Kind; usage := Token.UsageSet{}):
    Token.T RAISES {SyntaxError, OutOfTokens, GraphError} =
    VAR tmp: Token.T;

    BEGIN
      (* test for correct actual token *)
      IF (nextTokenKind # expected) THEN
        RAISE SyntaxError(Error{nextToken, Message.Code.TokenExpected});
      END;

      (* save usage set to actual token *)
      nextToken.setUsageSet(usage);

      (* get next relevant token for look ahead *)
      tmp := nextToken;
      IF (tmp = NIL) THEN
        (* Last call of Match does not find any more token *)
        RAISE OutOfTokens;
      END;

      (* skip WhiteSpaces and Comments *)
      REPEAT
        TRY
          nextToken :=
            syntaxGraph.getNextToken(nextToken, Token.Language.M2);
        EXCEPT
        | BaseGraph.NodeNotInGraph => RAISE GraphError;
        END;
        IF (nextToken = NIL) THEN
          (* if nextToken is NIL then nextTokenKind is NoToken *)
          nextTokenKind := Symbol.Kind.NoToken;
        ELSE
          nextTokenKind := nextToken.getKind();
        END;
      UNTIL (NOT (nextTokenKind IN SkipIt));

      RETURN tmp;
    END Match;


  (*
    --- procedures to parse rules ---
  *)
  PROCEDURE SyntaxCompilationUnit (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxCompilationUnit);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      CASE nextTokenKind OF
      | Symbol.Kind.Definition => Insert(tmp, SyntaxDefinitionModule(), 1);
      | Symbol.Kind.Implementation, Symbol.Kind.Module =>
          Insert(tmp, SyntaxProgramModule(), 1);
      ELSE
        RAISE SyntaxError(Error{nextToken, Message.Code.ModuleExpected});
      END;
      RETURN tmp;
    END SyntaxCompilationUnit;


  PROCEDURE SyntaxDefinitionModule (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxDefinitionModule);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.Definition), 1);
      Insert(tmp, SyntaxForIdentOpt(), 2);
      Insert(tmp, Match(Symbol.Kind.Module), 3);
      Insert(tmp, SyntaxPublicScope(), 4);
      RETURN tmp;
    END SyntaxDefinitionModule;


  PROCEDURE SyntaxPublicScope (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxPublicScope);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.Identifier,
                        Token.UsageSet{Token.Usage.Decl}), 1);
      Insert(tmp, Match(Symbol.Kind.Semicolon), 2);
      Insert(tmp, SyntaxDefinitionScope(), 3);
      Insert(tmp, Match(Symbol.Kind.End), 4);
      Insert(tmp, Match(Symbol.Kind.Identifier,
                        Token.UsageSet{Token.Usage.Appl}), 5);
      Insert(tmp, Match(Symbol.Kind.Period), 6);
      RETURN tmp;
    END SyntaxPublicScope;


  PROCEDURE SyntaxForIdentOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxForIdentOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.For) THEN
        Insert(tmp, Match(Symbol.Kind.For), 1);
        Insert(tmp, Match(Symbol.Kind.Identifier), 2);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxForIdentOpt;


  PROCEDURE SyntaxDefinitionScope (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxDefinitionScope);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, SyntaxImportList(), 1);
      Insert(tmp, SyntaxExportList(), 2);
      Insert(tmp, SyntaxDefinitionList(), 3);
      RETURN tmp;
    END SyntaxDefinitionScope;


  PROCEDURE SyntaxProgramModule (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxProgramModule);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, SyntaxImplementationOpt(), 1);
      Insert(tmp, Match(Symbol.Kind.Module), 2);
      Insert(tmp, SyntaxPrivateScope(), 3);
      RETURN tmp;
    END SyntaxProgramModule;


  PROCEDURE SyntaxPrivateScope (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxPrivateScope);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.Identifier,
                        Token.UsageSet{Token.Usage.Decl}), 1);
      Insert(tmp, Match(Symbol.Kind.Semicolon), 2);
      Insert(tmp, SyntaxProgramScope(), 3);
      Insert(tmp, Match(Symbol.Kind.Identifier,
                        Token.UsageSet{Token.Usage.Appl}), 4);
      Insert(tmp, Match(Symbol.Kind.Period), 5);
      RETURN tmp;
    END SyntaxPrivateScope;


  PROCEDURE SyntaxImplementationOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxImplementationOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.Implementation) THEN
        Insert(tmp, Match(Symbol.Kind.Implementation), 1);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxImplementationOpt;


  PROCEDURE SyntaxProgramScope (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxProgramScope);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, SyntaxImportList(), 1);
      Insert(tmp, SyntaxBlock(), 2);
      RETURN tmp;
    END SyntaxProgramScope;


  PROCEDURE SyntaxDefinitionList (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    CONST
      DLLookAhead = Symbol.KindSet{Symbol.Kind.Const, Symbol.Kind.Type,
                                   Symbol.Kind.Var, Symbol.Kind.Procedure};

    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxDefinitionList);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind IN DLLookAhead) THEN
        Insert(tmp, SyntaxDefinition(), 1);
        Insert(tmp, SyntaxDefinitionList(), 2);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxDefinitionList;


  PROCEDURE SyntaxDefinition (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxDefinition);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      CASE nextTokenKind OF
      | Symbol.Kind.Const => Insert(tmp, SyntaxConstDefinition(), 1);
      | Symbol.Kind.Type => Insert(tmp, SyntaxTypeDefinition(), 1);
      | Symbol.Kind.Var => Insert(tmp, SyntaxVarDefinition(), 1);
      | Symbol.Kind.Procedure =>
          Insert(tmp, SyntaxProcedureDefinition(), 1);
      ELSE
        RAISE
          SyntaxError(Error{nextToken, Message.Code.DefinitionExpected});
      END;
      RETURN tmp;
    END SyntaxDefinition;


  PROCEDURE SyntaxConstDefinition (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxConstDefinition);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.Const), 1);
      Insert(tmp, SyntaxConstList(), 2);
      RETURN tmp;
    END SyntaxConstDefinition;


  PROCEDURE SyntaxConstList (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxConstList);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.Identifier) THEN
        Insert(tmp, Match(Symbol.Kind.Identifier,
                          Token.UsageSet{Token.Usage.Decl}), 1);
        Insert(tmp, Match(Symbol.Kind.Equal), 2);
        Insert(tmp, SyntaxConstExpr(), 3);
        Insert(tmp, Match(Symbol.Kind.Semicolon), 4);
        Insert(tmp, SyntaxConstList(), 5);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxConstList;


  PROCEDURE SyntaxTypeDefinition (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxTypeDefinition);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.Type), 1);
      Insert(tmp, SyntaxTypeOptList(), 2);
      RETURN tmp;
    END SyntaxTypeDefinition;


  PROCEDURE SyntaxTypeOptList (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxTypeOptList);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.Identifier) THEN
        Insert(tmp, Match(Symbol.Kind.Identifier,
                          Token.UsageSet{Token.Usage.Decl}), 1);
        Insert(tmp, SyntaxTypeOpt(), 2);
        Insert(tmp, Match(Symbol.Kind.Semicolon), 3);
        Insert(tmp, SyntaxTypeOptList(), 4);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxTypeOptList;


  PROCEDURE SyntaxTypeOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxTypeOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.Equal) THEN
        Insert(tmp, Match(Symbol.Kind.Equal), 1);
        Insert(tmp, SyntaxType(), 2);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxTypeOpt;


  PROCEDURE SyntaxVarDefinition (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxVarDefinition);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.Var), 1);
      Insert(tmp, SyntaxVarList(), 2);
      RETURN tmp;
    END SyntaxVarDefinition;


  PROCEDURE SyntaxVarList (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxVarList);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.Identifier) THEN
        Insert(tmp, Match(Symbol.Kind.Identifier,
                          Token.UsageSet{Token.Usage.Decl}), 1);
        Insert(tmp, SyntaxDIdentList(), 2);
        Insert(tmp, Match(Symbol.Kind.Colon), 3);
        Insert(tmp, SyntaxType(), 4);
        Insert(tmp, Match(Symbol.Kind.Semicolon), 5);
        Insert(tmp, SyntaxVarList(), 6);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxVarList;


  PROCEDURE SyntaxProcedureDefinition (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxProcedureDefinition);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.Procedure), 1);
      Insert(tmp, Match(Symbol.Kind.Identifier,
                        Token.UsageSet{Token.Usage.Decl}), 2);
      Insert(tmp, SyntaxFormalScope(), 3);
      Insert(tmp, Match(Symbol.Kind.Semicolon), 4);
      RETURN tmp;
    END SyntaxProcedureDefinition;


  PROCEDURE SyntaxFormalScope (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxFormalScope);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, SyntaxFormalParametersOpt(), 1);
      RETURN tmp;
    END SyntaxFormalScope;


  PROCEDURE SyntaxImportList (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxImportList);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind
            IN Symbol.KindSet{Symbol.Kind.From, Symbol.Kind.Import}) THEN
        Insert(tmp, SyntaxImport(), 1);
        Insert(tmp, SyntaxImportList(), 2);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxImportList;


  PROCEDURE SyntaxImport (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxImport);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      CASE nextTokenKind OF
      | Symbol.Kind.Import => Insert(tmp, SyntaxQualifiedImport(), 1);
      | Symbol.Kind.From => Insert(tmp, SyntaxUnqualifiedImport(), 1);
      ELSE
        RAISE SyntaxError(Error{nextToken, Message.Code.ImportExpected});
      END;
      RETURN tmp;
    END SyntaxImport;


  PROCEDURE SyntaxQualifiedImport (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxQualifiedImport);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.Import), 1);
      Insert(tmp, SyntaxQEntryScope(), 2);
      RETURN tmp;
    END SyntaxQualifiedImport;


  PROCEDURE SyntaxQEntryScope (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxQEntryScope);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(
        tmp, Match(Symbol.Kind.Identifier,
                   Token.UsageSet{Token.Usage.Decl, Token.Usage.Appl}), 1);
      Insert(tmp, SyntaxDAIdentList(), 2);
      Insert(tmp, Match(Symbol.Kind.Semicolon), 3);
      RETURN tmp;
    END SyntaxQEntryScope;


  PROCEDURE SyntaxUnqualifiedImport (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxUnqualifiedImport);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.From), 1);
      Insert(tmp, SyntaxUEntryScope(), 2);
      Insert(tmp, Match(Symbol.Kind.Import), 3);
      Insert(tmp, SyntaxImportScope(), 4);
      Insert(tmp, Match(Symbol.Kind.Semicolon), 5);
      RETURN tmp;
    END SyntaxUnqualifiedImport;


  PROCEDURE SyntaxUEntryScope (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxUEntryScope);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(
        tmp, Match(Symbol.Kind.Identifier,
                   Token.UsageSet{Token.Usage.Decl, Token.Usage.Appl}), 1);
      RETURN tmp;
    END SyntaxUEntryScope;


  PROCEDURE SyntaxImportScope (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxImportScope);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(
        tmp, Match(Symbol.Kind.Identifier,
                   Token.UsageSet{Token.Usage.Decl, Token.Usage.Appl}), 1);
      Insert(tmp, SyntaxDAIdentList(), 2);
      RETURN tmp;
    END SyntaxImportScope;


  PROCEDURE SyntaxExportList (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxExportList);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.Export) THEN
        Insert(tmp, SyntaxExport(), 1);
        Insert(tmp, SyntaxExportList(), 2);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxExportList;


  PROCEDURE SyntaxExportOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxExportOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.Export) THEN
        Insert(tmp, SyntaxExport(), 1);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxExportOpt;


  PROCEDURE SyntaxExport (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxExport);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.Export), 1);
      Insert(tmp, SyntaxQualifiedOpt(), 2);
      Insert(tmp, SyntaxExportScope(), 3);
      Insert(tmp, Match(Symbol.Kind.Semicolon), 4);
      RETURN tmp;
    END SyntaxExport;


  PROCEDURE SyntaxQualifiedOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxQualifiedOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.Qualified) THEN
        Insert(tmp, Match(Symbol.Kind.Qualified), 1);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxQualifiedOpt;


  PROCEDURE SyntaxExportScope (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxExportScope);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(
        tmp, Match(Symbol.Kind.Identifier,
                   Token.UsageSet{Token.Usage.Decl, Token.Usage.Appl}), 1);
      Insert(tmp, SyntaxDAIdentList(), 2);
      RETURN tmp;
    END SyntaxExportScope;


  PROCEDURE SyntaxBlock (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxBlock);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, SyntaxDeclarationList(), 1);
      Insert(tmp, SyntaxBlockStatementsOpt(), 2);
      Insert(tmp, Match(Symbol.Kind.End), 3);
      RETURN tmp;
    END SyntaxBlock;


  PROCEDURE SyntaxBlockStatementsOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxBlockStatementsOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.Begin) THEN
        Insert(tmp, Match(Symbol.Kind.Begin), 1);
        Insert(tmp, SyntaxStatementOptSeq(), 2);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxBlockStatementsOpt;


  PROCEDURE SyntaxDeclarationList (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    CONST
      DLLookAhead = Symbol.KindSet{
                      Symbol.Kind.Const, Symbol.Kind.Type, Symbol.Kind.Var,
                      Symbol.Kind.Module, Symbol.Kind.Procedure};

    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxDeclarationList);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind IN DLLookAhead) THEN
        Insert(tmp, SyntaxDeclaration(), 1);
        Insert(tmp, SyntaxDeclarationList(), 2);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxDeclarationList;


  PROCEDURE SyntaxDeclaration (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxDeclaration);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      CASE nextTokenKind OF
      | Symbol.Kind.Const => Insert(tmp, SyntaxConstDefinition(), 1);
      | Symbol.Kind.Type => Insert(tmp, SyntaxTypeDeclaration(), 1);
      | Symbol.Kind.Var => Insert(tmp, SyntaxVarDefinition(), 1);
      | Symbol.Kind.Module => Insert(tmp, SyntaxModuleDeclaration(), 1);
      | Symbol.Kind.Procedure =>
          Insert(tmp, SyntaxProcedureDeclaration(), 1);
      ELSE
        RAISE
          SyntaxError(Error{nextToken, Message.Code.DeclarationExpected});
      END;
      RETURN tmp;
    END SyntaxDeclaration;


  PROCEDURE SyntaxTypeDeclaration (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxTypeDeclaration);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.Type), 1);
      Insert(tmp, SyntaxTypeDeclarationList(), 2);
      RETURN tmp;
    END SyntaxTypeDeclaration;


  PROCEDURE SyntaxTypeDeclarationList (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxTypeDeclarationList);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.Identifier) THEN
        Insert(tmp, Match(Symbol.Kind.Identifier,
                          Token.UsageSet{Token.Usage.Decl}), 1);
        Insert(tmp, Match(Symbol.Kind.Equal), 2);
        Insert(tmp, SyntaxType(), 3);
        Insert(tmp, Match(Symbol.Kind.Semicolon), 4);
        Insert(tmp, SyntaxTypeDeclarationList(), 5);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxTypeDeclarationList;


  PROCEDURE SyntaxModuleDeclaration (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxModuleDeclaration);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.Module), 1);
      Insert(tmp, Match(Symbol.Kind.Identifier,
                        Token.UsageSet{Token.Usage.Decl}), 2);
      Insert(tmp, SyntaxPriorityOpt(), 3);
      Insert(tmp, Match(Symbol.Kind.Semicolon), 4);
      Insert(tmp, SyntaxModuleScope(), 5);
      Insert(tmp, Match(Symbol.Kind.Identifier,
                        Token.UsageSet{Token.Usage.Appl}), 6);
      Insert(tmp, Match(Symbol.Kind.Semicolon), 7);
      RETURN tmp;
    END SyntaxModuleDeclaration;


  PROCEDURE SyntaxPriorityOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxPriorityOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.ALBracket) THEN
        Insert(tmp, Match(Symbol.Kind.ALBracket), 1);
        Insert(tmp, SyntaxConstExpr(), 2);
        Insert(tmp, Match(Symbol.Kind.ARBracket), 3);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxPriorityOpt;


  PROCEDURE SyntaxModuleScope (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxModuleScope);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, SyntaxImportList(), 1);
      Insert(tmp, SyntaxExportOpt(), 2);
      Insert(tmp, SyntaxBlock(), 3);
      RETURN tmp;
    END SyntaxModuleScope;


  PROCEDURE SyntaxProcedureDeclaration (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxProcedureDeclaration);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.Procedure), 1);
      Insert(tmp, Match(Symbol.Kind.Identifier,
                        Token.UsageSet{Token.Usage.Decl}), 2);
      Insert(tmp, SyntaxOuterScope(), 3);
      RETURN tmp;
    END SyntaxProcedureDeclaration;


  PROCEDURE SyntaxOuterScope (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxOuterScope);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, SyntaxFormalParametersOpt(), 1);
      Insert(tmp, Match(Symbol.Kind.Semicolon), 2);
      Insert(tmp, SyntaxProcedureTail(), 3);
      RETURN tmp;
    END SyntaxOuterScope;


  PROCEDURE SyntaxProcedureTail (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxProcedureTail);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      CASE nextTokenKind OF
      | Symbol.Kind.Forward => Insert(tmp, Match(Symbol.Kind.Forward), 1);
      ELSE                       (* later tested; because of look ahead too
                                    large *)
        Insert(tmp, SyntaxProcedureBody(), 1);
      END;
      RETURN tmp;
    END SyntaxProcedureTail;


  PROCEDURE SyntaxProcedureBody (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxProcedureBody);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, SyntaxInnerScope(), 1);
      Insert(tmp, SyntaxExtraScope(), 2);
      RETURN tmp;
    END SyntaxProcedureBody;


  PROCEDURE SyntaxInnerScope (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxInnerScope);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, SyntaxBlock(), 1);
      RETURN tmp;
    END SyntaxInnerScope;


  PROCEDURE SyntaxExtraScope (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxExtraScope);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.Identifier,
                        Token.UsageSet{Token.Usage.Appl}), 1);
      Insert(tmp, Match(Symbol.Kind.Semicolon), 2);
      RETURN tmp;
    END SyntaxExtraScope;


  PROCEDURE SyntaxFormalParametersOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxFormalParametersOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.LBracket) THEN
        Insert(tmp, SyntaxFormalParameters(), 1);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxFormalParametersOpt;


  PROCEDURE SyntaxFormalParameters (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxFormalParameters);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.LBracket), 1);
      Insert(tmp, SyntaxParameterSectionSeqOpt(), 2);
      Insert(tmp, Match(Symbol.Kind.RBracket), 3);
      Insert(tmp, SyntaxReturnParameterOpt(), 4);
      RETURN tmp;
    END SyntaxFormalParameters;


  PROCEDURE SyntaxReturnParameterOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxReturnParameterOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.Colon) THEN
        Insert(tmp, Match(Symbol.Kind.Colon), 1);
        Insert(tmp, SyntaxQualIdent(), 2);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxReturnParameterOpt;


  PROCEDURE SyntaxParameterSectionSeqOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR
      tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxParameterSectionSeqOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind
            IN Symbol.KindSet{Symbol.Kind.Var, Symbol.Kind.Identifier}) THEN
        Insert(tmp, SyntaxParameterSection(), 1);
        Insert(tmp, SyntaxParameterSectionList(), 2);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxParameterSectionSeqOpt;


  PROCEDURE SyntaxParameterSectionList (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxParameterSectionList);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.Semicolon) THEN
        Insert(tmp, Match(Symbol.Kind.Semicolon), 1);
        Insert(tmp, SyntaxParameterSection(), 2);
        Insert(tmp, SyntaxParameterSectionList(), 3);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxParameterSectionList;


  PROCEDURE SyntaxParameterSection (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxParameterSection);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, SyntaxVarOpt(), 1);
      Insert(tmp, Match(Symbol.Kind.Identifier,
                        Token.UsageSet{Token.Usage.Decl}), 2);
      Insert(tmp, SyntaxDIdentList(), 3);
      Insert(tmp, Match(Symbol.Kind.Colon), 4);
      Insert(tmp, SyntaxFormalType(), 5);
      RETURN tmp;
    END SyntaxParameterSection;


  PROCEDURE SyntaxVarOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxVarOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.Var) THEN
        Insert(tmp, Match(Symbol.Kind.Var), 1);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxVarOpt;


  PROCEDURE SyntaxType (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxType);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      CASE nextTokenKind OF
      | Symbol.Kind.Procedure => Insert(tmp, SyntaxProcedureType(), 1);
      | Symbol.Kind.Pointer => Insert(tmp, SyntaxPointerType(), 1);
      | Symbol.Kind.Set => Insert(tmp, SyntaxSetType(), 1);
      | Symbol.Kind.Array => Insert(tmp, SyntaxArrayType(), 1);
      | Symbol.Kind.Record => Insert(tmp, SyntaxRecordType(), 1);
      | Symbol.Kind.LBracket, Symbol.Kind.ALBracket,
          Symbol.Kind.Identifier =>
          Insert(tmp, SyntaxSimpleType(), 1);
      ELSE
        RAISE SyntaxError(Error{nextToken, Message.Code.TypeExpected});
      END;
      RETURN tmp;
    END SyntaxType;


  PROCEDURE SyntaxProcedureType (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxProcedureType);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.Procedure), 1);
      Insert(tmp, SyntaxFormalSignatureOpt(), 2);
      RETURN tmp;
    END SyntaxProcedureType;


  PROCEDURE SyntaxFormalSignatureOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxFormalSignatureOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.LBracket) THEN
        Insert(tmp, SyntaxFormalSignature(), 1);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxFormalSignatureOpt;


  PROCEDURE SyntaxFormalSignature (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxFormalSignature);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.LBracket), 1);
      Insert(tmp, SyntaxSignatureSectionSeqOpt(), 2);
      Insert(tmp, Match(Symbol.Kind.RBracket), 3);
      Insert(tmp, SyntaxReturnSignatureOpt(), 4);
      RETURN tmp;
    END SyntaxFormalSignature;


  PROCEDURE SyntaxReturnSignatureOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxReturnSignatureOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.Colon) THEN
        Insert(tmp, Match(Symbol.Kind.Colon), 1);
        Insert(tmp, SyntaxSimpleType(), 2);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxReturnSignatureOpt;


  PROCEDURE SyntaxSignatureSectionSeqOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    CONST
      SSSOLookAhead = Symbol.KindSet{
                        Symbol.Kind.Var, Symbol.Kind.Identifier,
                        Symbol.Kind.Array};

    VAR
      tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxSignatureSectionSeqOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind IN SSSOLookAhead) THEN
        Insert(tmp, SyntaxSignatureSection(), 1);
        Insert(tmp, SyntaxSignatureSectionList(), 2);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxSignatureSectionSeqOpt;


  PROCEDURE SyntaxSignatureSectionList (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxSignatureSectionList);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.Comma) THEN
        Insert(tmp, Match(Symbol.Kind.Comma), 1);
        Insert(tmp, SyntaxSignatureSection(), 2);
        Insert(tmp, SyntaxSignatureSectionList(), 3);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxSignatureSectionList;


  PROCEDURE SyntaxSignatureSection (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxSignatureSection);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, SyntaxVarOpt(), 1);
      Insert(tmp, SyntaxFormalType(), 2);
      RETURN tmp;
    END SyntaxSignatureSection;


  PROCEDURE SyntaxFormalType (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxFormalType);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, SyntaxArrayOpt(), 1);
      Insert(tmp, SyntaxQualIdent(), 2);
      RETURN tmp;
    END SyntaxFormalType;


  PROCEDURE SyntaxArrayOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxArrayOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.Array) THEN
        Insert(tmp, Match(Symbol.Kind.Array), 1);
        Insert(tmp, Match(Symbol.Kind.Of), 2);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxArrayOpt;


  PROCEDURE SyntaxPointerType (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxPointerType);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.Pointer), 1);
      Insert(tmp, Match(Symbol.Kind.To), 2);
      Insert(tmp, SyntaxType(), 3);
      RETURN tmp;
    END SyntaxPointerType;


  PROCEDURE SyntaxSetType (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxSetType);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.Set), 1);
      Insert(tmp, Match(Symbol.Kind.Of), 2);
      Insert(tmp, SyntaxType(), 3);
      RETURN tmp;
    END SyntaxSetType;


  PROCEDURE SyntaxArrayType (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxArrayType);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.Array), 1);
      Insert(tmp, SyntaxSimpleType(), 2);
      Insert(tmp, SyntaxSimpleTypeList(), 3);
      Insert(tmp, Match(Symbol.Kind.Of), 4);
      Insert(tmp, SyntaxType(), 5);
      RETURN tmp;
    END SyntaxArrayType;


  PROCEDURE SyntaxSimpleTypeList (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxSimpleTypeList);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.Comma) THEN
        Insert(tmp, Match(Symbol.Kind.Comma), 1);
        Insert(tmp, SyntaxSimpleType(), 2);
        Insert(tmp, SyntaxSimpleTypeList(), 3);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxSimpleTypeList;


  PROCEDURE SyntaxRecordType (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxRecordType);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.Record), 1);
      Insert(tmp, SyntaxRecordScope(), 2);
      Insert(tmp, Match(Symbol.Kind.End), 3);
      RETURN tmp;
    END SyntaxRecordType;


  PROCEDURE SyntaxRecordScope (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxRecordScope);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, SyntaxFieldOptSeq(), 1);
      RETURN tmp;
    END SyntaxRecordScope;


  PROCEDURE SyntaxFieldOptSeq (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxFieldOptSeq);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, SyntaxFieldOpt(), 1);
      Insert(tmp, SyntaxFieldOptList(), 2);
      RETURN tmp;
    END SyntaxFieldOptSeq;


  PROCEDURE SyntaxFieldOptList (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxFieldOptList);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.Semicolon) THEN
        Insert(tmp, Match(Symbol.Kind.Semicolon), 1);
        Insert(tmp, SyntaxFieldOpt(), 2);
        Insert(tmp, SyntaxFieldOptList(), 3);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxFieldOptList;


  PROCEDURE SyntaxFieldOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    CONST
      FOLookAhead = Symbol.KindSet{
                      Symbol.Kind.Identifier, Symbol.Kind.Case};

    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxFieldOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind IN FOLookAhead) THEN
        Insert(tmp, SyntaxField(), 1);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxFieldOpt;


  PROCEDURE SyntaxField (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxField);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      CASE nextTokenKind OF
      | Symbol.Kind.Identifier => Insert(tmp, SyntaxSimpleField(), 1);
      | Symbol.Kind.Case => Insert(tmp, SyntaxCaseField(), 1);
      ELSE
        RAISE
          SyntaxError(Error{nextToken, Message.Code.CaseFieldExpected});
      END;
      RETURN tmp;
    END SyntaxField;


  PROCEDURE SyntaxSimpleField (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxSimpleField);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.Identifier,
                        Token.UsageSet{Token.Usage.Decl}), 1);
      Insert(tmp, SyntaxDIdentList(), 2);
      Insert(tmp, Match(Symbol.Kind.Colon), 3);
      Insert(tmp, SyntaxType(), 4);
      RETURN tmp;
    END SyntaxSimpleField;


  PROCEDURE SyntaxCaseField (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxCaseField);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.Case), 1);
      Insert(tmp, SyntaxDIdentOpt(), 2);
      Insert(tmp, Match(Symbol.Kind.Colon), 3);
      Insert(tmp, SyntaxQualIdent(), 4);
      Insert(tmp, Match(Symbol.Kind.Of), 5);
      Insert(tmp, SyntaxVariantOpt(), 6);
      Insert(tmp, SyntaxVariantOptList(), 7);
      Insert(tmp, SyntaxElseFieldOpt(), 8);
      Insert(tmp, Match(Symbol.Kind.End), 9);
      RETURN tmp;
    END SyntaxCaseField;


  PROCEDURE SyntaxElseFieldOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxElseFieldOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.Else) THEN
        Insert(tmp, Match(Symbol.Kind.Else), 1);
        Insert(tmp, SyntaxFieldOptSeq(), 2);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxElseFieldOpt;


  PROCEDURE SyntaxVariantOptList (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxVariantOptList);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.Bar) THEN
        Insert(tmp, Match(Symbol.Kind.Bar), 1);
        Insert(tmp, SyntaxVariantOpt(), 2);
        Insert(tmp, SyntaxVariantOptList(), 3);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxVariantOptList;


  PROCEDURE SyntaxVariantOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    CONST
      VOLookAhead = Symbol.KindSet{
                      Symbol.Kind.Plus, Symbol.Kind.Minus,
                      Symbol.Kind.IntegerConst, Symbol.Kind.LongConst,
                      Symbol.Kind.StringConst, Symbol.Kind.CharConst,
                      Symbol.Kind.RealConst, Symbol.Kind.LBracket,
                      Symbol.Kind.Not, Symbol.Kind.Identifier,
                      Symbol.Kind.CLBracket};

    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxVariantOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind IN VOLookAhead) THEN
        Insert(tmp, SyntaxCaseLabelSeq(), 1);
        Insert(tmp, Match(Symbol.Kind.Colon), 2);
        Insert(tmp, SyntaxFieldOptSeq(), 3);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxVariantOpt;


  PROCEDURE SyntaxSimpleType (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxSimpleType);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      CASE nextTokenKind OF
      | Symbol.Kind.LBracket => Insert(tmp, SyntaxEnumeration(), 1);
      | Symbol.Kind.ALBracket => Insert(tmp, SyntaxSubrange(), 1);
      | Symbol.Kind.Identifier =>
          Insert(tmp, SyntaxQualIdentOrSubrange(), 1);
      ELSE
        RAISE
          SyntaxError(Error{nextToken, Message.Code.SimpleTypeExpected});
      END;
      RETURN tmp;
    END SyntaxSimpleType;


  PROCEDURE SyntaxEnumeration (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxEnumeration);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.LBracket), 1);
      Insert(tmp, SyntaxEnumerationScope(), 2);
      Insert(tmp, Match(Symbol.Kind.RBracket), 3);
      RETURN tmp;
    END SyntaxEnumeration;


  PROCEDURE SyntaxEnumerationScope (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxEnumerationScope);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.Identifier,
                        Token.UsageSet{Token.Usage.Decl}), 1);
      Insert(tmp, SyntaxDIdentList(), 2);
      RETURN tmp;
    END SyntaxEnumerationScope;


  PROCEDURE SyntaxSubrangeOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxSubrangeOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.ALBracket) THEN
        Insert(tmp, SyntaxSubrange(), 1);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxSubrangeOpt;


  PROCEDURE SyntaxSubrange (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxSubrange);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.ALBracket), 1);
      Insert(tmp, SyntaxConstExpr(), 2);
      Insert(tmp, Match(Symbol.Kind.Range), 3);
      Insert(tmp, SyntaxConstExpr(), 4);
      Insert(tmp, Match(Symbol.Kind.ARBracket), 5);
      RETURN tmp;
    END SyntaxSubrange;

  PROCEDURE SyntaxQualIdentOrSubrange (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxQualIdentOrSubrange);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, SyntaxQualIdent(), 1);
      Insert(tmp, SyntaxSubrangeOpt(), 2);
      RETURN tmp;
    END SyntaxQualIdentOrSubrange;

  PROCEDURE SyntaxStatementOptSeq (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxStatementOptSeq);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, SyntaxStatementOpt(), 1);
      Insert(tmp, SyntaxStatementOptList(), 2);
      RETURN tmp;
    END SyntaxStatementOptSeq;


  PROCEDURE SyntaxStatementOptList (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxStatementOptList);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.Semicolon) THEN
        Insert(tmp, Match(Symbol.Kind.Semicolon), 1);
        Insert(tmp, SyntaxStatementOpt(), 2);
        Insert(tmp, SyntaxStatementOptList(), 3);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxStatementOptList;


  PROCEDURE SyntaxStatementOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    CONST
      SOLookAhead = Symbol.KindSet{
                      Symbol.Kind.If, Symbol.Kind.Case, Symbol.Kind.While,
                      Symbol.Kind.Repeat, Symbol.Kind.Loop,
                      Symbol.Kind.For, Symbol.Kind.With, Symbol.Kind.Exit,
                      Symbol.Kind.Return, Symbol.Kind.Identifier};

    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxStatementOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind IN SOLookAhead) THEN
        Insert(tmp, SyntaxStatement(), 1);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxStatementOpt;


  PROCEDURE SyntaxStatement (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxStatement);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      CASE nextTokenKind OF
      | Symbol.Kind.Identifier =>
          Insert(tmp, SyntaxAssignmentOrCallStatement(), 1);
      | Symbol.Kind.If => Insert(tmp, SyntaxIfStatement(), 1);
      | Symbol.Kind.Case => Insert(tmp, SyntaxCaseStatement(), 1);
      | Symbol.Kind.While => Insert(tmp, SyntaxWhileStatement(), 1);
      | Symbol.Kind.Repeat => Insert(tmp, SyntaxRepeatStatement(), 1);
      | Symbol.Kind.Loop => Insert(tmp, SyntaxLoopStatement(), 1);
      | Symbol.Kind.For => Insert(tmp, SyntaxForStatement(), 1);
      | Symbol.Kind.With => Insert(tmp, SyntaxWithStatement(), 1);
      | Symbol.Kind.Exit => Insert(tmp, SyntaxExitStatement(), 1);
      | Symbol.Kind.Return => Insert(tmp, SyntaxReturnStatement(), 1);
      ELSE
        RAISE
          SyntaxError(Error{nextToken, Message.Code.StatementExpected});
      END;
      RETURN tmp;
    END SyntaxStatement;


  PROCEDURE SyntaxAssignmentOrCallStatement (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR
      tmp := NEW(Syntax.T).init(
               Symbol.Kind.SyntaxAssignmentOrCallStatement);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, SyntaxDesignator(), 1);
      Insert(tmp, SyntaxAssignmentOrCall(), 2);
      RETURN tmp;
    END SyntaxAssignmentOrCallStatement;


  PROCEDURE SyntaxAssignmentOrCall (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxAssignmentOrCall);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      CASE nextTokenKind OF
      | Symbol.Kind.Assign => Insert(tmp, SyntaxAssignment(), 1);
      ELSE                       (* tested later; because of large look
                                    ahead *)
        Insert(tmp, SyntaxActualParametersOpt(), 1);
      END;
      RETURN tmp;
    END SyntaxAssignmentOrCall;


  PROCEDURE SyntaxAssignment (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxAssignment);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.Assign), 1);
      Insert(tmp, SyntaxExpr(), 2);
      RETURN tmp;
    END SyntaxAssignment;


  PROCEDURE SyntaxExitStatement (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxExitStatement);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.Exit), 1);
      RETURN tmp;
    END SyntaxExitStatement;


  PROCEDURE SyntaxReturnStatement (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxReturnStatement);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.Return), 1);
      Insert(tmp, SyntaxExprOpt(), 2);
      RETURN tmp;
    END SyntaxReturnStatement;


  PROCEDURE SyntaxIfStatement (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxIfStatement);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.If), 1);
      Insert(tmp, SyntaxExpr(), 2);
      Insert(tmp, Match(Symbol.Kind.Then), 3);
      Insert(tmp, SyntaxStatementOptSeq(), 4);
      Insert(tmp, SyntaxElseIfList(), 5);
      Insert(tmp, SyntaxElseOpt(), 6);
      Insert(tmp, Match(Symbol.Kind.End), 7);
      RETURN tmp;
    END SyntaxIfStatement;


  PROCEDURE SyntaxElseIfList (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxElseIfList);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.Elsif) THEN
        Insert(tmp, Match(Symbol.Kind.Elsif), 1);
        Insert(tmp, SyntaxExpr(), 2);
        Insert(tmp, Match(Symbol.Kind.Then), 3);
        Insert(tmp, SyntaxStatementOptSeq(), 4);
        Insert(tmp, SyntaxElseIfList(), 5);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxElseIfList;


  PROCEDURE SyntaxElseOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxElseOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.Else) THEN
        Insert(tmp, Match(Symbol.Kind.Else), 1);
        Insert(tmp, SyntaxStatementOptSeq(), 2);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxElseOpt;


  PROCEDURE SyntaxCaseStatement (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxCaseStatement);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.Case), 1);
      Insert(tmp, SyntaxExpr(), 2);
      Insert(tmp, Match(Symbol.Kind.Of), 3);
      Insert(tmp, SyntaxCaseOptSeq(), 4);
      Insert(tmp, SyntaxElseOpt(), 5);
      Insert(tmp, Match(Symbol.Kind.End), 6);
      RETURN tmp;
    END SyntaxCaseStatement;


  PROCEDURE SyntaxCaseOptSeq (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxCaseOptSeq);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, SyntaxCaseOpt(), 1);
      Insert(tmp, SyntaxCaseOptList(), 2);
      RETURN tmp;
    END SyntaxCaseOptSeq;


  PROCEDURE SyntaxCaseOptList (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxCaseOptList);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.Bar) THEN
        Insert(tmp, Match(Symbol.Kind.Bar), 1);
        Insert(tmp, SyntaxCaseOpt(), 2);
        Insert(tmp, SyntaxCaseOptList(), 3);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxCaseOptList;


  PROCEDURE SyntaxCaseOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    CONST
      COLookAhead = Symbol.KindSet{
                      Symbol.Kind.Plus, Symbol.Kind.Minus,
                      Symbol.Kind.IntegerConst, Symbol.Kind.LongConst,
                      Symbol.Kind.StringConst, Symbol.Kind.CharConst,
                      Symbol.Kind.RealConst, Symbol.Kind.LBracket,
                      Symbol.Kind.Not, Symbol.Kind.Identifier,
                      Symbol.Kind.CLBracket};

    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxCaseOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind IN COLookAhead) THEN
        Insert(tmp, SyntaxCase(), 1);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxCaseOpt;


  PROCEDURE SyntaxCase (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxCase);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, SyntaxCaseLabelSeq(), 1);
      Insert(tmp, Match(Symbol.Kind.Colon), 2);
      Insert(tmp, SyntaxStatementOptSeq(), 3);
      RETURN tmp;
    END SyntaxCase;


  PROCEDURE SyntaxCaseLabelSeq (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxCaseLabelSeq);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, SyntaxCaseLabel(), 1);
      Insert(tmp, SyntaxCaseLabelList(), 2);
      RETURN tmp;
    END SyntaxCaseLabelSeq;


  PROCEDURE SyntaxCaseLabelList (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxCaseLabelList);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.Comma) THEN
        Insert(tmp, Match(Symbol.Kind.Comma), 1);
        Insert(tmp, SyntaxCaseLabel(), 2);
        Insert(tmp, SyntaxCaseLabelList(), 3);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxCaseLabelList;


  PROCEDURE SyntaxCaseLabel (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxCaseLabel);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, SyntaxConstExpr(), 1);
      Insert(tmp, SyntaxCaseRangeOpt(), 2);
      RETURN tmp;
    END SyntaxCaseLabel;


  PROCEDURE SyntaxCaseRangeOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxCaseRangeOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.Range) THEN
        Insert(tmp, Match(Symbol.Kind.Range), 1);
        Insert(tmp, SyntaxConstExpr(), 2);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxCaseRangeOpt;


  PROCEDURE SyntaxWhileStatement (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxWhileStatement);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.While), 1);
      Insert(tmp, SyntaxExpr(), 2);
      Insert(tmp, Match(Symbol.Kind.Do), 3);
      Insert(tmp, SyntaxStatementOptSeq(), 4);
      Insert(tmp, Match(Symbol.Kind.End), 5);
      RETURN tmp;
    END SyntaxWhileStatement;


  PROCEDURE SyntaxRepeatStatement (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxRepeatStatement);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.Repeat), 1);
      Insert(tmp, SyntaxStatementOptSeq(), 2);
      Insert(tmp, Match(Symbol.Kind.Until), 3);
      Insert(tmp, SyntaxExpr(), 4);
      RETURN tmp;
    END SyntaxRepeatStatement;


  PROCEDURE SyntaxForStatement (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxForStatement);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.For), 1);
      Insert(tmp, Match(Symbol.Kind.Identifier,
                        Token.UsageSet{Token.Usage.Appl}), 2);
      Insert(tmp, Match(Symbol.Kind.Assign), 3);
      Insert(tmp, SyntaxExpr(), 4);
      Insert(tmp, Match(Symbol.Kind.To), 5);
      Insert(tmp, SyntaxExpr(), 6);
      Insert(tmp, SyntaxByExprOpt(), 7);
      Insert(tmp, Match(Symbol.Kind.Do), 8);
      Insert(tmp, SyntaxStatementOptSeq(), 9);
      Insert(tmp, Match(Symbol.Kind.End), 10);
      RETURN tmp;
    END SyntaxForStatement;


  PROCEDURE SyntaxByExprOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxByExprOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.By) THEN
        Insert(tmp, Match(Symbol.Kind.By), 1);
        Insert(tmp, SyntaxExpr(), 2);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxByExprOpt;


  PROCEDURE SyntaxLoopStatement (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxLoopStatement);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.Loop), 1);
      Insert(tmp, SyntaxStatementOptSeq(), 2);
      Insert(tmp, Match(Symbol.Kind.End), 3);
      RETURN tmp;
    END SyntaxLoopStatement;


  PROCEDURE SyntaxWithStatement (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxWithStatement);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.With), 1);
      Insert(tmp, SyntaxDesignator(), 2);
      Insert(tmp, Match(Symbol.Kind.Do), 3);
      Insert(tmp, SyntaxWithScope(), 4);
      Insert(tmp, Match(Symbol.Kind.End), 5);
      RETURN tmp;
    END SyntaxWithStatement;


  PROCEDURE SyntaxWithScope (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxWithScope);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, SyntaxStatementOptSeq(), 1);
      RETURN tmp;
    END SyntaxWithScope;


  PROCEDURE SyntaxDesignator (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxDesignator);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.Identifier,
                        Token.UsageSet{Token.Usage.Appl}), 1);
      Insert(tmp, SyntaxDesignatorTailList(), 2);
      RETURN tmp;
    END SyntaxDesignator;


  PROCEDURE SyntaxDesignatorTailList (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    CONST
      DTLLookAhead = Symbol.KindSet{
                       Symbol.Kind.Period, Symbol.Kind.ALBracket,
                       Symbol.Kind.Arrow};

    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxDesignatorTailList);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind IN DTLLookAhead) THEN
        Insert(tmp, SyntaxDesignatorTail(), 1);
        Insert(tmp, SyntaxDesignatorTailList(), 2);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxDesignatorTailList;


  PROCEDURE SyntaxDesignatorTail (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxDesignatorTail);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      CASE nextTokenKind OF
      | Symbol.Kind.Period => Insert(tmp, SyntaxDesignatorScope(), 1);
      | Symbol.Kind.Arrow => Insert(tmp, SyntaxReference(), 1);
      | Symbol.Kind.ALBracket => Insert(tmp, SyntaxSubscriptionScope(), 1);
      ELSE
        RAISE SyntaxError(
                Error{nextToken, Message.Code.DesignatorItemExpected});
      END;
      RETURN tmp;
    END SyntaxDesignatorTail;


  PROCEDURE SyntaxDesignatorScope (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxDesignatorScope);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.Period), 1);
      Insert(tmp, Match(Symbol.Kind.Identifier,
                        Token.UsageSet{Token.Usage.Appl}), 2);
      RETURN tmp;
    END SyntaxDesignatorScope;


  PROCEDURE SyntaxReference (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxReference);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.Arrow), 1);
      RETURN tmp;
    END SyntaxReference;


  PROCEDURE SyntaxSubscriptionScope (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxSubscriptionScope);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.ALBracket), 1);
      Insert(tmp, SyntaxExpr(), 2);
      Insert(tmp, SyntaxExprList(), 3);
      Insert(tmp, Match(Symbol.Kind.ARBracket), 4);
      RETURN tmp;
    END SyntaxSubscriptionScope;


  PROCEDURE SyntaxActualParametersOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxActualParametersOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.LBracket) THEN
        Insert(tmp, SyntaxActualParameters(), 1);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxActualParametersOpt;


  PROCEDURE SyntaxActualParameters (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxActualParameters);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.LBracket), 1);
      Insert(tmp, SyntaxExprSeqOpt(), 2);
      Insert(tmp, Match(Symbol.Kind.RBracket), 3);
      RETURN tmp;
    END SyntaxActualParameters;


  PROCEDURE SyntaxExprSeqOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    CONST
      ESOLookAhead = Symbol.KindSet{
                       Symbol.Kind.Plus, Symbol.Kind.Minus,
                       Symbol.Kind.IntegerConst, Symbol.Kind.LongConst,
                       Symbol.Kind.StringConst, Symbol.Kind.CharConst,
                       Symbol.Kind.RealConst, Symbol.Kind.LBracket,
                       Symbol.Kind.Not, Symbol.Kind.CLBracket,
                       Symbol.Kind.Identifier};

    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxExprSeqOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind IN ESOLookAhead) THEN
        Insert(tmp, SyntaxExpr(), 1);
        Insert(tmp, SyntaxExprList(), 2);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxExprSeqOpt;


  PROCEDURE SyntaxExprList (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxExprList);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.Comma) THEN
        Insert(tmp, Match(Symbol.Kind.Comma), 1);
        Insert(tmp, SyntaxExpr(), 2);
        Insert(tmp, SyntaxExprList(), 3);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxExprList;


  PROCEDURE SyntaxExprOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    CONST
      EOLookAhead = Symbol.KindSet{
                      Symbol.Kind.Plus, Symbol.Kind.Minus,
                      Symbol.Kind.IntegerConst, Symbol.Kind.LongConst,
                      Symbol.Kind.StringConst, Symbol.Kind.CharConst,
                      Symbol.Kind.RealConst, Symbol.Kind.LBracket,
                      Symbol.Kind.Not, Symbol.Kind.CLBracket,
                      Symbol.Kind.Identifier};

    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxExprOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind IN EOLookAhead) THEN
        Insert(tmp, SyntaxExpr(), 1);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxExprOpt;


  PROCEDURE SyntaxExpr (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxExpr);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, SyntaxSimpleExpr(), 1);
      Insert(tmp, SyntaxRelationOpt(), 2);
      RETURN tmp;
    END SyntaxExpr;


  PROCEDURE SyntaxRelationOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    CONST
      ROLookAhead = Symbol.KindSet{Symbol.Kind.Equal, Symbol.Kind.NEqual,
                                   Symbol.Kind.Less, Symbol.Kind.LEqual,
                                   Symbol.Kind.Greater, Symbol.Kind.GEqual,
                                   Symbol.Kind.In};

    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxRelationOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind IN ROLookAhead) THEN
        Insert(tmp, SyntaxRelation(), 1);
        Insert(tmp, SyntaxSimpleExpr(), 2);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxRelationOpt;


  PROCEDURE SyntaxRelation (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    CONST
      RLookAhead = Symbol.KindSet{Symbol.Kind.Equal, Symbol.Kind.NEqual,
                                  Symbol.Kind.Less, Symbol.Kind.LEqual,
                                  Symbol.Kind.Greater, Symbol.Kind.GEqual,
                                  Symbol.Kind.In};

    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxRelation);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind IN RLookAhead) THEN
        Insert(tmp, Match(nextTokenKind), 1);
      ELSE
        RAISE SyntaxError(Error{nextToken, Message.Code.RelationExpected});
      END;
      RETURN tmp;
    END SyntaxRelation;


  PROCEDURE SyntaxSimpleExpr (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxSimpleExpr);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, SyntaxUnaryAddOpt(), 1);
      Insert(tmp, SyntaxTerm(), 2);
      Insert(tmp, SyntaxAddTermList(), 3);
      RETURN tmp;
    END SyntaxSimpleExpr;


  PROCEDURE SyntaxUnaryAddOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxUnaryAddOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind
            IN Symbol.KindSet{Symbol.Kind.Minus, Symbol.Kind.Plus}) THEN
        Insert(tmp, SyntaxUnaryAdd(), 1);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxUnaryAddOpt;


  PROCEDURE SyntaxUnaryAdd (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxUnaryAdd);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      CASE nextTokenKind OF
      | Symbol.Kind.Plus, Symbol.Kind.Minus =>
          Insert(tmp, Match(nextTokenKind), 1);
      ELSE
        RAISE
          SyntaxError(Error{nextToken, Message.Code.SumOperatorExpected});
      END;
      RETURN tmp;
    END SyntaxUnaryAdd;


  PROCEDURE SyntaxAddTermList (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    CONST
      ATLLookAhead = Symbol.KindSet{
                       Symbol.Kind.Plus, Symbol.Kind.Minus, Symbol.Kind.Or};

    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxAddTermList);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind IN ATLLookAhead) THEN
        Insert(tmp, SyntaxBinaryAdd(), 1);
        Insert(tmp, SyntaxTerm(), 2);
        Insert(tmp, SyntaxAddTermList(), 3);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxAddTermList;


  PROCEDURE SyntaxBinaryAdd (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxBinaryAdd);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      CASE nextTokenKind OF
      | Symbol.Kind.Plus => Insert(tmp, Match(Symbol.Kind.Plus), 1);
      | Symbol.Kind.Minus => Insert(tmp, Match(Symbol.Kind.Minus), 1);
      | Symbol.Kind.Or => Insert(tmp, Match(Symbol.Kind.Or), 1);
      ELSE
        RAISE
          SyntaxError(Error{nextToken, Message.Code.BinaryAddExpected});
      END;
      RETURN tmp;
    END SyntaxBinaryAdd;


  PROCEDURE SyntaxTerm (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxTerm);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, SyntaxFactor(), 1);
      Insert(tmp, SyntaxMulFactorList(), 2);
      RETURN tmp;
    END SyntaxTerm;


  PROCEDURE SyntaxMulFactorList (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    CONST
      MFLLookAhead = Symbol.KindSet{
                       Symbol.Kind.Mult, Symbol.Kind.Division,
                       Symbol.Kind.Div, Symbol.Kind.Mod, Symbol.Kind.Rem,
                       Symbol.Kind.And, Symbol.Kind.Ampersand};

    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxMulFactorList);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind IN MFLLookAhead) THEN
        Insert(tmp, SyntaxMul(), 1);
        Insert(tmp, SyntaxFactor(), 2);
        Insert(tmp, SyntaxMulFactorList(), 3);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxMulFactorList;


  PROCEDURE SyntaxMul (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxMul);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      CASE nextTokenKind OF
      | Symbol.Kind.Mult, Symbol.Kind.Division, Symbol.Kind.Div,
          Symbol.Kind.Mod, Symbol.Kind.Rem, Symbol.Kind.And,
          Symbol.Kind.Ampersand =>
          Insert(tmp, Match(nextTokenKind), 1);
      ELSE
        RAISE
          SyntaxError(Error{nextToken, Message.Code.MulOperatorExpected});
      END;
      RETURN tmp;
    END SyntaxMul;


  PROCEDURE SyntaxFactor (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxFactor);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      CASE nextTokenKind OF
      | Symbol.Kind.IntegerConst, Symbol.Kind.LongConst,
          Symbol.Kind.StringConst, Symbol.Kind.CharConst,
          Symbol.Kind.RealConst =>
          Insert(tmp, Match(nextTokenKind), 1);
      | Symbol.Kind.LBracket => Insert(tmp, SyntaxFactorExpr(), 1);
      | Symbol.Kind.Not => Insert(tmp, SyntaxNotFactor(), 1);
      | Symbol.Kind.Identifier => Insert(tmp, SyntaxQualSetOrCall(), 1);
      | Symbol.Kind.CLBracket => Insert(tmp, SyntaxSet(), 1);
      ELSE
        RAISE SyntaxError(Error{nextToken, Message.Code.FactorExpected});
      END;
      RETURN tmp;
    END SyntaxFactor;


  PROCEDURE SyntaxFactorExpr (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxFactorExpr);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.LBracket), 1);
      Insert(tmp, SyntaxExpr(), 2);
      Insert(tmp, Match(Symbol.Kind.RBracket), 3);
      RETURN tmp;
    END SyntaxFactorExpr;


  PROCEDURE SyntaxNotFactor (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxNotFactor);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.Not), 1);
      Insert(tmp, SyntaxFactor(), 2);
      RETURN tmp;
    END SyntaxNotFactor;


  PROCEDURE SyntaxQualSetOrCall (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxQualSetOrCall);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, SyntaxQualIdent(), 1);
      Insert(tmp, SyntaxSetOrCall(), 2);
      RETURN tmp;
    END SyntaxQualSetOrCall;


  PROCEDURE SyntaxSetOrCall (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxSetOrCall);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      CASE nextTokenKind OF
      | Symbol.Kind.CLBracket => Insert(tmp, SyntaxSet(), 1);
      ELSE
        (*
          branch must be tested later!,
          Look ahead too difficult
        *)
        Insert(tmp, SyntaxCall(), 1);
      END;
      RETURN tmp;
    END SyntaxSetOrCall;


  PROCEDURE SyntaxCall (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxCall);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, SyntaxDesignatorTailList(), 1);
      Insert(tmp, SyntaxActualParametersOpt(), 2);
      RETURN tmp;
    END SyntaxCall;


  PROCEDURE SyntaxSet (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxSet);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.CLBracket), 1);
      Insert(tmp, SyntaxElementSeqOpt(), 2);
      Insert(tmp, Match(Symbol.Kind.CRBracket), 3);
      RETURN tmp;
    END SyntaxSet;


  PROCEDURE SyntaxElementSeqOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    CONST
      ESOLookAhead = Symbol.KindSet{
                       Symbol.Kind.Plus, Symbol.Kind.Minus,
                       Symbol.Kind.IntegerConst, Symbol.Kind.LongConst,
                       Symbol.Kind.StringConst, Symbol.Kind.CharConst,
                       Symbol.Kind.RealConst, Symbol.Kind.LBracket,
                       Symbol.Kind.Not, Symbol.Kind.Identifier,
                       Symbol.Kind.CLBracket};

    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxElementSeqOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind IN ESOLookAhead) THEN
        Insert(tmp, SyntaxElement(), 1);
        Insert(tmp, SyntaxElementList(), 2);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxElementSeqOpt;


  PROCEDURE SyntaxElementList (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxElementList);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.Comma) THEN
        Insert(tmp, Match(Symbol.Kind.Comma), 1);
        Insert(tmp, SyntaxElement(), 2);
        Insert(tmp, SyntaxElementList(), 3);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxElementList;


  PROCEDURE SyntaxElement (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxElement);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, SyntaxExpr(), 1);
      Insert(tmp, SyntaxElementRangeOpt(), 2);
      RETURN tmp;
    END SyntaxElement;


  PROCEDURE SyntaxElementRangeOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxElementRangeOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.Range) THEN
        Insert(tmp, Match(Symbol.Kind.Range), 1);
        Insert(tmp, SyntaxExpr(), 2);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxElementRangeOpt;



  PROCEDURE SyntaxConstExprSeqOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    CONST
      CESOLookAhead = Symbol.KindSet{
                        Symbol.Kind.Plus, Symbol.Kind.Minus,
                        Symbol.Kind.IntegerConst, Symbol.Kind.LongConst,
                        Symbol.Kind.StringConst, Symbol.Kind.CharConst,
                        Symbol.Kind.RealConst, Symbol.Kind.LBracket,
                        Symbol.Kind.Not, Symbol.Kind.Identifier,
                        Symbol.Kind.CLBracket};

    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxConstExprSeqOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind IN CESOLookAhead) THEN
        Insert(tmp, SyntaxConstExpr(), 1);
        Insert(tmp, SyntaxConstExprList(), 2);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxConstExprSeqOpt;


  PROCEDURE SyntaxConstExprList (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxConstExprList);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.Comma) THEN
        Insert(tmp, Match(Symbol.Kind.Comma), 1);
        Insert(tmp, SyntaxConstExpr(), 2);
        Insert(tmp, SyntaxConstExprList(), 3);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxConstExprList;


  PROCEDURE SyntaxConstExpr (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxConstExpr);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, SyntaxSimpleConstExpr(), 1);
      Insert(tmp, SyntaxSimpleRelationOpt(), 2);
      RETURN tmp;
    END SyntaxConstExpr;


  PROCEDURE SyntaxSimpleRelationOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    CONST
      SROLookAhead = Symbol.KindSet{Symbol.Kind.Equal, Symbol.Kind.NEqual,
                                    Symbol.Kind.Less, Symbol.Kind.Greater,
                                    Symbol.Kind.LEqual, Symbol.Kind.GEqual,
                                    Symbol.Kind.In};

    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxSimpleRelationOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind IN SROLookAhead) THEN
        Insert(tmp, SyntaxRelation(), 1);
        Insert(tmp, SyntaxSimpleConstExpr(), 2);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxSimpleRelationOpt;


  PROCEDURE SyntaxSimpleConstExpr (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxSimpleConstExpr);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, SyntaxUnaryAddOpt(), 1);
      Insert(tmp, SyntaxConstTerm(), 2);
      Insert(tmp, SyntaxAddSimpleTermList(), 3);
      RETURN tmp;
    END SyntaxSimpleConstExpr;


  PROCEDURE SyntaxAddSimpleTermList (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    CONST
      ASTLLookAhead = Symbol.KindSet{Symbol.Kind.Plus, Symbol.Kind.Minus,
                                     Symbol.Kind.Or};

    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxAddSimpleTermList);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind IN ASTLLookAhead) THEN
        Insert(tmp, SyntaxBinaryAdd(), 1);
        Insert(tmp, SyntaxConstTerm(), 2);
        Insert(tmp, SyntaxAddSimpleTermList(), 3);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxAddSimpleTermList;


  PROCEDURE SyntaxConstTerm (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxConstTerm);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, SyntaxConstFactor(), 1);
      Insert(tmp, SyntaxMulConstFactorList(), 2);
      RETURN tmp;
    END SyntaxConstTerm;


  PROCEDURE SyntaxMulConstFactorList (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    CONST
      MCFLLookAhead = Symbol.KindSet{
                        Symbol.Kind.Mult, Symbol.Kind.Division,
                        Symbol.Kind.Div, Symbol.Kind.Mod, Symbol.Kind.Rem,
                        Symbol.Kind.And, Symbol.Kind.Ampersand};

    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxMulConstFactorList);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind IN MCFLLookAhead) THEN
        Insert(tmp, SyntaxMul(), 1);
        Insert(tmp, SyntaxConstFactor(), 2);
        Insert(tmp, SyntaxMulConstFactorList(), 3);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxMulConstFactorList;


  PROCEDURE SyntaxConstFactor (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxConstFactor);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      CASE nextTokenKind OF
      | Symbol.Kind.IntegerConst =>
          Insert(tmp, Match(Symbol.Kind.IntegerConst), 1);
      | Symbol.Kind.LongConst =>
          Insert(tmp, Match(Symbol.Kind.LongConst), 1);
      | Symbol.Kind.RealConst =>
          Insert(tmp, Match(Symbol.Kind.RealConst), 1);
      | Symbol.Kind.CharConst =>
          Insert(tmp, Match(Symbol.Kind.CharConst), 1);
      | Symbol.Kind.StringConst =>
          Insert(tmp, Match(Symbol.Kind.StringConst), 1);
      | Symbol.Kind.LBracket => Insert(tmp, SyntaxConstFactorExpr(), 1);
      | Symbol.Kind.Not => Insert(tmp, SyntaxNotConstFactor(), 1);
      | Symbol.Kind.Identifier =>
          Insert(tmp, SyntaxQualConstSetOrCall(), 1);
      | Symbol.Kind.CLBracket => Insert(tmp, SyntaxConstSet(), 1);
      ELSE
        RAISE SyntaxError(
                Error{nextToken, Message.Code.ConstantFactorExpected});
      END;
      RETURN tmp;
    END SyntaxConstFactor;


  PROCEDURE SyntaxConstFactorExpr (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxConstFactorExpr);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.LBracket), 1);
      Insert(tmp, SyntaxConstExpr(), 2);
      Insert(tmp, Match(Symbol.Kind.RBracket), 3);
      RETURN tmp;
    END SyntaxConstFactorExpr;


  PROCEDURE SyntaxNotConstFactor (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxNotConstFactor);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.Not), 1);
      Insert(tmp, SyntaxConstFactor(), 2);
      RETURN tmp;
    END SyntaxNotConstFactor;


  PROCEDURE SyntaxQualConstSetOrCall (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxQualConstSetOrCall);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, SyntaxQualIdent(), 1);
      Insert(tmp, SyntaxConstSetOrCall(), 2);
      RETURN tmp;
    END SyntaxQualConstSetOrCall;


  PROCEDURE SyntaxConstSetOrCall (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxConstSetOrCall);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      CASE nextTokenKind OF
      | Symbol.Kind.CLBracket => Insert(tmp, SyntaxConstSet(), 1)
      ELSE                       (* later tested; because of look ahead too
                                    large *)
        Insert(tmp, SyntaxConstActualParametersOpt(), 1);
      END;
      RETURN tmp;
    END SyntaxConstSetOrCall;


  PROCEDURE SyntaxConstActualParametersOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR
      tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxConstActualParametersOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.LBracket) THEN
        Insert(tmp, Match(Symbol.Kind.LBracket), 1);
        Insert(tmp, SyntaxConstExprSeqOpt(), 2);
        Insert(tmp, Match(Symbol.Kind.RBracket), 3);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxConstActualParametersOpt;


  PROCEDURE SyntaxConstSet (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxConstSet);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.CLBracket), 1);
      Insert(tmp, SyntaxConstElementSeqOpt(), 2);
      Insert(tmp, Match(Symbol.Kind.CRBracket), 3);
      RETURN tmp;
    END SyntaxConstSet;


  PROCEDURE SyntaxConstElementSeqOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    CONST
      CESOLookAhead = Symbol.KindSet{
                        Symbol.Kind.Plus, Symbol.Kind.Minus,
                        Symbol.Kind.IntegerConst, Symbol.Kind.LongConst,
                        Symbol.Kind.StringConst, Symbol.Kind.CharConst,
                        Symbol.Kind.RealConst, Symbol.Kind.LBracket,
                        Symbol.Kind.Not, Symbol.Kind.Identifier,
                        Symbol.Kind.CLBracket};

    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxConstElementSeqOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind IN CESOLookAhead) THEN
        Insert(tmp, SyntaxConstElement(), 1);
        Insert(tmp, SyntaxConstElementList(), 2);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxConstElementSeqOpt;


  PROCEDURE SyntaxConstElementList (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxConstElementList);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.Comma) THEN
        Insert(tmp, Match(Symbol.Kind.Comma), 1);
        Insert(tmp, SyntaxConstElement(), 2);
        Insert(tmp, SyntaxConstElementList(), 3);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxConstElementList;


  PROCEDURE SyntaxConstElement (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxConstElement);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, SyntaxConstExpr(), 1);
      Insert(tmp, SyntaxConstRangeOpt(), 2);
      RETURN tmp;
    END SyntaxConstElement;


  PROCEDURE SyntaxConstRangeOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxConstRangeOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.Range) THEN
        Insert(tmp, Match(Symbol.Kind.Range), 1);
        Insert(tmp, SyntaxConstExpr(), 2);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxConstRangeOpt;


  PROCEDURE SyntaxDIdentOpt (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxDIdentOpt);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.Identifier) THEN
        Insert(tmp, Match(Symbol.Kind.Identifier,
                          Token.UsageSet{Token.Usage.Decl}), 1);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxDIdentOpt;


  PROCEDURE SyntaxDIdentList (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxDIdentList);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.Comma) THEN
        Insert(tmp, Match(Symbol.Kind.Comma), 1);
        Insert(tmp, Match(Symbol.Kind.Identifier,
                          Token.UsageSet{Token.Usage.Decl}), 2);
        Insert(tmp, SyntaxDIdentList(), 3);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxDIdentList;


  PROCEDURE SyntaxDAIdentList (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxDAIdentList);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.Comma) THEN
        Insert(tmp, Match(Symbol.Kind.Comma), 1);
        Insert(
          tmp, Match(Symbol.Kind.Identifier,
                     Token.UsageSet{Token.Usage.Decl, Token.Usage.Appl}), 2);
        Insert(tmp, SyntaxDAIdentList(), 3);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxDAIdentList;


  PROCEDURE SyntaxQualIdent (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxQualIdent);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      Insert(tmp, Match(Symbol.Kind.Identifier,
                        Token.UsageSet{Token.Usage.Appl}), 1);
      Insert(tmp, SyntaxQualificationScope(), 2);
      RETURN tmp;
    END SyntaxQualIdent;


  PROCEDURE SyntaxQualificationScope (): Syntax.T
    RAISES {GraphError, BaseGraph.NodeInGraph, SyntaxError, OutOfTokens} =
    VAR tmp := NEW(Syntax.T).init(Symbol.Kind.SyntaxQualificationScope);

    BEGIN
      syntaxGraph.insertSyntax(tmp);
      IF (nextTokenKind = Symbol.Kind.Period) THEN
        Insert(tmp, Match(Symbol.Kind.Period), 1);
        Insert(tmp, Match(Symbol.Kind.Identifier,
                          Token.UsageSet{Token.Usage.Appl}), 2);
        Insert(tmp, SyntaxQualificationScope(), 3);
      ELSE
        (* epsilon *)
      END;
      RETURN tmp;
    END SyntaxQualificationScope;


  (* Parse *)
  BEGIN
    TRY
      nextToken := syntaxGraph.getFirstToken(anchor, Token.Language.M2);
      WHILE (nextToken.getKind() IN SkipIt) DO
        nextToken :=
          syntaxGraph.getNextToken(nextToken, Token.Language.M2);
      END;
      nextTokenKind := nextToken.getKind();

      syntaxGraph.setRoot(anchor, SyntaxCompilationUnit());
    EXCEPT
      BaseGraph.NodeNotInGraph, BaseGraph.NodeInGraph,
          BaseGraph.EdgeInGraph =>
        RAISE GraphError;
    END;
  END Parse;

BEGIN
END Parser.
