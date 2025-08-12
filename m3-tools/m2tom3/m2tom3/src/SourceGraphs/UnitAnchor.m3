MODULE UnitAnchor;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:09:30
    UnitAnchor.m3,v
# Revision 1.1  1994/11/30  15:09:30  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- UnitAnchor -------------------------------------------------------------
  * Assumptions about hashing:
  *  hashing is yet irrelevant
  * ----------------------------------------------------------------------------
  **)

IMPORT SyntaxAnchor AS Super;


REVEAL
  T = Public BRANDED OBJECT
        name, path, suffix      : TEXT;
        workUnit, definitionUnit: BOOLEAN;

      OVERRIDES
        init         := Init;
        getName      := GetName;
        getPath      := GetPath;
        getSuffix    := GetSuffix;
        isWork       := IsWork;
        isDefinition := IsDefinition;
        setWork      := SetWork;
      END;


PROCEDURE Init (self                : T;
                name, path, suffix  : TEXT;
                isWork, isDefinition: BOOLEAN): T =
  BEGIN
    self := NARROW(self, Super.T).init();
    self.name := name;
    self.path := path;
    self.suffix := suffix;
    self.workUnit := isWork;
    self.definitionUnit := isDefinition;
    RETURN self;
  END Init;


PROCEDURE GetName (self: T): TEXT =
  BEGIN
    RETURN self.name;
  END GetName;


PROCEDURE GetPath (self: T): TEXT =
  BEGIN
    RETURN self.path;
  END GetPath;


PROCEDURE GetSuffix (self: T): TEXT =
  BEGIN
    RETURN self.suffix;
  END GetSuffix;


PROCEDURE IsWork (self: T): BOOLEAN =
  BEGIN
    RETURN self.workUnit;
  END IsWork;


PROCEDURE IsDefinition (self: T): BOOLEAN =
  BEGIN
    RETURN self.definitionUnit;
  END IsDefinition;


PROCEDURE SetWork (self: T) =
  BEGIN
    self.workUnit := TRUE;
  END SetWork;

BEGIN
END UnitAnchor.
