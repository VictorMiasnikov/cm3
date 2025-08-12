MODULE PointerGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:05:48
    PointerGen.m3,v
# Revision 1.1  1994/11/30  15:05:48  pk
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

(* subsystem Generator *)
IMPORT GeneratorSupport;


PROCEDURE ChangeToReference (graph      : SourceGraph.T;
                             anchor     : SourceGraph.Anchor;
                             pointerType: Syntax.T            ) =
  <* FATAL BaseGraph.NodeNotInGraph, BaseGraph.NodeInGraph,
  TokenGraph.NoAnchor, TokenGraph.NotInStream *>

  BEGIN
    <* ASSERT (pointerType.getKind () = Symbol.Kind.SyntaxPointerType) *>

    (* remove 'POINTER TO' *)
    GeneratorSupport.RemoveM3(
      graph, graph.getChildSymbol(pointerType, 1, Symbol.Kind.Pointer));
    GeneratorSupport.RemoveM3(
      graph, graph.getChildSymbol(pointerType, 2, Symbol.Kind.To));

    (* add 'UNTRACED BRANDED REF' *)
    graph.appendToken(
      anchor,
      NEW(Token.T).init(Symbol.Kind.GenText, "UNTRACED BRANDED REF"),
      graph.getChildSymbol(pointerType, 1, Symbol.Kind.Pointer));
  END ChangeToReference;

BEGIN
END PointerGen.
