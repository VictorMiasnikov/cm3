INTERFACE Generator;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:05:14
    Generator.i3,v
# Revision 1.1  1994/11/30  15:05:14  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- Generator --------------------------------------------------------------
  * This functional module represents the top of the generator subsystem. The
  * only exported function supports the whole work to do.
  * ----------------------------------------------------------------------------
  **)

IMPORT SourceGraph;


PROCEDURE GenerateM3Source (graph: SourceGraph.T);
  (* Doing all work. *)

END Generator.
