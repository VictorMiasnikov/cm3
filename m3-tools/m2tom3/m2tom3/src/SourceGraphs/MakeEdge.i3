INTERFACE MakeEdge;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Kai Michael Degner                                        *)

(** pk
    1.1
    1994/11/30 15:08:13
    MakeEdge.i3,v
# Revision 1.1  1994/11/30  15:08:13  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- MakeEdge ---------------------------------------------------------------
  * Abstract data type module. Make edges are used to link modules (resp.
  * their anchors) to a make order.
  *
  * No further information than the type of the edge itself is
  * yet neccessary so there are not data or methods fields.
  * ----------------------------------------------------------------------------
  **)

IMPORT BaseEdge AS Super;

TYPE
  T <: Public;
  Public = Super.T OBJECT END;

END MakeEdge.
