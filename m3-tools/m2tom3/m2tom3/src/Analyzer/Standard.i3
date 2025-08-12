INTERFACE Standard;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:04:15
    Standard.i3,v
# Revision 1.1  1994/11/30  15:04:15  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT Symbol;
IMPORT SourceGraph;


PROCEDURE IsPredefinedType (graph: SourceGraph.T; symbol: Symbol.T):
  BOOLEAN;
  (* This function checks whether a given symbol designates a predefined
     type or not.  You may call this function with an ident or qualified
     ident. *)

END Standard.
