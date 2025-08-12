MODULE GeneratorSupport;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Thomas Stockheim                                          *)

(** pk
    1.2
    1995/02/14 12:16:49
    GeneratorSupport.m3,v
# Revision 1.2  1995/02/14  12:16:49  pk
# Some unnecessary exception handling removed.
#
# Revision 1.1  1994/11/30  15:05:21  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(* subsystem SourceGraph *)
IMPORT BaseGraph;
IMPORT Symbol;
IMPORT Token, TokenSupport;
IMPORT Syntax, SyntaxSupport;
IMPORT SourceGraph;


PROCEDURE GetTextOfType (graph: SourceGraph.T; typeSymbol: Symbol.T):
  TEXT =
  <* FATAL BaseGraph.NodeNotInGraph *>

  VAR
    name: TEXT    := "no_tpyename_found";
    tmp : Token.T;

  BEGIN
    CASE typeSymbol.getKind() OF
    | Symbol.Kind.Identifier =>
        name := NARROW(typeSymbol, Token.T).getText();

    | Symbol.Kind.SyntaxQualIdent =>
        tmp :=
          NARROW(
            graph.getChildSymbol(
              NARROW(typeSymbol, Syntax.T), 1, Symbol.Kind.Identifier),
            Token.T);
        IF (Token.Language.M3 IN tmp.getLanguages()) THEN
          name := tmp.getText();
        ELSE
          name := "";
        END;
        tmp := TokenSupport.SkipWhiteSpaceAndComment(
                 graph, tmp, Token.Language.M3);
        WHILE ((graph.getParentSyntax(tmp) = NIL)
                 OR ((graph.getParentSyntax(tmp)).getKind()
                       = Symbol.Kind.SyntaxQualificationScope)) DO
          IF (Token.Language.M3 IN tmp.getLanguages()) THEN
            name := name & tmp.getText();
          END;
          tmp := TokenSupport.SkipWhiteSpaceAndComment(
                   graph, tmp, Token.Language.M3);
        END;
    ELSE
      (* unexpected type name *)
      <* ASSERT FALSE *>
    END;
    RETURN name;
  END GetTextOfType;


(** --- RemoveM3 ---------------------------------------------------------------
  * Remove the language M3 of all token of the subtree under symbol.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE RemoveM3 (graph: SourceGraph.T; symbol: Symbol.T) =
  VAR i: SyntaxSupport.SyntaxTreeIterator;

  BEGIN
    TYPECASE symbol OF
    | Token.T (token) => token.removeLanguage(Token.Language.M3);

    | Syntax.T =>
        i := NEW(SyntaxSupport.SyntaxTreeIterator).init(graph, symbol);

        symbol := i.next();
        WHILE (symbol # NIL) DO
          IF (ISTYPE(symbol, Token.T)) THEN
            NARROW(symbol, Token.T).removeLanguage(Token.Language.M3);
          END;
          symbol := i.next();
        END;
    ELSE
      (* empty *)
    END;
  END RemoveM3;

BEGIN
END GeneratorSupport.
