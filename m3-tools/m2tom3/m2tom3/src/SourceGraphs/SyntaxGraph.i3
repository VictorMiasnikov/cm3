INTERFACE SyntaxGraph;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.2
    1995/02/14 12:17:03
    SyntaxGraph.i3,v
# Revision 1.2  1995/02/14  12:17:03  pk
# Some unnecessary exception handling removed.
#
# Revision 1.1  1994/11/30  15:08:54  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- SyntaxGraph ------------------------------------------------------------
  * Abstract data type module. A syntax graph extend a token graph by adding
  * syntax nodes and linking them into a syntax tree using syntax edges and
  * anchors.
  * ----------------------------------------------------------------------------
  **)

IMPORT TokenGraph AS Super;
IMPORT BaseGraph;
IMPORT Symbol;
IMPORT Syntax, SyntaxAnchor;


EXCEPTION NumberNotUnique;


TYPE
  T <: Public;

  Public =
    Super.T OBJECT
    METHODS
      insertSyntax (syntax: Syntax.T) RAISES {BaseGraph.NodeInGraph};
                    (* Inserts a syntax node to a graph.  It is a checked
                       error if this node is already member of the graph
                       (exception BaseGraph.NodeInGraph) *)


      insertSyntaxEdge (source: Syntax.T; target: Symbol.T; no: CARDINAL)
                        RAISES {BaseGraph.EdgeInGraph,
                                BaseGraph.NodeNotInGraph, NumberNotUnique};
                        (* Links source and target with a syntax edge.  The
                           attribut >number of children< of the source node
                           is updated automatically.  You shouldn't set
                           this attribut manually!  Source must be a
                           non-terminal symbol and target may be terminal
                           or non-terminal.  All edges from source should
                           have unique numbers (exception NumberNotUnique)
                           and there shouldn't exist other syntax edges
                           connected to target (exception
                           BaseGraph.EdgeInGraph).  It is required that
                           source and target nodes are already inserted to
                           the graph (exception
                           BaseGraph.NodeNotInGraph) *)


      getChildSymbol (parent      : Syntax.T;
                      no          : CARDINAL;
                      expectedKind: Symbol.Kind := Symbol.Kind.NoToken):
                      Symbol.T RAISES {BaseGraph.NodeNotInGraph};
                      (* Retrieves the child of given parent connected with
                         a syntax edge of specified number.  If there is no
                         such child or parent is NIL you'll get NIL.  If
                         you expect another kind than NoToken the procedure
                         will test if the result kind is equal to
                         expectedKind.  If this test fails an exception
                         will be raised (BaseGraph.NodeNotInGraph).  Your
                         parent should be a member of the graph (exception
                         BaseGraph.NodeNotInGraph). *)


      getParentSyntax (child       : Symbol.T;
                       expectedKind: Symbol.Kind := Symbol.Kind.NoToken):
                       Syntax.T RAISES {BaseGraph.NodeNotInGraph};
                       (* Retrieves the parent of the given child connected
                          with a syntax edge.  If there is no connected
                          parent you'll get NIL.  If you expect another
                          kind than NoToken the procedure will test if the
                          result kind is equal to expectedKind.  If this
                          test fails an exception will be raised
                          (BaseGraph.NodeNotInGraph).  Your child should be
                          a member of the graph (exception
                          BaseNode.NodeNotInGraph). *)


      iterateChildren (source: Syntax.T): ChildIterator;
                       (* Retrieves a child iterator which enumerates all
                          children of your source.  The enumeration is
                          ordered by the no attribut of the connecting
                          edges, starting at the lowest one.  Your source
                          node should be a member of the graph (exception
                          BaseGraph.NodeNotInGraph).  WARNING: you
                          shouldn't insert new syntax edges starting at
                          source while using the iterator! *)


      setRoot (anchor: SyntaxAnchor.T; root: Syntax.T)
               RAISES {BaseGraph.NodeNotInGraph, BaseGraph.EdgeInGraph};
               (* Establishes a root of a syntax tree.  If anchor or root
                  are NIL or not member of your graph you'll get the
                  exception BaseGraph.NodeNotInGraph.  If either the anchor
                  or the root are already connected you'll get the
                  exception BaseGraph.EdgeInGraph. *)


      getRoot (anchor: SyntaxAnchor.T): Syntax.T
               RAISES {BaseGraph.NodeNotInGraph};
               (* Retrieves the root of a syntax tree.  If anchor is NIL or
                  not connected you'll get the result NIL.  It is a checked
                  error if your anchor is not member of the graph
                  (BaseGraph.NodeNotInGraph). *)


      findAnchor (symbol: Symbol.T): SyntaxAnchor.T
                  RAISES {BaseGraph.NodeNotInGraph};
                  (* Search the anchor to a given symbol (token or syntax)
                     node.  This method overrides the related method in the
                     token graph by an generalized and optimized
                     version. *)
    END;


  ChildIterator <: ChildIteratorPublic;

  ChildIteratorPublic =
    OBJECT
    METHODS
      next (): Symbol.T;
            (* Retrieves the next child of the enumeration.  If the is no
               further child, you'll get NIL.  See iterateChildren for
               further details. *)
    END;

END SyntaxGraph.
