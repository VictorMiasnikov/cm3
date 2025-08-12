INTERFACE BaseGraph;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:07:45
    BaseGraph.i3,v
# Revision 1.1  1994/11/30  15:07:45  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- BaseGraph --------------------------------------------------------------
  * Abstract data type module providing a graph.
  *
  * Nodes and Edges are specialized kinds of ClusterTable.Item, so they must
  * support a method hash to determine their hash class. For nodes and edges
  * this methods are predefined: the hash class of each node is arbitrary
  * (usually new), edges of the same dynamic type are collected in a single
  * hash class.
  *
  * All data types of this modules are objects, so the may be effeciently
  * expanded and specialized.
  *
  * This module is named BaseGraph instead of ClusterGraph because it replaces
  * BaseGraph and the amount of changes (especially renaming exceptions) in
  * other modules should be reduced.
  * ----------------------------------------------------------------------------
  **)

IMPORT ClusterTable;


EXCEPTION
  NodeInGraph;
  NodeNotInGraph;
  EdgeInGraph;
  EdgeNotInGraph;
  ResultNotUnique;


TYPE
  Edge <: EdgePublic;

  EdgePublic = ClusterTable.Item OBJECT
               METHODS
                 init (): Edge;

                 getSourceNode (): Node;
                 getTargetNode (): Node;
               END;


  Node <: NodePublic;

  NodePublic = ClusterTable.Item OBJECT METHODS init (): Node; END;


  T <: Public;

  Public = ClusterTable.T OBJECT
           METHODS
             insertNode (node: Node; noOfEdges: CARDINAL := 1)
                         RAISES {NodeInGraph};

             deleteNode (node: Node) RAISES {NodeNotInGraph};

             insertEdge (edge: Edge; source, target: Node)
                         RAISES {EdgeInGraph, NodeNotInGraph};

             deleteEdge (edge: Edge) RAISES {EdgeNotInGraph};

             iterateNodes (sampleNode: Node := NIL): NodeIterator;

             iterateOutEdges (source: Node; sampleEdge: Edge := NIL):
                              EdgeIterator RAISES {NodeNotInGraph};

             iterateInEdges (source: Node; sampleEdge: Edge := NIL):
                             EdgeIterator RAISES {NodeNotInGraph};

             getNextNode (source    : Node;
                          sampleEdge: Edge          := NIL;
                          predicate : EdgePredicate := NIL  ): Node
                          RAISES {ResultNotUnique, NodeNotInGraph};

             getPrevNode (source    : Node;
                          sampleEdge: Edge          := NIL;
                          predicate : EdgePredicate := NIL  ): Node
                          RAISES {ResultNotUnique, NodeNotInGraph};

             getEdge (source, target: Node; sampleEdge: Edge := NIL): Edge
                      RAISES {ResultNotUnique, NodeNotInGraph};
           END;


  NodePredicate = PROCEDURE (node: Node): BOOLEAN;

  NodeIterator <: NodeIteratorPublic;

  NodeIteratorPublic =
    ClusterTable.ItemIterator OBJECT METHODS next (): Node; END;


  EdgePredicate = PROCEDURE (edge: Edge): BOOLEAN;


  EdgeIterator <: EdgeIteratorPublic;

  EdgeIteratorPublic =
    ClusterTable.ItemIterator OBJECT METHODS next (): Edge; END;

END BaseGraph.
