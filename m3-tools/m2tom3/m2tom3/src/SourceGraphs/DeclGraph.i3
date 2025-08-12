INTERFACE DeclGraph;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Kai Michael Degner                                        *)

(** pk
    1.1
    1994/11/30 15:07:58
    DeclGraph.i3,v
# Revision 1.1  1994/11/30  15:07:58  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- DeclGraph --------------------------------------------------------------
  * Abstract data type module. Decl graphs extends make graphs by all
  * ressources needed for linking identifiers.
  *
  * These are methods to add DeclToAppl, ServerToClient and ScopeToDecl edges
  * and retrieving them by iterators. To link all units into an environment
  * the graph contains an environment node.
  * ----------------------------------------------------------------------------
  **)

IMPORT MakeGraph AS Super;
IMPORT Token, Syntax;
IMPORT BaseGraph;
IMPORT ServerToClientEdge;


TYPE
  T <: Public;

  Public =
    Super.T OBJECT
    METHODS
      init (noOfNodes: CARDINAL := 0; existenceChecks: BOOLEAN := FALSE): T
            RAISES {};
            (* Initializes graph.  For information on parameters noOfNodes,
               existenceChecks see base class (BaseGraph). *)


      getEnvScope (): Syntax.T;
                   (* Retrieves the environment scope node.  Its kind is
                      Syntax.Kind.SyntaxEnvScope. *)


      insertDeclToApplEdge (decl, appl: Token.T)
                            RAISES {BaseGraph.EdgeInGraph,
                                    BaseGraph.NodeNotInGraph};

      insertServerToClientEdge (server, client: Syntax.T;
                                priority      : ServerToClientEdge.Priority)
                                RAISES {BaseGraph.EdgeInGraph,
                                        BaseGraph.NodeNotInGraph};

      insertScopeToDeclEdge (scope: Syntax.T; decl: Token.T)
                             RAISES {BaseGraph.EdgeInGraph,
                                     BaseGraph.NodeNotInGraph};

      (* insertXXX inserts a edge of type XXX into the graph.  The nodes
         must already exists, otherwise you get the exception
         BaseGraph.NodeNotInGraph. *)


      iterateServersOfClient (client  : Syntax.T;
                              priority: ServerToClientEdge.Priority):
                              ServersOfClientIterator
                              RAISES {BaseGraph.NodeNotInGraph};
                              (* Initializes an iterator to get all server
                                 scopes of a given client scope. *)


      iterateDeclsOfScope (scope: Syntax.T): DeclsOfScopeIterator
                           RAISES {BaseGraph.NodeNotInGraph};
                           (* Initializes an iterator to get all declaring
                              identifiers of a given scope. *)


      iterateApplsOfDecl (decl: Token.T): ApplsOfDeclIterator
                          RAISES {BaseGraph.NodeNotInGraph};
                          (* Initializes an iterator to get all applying
                             identifiers of a given declaring
                             identifier. *)


      getDeclOfAppl (appl: Token.T): Token.T
                     RAISES {BaseGraph.NodeNotInGraph};
                     (* Returns the declaring identifier of a given
                        applying identifier node.  You get NIL if no
                        declaring identifier is bound to the applying
                        occurence.  If the given node is not in the graph
                        you get the exception BaseGraph.NodeNotInGraph. *)


      existsToClientEdge (client: Syntax.T): BOOLEAN
                          RAISES {BaseGraph.NodeNotInGraph}
                          (* Returns TRUE, if the client have an incoming
                             ServerToClientEdge, FALSE otherwise.  Raises
                             BaseGraph.NodeNotInGraph if client isn't a
                             node of the graph. *)

    END;


  ServersOfClientIterator <: ServersOfClientIteratorPublic;

  ServersOfClientIteratorPublic = OBJECT METHODS next (): Syntax.T; END;


  DeclsOfScopeIterator <: DeclsOfScopeIteratorPublic;

  DeclsOfScopeIteratorPublic = OBJECT METHODS next (): Token.T; END;


  ApplsOfDeclIterator <: ApplsOfDeclIteratorPublic;

  ApplsOfDeclIteratorPublic = OBJECT METHODS next (): Token.T; END;

(* Methods next of all iterators returns the next node.  You get NIL if no
   more node are awailable. *)

END DeclGraph.
