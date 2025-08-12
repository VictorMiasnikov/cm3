MODULE TokenAnchor;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:09:13
    TokenAnchor.m3,v
# Revision 1.1  1994/11/30  15:09:13  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- TokenAnchor ------------------------------------------------------------
  * Assumptions about hashing:
  *  none used
  *  (while hashing for token anchors is redefined)
  * ----------------------------------------------------------------------------
  **)

IMPORT Word;


REVEAL T = Public BRANDED OBJECT OVERRIDES hash := Hash; END;


PROCEDURE Hash (self: T): Word.T =
  BEGIN
    RETURN TYPECODE(self);
  END Hash;

BEGIN
END TokenAnchor.
