MODULE OpaqueGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Kai Michael Degner                                        *)

(** pk
    1.1
    1994/11/30 15:05:35
    OpaqueGen.m3,v
# Revision 1.1  1994/11/30  15:05:35  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT BaseGraph, SourceGraph;
IMPORT Syntax, Symbol, Token;
IMPORT DeclGraph, TokenGraph;
IMPORT IdentifierLinker;
IMPORT GeneratorSupport;
IMPORT Text;
IMPORT Message;


(** --- IsOpaqueType ------------------------------------------------------
  * Checks whether the given type refers to an opaque type declaration or
  * not.
  * -----------------------------------------------------------------------
  **)
PROCEDURE IsOpaqueType (type: Syntax.T): BOOLEAN =
  BEGIN
    <* ASSERT type.getKind () = Symbol.Kind.SyntaxTypeOpt *>
    RETURN (type.getNoOfChildren() = 0);
  END IsOpaqueType;


(** --- HandleOpaqueType ------------------------------------------------------
  * See interface for information on procedure.
  * ---------------------------------------------------------------------------
  **)
PROCEDURE HandleOpaqueType (graph  : SourceGraph.T;
                            anchor : SourceGraph.Anchor;
                            typeOpt: Syntax.T            ) =
  <* FATAL BaseGraph.NodeNotInGraph *>

  VAR
    typeDef       : Syntax.T;
    typeOfTypeDef : Syntax.T;
    implementation: SourceGraph.Anchor;

  BEGIN
    <* ASSERT typeOpt.getKind () = Symbol.Kind.SyntaxTypeOpt *>

    IF (anchor = NIL) THEN RETURN; END;

    implementation :=
      graph.getUnit(anchor.getName(), isDefinition := FALSE);

    IF (NOT anchor.isWork()) THEN
      IF (implementation = NIL) THEN RETURN; END;
    END;

    typeDef := GetDefOfOpaque(graph, anchor, typeOpt);

    IF (typeDef = NIL) THEN
      MakeSubType(graph, anchor, typeOpt);
      RETURN;
    END;

    typeOfTypeDef := graph.getChildSymbol(typeDef, 1);
    IF (typeOfTypeDef.getKind() = Symbol.Kind.SyntaxPointerType) THEN
      MakeSubType(graph, anchor, typeOpt);
      RevealDef(graph, implementation, typeDef);
    ELSE
      MakePublic(graph, anchor, typeOpt, implementation, typeDef);
    END;
    RETURN;
  END HandleOpaqueType;


(** --- GetDefOfOpaque ------------------------------------------------------
  * Searches the type definition of an opaque type in the corresponding
  * implementation module. Returns NIL if implementation module doesn't
  * exist or opaque type is not defined. Otherwise it returns the syntax tree
  * node of the definition with kind Symbol.Kind.SyntaxType.
  * -------------------------------------------------------------------------
  **)
PROCEDURE GetDefOfOpaque (graph  : SourceGraph.T;
                          def    : SourceGraph.Anchor;
                          typeOpt: Syntax.T            ): Syntax.T =
  <* FATAL BaseGraph.NodeNotInGraph *>

  VAR
    nameOfOpaque  : TEXT;
    implementation: SourceGraph.Anchor;
    iterator      : DeclGraph.DeclsOfScopeIterator;
    symbol        : Symbol.T;
    typeIdent     : Token.T;

  (** --- GetNameOfOpaque -----------------------------------------------------
    * Estimates the name of an opaque type.
    * -------------------------------------------------------------------------
    **)
  PROCEDURE GetNameOfOpaque (graph: SourceGraph.T; typeOpt: Syntax.T):
    TEXT =
    VAR ident: Symbol.T;

    BEGIN
      ident :=
        graph.getChildSymbol(
          graph.getParentSyntax(typeOpt, Symbol.Kind.SyntaxTypeOptList), 1,
          Symbol.Kind.Identifier);
      RETURN NARROW(ident, Token.T).getText();
    END GetNameOfOpaque;

  (* GetDefOfOpaque *)
  BEGIN
    implementation := graph.getUnit(def.getName(), isDefinition := FALSE);
    IF (implementation = NIL) THEN RETURN NIL; END;

    nameOfOpaque := GetNameOfOpaque(graph, typeOpt);
    symbol := graph.getChildSymbol(graph.getRoot(implementation), 1,
                                   Symbol.Kind.SyntaxProgramModule);
    symbol :=
      graph.getChildSymbol(symbol, 3, Symbol.Kind.SyntaxPrivateScope);
    symbol :=
      graph.getChildSymbol(symbol, 3, Symbol.Kind.SyntaxProgramScope);

    iterator := graph.iterateDeclsOfScope(symbol);

    typeIdent := iterator.next();
    WHILE (typeIdent # NIL) DO
      IF (Text.Equal(nameOfOpaque, typeIdent.getText())) THEN
        symbol :=
          graph.getParentSyntax(NARROW(typeIdent, Symbol.T),
                                Symbol.Kind.SyntaxTypeDeclarationList);
        RETURN NARROW(graph.getChildSymbol(
                        symbol, 3, Symbol.Kind.SyntaxType), Syntax.T);
      END;
      typeIdent := iterator.next();
    END;
    RETURN NIL;
  END GetDefOfOpaque;


(** --- MakeSubType ------------------------------------------------------------
  * Insert Modula-3 token '<:ADDRESS'
  * ----------------------------------------------------------------------------
  **)
PROCEDURE MakeSubType (graph  : SourceGraph.T;
                       def    : SourceGraph.Anchor;
                       typeOpt: Syntax.T            ) =
  <* FATAL BaseGraph.NodeNotInGraph,
           BaseGraph.NodeInGraph,
           TokenGraph.NoAnchor,
           TokenGraph.NotInStream *>

  VAR typeIdent: Token.T;

  BEGIN
    <* ASSERT typeOpt.getKind() = Symbol.Kind.SyntaxTypeOpt *>
    typeIdent := NARROW(graph.getChildSymbol(
                          graph.getParentSyntax(
                            typeOpt, Symbol.Kind.SyntaxTypeOptList), 1,
                          Symbol.Kind.Identifier), Token.T);
    WITH newToken = NEW(Token.T).init(Symbol.Kind.GenText, " <: ADDRESS",
                                      Token.LanguageSet{Token.Language.M3}) DO
      graph.appendToken(def, newToken, typeIdent);
    END;
  END MakeSubType;


(** --- RevealDef --------------------------------------------------------------
  * Inserts Modula-3 keyword 'REVEAL' before type definition.
  * Checks whether the keyword 'TYPE' must be inserted after the definition or
  * not. If type definition is the first definition in unit replaces keyword
  * 'TYPE' by "REVEAL' and inserts 'TYPE' after the declaration.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE RevealDef (graph  : SourceGraph.T;
                     imp    : SourceGraph.Anchor;
                     typeDef: Syntax.T            ) =
  <* FATAL BaseGraph.NodeNotInGraph,
           BaseGraph.NodeInGraph,
           TokenGraph.NoAnchor,
           TokenGraph.NotInStream *>

  VAR
    typeIdent: Token.T;
    symbol   : Symbol.T;

  (** --- HandleFirst ----------------------------------------------------------
    * If definition is first type definition in unit removes keyword 'TYPE'.
    * --------------------------------------------------------------------------
    **)
  PROCEDURE HandleFirst (graph: SourceGraph.T; typeDef: Syntax.T) =
    VAR token: Token.T;

    BEGIN
      token := graph.getChildSymbol(
                 graph.getParentSyntax(
                   graph.getParentSyntax(
                     typeDef, Symbol.Kind.SyntaxTypeDeclarationList)), 1);
      IF (token.getKind() = Symbol.Kind.Type) THEN
        token.removeLanguage(Token.Language.M3);
      END;
    END HandleFirst;

  (* RevealDef *)
  BEGIN
    <* ASSERT typeDef.getKind() = Symbol.Kind.SyntaxType *>

    typeIdent :=
      NARROW(graph.getChildSymbol(
               graph.getParentSyntax(
                 typeDef, Symbol.Kind.SyntaxTypeDeclarationList), 1,
               Symbol.Kind.Identifier), Token.T);

    HandleFirst(graph, typeDef);

    WITH newToken = NEW(Token.T).init(Symbol.Kind.GenText, "REVEAL\n",
                                      Token.LanguageSet{Token.Language.M3}) DO
      graph.prependToken(imp, newToken, typeIdent);
    END;

    symbol := graph.getChildSymbol(
                graph.getParentSyntax(
                  typeDef, Symbol.Kind.SyntaxTypeDeclarationList), 5,
                Symbol.Kind.SyntaxTypeDeclarationList);

    IF (NARROW(symbol, Syntax.T).getNoOfChildren() # 0) THEN
      symbol := graph.getChildSymbol(symbol, 1, Symbol.Kind.Identifier);
      WITH newToken = NEW(Token.T).init(
                        Symbol.Kind.GenText, "TYPE\n",
                        Token.LanguageSet{Token.Language.M3}) DO
        graph.prependToken(imp, newToken, NARROW(symbol, Token.T));
      END;
    END;
  END RevealDef;


(** --- MakePublic -------------------------------------------------------------
  * Makes an opaque type public. Type definition will be removed from
  * implementation unit.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE MakePublic (graph  : SourceGraph.T;
                      def    : SourceGraph.Anchor;
                      typeOpt: Syntax.T;
                      imp    : SourceGraph.Anchor;
                      typeDef: Syntax.T            ) =
  <* FATAL BaseGraph.NodeNotInGraph,
           BaseGraph.NodeInGraph,
           TokenGraph.NoAnchor,
           TokenGraph.NotInStream *>

  VAR
    typeQualIdent                         : Symbol.T;
    typeDeclIdent, typeDefIdent, semicolon: Token.T;
    typeName                              : TEXT;

  BEGIN
    <* ASSERT typeOpt.getKind() = Symbol.Kind.SyntaxTypeOpt *>
    <* ASSERT typeDef.getKind() = Symbol.Kind.SyntaxType *>

    typeQualIdent := IdentifierLinker.FindTypeName(graph, typeDef);
    IF (typeQualIdent = NIL) THEN TypeError(graph, typeOpt); RETURN; END;

    typeName := GeneratorSupport.GetTextOfType(graph, typeQualIdent);

    (* handle definition unit *)
    WITH newToken = NEW(Token.T).init(
                      Symbol.Kind.GenText, " = " & typeName,
                      Token.LanguageSet{Token.Language.M3}) DO
      typeDeclIdent := NARROW(graph.getChildSymbol(
                                graph.getParentSyntax(
                                  typeOpt, Symbol.Kind.SyntaxTypeOptList),
                                1, Symbol.Kind.Identifier), Token.T);
      graph.appendToken(def, newToken, typeDeclIdent);
    END;

    (* handle implementation unit *)
    typeDefIdent :=
      NARROW(graph.getChildSymbol(
               graph.getParentSyntax(
                 typeDef, Symbol.Kind.SyntaxTypeDeclarationList), 1,
               Symbol.Kind.Identifier), Token.T);
    WITH newToken = NEW(Token.T).init(Symbol.Kind.GenText, "\n(** ",
                                      Token.LanguageSet{Token.Language.M3}) DO
      graph.prependToken(imp, newToken, typeDefIdent);
    END;

    WITH newToken = NEW(Token.T).init(Symbol.Kind.GenText, " **)",
                                      Token.LanguageSet{Token.Language.M3}) DO
      semicolon :=
        NARROW(graph.getChildSymbol(
                 graph.getParentSyntax(
                   typeDef, Symbol.Kind.SyntaxTypeDeclarationList), 4,
                 Symbol.Kind.Semicolon), Token.T);

      graph.appendToken(imp, newToken, semicolon);
      Message.Write(graph := graph, token := typeDeclIdent,
                    code := Message.Code.UnregularOpaqueType);
    END;
  END MakePublic;


(** --- TypeError --------------------------------------------------------------
  * Put out a type error warning.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE TypeError (graph: SourceGraph.T; typeOpt: Syntax.T) =
  <* FATAL BaseGraph.NodeNotInGraph *>

  VAR typeIdent: Token.T;

  BEGIN
    <* ASSERT typeOpt.getKind() = Symbol.Kind.SyntaxTypeOpt *>
    typeIdent := NARROW(graph.getChildSymbol(
                          graph.getParentSyntax(
                            typeOpt, Symbol.Kind.SyntaxTypeOptList), 1,
                          Symbol.Kind.Identifier), Token.T);
    Message.Write(graph := graph, token := typeIdent,
                  code := Message.Code.TypeErrorOpaqueTypeExpected);
  END TypeError;

BEGIN
END OpaqueGen.
