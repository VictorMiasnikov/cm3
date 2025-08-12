INTERFACE ScopeToDeclEdge;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:08:24
    ScopeToDeclEdge.i3,v
# Revision 1.1  1994/11/30  15:08:24  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- ScopeToDeclEdge --------------------------------------------------------
  * Abstract data type module. ScopeToDecl edges are used while linking
  * declaring identifiers to their applying identifiers.
  *
  * No further information than the type of the edges itself is
  * yet neccessary so there are not data or methods fields.
  * ----------------------------------------------------------------------------
  **)

IMPORT BaseEdge AS Super;


TYPE
  T <: Public;
  Public = Super.T OBJECT END;

END ScopeToDeclEdge.
