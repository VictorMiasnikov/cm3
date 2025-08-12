INTERFACE GeneratorSupport;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Thomas Stockheim                                          *)

(** pk
    1.1
    1994/11/30 15:05:18
    GeneratorSupport.i3,v
# Revision 1.1  1994/11/30  15:05:18  pk
# Release Version 2.00.
#
*)

(***************************************************************************)

(** --- GeneratorSupport -------------------------------------------------------
  * This functional module provides some general functions used for some
  * generators.
  * ----------------------------------------------------------------------------
  **)

(* subsystem SourceGraph *)
IMPORT Symbol;
IMPORT SourceGraph;


PROCEDURE GetTextOfType (graph: SourceGraph.T; type: Symbol.T): TEXT;
  (* This function may be called where type points to an identifier or
     qualified ident node.  It will return the type name in a single text.
     It is a checked runtime error if you call this procedure for any other
     node. *)


PROCEDURE RemoveM3 (graph: SourceGraph.T; symbol: Symbol.T);
  (* Remove the language M3 of all token of the subtree under symbol. *)

END GeneratorSupport.
