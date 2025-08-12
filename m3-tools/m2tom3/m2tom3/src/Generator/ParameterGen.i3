INTERFACE ParameterGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Thomas Stockheim                                          *)

(** pk
    1.1
    1994/11/30 15:05:42
    ParameterGen.i3,v
# Revision 1.1  1994/11/30  15:05:42  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT Syntax;
IMPORT SourceGraph;


PROCEDURE InsertParentheses (graph : SourceGraph.T;
                             anchor: SourceGraph.Anchor;
                             syntax: Syntax.T            );
  (* In Modula-2 a procedure call doesn't need parentheses if no arguments
     are given but in Modula-3 they allways have to be used. *)

END ParameterGen.
