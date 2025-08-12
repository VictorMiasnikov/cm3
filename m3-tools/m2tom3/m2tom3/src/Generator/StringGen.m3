MODULE StringGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:06:02
    StringGen.m3,v
# Revision 1.1  1994/11/30  15:06:02  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(* subsystem SourceGraph *)
IMPORT BaseGraph;
IMPORT Symbol;
IMPORT Token, TokenSupport;
IMPORT SyntaxSupport, ActualToFormalType, CopyTokenSubstream;
IMPORT SourceGraph, TokenGraph;
IMPORT Syntax;

(* other stuff *)
IMPORT Text, Fmt, Configuration;


<* FATAL BaseGraph.NodeInGraph, BaseGraph.NodeNotInGraph, TokenGraph.NoAnchor,
 TokenGraph.NotInStream *>


(** --- ConvertString ----------------------------------------------------------
  * Converts a string literal into a constant array of character since
  * Modula-3 otherwise interprets these literals as TEXT rather than
  * ARRAY OF CHAR.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE ConvertString (graph : SourceGraph.T;
                         anchor: SourceGraph.Anchor;
                         token : Token.T             ) =
  BEGIN
    IF (Configuration.KeepStrings()) THEN RETURN; END;
    (* check whether the literal occurs within an assignment *)
    WITH isAssignment = (SyntaxSupport.FindPath(
                           graph, token,
                           ARRAY [0 .. 6] OF
                             Symbol.Kind{
                             Symbol.Kind.SyntaxFactor,
                             Symbol.Kind.SyntaxTerm,
                             Symbol.Kind.SyntaxSimpleExpr,
                             Symbol.Kind.SyntaxExpr,
                             Symbol.Kind.SyntaxAssignment,
                             Symbol.Kind.SyntaxAssignmentOrCall,
                             Symbol.Kind.SyntaxAssignmentOrCallStatement},
                           FALSE) # NIL) DO

      token.removeLanguage(Token.Language.M3);

      IF (isAssignment) THEN
        ConvertToAssignment(graph, anchor, token);
      ELSE
        ConvertSimple(graph, anchor, token);
      END;
    END;
  END ConvertString;


(* If the string literal is the right hand side of an assignment statement,
   the variable on the left hand side must be replaced by an appropiate
   SUBARRAY expression, because the compiler only accepts assignment of an
   array to another, if their ranges are equal.  Another difference between
   AOCs in assignments and elsewhere is, that the AOC must not have a
   trailing zero byte if the variable it is assigned to has just as many
   fields as the string literal. *)
PROCEDURE ConvertToAssignment (graph : SourceGraph.T;
                               anchor: SourceGraph.Anchor;
                               token : Token.T             ) =
  VAR
    desitext    : TEXT;
    l           : INTEGER  := Text.Length(token.getText());
    assign, semi: Symbol.T;
    current     : Token.T;

  BEGIN
    AppendChars(graph, anchor, token, tail := "}");

    graph.appendToken(
      anchor,
      NEW(Token.T).init(
        Symbol.Kind.GenText, "ARRAY [0.." & Fmt.Int(l - 3) & "] OF CHAR{",
        Token.M3Only), token);

    assign :=
      graph.getChildSymbol(
        SyntaxSupport.FindPath(
          graph, token,
          ARRAY [0 .. 4] OF
            Symbol.Kind{
            Symbol.Kind.SyntaxFactor, Symbol.Kind.SyntaxTerm,
            Symbol.Kind.SyntaxSimpleExpr, Symbol.Kind.SyntaxExpr,
            Symbol.Kind.SyntaxAssignment}, FALSE), 1, Symbol.Kind.Assign);

    WITH assignment = graph.getParentSyntax(
                        assign,
                        expectedKind := Symbol.Kind.SyntaxAssignment),
         assignmentOrCall = graph.getParentSyntax(
                              assignment,
                              expectedKind :=
                                Symbol.Kind.SyntaxAssignmentOrCall),
         assignmentOrCallStatement = graph.getParentSyntax(
                                       assignmentOrCall,
                                       expectedKind :=
                                         Symbol.Kind.SyntaxAssignmentOrCallStatement) DO
      current :=
        SyntaxSupport.FindLeftmostToken(graph, assignmentOrCallStatement);
    END;
    WITH prevToken = graph.getPrevToken(current, Token.Language.M3) DO
      IF ((prevToken # NIL) AND (prevToken.getKind() = Symbol.Kind.Period)
            AND (graph.getParentSyntax(prevToken) = NIL)) THEN
        current := graph.getPrevToken(prevToken, Token.Language.M3);
      END;
    END;


    desitext :=
      TokenSupport.TextBetweenTokens(
        graph, current, graph.getPrevToken(assign, Token.Language.M3));

    (* 3.  find the end of the assignment statement, to insert the if
       clause *)
    semi := graph.getNextToken(token, Token.Language.M3);
    WHILE ((semi # NIL) AND (NOT semi.getKind()
                                   IN Symbol.KindSet{
                                        Symbol.Kind.Semicolon,
                                        Symbol.Kind.End, Symbol.Kind.Bar})) DO
      semi := graph.getNextToken(semi, Token.Language.M3);
    END;

    (* insert SUBARRAY expression *)
    graph.prependToken(
      anchor,
      NEW(Token.T).init(Symbol.Kind.GenText, "SUBARRAY(", Token.M3Only),
      current);
    graph.prependToken(
      anchor, NEW(Token.T).init(
                Symbol.Kind.GenText, ", 0, " & Fmt.Int(l - 2) & ") ",
                Token.M3Only), assign);
    (* insert an if-statement, that adds zero byte if possible *)
    graph.prependToken(
      anchor, NEW(Token.T).init(Symbol.Kind.Semicolon, ";", Token.M3Only),
      semi);
    graph.prependToken(
      anchor,
      NEW(Token.T).init(
        Symbol.Kind.GenText,
        "\nIF NUMBER(" & desitext & ") > " & Fmt.Int(l - 2) & " THEN "
          & desitext & "[FIRST(" & desitext & ") + " & Fmt.Int(l - 2)
          & "] := \'\\000\'; END\n", Token.M3Only), semi);
  END ConvertToAssignment;


PROCEDURE ConvertSimple (graph : SourceGraph.T;
                         anchor: SourceGraph.Anchor;
                         token : Token.T             ) =
  VAR
    formalQualIdent: Syntax.T;
    passToOpenArray: BOOLEAN;

  BEGIN
    (* By default, we assume that we can generate a constructor for an
       array with a size equal to the length of string.  This works for
       constant declarations and if the literal is an actual parameter in a
       procedure call and the corresponding formal parameter is an ARRAY OF
       BYTE.  It fails, however, if it is an actual parameter and the
       corresponding formal parameter is a fixed-sized array.  Now we try
       to determine if the latter is the case.  If we can find the
       procedure's declaration, and we find out that the formal parameter's
       type is not an open array, we compute the type identifier. *)
    WITH actualParam = GetExpr(graph, token) DO
      IF (actualParam # NIL) THEN
        formalQualIdent := GetFormalTypeIdent(graph, actualParam);
        passToOpenArray := (formalQualIdent = NIL);
      ELSE
        passToOpenArray := TRUE;
      END;
    END;

    IF (passToOpenArray) THEN
      ConvertToOpen(graph, anchor, token);
    ELSE
      ConvertToFixed(graph, anchor, token, formalQualIdent);
    END;
  END ConvertSimple;


PROCEDURE ConvertToOpen (graph : SourceGraph.T;
                         anchor: SourceGraph.Anchor;
                         token : Token.T             ) =
  VAR l := Text.Length(token.getText());

  BEGIN
    AppendChars(graph, anchor, token, tail := "'\\000'}");

    graph.appendToken(
      anchor,
      NEW(Token.T).init(
        Symbol.Kind.GenText, "ARRAY [0.." & Fmt.Int(l - 2) & "] OF CHAR{",
        Token.M3Only), token);
  END ConvertToOpen;


PROCEDURE ConvertToFixed (graph          : SourceGraph.T;
                          anchor         : SourceGraph.Anchor;
                          token          : Token.T;
                          formalQualIdent: Syntax.T            ) =
  BEGIN
    AppendChars(graph, anchor, token, tail := "'\\000',..}");
    WITH newToken = NEW(Token.T).init(
                      Symbol.Kind.GenText, "{", Token.M3Only) DO
      graph.appendToken(anchor, newToken, token);
    END;
    CopyTokenSubstream.F(graph, anchor, formalQualIdent,
                         insertionPoint := token, resetM3 := FALSE);
  END ConvertToFixed;


PROCEDURE AppendChars (graph : SourceGraph.T;
                       anchor: SourceGraph.Anchor;
                       token : Token.T;
                       tail  : TEXT                ) =
  VAR
    t                    := token.getText();
    l                    := Text.Length(t);
    insertComma: BOOLEAN;
    char       : TEXT;

  BEGIN
    graph.appendToken(
      anchor, NEW(Token.T).init(Symbol.Kind.GenText, tail, Token.M3Only),
      token);

    IF (l <= 2) THEN RETURN; END;

    insertComma := (Text.GetChar(tail, 0) # '}');
    FOR i := l - 2 TO 1 BY -1 DO
      IF (insertComma) THEN
        graph.appendToken(
          anchor, NEW(Token.T).init(Symbol.Kind.Comma, ",", Token.M3Only),
          token);
      END;
      insertComma := TRUE;
      char := Text.Sub(t, i, 1);
      IF (Text.Equal(char, "'")) THEN char := "\\'"; END;
      graph.appendToken(
        anchor, NEW(Token.T).init(
                  Symbol.Kind.CharConst, "'" & char & "'", Token.M3Only),
        token);
    END;
  END AppendChars;


PROCEDURE GetFormalTypeIdent (graph: SourceGraph.T; actualParam: Syntax.T):
  Syntax.T =
  <* FATAL BaseGraph.NodeNotInGraph *>

  BEGIN
    WITH formalType = ActualToFormalType.Get(graph, actualParam) DO
      IF (formalType = NIL) THEN RETURN NIL; END;
      WITH arrayOpt = graph.getChildSymbol(
                        formalType, no := 1,
                        expectedKind := Symbol.Kind.SyntaxArrayOpt) DO
        IF (NARROW(arrayOpt, Syntax.T).getNoOfChildren() > 0) THEN
          RETURN NIL;
        END;
      END;
      RETURN graph.getChildSymbol(
               formalType, no := 2,
               expectedKind := Symbol.Kind.SyntaxQualIdent);
    END;
  END GetFormalTypeIdent;


PROCEDURE GetExpr (graph: SourceGraph.T; token: Token.T): Syntax.T =
  VAR
    current    : Syntax.T;
    currentExpr: Syntax.T;

  <* FATAL BaseGraph.NodeNotInGraph *>

  BEGIN
    current := graph.getParentSyntax(token);
    WHILE (NOT (current.getKind()
                  IN Symbol.KindSet{Symbol.Kind.SyntaxActualParameters,
                                    Symbol.Kind.SyntaxCompilationUnit})) DO
      IF (current.getKind() = Symbol.Kind.SyntaxExpr) THEN
        currentExpr := current;
      END;
      current := graph.getParentSyntax(current);
    END;
    IF (current.getKind() = Symbol.Kind.SyntaxCompilationUnit) THEN
      RETURN NIL;
    ELSE
      RETURN currentExpr;
    END;
  END GetExpr;

BEGIN
END StringGen.
