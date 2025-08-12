MODULE BaseGraph;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:07:47
    BaseGraph.m3,v
# Revision 1.1  1994/11/30  15:07:47  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- BaseGraph --------------------------------------------------------------
  * This module realizes the graph via the module ClusterTable.
  *
  * A graph itself can be regarded as a table of nodes and each node
  * has two related tables of incoming and outcoming nodes. At least an edge
  * contains references to its source and target node.
  * ----------------------------------------------------------------------------
  **)

IMPORT ClusterTable;
IMPORT Word;


REVEAL
  Edge = EdgePublic BRANDED OBJECT
           source, target: Node := NIL;
         OVERRIDES
           init          := InitEdge;
           hash          := HashEdge;
           getSourceNode := GetSourceNode;
           getTargetNode := GetTargetNode;
         END;


  Node = NodePublic BRANDED OBJECT
           hashValue        : Word.T;
           inEdges, outEdges: ClusterTable.T := NIL;
         OVERRIDES
           init := InitNode;
           hash := HashNode
         END;


  T = Public BRANDED OBJECT
      OVERRIDES
        insertNode      := InsertNode;
        deleteNode      := DeleteNode;
        insertEdge      := InsertEdge;
        deleteEdge      := DeleteEdge;
        iterateNodes    := IterateNodes;
        iterateOutEdges := IterateOutEdges;
        iterateInEdges  := IterateInEdges;
        getNextNode     := GetNextNode;
        getPrevNode     := GetPrevNode;
        getEdge         := GetEdge
      END;



  NodeIterator =
    NodeIteratorPublic BRANDED OBJECT OVERRIDES next := NextNode; END;



  EdgeIterator =
    EdgeIteratorPublic BRANDED OBJECT OVERRIDES next := NextEdge; END;



VAR nodeNumber: CARDINAL := 0;


(*
 * --- edge procedures --------------------------------------------------------
 *)
PROCEDURE InitEdge (self: Edge): Edge =
  BEGIN
    (* nothing to do *)
    RETURN self;
  END InitEdge;


PROCEDURE HashEdge (self: Edge): Word.T =
  BEGIN
    RETURN TYPECODE(self);
  END HashEdge;


PROCEDURE GetSourceNode (self: Edge): Node =
  BEGIN
    RETURN self.source;
  END GetSourceNode;


PROCEDURE GetTargetNode (self: Edge): Node =
  BEGIN
    RETURN self.target;
  END GetTargetNode;



(*
 * --- node procedures --------------------------------------------------------
 *)
PROCEDURE InitNode (self: Node): Node =
  BEGIN
    nodeNumber := Word.Plus(nodeNumber, 1);
    self.hashValue := nodeNumber;

    RETURN self;
  END InitNode;


PROCEDURE HashNode (self: Node): Word.T =
  BEGIN
    RETURN self.hashValue;
  END HashNode;


(*
 * --- graph procedures --------------------------------------------------------
 *)
PROCEDURE InsertNode (self: T; node: Node; noOfEdges: CARDINAL := 4)
  RAISES {NodeInGraph} =
  BEGIN
    node.inEdges := NEW(ClusterTable.T).init(noOfEdges, self.doChecks());
    node.outEdges := NEW(ClusterTable.T).init(noOfEdges, self.doChecks());

    TRY
      self.insertItem(node);
    EXCEPT
    | ClusterTable.ItemInTable => RAISE NodeInGraph;
    END;
  END InsertNode;


