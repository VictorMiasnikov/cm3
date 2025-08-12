MODULE EnumerationGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:05:02
    EnumerationGen.m3,v
# Revision 1.1  1994/11/30  15:05:02  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- EnumerationGen ---------------------------------------------------------
  * The main procedure of this module searchs for enumeration element identifier
  * declarations and qualifies the related applying identifiers with the
  * enumeration type name.
  *
  * Within the type declaration the surrounding parentheses are also replaced
  * by Bracets.
  *
  * to do:
  *   anonymous enumeration types are not handled yet,
  *   missing check if the enumeration type name must be imported,
  *   missing handling of possible hidden enumeration type names
  * ----------------------------------------------------------------------------
  **)

(* subsystem SourceGraph *)
IMPORT BaseGraph;
IMPORT Symbol;
IMPORT Token, TokenGraph;
IMPORT Syntax, SyntaxSupport;
IMPORT DeclGraph;
IMPORT SourceGraph;

(* subsystem Utilities *)
IMPORT Message;


(** --- ChangeParentheses ------------------------------------------------------
  * Replace the parentheses '(' ')'  of the enumeration declaration by
  * bracets  '{' '}'.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE ChangeParentheses (graph: SourceGraph.T;
                             unit : SourceGraph.Anchor;
                             enum : Syntax.T            ) =
  <* FATAL TokenGraph.NoAnchor,  TokenGraph.NotInStream, BaseGraph.NodeInGraph,
     BaseGraph.NodeNotInGraph *>

  VAR child, bracet: Token.T;

  BEGIN
    bracet := NEW(Token.T).init(Symbol.Kind.CLBracket, "{");
    bracet.setLanguage(Token.Language.M3);
    child := graph.getChildSymbol(enum, 1, Symbol.Kind.LBracket);
    child.removeLanguage(Token.Language.M3);
    graph.appendToken(unit, bracet, child);

    bracet := NEW(Token.T).init(Symbol.Kind.CRBracket, "}");
    bracet.setLanguage(Token.Language.M3);
    child := graph.getChildSymbol(enum, 3, Symbol.Kind.RBracket);
    child.removeLanguage(Token.Language.M3);
    graph.appendToken(unit, bracet, child);
  END ChangeParentheses;


(** --- QualifyEnumeration -----------------------------------------------------
  * Search all declaring enumeration element identifiers and qualify their
  * applyings by calling QualifyEnumerationElement.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE QualifyEnumeration (graph: SourceGraph.T; enumType: Syntax.T) =
  <* FATAL BaseGraph.NodeNotInGraph *>

  VAR
    declEnumElement : Token.T;
    declList        : Syntax.T;
    enumTypeName    : Token.T;
    enumTypeNameText: TEXT;

  BEGIN
    enumTypeName := FindEnumerationTypeName(graph, enumType);
    IF (enumTypeName = NIL) THEN
      WITH t = SyntaxSupport.FindLeftmostToken(graph, enumType) DO
        Message.Write(
          graph := graph, token := t, code := Message.Code.AnonymousType)
      END;
      RETURN;
    END;

    enumTypeNameText := enumTypeName.getText();

    WITH enumScope = graph.getChildSymbol(
                       enumType, 2, Symbol.Kind.SyntaxEnumerationScope) DO
      (* qualify first enumeration element *)
      declEnumElement :=
        graph.getChildSymbol(enumScope, 1, Symbol.Kind.Identifier);
      QualifyEnumerationElement(graph, declEnumElement, enumTypeNameText);

      (* qualify other enumeration elements *)
      declList :=
        graph.getChildSymbol(enumScope, 2, Symbol.Kind.SyntaxDIdentList);
      WHILE (0 < NARROW(declList, Syntax.T).getNoOfChildren()) DO
        declEnumElement :=
          graph.getChildSymbol(declList, 2, Symbol.Kind.Identifier);
        QualifyEnumerationElement(graph, declEnumElement, enumTypeNameText);

        declList :=
          graph.getChildSymbol(declList, 3, Symbol.Kind.SyntaxDIdentList);
      END;
    END;
  END QualifyEnumeration;


(** --- FindEnumerationTypeName ------------------------------------------------
  * Search the token with the declaring identifier of the enumeration type.
  *
  * Because of the possibility of anonymous type declarations in Modula-2 the
  * procedure may return NIL.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE FindEnumerationTypeName (graph: SourceGraph.T; enum: Syntax.T):
  Token.T =
  <* FATAL BaseGraph.NodeNotInGraph *>

  VAR simpleParent, typeParent: Syntax.T;

  BEGIN
    simpleParent :=
      graph.getParentSyntax(
        graph.getParentSyntax(enum, Symbol.Kind.SyntaxSimpleType));

    CASE simpleParent.getKind() OF
    | Symbol.Kind.SyntaxReturnSignatureOpt =>
        (* anonymous enumeration type detected *)
        RETURN NIL;

    | Symbol.Kind.SyntaxType =>
        typeParent := graph.getParentSyntax(simpleParent);

        CASE typeParent.getKind() OF
        | Symbol.Kind.SyntaxVarList, Symbol.Kind.SyntaxPointerType,
            Symbol.Kind.SyntaxSetType, Symbol.Kind.SyntaxArrayType,
            Symbol.Kind.SyntaxSimpleField =>
            (* anonymous enumeration type detected *)
            RETURN NIL;

        | Symbol.Kind.SyntaxTypeOpt =>
            RETURN graph.getChildSymbol(
                     graph.getParentSyntax(
                       typeParent, Symbol.Kind.SyntaxTypeOptList), 1,
                     Symbol.Kind.Identifier);

        | Symbol.Kind.SyntaxTypeDeclarationList =>
            RETURN
              graph.getChildSymbol(typeParent, 1, Symbol.Kind.Identifier);
        ELSE
          (* unknown parent of enumeration type *)
          <* ASSERT FALSE *>
        END;
    ELSE
      (* unknown parent of enumeration type *)
      <* ASSERT FALSE *>
    END;
  END FindEnumerationTypeName;


(** --- QualifyEnumerationElement ----------------------------------------------
  * Iterate all applying identifiers of the given declaring identifier and
  * prepend the qualification tokens.
  *
  * See to-do list for missing operations.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE QualifyEnumerationElement (graph           : SourceGraph.T;
                                     declEnumElement : Token.T;
                                     enumTypeNameText: TEXT           ) =
  <* FATAL BaseGraph.NodeNotInGraph, BaseGraph.NodeInGraph,
           TokenGraph.NoAnchor, TokenGraph.NotInStream *>

  VAR
    i                            : DeclGraph.ApplsOfDeclIterator;
    applEnumElement, qual, period: Token.T;
    anchor                       : SourceGraph.Anchor;

  BEGIN
    i := graph.iterateApplsOfDecl(declEnumElement);
    applEnumElement := i.next();
    WHILE (applEnumElement # NIL) DO
      IF (Token.Language.M3 IN applEnumElement.getLanguages()) THEN
        anchor := graph.findAnchor(applEnumElement);

        IF (anchor.isWork()) THEN
          qual :=
            NEW(Token.T).init(Symbol.Kind.Identifier, enumTypeNameText);
          graph.prependToken(anchor, qual, applEnumElement);

          period := NEW(Token.T).init(Symbol.Kind.Period, ".");
          graph.prependToken(anchor, period, applEnumElement);
        END;
      END;

      applEnumElement := i.next();
    END;
  END QualifyEnumerationElement;

BEGIN
END EnumerationGen.
