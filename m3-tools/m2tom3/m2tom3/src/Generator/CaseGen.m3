MODULE CaseGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Kai Michael Degner                                        *)

(** pk
    1.2
    1995/09/04 10:18:50
    CaseGen.m3,v
# Revision 1.2  1995/09/04  10:18:50  pk
# Modula-2 allows a case to be empty, Modula-3 doesn't. Bars in a
# CASE-Statement with no subsequent case are therefore removed.
#
# Revision 1.1  1994/11/30  15:04:54  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT SourceGraph, TokenGraph, BaseGraph;
IMPORT Symbol, Token, Syntax;
IMPORT SyntaxSupport;
IMPORT GeneratorSupport;


PROCEDURE ModifyCase (graph        : SourceGraph.T;
                      anchor       : SourceGraph.Anchor;
                      caseStatement: Syntax.T            ) =
  <* FATAL BaseGraph.NodeInGraph,
           BaseGraph.NodeNotInGraph,
           TokenGraph.NoAnchor,
           TokenGraph.NotInStream *>

  VAR
    iterator     : SyntaxSupport.SyntaxTreeIterator;
    symbol, child: Symbol.T;
    token        : Token.T;

  BEGIN
    WITH caseOptSeq = graph.getChildSymbol(
                        caseStatement, 4, Symbol.Kind.SyntaxCaseOptSeq) DO
      iterator :=
        NEW(SyntaxSupport.SyntaxTreeIterator).init(graph, caseOptSeq);
    END;

    symbol := iterator.next();
    WHILE (symbol # NIL) DO
      IF (symbol.getKind() = Symbol.Kind.Colon) THEN
        IF (graph.getParentSyntax(symbol).getKind()
              = Symbol.Kind.SyntaxCase) THEN
          token := NARROW(symbol, Token.T);
          IF (Token.Language.M3 IN token.getLanguages()) THEN
            token.removeLanguage(Token.Language.M3);
            WITH newToken = NEW(Token.T).init(
                              Symbol.Kind.ImpArrow, "=>", Token.M3Only) DO
              graph.appendToken(anchor, newToken, token);
            END;
          END;
        END;
      END;
      IF (symbol.getKind() = Symbol.Kind.SyntaxStatementOpt) THEN
        IF (NARROW(symbol, Syntax.T).getNoOfChildren() = 0) THEN
          WITH parent = graph.getParentSyntax(symbol) DO
            IF (parent.getKind() = Symbol.Kind.SyntaxStatementOptSeq) THEN
              child := graph.getChildSymbol(
                         parent, 2, Symbol.Kind.SyntaxStatementOptList);
            ELSE
              child := graph.getChildSymbol(
                         parent, 3, Symbol.Kind.SyntaxStatementOptList);
            END;
            IF (NARROW(child, Syntax.T).getNoOfChildren() > 0) THEN
              GeneratorSupport.RemoveM3(
                graph,
                graph.getChildSymbol(child, 1, Symbol.Kind.Semicolon));
            END;
          END;
        END;
      END;
      IF (symbol.getKind() = Symbol.Kind.Bar) THEN
        WITH caseOptList = graph.getParentSyntax(
                             symbol, Symbol.Kind.SyntaxCaseOptList),
             caseOpt = graph.getChildSymbol(
                         caseOptList, 2, Symbol.Kind.SyntaxCaseOpt) DO
          IF (NARROW(caseOpt, Syntax.T).getNoOfChildren() = 0) THEN
            GeneratorSupport.RemoveM3(graph, symbol);
          END;
        END;
      END;
      symbol := iterator.next();
    END;
  END ModifyCase;

BEGIN
END CaseGen.
