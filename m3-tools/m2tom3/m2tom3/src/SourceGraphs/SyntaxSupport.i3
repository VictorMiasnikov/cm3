INTERFACE SyntaxSupport;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Alexander Poensgen                                        *)

(** pk
    1.2
    1995/02/14 12:17:06
    SyntaxSupport.i3,v
# Revision 1.2  1995/02/14  12:17:06  pk
# Some unnecessary exception handling removed.
#
# Revision 1.1  1994/11/30  15:09:02  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT BaseGraph;
IMPORT SyntaxGraph;
IMPORT Syntax;
IMPORT Token;
IMPORT Symbol;


TYPE
  SyntaxTreeIterator <: SyntaxTreeIteratorPublic;
    (* SyntaxTreeIterator is an iterator which retrieves the next syntax
       node in the common depth first ordering of a n - ary tree from left
       to right. *)

  RightMostIterator <: RightMostIteratorPublic;
    (* RightMostIterator is an iterator which retrieves the next syntax
       node in the common depth first ordering of a n - ary tree from right
       to left. *)


  SyntaxTreeIteratorPublic =
    OBJECT
    METHODS
      init (graph: SyntaxGraph.T; startSyntax: Symbol.T):
            SyntaxTreeIterator;
            (* startSyntax is the start node in the syntaxtree graph.  If
               graph is NIL then init will return NIL. *)

      next (): Symbol.T;
            (* Retrieves the next syntax node or token.  If there doesn`t
               exist any nodes or token anymore you`ll get NIL. *)


      skip (): Symbol.T;
            (* Skips the subtree of the current node and returns the root
               of the next subtree.  You`ll get NIL if there aren`t any
               subtrees anymore. *)
    END;


  RightMostIteratorPublic =
    (* analog to SyntaxTreeIterator *)
    OBJECT
    METHODS
      init (graph: SyntaxGraph.T; startSyntax: Symbol.T):
            RightMostIterator;
      next (): Symbol.T;
      skip (): Symbol.T;
    END;


PROCEDURE FindLeftmostToken (graph: SyntaxGraph.T; start: Syntax.T):
  Token.T;

PROCEDURE FindRightmostToken (graph: SyntaxGraph.T; start: Syntax.T):
  Token.T;

(* Retrieves the rightmost (leftmost) token of an syntax tree with root
   node start.  The result is NIL if no token exists. *)


PROCEDURE FindPath (         graph : SyntaxGraph.T;
                             actual: Symbol.T;
                    READONLY path  : ARRAY OF Symbol.Kind;
                    READONLY down  : BOOLEAN               ): Symbol.T
  RAISES {BaseGraph.NodeNotInGraph};
  (* FindPath tries to traverse the graph starting at node 'actual'
     according to the symboltypes given in path.  If down is TRUE, FindPath
     is searching for a child of 'actual' which is of kind 'path[0]'.  If
     down is FASLE, FindPath tests wether the parent syntax node is of kind
     'path[0]'.  When this first step (either up or down) is succesful,
     FindPath calls itself recursivly with the new node and a shorter
     'path'.  Finally FindPath will return the node corresponding to the
     last element of 'path' or NIL if the search fails. *)

END SyntaxSupport.
