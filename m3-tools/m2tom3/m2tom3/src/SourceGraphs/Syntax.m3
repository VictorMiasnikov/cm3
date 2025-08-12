MODULE Syntax;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:08:43
    Syntax.m3,v
# Revision 1.1  1994/11/30  15:08:43  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- Syntax -----------------------------------------------------------------
  * Assumptions about hashing:
  *  hashing is yet irrelevant
  * ----------------------------------------------------------------------------
  **)

REVEAL
  T = Public BRANDED OBJECT
        noOfChildren: CARDINAL := 0;
      OVERRIDES
        getNoOfChildren := GetNoOfChildren;
        setNoOfChildren := SetNoOfChildren;
      END;


PROCEDURE GetNoOfChildren (self: T): CARDINAL =
  BEGIN
    RETURN self.noOfChildren;
  END GetNoOfChildren;


PROCEDURE SetNoOfChildren (self: T; value: CARDINAL) =
  BEGIN
    self.noOfChildren := value;
  END SetNoOfChildren;

BEGIN
END Syntax.
