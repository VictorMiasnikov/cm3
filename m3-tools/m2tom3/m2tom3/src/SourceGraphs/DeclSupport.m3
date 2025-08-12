MODULE DeclSupport;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Peter Klein                                               *)

(** pk
    1.1
    1994/11/30 15:08:06
    DeclSupport.m3,v
# Revision 1.1  1994/11/30  15:08:06  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT SourceGraph, DeclGraph, BaseGraph, Token, Symbol, Syntax;


<* FATAL BaseGraph.NodeNotInGraph *>


REVEAL
  CallIterator = CallIteratorPublic BRANDED OBJECT
                   graph       : SourceGraph.T;
                   applIterator: DeclGraph.ApplsOfDeclIterator;
                 END;


TYPE
  DeclIterator =
    CallIterator OBJECT OVERRIDES next := DeclIteratorNext; END;

  DefIterator = CallIterator OBJECT
                  tmpIterator: DeclGraph.ApplsOfDeclIterator := NIL;
                OVERRIDES
                  next := DefIteratorNext;
                END;


PROCEDURE IterateProcCalls (graph: SourceGraph.T; ident: Token.T):
  CallIterator =
  VAR iterator: CallIterator;

  BEGIN
    WITH parent = graph.getParentSyntax(ident) DO
      CASE parent.getKind() OF
        Symbol.Kind.SyntaxProcedureDeclaration =>
          iterator := NEW(DeclIterator);
      | Symbol.Kind.SyntaxProcedureDefinition =>
          iterator := NEW(DefIterator);
      ELSE
        <* ASSERT FALSE *>
      END;
    END;
    iterator.graph := graph;
    iterator.applIterator := graph.iterateApplsOfDecl(ident);
    RETURN iterator;
  END IterateProcCalls;


PROCEDURE DeclIteratorNext (iterator: DeclIterator): Token.T =
  BEGIN
    LOOP
      WITH token = iterator.applIterator.next() DO
        IF (token = NIL) THEN RETURN NIL; END;
        WITH parent = iterator.graph.getParentSyntax(token) DO
          IF ((parent # NIL)
                AND (parent.getKind() # Symbol.Kind.SyntaxExtraScope)) THEN
            RETURN token;
          END;
        END;
      END;
    END;
  END DeclIteratorNext;


PROCEDURE DefIteratorNext (iterator: DefIterator): Token.T =
  BEGIN
    IF (iterator.tmpIterator # NIL) THEN
      WITH token = iterator.tmpIterator.next() DO
        IF (token = NIL) THEN
          iterator.tmpIterator := NIL;
        ELSE
          RETURN token;
        END;
      END;
    END;

    WITH token = iterator.applIterator.next() DO
      IF (token = NIL) THEN RETURN NIL; END;
      IF (IsUnqualImportInImpl(iterator.graph, token)) THEN
        iterator.tmpIterator := iterator.graph.iterateApplsOfDecl(token);
        RETURN DefIteratorNext(iterator);
      END;
      RETURN token;
    END;
  END DefIteratorNext;


PROCEDURE IsUnqualImportInImpl (graph: SourceGraph.T; ident: Token.T):
  BOOLEAN =
  VAR current: Syntax.T;

  BEGIN
    current := graph.getParentSyntax(ident);
    WHILE (current.getKind() = Symbol.Kind.SyntaxDAIdentList) DO
      current := graph.getParentSyntax(current);
    END;
    IF (current.getKind() # Symbol.Kind.SyntaxImportScope) THEN
      RETURN FALSE;
    END;
    WHILE (current.getKind() # Symbol.Kind.SyntaxCompilationUnit) DO
      current := graph.getParentSyntax(current);
    END;
    current := graph.getChildSymbol(current, no := 1);
    RETURN (current.getKind() = Symbol.Kind.SyntaxProgramModule);
  END IsUnqualImportInImpl;

BEGIN
END DeclSupport.
