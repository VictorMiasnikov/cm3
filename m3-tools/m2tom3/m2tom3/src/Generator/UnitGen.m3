MODULE UnitGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:06:09
    UnitGen.m3,v
# Revision 1.1  1994/11/30  15:06:09  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(* subsystem SourceGraph *)
IMPORT BaseGraph;
IMPORT Symbol;
IMPORT Token, TokenGraph;
IMPORT Syntax;
IMPORT SourceGraph;

(* subsystem Utilities *)
IMPORT Message;

(* subsystem Generator *)
IMPORT GeneratorSupport;


PROCEDURE ChangeInterface (graph    : SourceGraph.T;
                           unit     : SourceGraph.Anchor;
                           defModule: Syntax.T            ) =
  <* FATAL BaseGraph.NodeInGraph, BaseGraph.NodeNotInGraph,
  TokenGraph.NoAnchor, TokenGraph.NotInStream *>

  BEGIN
    <* ASSERT (defModule.getKind () = Symbol.Kind.SyntaxDefinitionModule) *>

    WITH definition = graph.getChildSymbol(
                        defModule, 1, Symbol.Kind.Definition) DO
      (* Remove 'DEFINITION' *)
      GeneratorSupport.RemoveM3(graph, definition);

      (* Remove 'MODULE' *)
      WITH module = graph.getChildSymbol(defModule, 3, Symbol.Kind.Module) DO
        GeneratorSupport.RemoveM3(graph, module);
      END;

      (* Add 'UNSAFE' *)
      graph.appendToken(unit, NEW(Token.T).init(
                                Symbol.Kind.GenText, "UNSAFE INTERFACE",
                                Token.M3Only), definition);
    END;
  END ChangeInterface;


PROCEDURE ChangeProgram (graph     : SourceGraph.T;
                         unit      : SourceGraph.Anchor;
                         progModule: Syntax.T            ) =
  <* FATAL BaseGraph.NodeInGraph, BaseGraph.NodeNotInGraph,
  TokenGraph.NoAnchor, TokenGraph.NotInStream *>

  BEGIN
    <* ASSERT (progModule.getKind () = Symbol.Kind.SyntaxProgramModule) *>

    (* Add 'UNSAFE' *)
    WITH module = graph.getChildSymbol(progModule, 2, Symbol.Kind.Module) DO
      graph.prependToken(unit, NEW(Token.T).init(Symbol.Kind.GenText,
                                                 "UNSAFE ", Token.M3Only),
                         module);
    END;
    WITH implementationOpt = NARROW(graph.getChildSymbol(
                                      progModule, 1,
                                      Symbol.Kind.SyntaxImplementationOpt),
                                    Syntax.T) DO
      IF (0 < implementationOpt.getNoOfChildren()) THEN
        (* Implementation module detected -> remove 'IMPLEMENTATION' *)
        GeneratorSupport.RemoveM3(graph, implementationOpt);
      ELSE
        (* Program module detected -> add ' EXPORTS Main' *)
        WITH moduleIdent = graph.getChildSymbol(
                             graph.getChildSymbol(
                               progModule, 3,
                               Symbol.Kind.SyntaxPrivateScope), 1,
                             Symbol.Kind.Identifier) DO
          graph.appendToken(unit, NEW(Token.T).init(
                                    Symbol.Kind.GenText, " EXPORTS Main",
                                    Token.M3Only), moduleIdent);
        END;
      END;
    END;
  END ChangeProgram;


PROCEDURE ChangeModule (graph     : SourceGraph.T;
                        unit      : SourceGraph.Anchor;
                        moduleDecl: Syntax.T            ) =
  <* FATAL BaseGraph.NodeInGraph, BaseGraph.NodeNotInGraph,
  TokenGraph.NoAnchor, TokenGraph.NotInStream *>

  BEGIN
    <* ASSERT (moduleDecl.getKind () = Symbol.Kind.SyntaxModuleDeclaration) *>

    WITH module = graph.getChildSymbol(moduleDecl, 1, Symbol.Kind.Module) DO
      (* Add 'UNSAFE' *)
      graph.prependToken(unit, NEW(Token.T).init(Symbol.Kind.GenText,
                                                 "UNSAFE ", Token.M3Only),
                         module);
    END;

    (* Force warning message *)
    Message.Write(
      graph := graph,
      token := graph.getChildSymbol(moduleDecl, 2, Symbol.Kind.Identifier),
      code := Message.Code.UnableToHandleLocalModules);
  END ChangeModule;

BEGIN
END UnitGen.
