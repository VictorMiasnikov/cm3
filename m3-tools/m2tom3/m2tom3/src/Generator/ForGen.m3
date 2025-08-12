MODULE ForGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Thomas Stockheim                                          *)

(** pk
    1.1
    1994/11/30 15:05:12
    ForGen.m3,v
# Revision 1.1  1994/11/30  15:05:12  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(* subsystem SourceGraph *)
IMPORT BaseGraph;
IMPORT Symbol;
IMPORT TokenSupport, Token, TokenGraph;
IMPORT Syntax;
IMPORT SourceGraph;

(* subsystem Analyzer *)
IMPORT IdentifierLinker;

(* subsystem Utilities *)
IMPORT Message;

(* subsystem Generator *)
IMPORT GeneratorSupport;


CONST M3only = Token.LanguageSet{Token.Language.M3};


PROCEDURE ChangeToWhile (graph : SourceGraph.T;
                         anchor: SourceGraph.Anchor;
                         token : Token.T             ) =
  <* FATAL BaseGraph.NodeNotInGraph, BaseGraph.NodeInGraph,
  TokenGraph.NoAnchor, TokenGraph.NotInStream *>

  VAR
    parent, type        : Syntax.T;
    tmp, endToken, ident: Token.T;
    typeSymbol          : Symbol.T;
    withBY              : BOOLEAN  := TRUE;
    typeName            : TEXT     := "UnkownType";

  BEGIN
    parent := graph.getParentSyntax(token);
    IF (parent # NIL) THEN
      IF (parent.getKind() = Symbol.Kind.SyntaxForIdentOpt) THEN
        (* This isn't a loop *)
        RETURN;
      END;
      endToken := graph.getChildSymbol(parent, parent.getNoOfChildren());
      token.removeLanguage(Token.Language.M3); (* Remove FOR *)
      graph.prependToken(
        anchor, NEW(Token.T).init(Symbol.Kind.Var, "VAR", M3only), token);
      token := TokenSupport.SkipWhiteSpaceAndComment(graph, token);

      ident := token;
      type := IdentifierLinker.FindTypeOfAppl(graph, token);
      IF (type # NIL) THEN
        typeSymbol := IdentifierLinker.FindTypeName(graph, type);
        IF (typeSymbol # NIL) THEN
          typeName := GeneratorSupport.GetTextOfType(graph, typeSymbol);
        ELSE
          typeName := "NoType";
        END;
      ELSE
        Message.Write(graph := graph, token := token,
                      code := Message.Code.AnonymousType);
      END;
      token.removeLanguage(Token.Language.M3); (* Remove FOR *)
      graph.appendToken(anchor, NEW(Token.T).init(Symbol.Kind.Identifier,
                                                  "m2tom3_index", M3only),
                        token);
      token :=
        TokenSupport.FindSymbolOfKind(graph, token, Symbol.Kind.Assign);
      graph.appendToken(
        anchor, NEW(Token.T).init(Symbol.Kind.GenText, "ORD(", M3only),
        token);

      token := TokenSupport.FindSymbolOfKind(graph, token, Symbol.Kind.To);
      token.removeLanguage(Token.Language.M3); (* Remove TO *)
      graph.prependToken(anchor, NEW(Token.T).init(
                                   Symbol.Kind.RBracket, ")", M3only),
                         token);
      graph.prependToken(
        anchor, NEW(Token.T).init(Symbol.Kind.Semicolon, ";", M3only),
        token);
      graph.appendToken(
        anchor, NEW(Token.T).init(Symbol.Kind.GenText, ":=ORD(", M3only),
        token);
      graph.appendToken(anchor, NEW(Token.T).init(Symbol.Kind.Identifier,
                                                  "m2tom3_end", M3only),
                        token);
      REPEAT
        token := graph.getNextToken(token, Token.Language.M3);
      UNTIL
        (token.getKind() IN Symbol.KindSet{Symbol.Kind.Do, Symbol.Kind.By});
      IF (token.getKind() = Symbol.Kind.Do) THEN
        withBY := FALSE;
        graph.prependToken(
          anchor,
          NEW(Token.T).init(Symbol.Kind.Begin, ");\nBEGIN\n ", M3only),
          token);
        graph.prependToken(
          anchor,
          NEW(Token.T).init(Symbol.Kind.GenText,
                            " WHILE m2tom3_index <= m2tom3_end ", M3only),
          token);
        graph.appendToken(
          anchor,
          NEW(Token.T).init(Symbol.Kind.GenText,
                            "\n " & ident.getText() & ":=VAL(m2tom3_index,"
                              & typeName & ");", M3only), token);
      ELSE
        graph.prependToken(
          anchor, NEW(Token.T).init(Symbol.Kind.GenText, ");", M3only),
          token);
        token.removeLanguage(Token.Language.M3); (* Remove BY *)
        graph.prependToken(anchor, NEW(Token.T).init(
                                     Symbol.Kind.Identifier, "m2tom3_step",
                                     M3only), token);
        graph.prependToken(
          anchor, NEW(Token.T).init(Symbol.Kind.GenText, ":=ORD(", M3only),
          token);
        token :=
          TokenSupport.FindSymbolOfKind(graph, token, Symbol.Kind.Do);
        graph.prependToken(
          anchor,
          NEW(Token.T).init(Symbol.Kind.GenText, ");\nBEGIN\n", M3only),
          token);
        graph.prependToken(
          anchor,
          NEW(Token.T).init(
            Symbol.Kind.Comment,
            "WHILE (m2tom3_index <= m2tom3_end AND m2tom3_step >= 0) "
              & "OR (m2tom3_index >= m2tom3_end AND m2tom3_step <= 0) ",
            M3only), token);
        graph.appendToken(
          anchor,
          NEW(Token.T).init(Symbol.Kind.GenText,
                            "\n " & ident.getText() & ":=VAL(m2tom3_index,"
                              & typeName & ");", M3only), token);
      END;
      tmp := endToken;
      REPEAT
        tmp := graph.getPrevToken(tmp, Token.Language.M2);
      UNTIL (NOT (tmp.getKind() IN Symbol.KindSet{Symbol.Kind.WhiteSpace,
                                                  Symbol.Kind.Comment}));
      IF (NOT (tmp.getKind()
                 IN Symbol.KindSet{Symbol.Kind.Semicolon, Symbol.Kind.Do})) THEN
        graph.prependToken(
          anchor, NEW(Token.T).init(Symbol.Kind.Semicolon, ";", M3only),
          endToken);
      END;
      IF (withBY) THEN
        graph.prependToken(
          anchor, NEW(Token.T).init(
                    Symbol.Kind.GenText,
                    "m2tom3_index:=ORD(" & ident.getText()
                      & ");\nINC(m2tom3_index,m2tom3_step);\n", M3only),
          endToken);
      ELSE
        graph.prependToken(
          anchor,
          NEW(Token.T).init(
            Symbol.Kind.GenText, "m2tom3_index:=ORD(" & ident.getText()
                                   & ");\nINC(m2tom3_index);\n", M3only),
          endToken);
      END;
      graph.appendToken(
        anchor, NEW(Token.T).init(Symbol.Kind.GenText, ";\nEND", M3only),
        endToken);
    END;
  END ChangeToWhile;

BEGIN
END ForGen.
