MODULE CHRGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Kai Michael Degner                                        *)

(** m2tom3
    1.2
    1995/08/30 16:25:59
    CHRGen.m3,v
# Revision 1.2  1995/08/30  16:25:59  m2tom3
# Bug fixed: CHRs may also appear in constant expressions.
#
# Revision 1.1  1994/11/30  15:04:50  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT SourceGraph, BaseGraph, TokenGraph;
IMPORT Symbol, Token;
IMPORT SyntaxSupport, GeneratorSupport;
IMPORT Text;


PROCEDURE HandleCHR (graph : SourceGraph.T;
                     anchor: SourceGraph.Anchor;
                     chr   : Token.T             ) =
  <* FATAL BaseGraph.NodeInGraph,
           BaseGraph.NodeNotInGraph,
           TokenGraph.NoAnchor,
           TokenGraph.NotInStream *>

  VAR
    symbol : Symbol.T;
    bracket: Token.T;

  BEGIN
    <* ASSERT chr.getKind () = Symbol.Kind.Identifier *>
    <* ASSERT Text.Equal(chr.getText(),"CHR") *>

    GeneratorSupport.RemoveM3(graph, chr);
    WITH newToken = NEW(Token.T).init(
                      Symbol.Kind.GenText, "VAL", Token.M3Only) DO
      graph.appendToken(anchor, newToken, chr);
    END;

    symbol := graph.getParentSyntax(chr, Symbol.Kind.SyntaxQualIdent);
    symbol := graph.getParentSyntax(symbol);
    <* ASSERT (symbol.getKind() = Symbol.Kind.SyntaxQualSetOrCall) OR
              (symbol.getKind() = Symbol.Kind.SyntaxQualConstSetOrCall) *>
    symbol := graph.getChildSymbol(symbol, 2);
    <* ASSERT (symbol.getKind() = Symbol.Kind.SyntaxSetOrCall) OR
              (symbol.getKind() = Symbol.Kind.SyntaxConstSetOrCall) *>

    bracket := SyntaxSupport.FindRightmostToken(graph, symbol);

    WITH newToken = NEW(Token.T).init(
                      Symbol.Kind.GenText, ",CHAR", Token.M3Only) DO
      graph.prependToken(anchor, newToken, bracket);
    END;
  END HandleCHR;

BEGIN
END CHRGen.
