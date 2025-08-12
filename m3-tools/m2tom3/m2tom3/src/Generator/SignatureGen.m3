MODULE SignatureGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Kai Michael Degner                                        *)

(** pk
    1.2
    1995/02/14 15:36:55
    SignatureGen.m3,v
# Revision 1.2  1995/02/14  15:36:55  pk
# New InsertReadonly procedure makes call-by-value ARRAY parameters
# READONLY.
#
# Revision 1.1  1994/11/30  15:05:53  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT SourceGraph, TokenGraph, BaseGraph;
IMPORT Symbol, Token, Syntax;
IMPORT SyntaxSupport, IdentifierLinker;
IMPORT Fmt;


(** --- InsertEmptyParameterList -----------------------------------------------
  * Inserts an empty parameter list '()'.
  * Call this for all procedure declaration and definition.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE InsertEmptyParameterList (graph : SourceGraph.T;
                                    anchor: SourceGraph.Anchor;
                                    proc  : Syntax.T            ) =
  <* FATAL BaseGraph.NodeInGraph, BaseGraph.NodeNotInGraph,
           TokenGraph.NoAnchor, TokenGraph.NotInStream *>

  (** --- MissingEmptyParameterList ----------------------------------------------
    * Determines whether empty paratheses are missing ot not.
    * ----------------------------------------------------------------------------
    **)
  PROCEDURE MissingEmptyParameterList (graph: SourceGraph.T; proc: Syntax.T):
    BOOLEAN =
    BEGIN
      RETURN
        (NARROW(graph.getChildSymbol(graph.getChildSymbol(proc, 3), 1),
                Syntax.T).getNoOfChildren() = 0);
    END MissingEmptyParameterList;

  (* InsertEmptyParameterList *)
  BEGIN
    <* ASSERT ((proc.getKind () = Symbol.Kind.SyntaxProcedureDeclaration)
            OR (proc.getKind () = Symbol.Kind.SyntaxProcedureDefinition))*>

    IF (MissingEmptyParameterList(graph, proc)) THEN
      WITH ident = graph.getChildSymbol(proc, 2, Symbol.Kind.Identifier) DO
        WITH newToken = NEW(Token.T).init(
                          Symbol.Kind.GenText, "()", Token.M3Only) DO
          graph.appendToken(anchor, newToken, ident);
        END;
      END;
    END;
  END InsertEmptyParameterList;


(** --- ChangeSemincolon -------------------------------------------------------
  * Replaces the semicolon at the end of a procedure head by an equal sign.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE ChangeSemicolon (graph   : SourceGraph.T;
                           anchor  : SourceGraph.Anchor;
                           procDecl: Syntax.T            ) =
  <* FATAL BaseGraph.NodeInGraph, BaseGraph.NodeNotInGraph,
       TokenGraph.NoAnchor, TokenGraph.NotInStream *>

  BEGIN
    <* ASSERT procDecl.getKind () = Symbol.Kind.SyntaxProcedureDeclaration *>

    WITH semicolon = graph.getChildSymbol(
                       graph.getChildSymbol(
                         procDecl, 3, Symbol.Kind.SyntaxOuterScope), 2,
                       Symbol.Kind.Semicolon) DO
      NARROW(semicolon, Token.T).removeLanguage(Token.Language.M3);
      WITH newToken = NEW(Token.T).init(
                        Symbol.Kind.GenText, " =", Token.M3Only) DO
        graph.appendToken(anchor, newToken, semicolon);
      END;
    END;
  END ChangeSemicolon;


(** --- ExtendProcedureType ----------------------------------------------------
  * Inserts identifier for formal parameters needed in procedure type
  * declaration.
  * If procedure type has an empty parameter list '()' will be generated if
  * necessary.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE ExtendProcedureType (graph   : SourceGraph.T;
                               anchor  : SourceGraph.Anchor;
                               procType: Syntax.T            ) =
  <* FATAL BaseGraph.NodeInGraph, BaseGraph.NodeNotInGraph,
         TokenGraph.NoAnchor, TokenGraph.NotInStream *>

  VAR
    formalSigOpt : Syntax.T;
    iterator     : SyntaxSupport.SyntaxTreeIterator;
    number       : CARDINAL;
    symbol, ident: Symbol.T;

  BEGIN
    <* ASSERT procType.getKind () = Symbol.Kind.SyntaxProcedureType *>

    formalSigOpt := graph.getChildSymbol(
                      procType, 2, Symbol.Kind.SyntaxFormalSignatureOpt);

    IF (formalSigOpt.getNoOfChildren() = 0) THEN
      (* Generate '()' *)
      WITH procIdent = graph.getChildSymbol(
                         procType, 1, Symbol.Kind.Procedure) DO
        WITH newToken = NEW(Token.T).init(
                          Symbol.Kind.GenText, "()", Token.M3Only) DO
          graph.appendToken(anchor, newToken, procIdent);
        END;
      END;
      RETURN;
    END;

    WITH sigSecSeqOpt = graph.getChildSymbol(
                          graph.getChildSymbol(
                            formalSigOpt, 1,
                            Symbol.Kind.SyntaxFormalSignature), 2,
                          Symbol.Kind.SyntaxSignatureSectionSeqOpt) DO
      iterator :=
        NEW(SyntaxSupport.SyntaxTreeIterator).init(graph, sigSecSeqOpt);
    END;
    number := 0;
    symbol := iterator.next();
    WHILE (symbol # NIL) DO
      IF (symbol.getKind() = Symbol.Kind.Comma) THEN
        NARROW(symbol, Token.T).removeLanguage(Token.Language.M3);
        WITH newToken = NEW(Token.T).init(
                          Symbol.Kind.GenText, ";", Token.M3Only) DO
          graph.appendToken(anchor, newToken, NARROW(symbol, Token.T));
        END;
      END;

      WITH symbolKind = symbol.getKind() DO
        IF ((symbolKind = Symbol.Kind.SyntaxQualIdent)
              OR (symbolKind = Symbol.Kind.Array)) THEN
          IF (symbolKind = Symbol.Kind.Array) THEN
            ident := symbol;
          ELSE
            ident := graph.getChildSymbol(symbol, 1);
          END;
          WITH newToken = NEW(Token.T).init(
                            Symbol.Kind.GenText,
                            "p" & Fmt.Int(number) & ": ", Token.M3Only) DO
            graph.prependToken(anchor, newToken, NARROW(ident, Token.T));
            IF (symbolKind = Symbol.Kind.Array) THEN
              EVAL iterator.next(); (* Skip ARRAY *)
              EVAL iterator.next(); (* Skip OF *)
              symbol := iterator.next(); (* Skip QualIdent *)
            ELSE
              symbol := iterator.next();
            END;
            INC(number);
          END;
        ELSE
          symbol := iterator.next();
        END;
      END;
    END;
  END ExtendProcedureType;


PROCEDURE InsertReadonly (graph   : SourceGraph.T;
                          anchor  : SourceGraph.Anchor;
                          procType: Syntax.T            ) =
  <* FATAL BaseGraph.NodeNotInGraph *>

  VAR
    formalParametersOpt : Syntax.T;
    parameterSection    : Syntax.T;
    parameterSectionList: Syntax.T;

  BEGIN
    CASE procType.getKind() OF
      Symbol.Kind.SyntaxProcedureDeclaration =>
        WITH outerScope = graph.getChildSymbol(
                            procType, 3, Symbol.Kind.SyntaxOuterScope) DO
          formalParametersOpt :=
            graph.getChildSymbol(
              outerScope, 1, Symbol.Kind.SyntaxFormalParametersOpt);
        END;
    | Symbol.Kind.SyntaxProcedureDefinition =>
        WITH formalScope = graph.getChildSymbol(
                             procType, 3, Symbol.Kind.SyntaxFormalScope) DO
          formalParametersOpt :=
            graph.getChildSymbol(
              formalScope, 1, Symbol.Kind.SyntaxFormalParametersOpt);
        END;
    ELSE
      <* ASSERT FALSE *>
    END;

    IF (formalParametersOpt.getNoOfChildren() = 0) THEN RETURN; END;

    WITH formalParameters = graph.getChildSymbol(
                              formalParametersOpt, 1,
                              Symbol.Kind.SyntaxFormalParameters),
         parameterSectionSeqOpt = graph.getChildSymbol(
                                    formalParameters, 2,
                                    Symbol.Kind.SyntaxParameterSectionSeqOpt) DO
      IF (NARROW(parameterSectionSeqOpt, Syntax.T).getNoOfChildren() = 0) THEN
        RETURN;
      END;
      parameterSection :=
        graph.getChildSymbol(
          parameterSectionSeqOpt, 1, Symbol.Kind.SyntaxParameterSection);
      parameterSectionList :=
        graph.getChildSymbol(parameterSectionSeqOpt, 2,
                             Symbol.Kind.SyntaxParameterSectionList);
    END;

    LOOP
      IF (IsCBVArray(graph, parameterSection)) THEN
        InsertPrefix(graph, anchor, parameterSection);
      END;
      IF (parameterSectionList.getNoOfChildren() = 0) THEN EXIT; END;
      parameterSection :=
        graph.getChildSymbol(
          parameterSectionList, 2, Symbol.Kind.SyntaxParameterSection);
      parameterSectionList :=
        graph.getChildSymbol(
          parameterSectionList, 3, Symbol.Kind.SyntaxParameterSectionList);
    END;
  END InsertReadonly;


PROCEDURE IsCBVArray (graph: SourceGraph.T; parameterSection: Syntax.T):
  BOOLEAN =
  <* FATAL BaseGraph.NodeNotInGraph *>

  BEGIN
    WITH varOpt = graph.getChildSymbol(
                    parameterSection, 1, Symbol.Kind.SyntaxVarOpt) DO
      IF (NARROW(varOpt, Syntax.T).getNoOfChildren() > 0) THEN
        RETURN FALSE;
      END;
    END;

    WITH formalType = graph.getChildSymbol(
                        parameterSection, 5, Symbol.Kind.SyntaxFormalType),
         arrayOpt = graph.getChildSymbol(
                      formalType, 1, Symbol.Kind.SyntaxArrayOpt) DO
      IF (NARROW(arrayOpt, Syntax.T).getNoOfChildren() > 0) THEN
        RETURN TRUE;
      END;
      WITH qualIdent = graph.getChildSymbol(
                         formalType, 2, Symbol.Kind.SyntaxQualIdent),
           realType = IdentifierLinker.FindRealType(graph, qualIdent) DO
        RETURN ((realType # NIL)
                  AND (realType.getKind() = Symbol.Kind.SyntaxArrayType));
      END;
    END;
  END IsCBVArray;


PROCEDURE InsertPrefix (graph           : SourceGraph.T;
                        anchor          : SourceGraph.Anchor;
                        parameterSection: Syntax.T            ) =
  <* FATAL BaseGraph.NodeNotInGraph, BaseGraph.NodeInGraph,
           TokenGraph.NoAnchor, TokenGraph.NotInStream *>

  VAR current: Token.T;

  BEGIN
    current := SyntaxSupport.FindLeftmostToken(graph, parameterSection);
    REPEAT
      current := graph.getPrevToken(current, Token.Language.M3);
    UNTIL ((current.getKind() = Symbol.Kind.Semicolon)
             OR (current.getKind() = Symbol.Kind.LBracket));
    WITH newToken = NEW(Token.T).init(
                      Symbol.Kind.GenText, "READONLY ", Token.M3Only) DO
      graph.appendToken(anchor, newToken, current);
    END;
  END InsertPrefix;

BEGIN
END SignatureGen.
