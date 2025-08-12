INTERFACE TokenEdge;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:09:16
    TokenEdge.i3,v
# Revision 1.1  1994/11/30  15:09:16  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- TokenEdge --------------------------------------------------------------
  * Abstract data type module. Token edges are used to link some token nodes
  * to a stream. No further information than the type of the edges itself is
  * yet neccessary so there are not data or methods fields.
  * ----------------------------------------------------------------------------
  **)

IMPORT BaseEdge AS Super;


TYPE
  T <: Public;
  Public = Super.T OBJECT END;

END TokenEdge.
