INTERFACE BaseNode;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:07:50
    BaseNode.i3,v
# Revision 1.1  1994/11/30  15:07:50  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- BaseNode ---------------------------------------------------------------
  * This abstract data type module represents a base type for nodes
  * to use above BaseGraph.
  *
  * All nodes contain an attribut number to serve the subsystem GraphView.
  * ----------------------------------------------------------------------------
  **)

IMPORT BaseGraph;


TYPE
  T <: Public;

  Public =
    BaseGraph.Node OBJECT
    METHODS
      init (number: CARDINAL := 0): T;
            (* Initializes node. *)

      setNumber (number: CARDINAL);
      getNumber (): CARDINAL;
                 (* Sets / gets the attribute number of this node. *)
    END;

END BaseNode.
