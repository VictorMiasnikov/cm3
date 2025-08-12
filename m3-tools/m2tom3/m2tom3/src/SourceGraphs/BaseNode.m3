MODULE BaseNode;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:07:53
    BaseNode.m3,v
# Revision 1.1  1994/11/30  15:07:53  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT BaseGraph;


REVEAL
  T = Public BRANDED OBJECT
        number: CARDINAL;
      OVERRIDES
        init      := Init;
        setNumber := SetNumber;
        getNumber := GetNumber;
      END;


PROCEDURE Init (self: T; number: CARDINAL): T =
  BEGIN
    self := NARROW(self, BaseGraph.Node).init();
    self.number := number;

    RETURN self;
  END Init;


PROCEDURE SetNumber (self: T; number: CARDINAL) =
  BEGIN
    self.number := number;
  END SetNumber;


PROCEDURE GetNumber (self: T): CARDINAL =
  BEGIN
    RETURN self.number;
  END GetNumber;

BEGIN
END BaseNode.
