INTERFACE ServerToClientEdge;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:08:30
    ServerToClientEdge.i3,v
# Revision 1.1  1994/11/30  15:08:30  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- ServerToClientEdge -----------------------------------------------------
  * Abstract data type module. ServerToClient edges are used to link scopes.
  *
  * The attribute priority
  * distinguish wether the identifiers of a server scope are propagated to the
  * client scope or not.
  * (For further information see:
  *  Bezeichnerbindung in einer inkrementellen Software-Entwicklungsumgebung,
  *  Diplomarbeit von Olaf Dickoph 1993,
  *  Lehrstuhl fuer Informatik III, RWTH Aachen, Germany)
  * ----------------------------------------------------------------------------
  **)

IMPORT BaseEdge AS Super;


TYPE
  Priority = {Low, High};


  T <: Public;

  Public = Super.T OBJECT
           METHODS
             init (priority: Priority): T;
                   (* initializes a edge with it's attributes. *)

             getPriority (): Priority;
                          (* retrieves the attribute value *)
           END;

END ServerToClientEdge.
