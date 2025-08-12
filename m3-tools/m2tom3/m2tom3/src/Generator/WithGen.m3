MODULE WithGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Thomas Stockheim                                          *)

(** pk
    1.1
    1994/11/30 15:06:18
    WithGen.m3,v
# Revision 1.1  1994/11/30  15:06:18  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(* subsystem SourceGraph *)
IMPORT BaseGraph;
IMPORT Symbol;
IMPORT Token, TokenGraph, TokenSupport;
IMPORT Syntax;
IMPORT SourceGraph;

(* subsystem Analyzer *)
IMPORT IdentifierLinker;

(* other stuff *)
IMPORT Fmt;


CONST M3only = Token.LanguageSet{Token.Language.M3};


PROCEDURE ChangeWith (graph : SourceGraph.T;
                      anchor: SourceGraph.Anchor;
                      token : Token.T             ) =
  BEGIN
    TransformWith(graph, anchor, token, 1);
  END ChangeWith;


PROCEDURE TransformWith (graph : SourceGraph.T;
                         anchor: SourceGraph.Anchor;
                         token : Token.T;
                         number: INTEGER             ) =
  <* FATAL BaseGraph.NodeNotInGraph, BaseGraph.NodeInGraph,
  TokenGraph.NoAnchor, TokenGraph.NotInStream *>

  VAR
    endToken, oldToken, withTrigger, testToken: Token.T;
    parent, recordScope, withScope            : Syntax.T;

  BEGIN
    (* first, test if with-statement has allready been handled !  If the
       with handling is done in a seceond pass, this could be done by
       stepping over the with statement after finishing *)
    testToken := token;
    REPEAT
      testToken := graph.getNextToken(testToken, Token.Language.M3)
    UNTIL (testToken.getKind()
             IN Symbol.KindSet{Symbol.Kind.Equal, Symbol.Kind.Do});
    IF (testToken.getKind() = Symbol.Kind.Do) THEN
      parent := graph.getParentSyntax(token);
      endToken := graph.getChildSymbol(parent, parent.getNoOfChildren());

      token := TokenSupport.SkipWhiteSpaceAndComment(graph, token);
      withScope :=
        graph.getChildSymbol(parent, 4, Symbol.Kind.SyntaxWithScope);
      withTrigger := IdentifierLinker.FindWithTrigger(graph, withScope);
      recordScope := IdentifierLinker.FindWithServer(graph, withTrigger);

      (* Insert XYZ_?  := before the with-identifier *)
      graph.prependToken(
        anchor, NEW(Token.T).init(
                  Symbol.Kind.Identifier, "m2tom3_" & Fmt.Int(number),
                  M3only, Token.UsageSet{Token.Usage.Decl}), token);
      graph.prependToken(
        anchor, NEW(Token.T).init(Symbol.Kind.Equal, "=", M3only), token);
      token := TokenSupport.FindSymbolOfKind(graph, token, Symbol.Kind.Do);

      (* add m2tom3_?  before all relevant identifiers *)
      REPEAT
        oldToken := token;       (* remember last token to check if
                                    Identifier is allready quallified *)
        token := graph.getNextToken(token, Token.Language.M3);
        IF (token.getKind() = Symbol.Kind.With) THEN
          TransformWith(graph, anchor, token, number + 1);
        ELSE
          IF ((token.getKind() = Symbol.Kind.Identifier)
                (* Is token an Identifier ? *)
                AND (oldToken.getKind() # Symbol.Kind.Period)
                (* Is it not qualified ? *)
                AND (Token.Usage.Appl IN token.getUsageSet())
                (* Is it an application ?*)
                AND (IdentifierLinker.FindSurroundingScope(
                       graph, graph.getDeclOfAppl(token)) = recordScope))
            (* Is it from the record ? *) THEN
            graph.prependToken(anchor,
                               NEW(Token.T).init(
                                 Symbol.Kind.Identifier,
                                 "m2tom3_" & Fmt.Int(number), M3only),
                               token);
            graph.prependToken(
              anchor, NEW(Token.T).init(Symbol.Kind.Period, ".", M3only),
              token);
          END;
        END;
      UNTIL (token = endToken);
    END;
  END TransformWith;

BEGIN
END WithGen.
