MODULE Generator;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:05:16
    Generator.m3,v
# Revision 1.1  1994/11/30  15:05:16  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT SourceGraph;
IMPORT UnitGraph;
IMPORT SyntaxGen, SimpleGen;
IMPORT Message;


PROCEDURE GenerateM3Source (graph: SourceGraph.T) =
  VAR
    unit: SourceGraph.Anchor;
    i   : UnitGraph.UnitIterator;

  BEGIN
    (* doing work for each work-module separately *)
    i := graph.iterateUnits();
    unit := i.next();

    WHILE (unit # NIL) DO
      Message.Write(
        code := Message.Code.None,
        info := "\ttransforming file " & unit.getName() & unit.getSuffix());

      IF (unit.isWork()) THEN
        SyntaxGen.AppendM3toM2Syntax(graph, unit);
      END;
      SimpleGen.HandleSyntaxTree(graph, unit);
      unit := i.next();
    END;
  END GenerateM3Source;

BEGIN
END Generator.
