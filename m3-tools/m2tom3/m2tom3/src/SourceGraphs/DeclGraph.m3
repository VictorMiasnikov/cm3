MODULE DeclGraph;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Kai Michael Degner                                        *)

(** pk
    1.1
    1994/11/30 15:08:00
    DeclGraph.m3,v
# Revision 1.1  1994/11/30  15:08:00  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- DeclGraph --------------------------------------------------------------
  * Abstract data type module. Decl graphs extends make graphs by all
  * ressources needed for identifier linkgage.
  * ----------------------------------------------------------------------------
  **)

IMPORT BaseGraph;
IMPORT Symbol;
IMPORT Token;
IMPORT Syntax;
IMPORT MakeGraph AS Super;
IMPORT DeclToApplEdge, ServerToClientEdge, ScopeToDeclEdge;


REVEAL
  T = Public BRANDED OBJECT
        envScope: Syntax.T;

      OVERRIDES
        init        := Init;
        getEnvScope := GetEnvScope;

        insertDeclToApplEdge     := InsertDeclToApplEdge;
        insertServerToClientEdge := InsertServerToClientEdge;
        insertScopeToDeclEdge    := InsertScopeToDeclEdge;

        iterateServersOfClient := IterateServersOfClient;
        iterateDeclsOfScope    := IterateDeclsOfScope;
        iterateApplsOfDecl     := IterateApplsOfDecl;

        getDeclOfAppl      := GetDeclOfAppl;
        existsToClientEdge := ExistsToClientEdge;
      END;


  ServersOfClientIterator = ServersOfClientIteratorPublic BRANDED OBJECT
                              iterator: BaseGraph.EdgeIterator;
                              priority: ServerToClientEdge.Priority;
                            OVERRIDES
                              next := ServersOfClientIteratorNext;
                            END;

  DeclsOfScopeIterator = DeclsOfScopeIteratorPublic BRANDED OBJECT
                           iterator: BaseGraph.EdgeIterator;
                         OVERRIDES
                           next := DeclsOfScopeIteratorNext;
                         END;

  ApplsOfDeclIterator = ApplsOfDeclIteratorPublic BRANDED OBJECT
                          iterator: BaseGraph.EdgeIterator;
                        OVERRIDES
                          next := ApplsOfDeclIteratorNext;
                        END;


(* sample edges to minimize allocations *)
VAR
  sampleDeclToApplEdge     := NEW(DeclToApplEdge.T);
  sampleServerToClientEdge := NEW(ServerToClientEdge.T);
  sampleScopeToDeclEdge    := NEW(ScopeToDeclEdge.T);


PROCEDURE Init (self: T; noOfNodes: CARDINAL; existenceChecks: BOOLEAN):
  T =
  <* FATAL BaseGraph.NodeInGraph *>

  BEGIN
    self := NARROW(self, Super.T).init(noOfNodes, existenceChecks);

    (* insert environment scope node *)
    self.envScope := NEW(Syntax.T).init(Symbol.Kind.SyntaxEnvScope);
    self.insertSyntax(self.envScope);
    RETURN self;
  END Init;


PROCEDURE GetEnvScope (self: T): Syntax.T =
  BEGIN
    RETURN self.envScope;
  END GetEnvScope;


PROCEDURE InsertDeclToApplEdge (self: T; decl, appl: Token.T)
  RAISES {BaseGraph.EdgeInGraph, BaseGraph.NodeNotInGraph} =
  BEGIN
    WITH edge = NEW(DeclToApplEdge.T) DO
      self.insertEdge(edge, decl, appl);
    END;
  END InsertDeclToApplEdge;


PROCEDURE InsertServerToClientEdge (self          : T;
                                    server, client: Syntax.T;
                                    priority: ServerToClientEdge.Priority)
  RAISES {BaseGraph.EdgeInGraph, BaseGraph.NodeNotInGraph} =
  BEGIN
    WITH edge = NEW(ServerToClientEdge.T).init(priority) DO
      self.insertEdge(edge, server, client);
    END;
  END InsertServerToClientEdge;


