MODULE ServerToClientEdge;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:08:33
    ServerToClientEdge.m3,v
# Revision 1.1  1994/11/30  15:08:33  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- ServerToClientEdge -----------------------------------------------------
  * Assumptions about hashing:
  *  hashing is yet irrelevant
  * ----------------------------------------------------------------------------
  **)


REVEAL
  T = Public BRANDED OBJECT
        priority: Priority;

      OVERRIDES
        init        := Init;
        getPriority := GetPriority;
      END;


PROCEDURE Init (self: T; priority: Priority): T =
  BEGIN
    self.priority := priority;
    RETURN self;
  END Init;


PROCEDURE GetPriority (self: T): Priority =
  BEGIN
    RETURN self.priority;
  END GetPriority;

BEGIN
END ServerToClientEdge.
