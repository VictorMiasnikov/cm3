MODULE MakeGraph;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Kai Michael Degner                                        *)

(** pk
    1.1
    1994/11/30 15:08:21
    MakeGraph.m3,v
# Revision 1.1  1994/11/30  15:08:21  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- MakeGraph --------------------------------------------------------------
  * Assumptions about hashing
  *  edges: edges of same dynamic type have equal hash values
  *  nodes: no assumption
  * ----------------------------------------------------------------------------
  **)

IMPORT UnitAnchor AS Anchor;
IMPORT BaseGraph;
IMPORT MakeEdge;
IMPORT Text;


REVEAL
  T = Public BRANDED OBJECT
        firstMake: Anchor.T := NIL;
      OVERRIDES
        appendMake   := AppendMake;
        iterateMakes := IterateMakes;
      END;

  MakeIterator = MakeIteratorPublic BRANDED OBJECT
                   current: Anchor.T;
                   graph  : T;
                 OVERRIDES
                   next := Next;
                 END;


(* sample edge to minimize allocations *)
VAR sampleEdge := NEW(MakeEdge.T);


PROCEDURE AppendMake (self: T; anchor: Anchor.T)
  RAISES {BaseGraph.NodeNotInGraph, UnitInMakeOrder} =
  VAR
    makIter               : MakeIterator;
    tempAnchor, lastAnchor: Anchor.T;

  <* FATAL BaseGraph.EdgeInGraph *>

  BEGIN
    IF (self.firstMake = NIL) THEN self.firstMake := anchor; RETURN; END;

    (* is anchor already in makeorder ? *)
    makIter := self.iterateMakes();
    REPEAT
      lastAnchor := tempAnchor;
      tempAnchor := makIter.next();
    UNTIL ((tempAnchor = NIL)
             OR (Text.Equal(tempAnchor.getName(), anchor.getName())
                   AND tempAnchor.isDefinition() = anchor.isDefinition()));

    IF (tempAnchor # NIL) THEN RAISE UnitInMakeOrder; END;

    WITH edge = NEW(MakeEdge.T) DO
      self.insertEdge(edge, lastAnchor, anchor);
    END;
  END AppendMake;


PROCEDURE IterateMakes (self: T): MakeIterator =
  BEGIN
    WITH mi = NEW(MakeIterator) DO
      mi.current := NIL;
      mi.graph := self;
      RETURN mi;
    END;
  END IterateMakes;


PROCEDURE Next (self: MakeIterator): Anchor.T =
  <* FATAL BaseGraph.ResultNotUnique, BaseGraph.NodeNotInGraph *>
  BEGIN
    IF (self.current = NIL) THEN
      self.current := self.graph.firstMake;
    ELSE
      self.current := self.graph.getNextNode(self.current, sampleEdge);
    END;
    RETURN self.current;
  END Next;

BEGIN
END MakeGraph.