PROCEDURE DeleteNode (self: T; node: Node) RAISES {NodeNotInGraph} =
  VAR edge: Edge;

  BEGIN
    (* delete out edges of this node from graph *)
    WITH i = self.iterateOutEdges(node) DO
      edge := i.next();
      WHILE (edge # NIL) DO
        TRY
          self.deleteEdge(edge);
        EXCEPT
        | EdgeNotInGraph => RAISE NodeNotInGraph;
        END;
        edge := i.next();
      END;
    END;

    (* delete in edges of this node from graph *)
    WITH i = self.iterateInEdges(node) DO
      edge := i.next();
      WHILE (edge # NIL) DO
        TRY
          self.deleteEdge(edge);
        EXCEPT
        | EdgeNotInGraph => RAISE NodeNotInGraph;
        END;
        edge := i.next();
      END;
    END;

    (* delete node itself from graph *)
    TRY
      self.deleteItem(node);
    EXCEPT
    | ClusterTable.ItemNotInTable => RAISE NodeNotInGraph;
    END;

    (* delete conected edge lists *)
    node.inEdges := NIL;
    node.outEdges := NIL;
  END DeleteNode;


PROCEDURE InsertEdge (self: T; edge: Edge; source, target: Node)
  RAISES {EdgeInGraph, NodeNotInGraph} =
  BEGIN
    IF (self.doChecks()
          AND ((source.outEdges = NIL) OR (target.inEdges = NIL))) THEN
      RAISE NodeNotInGraph;
    END;

    TRY
      source.outEdges.insertItem(edge);
      target.inEdges.insertItem(edge);
    EXCEPT
    | ClusterTable.ItemInTable => RAISE EdgeInGraph;
    END;

    edge.source := source;
    edge.target := target;
  END InsertEdge;


PROCEDURE DeleteEdge (self: T; edge: Edge) RAISES {EdgeNotInGraph} =
  BEGIN
    IF (self.doChecks() AND ((edge.source = NIL) OR (edge.target = NIL))) THEN
      RAISE EdgeNotInGraph;
    END;

    TRY
      edge.source.outEdges.deleteItem(edge);
      edge.target.inEdges.deleteItem(edge);
    EXCEPT
    | ClusterTable.ItemNotInTable => RAISE EdgeNotInGraph;
    END;

    edge.source := NIL;
    edge.target := NIL;
  END DeleteEdge;


PROCEDURE IterateNodes (self: T; sampleNode: Node := NIL): NodeIterator =
  BEGIN
    WITH i = NEW(NodeIterator).init(self, sampleNode) DO
      RETURN NARROW(i, NodeIterator);
    END;
  END IterateNodes;


PROCEDURE IterateOutEdges (self: T; source: Node; sampleEdge: Edge := NIL):
  EdgeIterator RAISES {NodeNotInGraph} =
  BEGIN
    IF (self.doChecks() AND ((source = NIL) OR (source.outEdges = NIL))) THEN
      RAISE NodeNotInGraph;
    END;

    WITH i = NEW(EdgeIterator).init(source.outEdges, sampleEdge) DO
      RETURN NARROW(i, EdgeIterator);
    END;
  END IterateOutEdges;


PROCEDURE IterateInEdges (self: T; source: Node; sampleEdge: Edge := NIL):
  EdgeIterator RAISES {NodeNotInGraph} =
  BEGIN
    IF (self.doChecks() AND ((source = NIL) OR (source.inEdges = NIL))) THEN
      RAISE NodeNotInGraph;
    END;

    WITH i = NEW(EdgeIterator).init(source.inEdges, sampleEdge) DO
      RETURN NARROW(i, EdgeIterator);
    END;
  END IterateInEdges;


PROCEDURE GetNextNode (<*UNUSED *> self      : T;
                                   source    : Node;
                                   sampleEdge: Edge          := NIL;
                                   predicate : EdgePredicate := NIL  ):
  Node RAISES {ResultNotUnique, NodeNotInGraph} =
  VAR edge: Edge;

  PROCEDURE ItemPredicate (item: ClusterTable.Item): BOOLEAN =
    BEGIN
      RETURN predicate(NARROW(item, Edge));
    END ItemPredicate;

  (* GetNextNode *)
  BEGIN
    IF (source = NIL) THEN RETURN NIL; END;
    IF (source.outEdges = NIL) THEN RAISE NodeNotInGraph; END;

    TRY
      IF (predicate = NIL) THEN
        edge := source.outEdges.getItem(sampleEdge);
      ELSE
        edge := source.outEdges.getItem(sampleEdge, ItemPredicate);
      END;

      IF (edge = NIL) THEN
        RETURN NIL;
      ELSE
        RETURN NARROW(edge, Edge).target;
      END;
    EXCEPT
    | ClusterTable.ItemNotUnique => RAISE ResultNotUnique;
    END;
  END GetNextNode;


PROCEDURE GetPrevNode (<*UNUSED*> self      : T;
                                  source    : Node;
                                  sampleEdge: Edge          := NIL;
                                  predicate : EdgePredicate := NIL  ): Node
  RAISES {ResultNotUnique, NodeNotInGraph} =
  VAR edge: Edge;

  PROCEDURE ItemPredicate (item: ClusterTable.Item): BOOLEAN =
    BEGIN
      RETURN predicate(NARROW(item, Edge));
    END ItemPredicate;

  (* GetPrevNode *)
  BEGIN
    IF (source = NIL) THEN RETURN NIL; END;
    IF (source.inEdges = NIL) THEN RAISE NodeNotInGraph; END;

    TRY
      IF (predicate = NIL) THEN
        edge := source.inEdges.getItem(sampleEdge);
      ELSE
        edge := source.inEdges.getItem(sampleEdge, ItemPredicate);
      END;

      IF (edge = NIL) THEN
        RETURN NIL;
      ELSE
        RETURN NARROW(edge, Edge).source;
      END;
    EXCEPT
    | ClusterTable.ItemNotUnique => RAISE ResultNotUnique;
    END
  END GetPrevNode;


PROCEDURE GetEdge (<*UNUSED*> self          : T;
                              source, target: Node;
                              sampleEdge    : Edge   := NIL): Edge
  RAISES {ResultNotUnique, NodeNotInGraph} =

  PROCEDURE IsTarget (item: ClusterTable.Item): BOOLEAN =
    BEGIN
      RETURN (NARROW(item, Edge).target = target);
    END IsTarget;

  (* GetEdge *)
  BEGIN
    IF ((source = NIL) OR (target = NIL)) THEN RETURN NIL; END;
    IF (source.inEdges = NIL) THEN RAISE NodeNotInGraph; END;

    TRY
      RETURN NARROW(source.outEdges.getItem(sampleEdge, IsTarget), Edge);
    EXCEPT
    | ClusterTable.ItemNotUnique => RAISE ResultNotUnique;
    END;
  END GetEdge;


(*
 * --- node iterator -----------------------------------------------------------
 *)
PROCEDURE NextNode (self: NodeIterator): Node =
  BEGIN
    RETURN NARROW(self, ClusterTable.ItemIterator).next();
  END NextNode;


(*
 * --- edge iterator  ----------------------------------------------------------
 *)
PROCEDURE NextEdge (self: EdgeIterator): Edge =
  BEGIN
    RETURN NARROW(self, ClusterTable.ItemIterator).next();
  END NextEdge;

BEGIN
END BaseGraph.
