MODULE SyntaxEdge;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:08:51
    SyntaxEdge.m3,v
# Revision 1.1  1994/11/30  15:08:51  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- SyntaxEdge -------------------------------------------------------------
  * Assumptions about hashing:
  *  hashing is yet irrelevant
  * ----------------------------------------------------------------------------
  **)

REVEAL
  T = Public BRANDED OBJECT
        no: CARDINAL;

      OVERRIDES
        init  := Init;
        setNo := SetNo;
        getNo := GetNo;
      END;


PROCEDURE Init (self: T; no: CARDINAL): T =
  BEGIN
    self.no := no;
    RETURN self;
  END Init;


PROCEDURE SetNo (self: T; no: CARDINAL) =
  BEGIN
    self.no := no;
  END SetNo;


PROCEDURE GetNo (self: T): CARDINAL =
  BEGIN
    RETURN self.no;
  END GetNo;

BEGIN
END SyntaxEdge.
