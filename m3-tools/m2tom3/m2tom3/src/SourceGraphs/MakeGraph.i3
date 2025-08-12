INTERFACE MakeGraph;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Kai Michael Degner                                        *)

(** pk
    1.1
    1994/11/30 15:08:19
    MakeGraph.i3,v
# Revision 1.1  1994/11/30  15:08:19  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- MakeGraph --------------------------------------------------------------
  * Abstract data type module. Make graphs bases on module graphs and extend
  * them by a make order.
  * ----------------------------------------------------------------------------
  **)

IMPORT UnitGraph AS Super;
IMPORT UnitAnchor AS Anchor;
IMPORT BaseGraph;


EXCEPTION UnitInMakeOrder;


TYPE
  T <: Public;
  Public =
    Super.T OBJECT
    METHODS
      appendMake (anchor: Anchor.T)
                  RAISES {BaseGraph.NodeNotInGraph, UnitInMakeOrder};
                  (* Includes this unit over it's anchor to the make order
                     at their end.

                     It is a checked error if the anchor is not member of
                     the graph (exception BaseGraph.NodeNotInGraph) or if
                     the anchor is already inlcuded in the make order
                     (exception UnitInMakeOrder)

                     It is up to you to establish a correct make order.
                     This order should resolve dependecies between units in
                     a way earlier units shouldn't depend on later
                     modules. *)


      iterateMakes (): MakeIterator;
                    (* Retrieves an iterator which enumerates all unit
                       anchors included in the make order. *)
    END;


  MakeIterator <: MakeIteratorPublic;

  MakeIteratorPublic =
    OBJECT
    METHODS
      next (): Anchor.T;
            (* Retrieves the next module anchor.  You'll get all module
               anchors in the already established make order by calling
               successivly next. *)
    END;

END MakeGraph.
