MODULE UnitGraph;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:09:34
    UnitGraph.m3,v
# Revision 1.1  1994/11/30  15:09:34  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- UnitGraph --------------------------------------------------------------
  * Assumptions about hashing
  *  edges: no assumption
  *  nodes: nodes of same dynamic type have equal hash values.
  *         There should be no inherites classes of UnitAnchors
  *         otherwhise they are not found by the unit iterator.
  * ----------------------------------------------------------------------------
  **)

IMPORT SyntaxGraph AS Super;
IMPORT UnitAnchor;
IMPORT BaseGraph, BaseNode;
IMPORT Text;


REVEAL
  T = Public BRANDED OBJECT
      OVERRIDES
        insertAnchor := InsertAnchor;
        iterateUnits := IterateUnits;
        getUnit      := GetUnit;
      END;


  UnitIterator = UnitIteratorPublic BRANDED OBJECT
                   current : BaseNode.T;
                   iterator: BaseGraph.NodeIterator;
                 OVERRIDES
                   next := NextUnit;
                 END;



PROCEDURE InsertAnchor (self: T; anchor: UnitAnchor.T)
  RAISES {BaseGraph.NodeInGraph, UnitNotUnique} =
  VAR
    iterator : UnitIterator;
    modAnchor: UnitAnchor.T;

  BEGIN
    iterator := self.iterateUnits();
    REPEAT                       (* search for same module *)
      modAnchor := iterator.next();
      IF ((modAnchor # NIL)
            AND Text.Equal(anchor.getName(), modAnchor.getName())
            AND (anchor.isDefinition() = modAnchor.isDefinition())) THEN
        RAISE UnitNotUnique;
      END;
    UNTIL (modAnchor = NIL);
    NARROW(self, Super.T).insertAnchor(anchor);
  END InsertAnchor;


PROCEDURE IterateUnits (self: T): UnitIterator =
  VAR iterator: UnitIterator;

  BEGIN
    iterator := NEW(UnitIterator);
    iterator.iterator := self.iterateNodes(NEW(UnitAnchor.T));
    RETURN iterator;
  END IterateUnits;


PROCEDURE GetUnit (self: T; name: TEXT; isDefinition: BOOLEAN):
  UnitAnchor.T =
  VAR
    iterator : UnitIterator;
    modAnchor: UnitAnchor.T;

  BEGIN
    iterator := self.iterateUnits();
    REPEAT
      modAnchor := iterator.next();
    UNTIL ((modAnchor = NIL)
             OR (Text.Equal(modAnchor.getName(), name)
                   AND modAnchor.isDefinition() = isDefinition));
    RETURN modAnchor;
  END GetUnit;


PROCEDURE NextUnit (self: UnitIterator): UnitAnchor.T =
  BEGIN
    REPEAT
      self.current := self.iterator.next();
      IF (self.current = NIL) THEN RETURN NIL; END;
    UNTIL ISTYPE(self.current, UnitAnchor.T);
    RETURN NARROW(self.current, UnitAnchor.T);
  END NextUnit;

BEGIN
END UnitGraph.
