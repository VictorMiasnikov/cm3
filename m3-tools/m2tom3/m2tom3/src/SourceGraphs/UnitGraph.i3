INTERFACE UnitGraph;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:09:32
    UnitGraph.i3,v
# Revision 1.1  1994/11/30  15:09:32  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- UnitGraph ------------------------------------------------------------
  * Abstract data type module. Beginning at this level a graph is a container
  * for several units.
  * Units are distinguished by their name and isDefinition attributes.
  * A unit graph extend a syntax graph by extending syntax anchors to unit
  * anchors.
  * ----------------------------------------------------------------------------
  **)

IMPORT SyntaxGraph AS Super;
IMPORT UnitAnchor;
IMPORT BaseGraph;


EXCEPTION UnitNotUnique;


TYPE
  T <: Public;

  Public =
    Super.T OBJECT
    METHODS
      insertAnchor (anchor: UnitAnchor.T)
                    RAISES {BaseGraph.NodeInGraph, UnitNotUnique};
                    (* Inserts a unit anchor into the given graph.  It is a
                       checked error if the anchor is already member of the
                       graph (exception BaseGraph.NodeInGraph) or if
                       another anchor with the same name and definition
                       flag value exists (exception UnitNotUnique) *)


      iterateUnits (): UnitIterator;
                    (* Retrieves an Iterator which enumerates all unit
                       anchors in the graph.  You should test the returned
                       anchors to operate only on needed units using
                       UnitAnchor.isWork / UnitAnchor.isDefinition *)


      getUnit (name: TEXT; isDefinition: BOOLEAN): UnitAnchor.T;
               (* Search the unit specified by name and isDefinition.  If
                  such a unit is found you'll get it's anchor.  Otherwhise
                  you'll get NIL. *)
    END;


  UnitIterator <: UnitIteratorPublic;

  UnitIteratorPublic =
    OBJECT
    METHODS
      next (): UnitAnchor.T;
            (* Retrieves the next unit anchor.  You'll get all inserted
               unit anchors of the graph by calling successivly next.  The
               anchors are retrieved in an arbitray order. *)
    END;

END UnitGraph.
