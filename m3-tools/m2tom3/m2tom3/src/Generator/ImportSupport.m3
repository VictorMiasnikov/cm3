MODULE ImportSupport;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Roland Baumann                                            *)

(** pk
    1.1
    1994/11/30 15:05:29
    ImportSupport.m3,v
# Revision 1.1  1994/11/30  15:05:29  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT SourceGraph, Text, Token, Symbol, TokenSupport, BaseGraph,
       TokenGraph;


<* FATAL BaseGraph.NodeInGraph, BaseGraph.NodeNotInGraph,
         TokenGraph.NoAnchor, TokenGraph.NotInStream *>


PROCEDURE FindFirstQualifiedImport (graph : SourceGraph.T;
                                    anchor: SourceGraph.Anchor): Token.T =
  VAR
    to   : Token.T;
    found: BOOLEAN := FALSE;

  BEGIN
    to := graph.getFirstToken(anchor, Token.Language.M3);
    WHILE ((NOT found) AND (to # NIL)
             AND (to.getKind() # Symbol.Kind.Begin)) DO
      IF (to.getKind() = Symbol.Kind.From) THEN
        (* Found an unqualified import -> skip it *)
        to :=
          TokenSupport.FindSymbolOfKind(graph, to, Symbol.Kind.Semicolon);
      ELSIF (to.getKind() = Symbol.Kind.Import) THEN
        (* This should be a qualified import.  Find first imported
           Module. *)
        to := TokenSupport.SkipWhiteSpaceAndComment(graph, to);
        found := TRUE;
      ELSE
        to := graph.getNextToken(to, Token.Language.M3);
      END;
    END;
    IF (found) THEN RETURN to; ELSE RETURN NIL; END;
  END FindFirstQualifiedImport;


PROCEDURE FindFirstUnqualifiedImport (graph : SourceGraph.T;
                                      anchor: SourceGraph.Anchor):
  Token.T =
  VAR
    to   : Token.T;
    found: BOOLEAN := FALSE;

  BEGIN
    to := graph.getFirstToken(anchor, Token.Language.M3);
    WHILE ((NOT found) AND (to # NIL)
             AND (to.getKind() # Symbol.Kind.Begin)) DO
      IF (to.getKind() = Symbol.Kind.Import) THEN
        (* Found a qualified import -> skip it *)
        to :=
          TokenSupport.FindSymbolOfKind(graph, to, Symbol.Kind.Semicolon);
      ELSIF (to.getKind() = Symbol.Kind.From) THEN
        (* This should be an unqualified import.  Find the module. *)
        to := TokenSupport.SkipWhiteSpaceAndComment(graph, to);
        found := TRUE;
      ELSE
        to := graph.getNextToken(to, Token.Language.M3);
      END;
    END;
    IF (found) THEN RETURN to; ELSE RETURN NIL; END;
  END FindFirstUnqualifiedImport;


PROCEDURE FindNextQualifiedImport (graph: SourceGraph.T; from: Token.T):
  Token.T =
  VAR
    to   : Token.T;
    found: BOOLEAN := FALSE;

  BEGIN
    (* Make sure we are not in an import list already found by earlier
       calls to FindXXXQualifiedImport *)
    to :=
      TokenSupport.FindSymbolOfKind(graph, from, Symbol.Kind.Semicolon);
    WHILE ((NOT found) AND (to # NIL)
             AND (to.getKind() # Symbol.Kind.Begin)) DO
      IF (to.getKind() = Symbol.Kind.From) THEN
        (* Found an unqualified import -> skip it *)
        to :=
          TokenSupport.FindSymbolOfKind(graph, to, Symbol.Kind.Semicolon);
      ELSIF (to.getKind() = Symbol.Kind.Import) THEN
        (* This should be a qualified import.  Find first imported
           Module. *)
        to := TokenSupport.SkipWhiteSpaceAndComment(graph, to);
        found := TRUE;
      ELSE
        to := graph.getNextToken(to, Token.Language.M3);
      END;
    END;
    IF (found) THEN RETURN to; ELSE RETURN NIL; END;
  END FindNextQualifiedImport;


PROCEDURE FindNextUnqualifiedImport (graph: SourceGraph.T; from: Token.T):
  Token.T =
  VAR
    to   : Token.T;
    found: BOOLEAN := FALSE;

  BEGIN
    (* Make sure we are not in an import list already found by earlier
       calls to FindXXXQualifiedImport *)
    to :=
      TokenSupport.FindSymbolOfKind(graph, from, Symbol.Kind.Semicolon);
    WHILE ((NOT found) AND (to # NIL)
             AND (to.getKind() # Symbol.Kind.Begin)) DO
      IF (to.getKind() = Symbol.Kind.Import) THEN
        (* Found a qualified import -> skip it *)
        to :=
          TokenSupport.FindSymbolOfKind(graph, to, Symbol.Kind.Semicolon);
      ELSIF (to.getKind() = Symbol.Kind.From) THEN
        (* This should be an unqualified import.  Find the module. *)
        to := TokenSupport.SkipWhiteSpaceAndComment(graph, to);
        found := TRUE;
      ELSE
        to := graph.getNextToken(to, Token.Language.M3);
      END;
    END;
    IF (found) THEN RETURN to; ELSE RETURN NIL; END;
  END FindNextUnqualifiedImport;


PROCEDURE FindIdentifier (graph: SourceGraph.T; from: Token.T; name: TEXT):
  Token.T =
  VAR
    to   : Token.T;
    found: BOOLEAN := FALSE;

  BEGIN
    to := from;
    WHILE ((to # NIL) AND (to.getKind() # Symbol.Kind.Semicolon)
             AND (NOT found)) DO
      IF ((to.getKind() = Symbol.Kind.Identifier)
            AND Text.Equal(name, to.getText())) THEN
        found := TRUE;
      ELSE
        to := graph.getNextToken(to, Token.Language.M3);
      END;
    END;
    IF (found) THEN RETURN to; ELSE RETURN NIL; END;
  END FindIdentifier;


PROCEDURE FindQualifiedImport (graph : SourceGraph.T;
                               anchor: SourceGraph.Anchor;
                               mod   : TEXT                ): Token.T =
  VAR mo, to: Token.T := NIL;

  BEGIN
    to := FindFirstQualifiedImport(graph, anchor);
    mo := NIL;
    WHILE ((mo = NIL) AND (to # NIL)) DO
      mo := FindIdentifier(graph, to, mod);
      to := FindNextQualifiedImport(graph, to);
    END;
    RETURN mo;
  END FindQualifiedImport;


PROCEDURE FindUnqualifiedImport (graph    : SourceGraph.T;
                                 anchor   : SourceGraph.Anchor;
                                 mod, item: TEXT                ):
  Token.T =
  VAR it, to: Token.T := NIL;

  BEGIN
    to := FindFirstUnqualifiedImport(graph, anchor);
    it := NIL;
    WHILE ((it = NIL) AND (to # NIL)) DO
      IF (Text.Equal(to.getText(), mod)) THEN
        it := FindIdentifier(graph, to, item);
      END;
      to := FindNextUnqualifiedImport(graph, to);
    END;
    RETURN it;
  END FindUnqualifiedImport;


PROCEDURE FindFirstPlaceToInsertImport (graph : SourceGraph.T;
                                        anchor: SourceGraph.Anchor):
  Token.T =
  VAR to: Token.T := NIL;

  BEGIN
    to := graph.getFirstToken(anchor, Token.Language.M3);
    to := TokenSupport.FindSymbolOfKind(graph, to, Symbol.Kind.Semicolon);
    RETURN TokenSupport.SkipWhiteSpaceAndComment(graph, to);
  END FindFirstPlaceToInsertImport;


PROCEDURE RemoveCommas (graph: SourceGraph.T; to: Token.T) =
  VAR t: Token.T;

  BEGIN
    (* trailing comma *)
    t := to;
    WHILE ((t # NIL) AND (t.getKind() # Symbol.Kind.Comma)
             AND (t.getKind() # Symbol.Kind.Semicolon)) DO
      t := graph.getNextToken(t, Token.Language.M3);
    END;
    IF (t.getKind() = Symbol.Kind.Comma) THEN
      t.removeLanguage(Token.Language.M3);
    ELSE
      (* leading comma *)
      t := to;
      WHILE ((t # NIL) AND (t.getKind() # Symbol.Kind.Comma)
               AND (t.getKind() # Symbol.Kind.Import)) DO
        t := graph.getPrevToken(t, Token.Language.M3);
      END;
      IF (t.getKind() = Symbol.Kind.Comma) THEN
        t.removeLanguage(Token.Language.M3);
      END;
    END;
  END RemoveCommas;


PROCEDURE RemoveGarbageImports (graph: SourceGraph.T; to: Token.T) =
  VAR
    t, h    : Token.T;
    notEmpty: BOOLEAN;

  BEGIN
    t := graph.getNextToken(to, Token.Language.M3);
    notEmpty := FALSE;
    WHILE ((NOT notEmpty) AND (t # NIL)
             AND (t.getKind() # Symbol.Kind.Semicolon)) DO
      IF ((t.getKind() = Symbol.Kind.Comma)
            OR (t.getKind() = Symbol.Kind.Identifier)) THEN
        notEmpty := TRUE;
      END;
      t := graph.getNextToken(t, Token.Language.M3);
    END;
    IF (NOT notEmpty) THEN
      t := graph.getPrevToken(to, Token.Language.M3);
      WHILE ((NOT notEmpty) AND (t # NIL)
               AND (t.getKind() # Symbol.Kind.Import)) DO
        IF ((t.getKind() = Symbol.Kind.Comma)
              OR (t.getKind() = Symbol.Kind.Identifier)) THEN
          notEmpty := TRUE;
        END;
        t := graph.getPrevToken(t, Token.Language.M3);
      END;
      IF (NOT notEmpty) THEN
        h := graph.getPrevToken(t, Token.Language.M3);
        WHILE ((h # NIL) AND (h.getKind() # Symbol.Kind.Semicolon)
                 AND (h.getKind() # Symbol.Kind.From)) DO
          h := graph.getPrevToken(h, Token.Language.M3);
        END;
        IF (h.getKind() = Symbol.Kind.From) THEN t := h; END;
        REPEAT
          t.removeLanguage(Token.Language.M3);
          t := graph.getNextToken(t, Token.Language.M3);
        UNTIL (t.getKind() = Symbol.Kind.Semicolon);
        t.removeLanguage(Token.Language.M3);
      END;
    END;
  END RemoveGarbageImports;


(* ------------------ visible procedures --------------- *)

PROCEDURE IsImported (g   : SourceGraph.T;
                      a   : SourceGraph.Anchor;
                      mod : TEXT;
                      item: TEXT                 := NIL): BOOLEAN
  RAISES {} =
  BEGIN
    IF (item = NIL) THEN
      RETURN FindQualifiedImport(g, a, mod) # NIL;
    ELSE
      RETURN FindUnqualifiedImport(g, a, mod, item) # NIL;
    END;
  END IsImported;


PROCEDURE AddImport (g   : SourceGraph.T;
                     a   : SourceGraph.Anchor;
                     mod : TEXT;
                     item: TEXT                 := NIL) RAISES {} =
  VAR to: Token.T := NIL;

  BEGIN
    IF (NOT IsImported(g, a, mod, item)) THEN
      IF (item = NIL) THEN       (* qualified import *)
        to := FindFirstQualifiedImport(g, a);
        IF (to # NIL) THEN
          g.prependToken(
            a, NEW(Token.T).init(Symbol.Kind.Identifier, mod,
                                 Token.LanguageSet{Token.Language.M3}), to);
          g.prependToken(
            a, NEW(Token.T).init(Symbol.Kind.Comma, ",",
                                 Token.LanguageSet{Token.Language.M3}), to);
          g.prependToken(
            a, NEW(Token.T).init(Symbol.Kind.WhiteSpace, " ",
                                 Token.LanguageSet{Token.Language.M3}), to);

        ELSE
          to := FindFirstPlaceToInsertImport(g, a);
          g.prependToken(
            a, NEW(Token.T).init(Symbol.Kind.Import, "IMPORT",
                                 Token.LanguageSet{Token.Language.M3}), to);
          g.prependToken(
            a, NEW(Token.T).init(Symbol.Kind.WhiteSpace, " ",
                                 Token.LanguageSet{Token.Language.M3}), to);
          g.prependToken(
            a, NEW(Token.T).init(Symbol.Kind.Identifier, mod,
                                 Token.LanguageSet{Token.Language.M3}), to);
          g.prependToken(
            a, NEW(Token.T).init(Symbol.Kind.Semicolon, ";",
                                 Token.LanguageSet{Token.Language.M3}), to);
          g.prependToken(
            a, NEW(Token.T).init(Symbol.Kind.WhiteSpace, "\n",
                                 Token.LanguageSet{Token.Language.M3}), to);
        END;
      ELSE                       (* unqualified import *)
        to := FindFirstUnqualifiedImport(g, a);
        WHILE ((to # NIL) AND (NOT (Text.Equal(mod, to.getText())))) DO
          to := FindNextUnqualifiedImport(g, to);
        END;
        IF (to # NIL) THEN
          to := TokenSupport.FindSymbolOfKind(g, to, Symbol.Kind.Import);
          to := TokenSupport.SkipWhiteSpaceAndComment(g, to);
          g.prependToken(
            a, NEW(Token.T).init(Symbol.Kind.Identifier, item,
                                 Token.LanguageSet{Token.Language.M3}), to);
          g.prependToken(
            a, NEW(Token.T).init(Symbol.Kind.Comma, ",",
                                 Token.LanguageSet{Token.Language.M3}), to);
          g.prependToken(
            a, NEW(Token.T).init(Symbol.Kind.WhiteSpace, " ",
                                 Token.LanguageSet{Token.Language.M3}), to);

        ELSE
          to := FindFirstPlaceToInsertImport(g, a);
          g.prependToken(
            a, NEW(Token.T).init(Symbol.Kind.From, "FROM",
                                 Token.LanguageSet{Token.Language.M3}), to);
          g.prependToken(
            a, NEW(Token.T).init(Symbol.Kind.WhiteSpace, " ",
                                 Token.LanguageSet{Token.Language.M3}), to);
          g.prependToken(
            a, NEW(Token.T).init(Symbol.Kind.Identifier, mod,
                                 Token.LanguageSet{Token.Language.M3}), to);
          g.prependToken(
            a, NEW(Token.T).init(Symbol.Kind.WhiteSpace, " ",
                                 Token.LanguageSet{Token.Language.M3}), to);
          g.prependToken(
            a, NEW(Token.T).init(Symbol.Kind.Import, "IMPORT",
                                 Token.LanguageSet{Token.Language.M3}), to);
          g.prependToken(
            a, NEW(Token.T).init(Symbol.Kind.WhiteSpace, " ",
                                 Token.LanguageSet{Token.Language.M3}), to);
          g.prependToken(
            a, NEW(Token.T).init(Symbol.Kind.Identifier, item,
                                 Token.LanguageSet{Token.Language.M3}), to);
          g.prependToken(
            a, NEW(Token.T).init(Symbol.Kind.Semicolon, ";",
                                 Token.LanguageSet{Token.Language.M3}), to);
          g.prependToken(
            a, NEW(Token.T).init(Symbol.Kind.WhiteSpace, "\n",
                                 Token.LanguageSet{Token.Language.M3}), to);
        END;
      END;
    END;
  END AddImport;


PROCEDURE RemoveImport (g   : SourceGraph.T;
                        a   : SourceGraph.Anchor;
                        mod : TEXT;
                        item: TEXT                 := NIL) RAISES {} =
  VAR to: Token.T;

  BEGIN
    IF (item = NIL) THEN
      to := FindQualifiedImport(g, a, mod);
    ELSE
      to := FindUnqualifiedImport(g, a, mod, item);
    END;
    IF (to # NIL) THEN
      to.removeLanguage(Token.Language.M3);
      RemoveCommas(g, to);
      RemoveGarbageImports(g, to);
    END;
  END RemoveImport;

BEGIN
END ImportSupport.