PROCEDURE InsertScopeToDeclEdge (self: T; scope: Syntax.T; decl: Token.T)
  RAISES {BaseGraph.EdgeInGraph, BaseGraph.NodeNotInGraph} =
  BEGIN
    WITH edge = NEW(ScopeToDeclEdge.T) DO
      self.insertEdge(edge, scope, decl);
    END;
  END InsertScopeToDeclEdge;


PROCEDURE GetDeclOfAppl (self: T; appl: Token.T): Token.T
  RAISES {BaseGraph.NodeNotInGraph} =
  <* FATAL BaseGraph.ResultNotUnique *>

  BEGIN
    RETURN NARROW(self.getPrevNode(appl, sampleDeclToApplEdge), Token.T);
  END GetDeclOfAppl;


PROCEDURE ExistsToClientEdge (self: T; client: Syntax.T): BOOLEAN
  RAISES {BaseGraph.NodeNotInGraph} =
  VAR i: BaseGraph.EdgeIterator;

  BEGIN
    i := self.iterateInEdges(client, sampleServerToClientEdge);
    RETURN (i.next() # NIL);
  END ExistsToClientEdge;


PROCEDURE IterateServersOfClient (self    : T;
                                  client  : Syntax.T;
                                  priority: ServerToClientEdge.Priority):
  ServersOfClientIterator RAISES {BaseGraph.NodeNotInGraph} =
  BEGIN
    WITH iter = NEW(ServersOfClientIterator) DO
      iter.priority := priority;
      iter.iterator :=
        self.iterateInEdges(client, sampleServerToClientEdge);
      RETURN iter;
    END;
  END IterateServersOfClient;


PROCEDURE IterateDeclsOfScope (self: T; scope: Syntax.T):
  DeclsOfScopeIterator RAISES {BaseGraph.NodeNotInGraph} =
  BEGIN
    WITH iter = NEW(DeclsOfScopeIterator) DO
      iter.iterator := self.iterateOutEdges(scope, sampleScopeToDeclEdge);
      RETURN iter;
    END;
  END IterateDeclsOfScope;


PROCEDURE IterateApplsOfDecl (self: T; decl: Token.T): ApplsOfDeclIterator
  RAISES {BaseGraph.NodeNotInGraph} =
  BEGIN
    WITH iter = NEW(ApplsOfDeclIterator) DO
      iter.iterator := self.iterateOutEdges(decl, sampleDeclToApplEdge);
      RETURN iter;
    END;
  END IterateApplsOfDecl;


PROCEDURE ServersOfClientIteratorNext (self: ServersOfClientIterator):
  Syntax.T =
  VAR edge: ServerToClientEdge.T;

  BEGIN
    REPEAT                       (* search next server with given
                                    priority *)
      edge := self.iterator.next();
    UNTIL (edge = NIL) OR (edge.getPriority() = self.priority);

    IF (edge # NIL) THEN
      RETURN NARROW(edge.getSourceNode(), Syntax.T);
    ELSE
      RETURN NIL;
    END;
  END ServersOfClientIteratorNext;


PROCEDURE DeclsOfScopeIteratorNext (self: DeclsOfScopeIterator): Token.T =
  VAR edge: ScopeToDeclEdge.T;

  BEGIN
    edge := self.iterator.next();

    IF (edge # NIL) THEN
      RETURN NARROW(edge.getTargetNode(), Token.T);
    ELSE
      RETURN NIL;
    END;
  END DeclsOfScopeIteratorNext;


PROCEDURE ApplsOfDeclIteratorNext (self: ApplsOfDeclIterator): Token.T =
  VAR edge: DeclToApplEdge.T;

  BEGIN
    edge := self.iterator.next();
    IF (edge # NIL) THEN
      RETURN NARROW(edge.getTargetNode(), Token.T);
    ELSE
      RETURN NIL;
    END;
  END ApplsOfDeclIteratorNext;

BEGIN
END DeclGraph.
