MODULE VariantGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.3
    1995/02/14 12:16:51
    VariantGen.m3,v
# Revision 1.3  1995/02/14  12:16:51  pk
# Some unnecessary exception handling removed.
#
# Revision 1.2  1995/01/24  10:43:19  pk
# In variant records with anonymous discriminants, the type identifier
# was not removed if it was converted previously, because the generated
# new identifier lies outside the subtree under which the flag is
# reset. Now, the flag is removed in a loop on token level.
#
# Revision 1.1  1994/11/30  15:06:15  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(* subsystem SourceGraph *)
IMPORT BaseGraph;
IMPORT Symbol;
IMPORT Token, TokenGraph;
IMPORT Syntax, SyntaxSupport;
IMPORT DeclGraph;
IMPORT SourceGraph;

(* subssystem Utilities *)
IMPORT Message;

(* subsystem Generator *)
IMPORT GeneratorSupport;


(** --- IsVariantRecord --------------------------------------------------------
  * Tests if a record contains a variant part to transform.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE IsVariantRecord (graph: SourceGraph.T; recordType: Syntax.T):
  BOOLEAN =
  VAR
    i     : SyntaxSupport.SyntaxTreeIterator;
    symbol: Symbol.T;

  BEGIN
    i := NEW(SyntaxSupport.SyntaxTreeIterator).init(graph, recordType);

    symbol := i.next();
    WHILE (symbol # NIL) DO
      IF (symbol.getKind() = Symbol.Kind.SyntaxCaseField) THEN
        RETURN TRUE;
      ELSIF (symbol.getKind() = Symbol.Kind.SyntaxSimpleField) THEN
        symbol := i.skip();
      ELSE
        symbol := i.next();
      END
    END;
    RETURN FALSE;
  END IsVariantRecord;


(** --- FlatRecord -------------------------------------------------------------
  * Transforms a variant record into a 'flat' record.
  *
  * The flat record contains all variant parts occupying an own memory place.
  * All applying occurences of variant field will be marked as
  *   'warning: applying of variant field'.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE FlatRecord (graph     : SourceGraph.T;
                      unit      : SourceGraph.Anchor;
                      recordType: Syntax.T;
                      inWork    : BOOLEAN             ) =

  (** --- MarksApplsOfIdent ----------------------------------------------------
    * Follows a decl identifier to all it's applying pendants and mark them
    * with a warning (`possible cast ?`).
    * --------------------------------------------------------------------------
    **)
  PROCEDURE MarkApplsOfIdent (decl: Token.T) =
    <* FATAL BaseGraph.NodeNotInGraph *>

    VAR
      i     : DeclGraph.ApplsOfDeclIterator;
      appl  : Token.T;
      anchor: SourceGraph.Anchor;

    BEGIN
      i := graph.iterateApplsOfDecl(decl);
      appl := i.next();

      WHILE (appl # NIL) DO
        anchor := graph.findAnchor(appl);
        IF (anchor.isWork()) THEN
          Message.Write(graph := graph, token := appl,
                        code := Message.Code.VariantAppl);
        END;
        appl := i.next();
      END;
    END MarkApplsOfIdent;


  (** --- MarkApplsOfVariant ---------------------------------------------------
    * Finds all declaring identifiers in this simple field and marks their
    * applying identifiers.
    * --------------------------------------------------------------------------
    **)
  PROCEDURE MarkApplsOfVariant (simpleField: Syntax.T) =
    <* FATAL BaseGraph.NodeNotInGraph *>

    VAR identList: Syntax.T;

    BEGIN
      (* mark first ident *)
      MarkApplsOfIdent(
        graph.getChildSymbol(simpleField, 1, Symbol.Kind.Identifier));

      (* mark further idents *)
      identList :=
        graph.getChildSymbol(simpleField, 2, Symbol.Kind.SyntaxDIdentList);
      WHILE (identList.getNoOfChildren() > 0) DO
        MarkApplsOfIdent(
          graph.getChildSymbol(identList, 2, Symbol.Kind.Identifier));
        identList :=
          graph.getChildSymbol(identList, 3, Symbol.Kind.SyntaxDIdentList);
      END;
    END MarkApplsOfVariant;


  (** --- CheckSemicolon -------------------------------------------------------
    * Checks and inserts if a semicolon occurs behind an identifier and before
    * a given token.
    * --------------------------------------------------------------------------
    **)
  PROCEDURE CheckSemicolon (token: Token.T) =
    <* FATAL BaseGraph.NodeNotInGraph, BaseGraph.NodeInGraph,
       TokenGraph.NoAnchor, TokenGraph.NotInStream *>

    CONST
      CheckSet = Symbol.KindSet{Symbol.Kind.Identifier,
                                Symbol.Kind.Semicolon, Symbol.Kind.Record};

    BEGIN
      REPEAT
        token := graph.getPrevToken(token, Token.Language.M3);
      UNTIL (token.getKind() IN CheckSet);

      IF (token.getKind() = Symbol.Kind.Identifier) THEN
        WITH semicolon = NEW(Token.T).init(
                           Symbol.Kind.Semicolon, ";",
                           Token.LanguageSet{Token.Language.M3}) DO
          graph.appendToken(unit, semicolon, token);
        END;
      END;
    END CheckSemicolon;


  PROCEDURE FlatFieldOptSeq (fieldOptSeq: Syntax.T; inCase: BOOLEAN) =
    <* FATAL BaseGraph.NodeNotInGraph *>

    VAR
      i                : SyntaxSupport.SyntaxTreeIterator;
      symbol, semicolon: Symbol.T;

    PROCEDURE FlatField (field: Syntax.T; inCase: BOOLEAN) =
      <* FATAL BaseGraph.NodeNotInGraph *>

      VAR
        variantOptList: Syntax.T;
        elseFieldOpt  : Syntax.T;
        current       : Token.T;

      PROCEDURE FlatVariant (variantOpt: Syntax.T) =
        VAR current: Token.T;

        BEGIN
          IF (variantOpt.getNoOfChildren() = 0) THEN RETURN; END;
          IF (inWork) THEN
            GeneratorSupport.RemoveM3(
              graph, graph.getChildSymbol(
                       variantOpt, 1, Symbol.Kind.SyntaxCaseLabelSeq));
            GeneratorSupport.RemoveM3(graph,
                                      graph.getChildSymbol(
                                        variantOpt, 2, Symbol.Kind.Colon));
            (* remove qualification with type name if already present *)
            current := SyntaxSupport.FindLeftmostToken(graph, variantOpt);
            current := graph.getPrevToken(current, Token.Language.M3);
            IF ((current # NIL) AND (graph.getParentSyntax(current) = NIL)
                  AND (current.getKind() = Symbol.Kind.Period)) THEN
              current.removeLanguage(Token.Language.M3);
              current := graph.getPrevToken(current, Token.Language.M3);
              <* ASSERT (current.getKind() = Symbol.Kind.Identifier) *>
              current.removeLanguage(Token.Language.M3);
            END;
          END;
          FlatFieldOptSeq(
            graph.getChildSymbol(
              variantOpt, 3, Symbol.Kind.SyntaxFieldOptSeq), inCase);
        END FlatVariant;

      (* FlatField *)
      BEGIN
        (* test if selector field is empty *)
        IF (NARROW(
              graph.getChildSymbol(field, 2, Symbol.Kind.SyntaxDIdentOpt),
              Syntax.T).getNoOfChildren() = 0) THEN

          IF (inWork) THEN
            (* empty selector -> remove ': type' *)
            current := graph.getChildSymbol(field, 3, Symbol.Kind.Colon);
            REPEAT
              current.removeLanguage(Token.Language.M3);
              current := graph.getNextToken(current, Token.Language.M3);
            UNTIL (current.getKind() = Symbol.Kind.Of);
          END;
        ELSE
          (* full selector -> marks appls *)
          MarkApplsOfIdent(
            graph.getChildSymbol(
              graph.getChildSymbol(field, 2, Symbol.Kind.SyntaxDIdentOpt),
              1, Symbol.Kind.Identifier));
          IF (inWork) THEN
            CheckSemicolon(graph.getChildSymbol(field, 5, Symbol.Kind.Of));
          END;
        END;

        IF (inWork) THEN
          (* remove case field *)
          GeneratorSupport.RemoveM3(
            graph, graph.getChildSymbol(field, 1, Symbol.Kind.Case));
          GeneratorSupport.RemoveM3(
            graph, graph.getChildSymbol(field, 5, Symbol.Kind.Of));
          GeneratorSupport.RemoveM3(
            graph, graph.getChildSymbol(field, 9, Symbol.Kind.End));
        END;

        (* flat first variant *)
        FlatVariant(
          graph.getChildSymbol(field, 6, Symbol.Kind.SyntaxVariantOpt));

        (* flat other variants *)
        variantOptList :=
          graph.getChildSymbol(field, 7, Symbol.Kind.SyntaxVariantOptList);
        WHILE (variantOptList.getNoOfChildren() # 0) DO
          IF (inWork) THEN
            WITH token = graph.getChildSymbol(
                           variantOptList, 1, Symbol.Kind.Bar) DO
              CheckSemicolon(token);
              GeneratorSupport.RemoveM3(graph, token);
            END;
          END;
          FlatVariant(graph.getChildSymbol(
                        variantOptList, 2, Symbol.Kind.SyntaxVariantOpt));
          variantOptList :=
            graph.getChildSymbol(
              variantOptList, 3, Symbol.Kind.SyntaxVariantOptList);
        END;

        (* flat else variant *)
        elseFieldOpt :=
          graph.getChildSymbol(field, 8, Symbol.Kind.SyntaxElseFieldOpt);
        IF (elseFieldOpt.getNoOfChildren() > 0) THEN
          IF (inWork) THEN
            WITH else = graph.getChildSymbol(
                          elseFieldOpt, 1, Symbol.Kind.Else) DO
              GeneratorSupport.RemoveM3(graph, else);
              CheckSemicolon(else);
            END;
          END;
          FlatFieldOptSeq(
            graph.getChildSymbol(
              elseFieldOpt, 2, Symbol.Kind.SyntaxFieldOptSeq), inCase);
          IF (inWork) THEN
            CheckSemicolon(graph.getChildSymbol(field, 9, Symbol.Kind.End));
          END;
        END;
      END FlatField;

    (* FlatFieldOptSeq *)
    BEGIN
      i := NEW(SyntaxSupport.SyntaxTreeIterator).init(graph, fieldOptSeq);

      symbol := i.next();
      WHILE (symbol # NIL) DO
        (* search variant parts to flat *)
        IF (symbol.getKind() = Symbol.Kind.SyntaxCaseField) THEN
          FlatField(symbol, inCase := TRUE);
          IF (inWork) THEN
            (* remove superfluous semicolon behind variant *)
            semicolon := graph.getChildSymbol(symbol, 9, Symbol.Kind.End);
            REPEAT
              semicolon :=
                graph.getNextToken(semicolon, Token.Language.M2);
            UNTIL
              (semicolon.getKind()
                 IN Symbol.KindSet{Symbol.Kind.Semicolon, Symbol.Kind.End});
            IF (semicolon.getKind() = Symbol.Kind.Semicolon) THEN
              GeneratorSupport.RemoveM3(graph, semicolon);
            END;
          END;

          (* go ahead *)
          symbol := i.skip();

          (* search embedded simple field and mark appls *)
        ELSIF (symbol.getKind() = Symbol.Kind.SyntaxSimpleField) THEN
          IF (inCase) THEN
            (* variant alternatives -> insert warnings behind applyings *)
            MarkApplsOfVariant(symbol);
          END;
          symbol := i.skip();

          (* search nothing, skip all *)
        ELSE
          symbol := i.next();
        END
      END
    END FlatFieldOptSeq;

  (* FlatRecord *)
  BEGIN
    FlatFieldOptSeq(recordType, inCase := FALSE);
  END FlatRecord;

BEGIN
END VariantGen.
