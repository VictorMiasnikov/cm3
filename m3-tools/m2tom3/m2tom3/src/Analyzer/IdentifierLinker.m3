MODULE IdentifierLinker;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.7
    1995/02/14 12:16:33
    IdentifierLinker.m3,v
# Revision 1.7  1995/02/14  12:16:33  pk
# Some unnecessary exception handling removed.
#
# Revision 1.6  1995/01/25  15:26:56  pk
# Finding a decl for an appl now immediately terminates if the we are
# looking for a predefined type (should speed things up a bit).
#
# Revision 1.5  1995/01/25  15:16:29  pk
# Last solution for the WITH problem was buggy. Now recursion is only
# terminated if the identifier appeared inside a WITH statement.
#
# Revision 1.4  1995/01/19  14:26:35  pk
# Inside a WITH statement for a record variable whose type is imported,
# the scope of the imported interface overrode the module's scope
# (thanks to Rodney Bates).
#
# The problem is that the identifier linker first searched the scope
# introduced by the RECORD type definition (thereby entering the scope
# of the definition module), and when he couldn't find the definition
# there, he recursively tried the record definition's server scope,
# which is the interface. Now, the recursion is terminated if the search
# started at a record scope, so that a new recursion starts in the
# original scope of the WITH statement.
#
# I suspect that the same problem can be triggered by other situations,
# but I can't think of one right now.
#
# Revision 1.3  1995/01/17  14:21:43  pk
# New check prevents crash if non-records are qualified (thanks to
# Rodney Bates).
#
# Revision 1.2  1995/01/17  10:05:36  pk
# Type change from Syntax to Symbol avoids NARROW fault on WITH
# statements with simple typed identifiers (thanks to Rodney Bates).
#
# Revision 1.1  1994/11/30  15:03:43  pk
# Release Version 2.00.
#
*)
(***************************************************************************)


(** --- IdentifierLinker -------------------------------------------------------
  * This functional module is highly dependent on the underlying grammar,
  * here the copper-grammar!
  *
  * Please beware:
  *  - in this module we distuinguish between 'abstract' and 'real'
  *    types and the type's name itself.
  *  - for predefined types (see module Standard, procedure IsPredefindedType)
  *    the applying identifier is regarded to be the real type as well as its
  *    type name.
  *
  * The global variable firstPass is used
  *   - to assure only one pass of the main procedure LinkIdentifiersOfGraph
  *   - to skip the reverse linking in later passes.
  *
  * Convention for all procedures:
  *   they should return NIL only if they aren't able to determine a result
  *   because of missing links. If a procedure isn't able to handle a
  *   construct because of changed grammar or obviously missing case rule
  *   (procedure internal error) it should terminate the program immediately.
  *
  * to do:
  *   (LinkClientToServer) don't know how to handle export scopes.
  *   (FindDesignatorServer) don't know how to handle export scopes.
  *   (FindTypeOfDecl) handling of decl in ConstList not implemented.
  * ----------------------------------------------------------------------------
  **)

(* subsystem SourceGraph *)
IMPORT BaseGraph;
IMPORT Symbol;
IMPORT Token, TokenGraph;
IMPORT Syntax, SyntaxSupport;
IMPORT MakeGraph;
IMPORT DeclGraph, ServerToClientEdge;
IMPORT SourceGraph;

(* subsystem Analyzer *)
IMPORT ScopeQueue;
IMPORT Standard;

(* subsystem Utilities *)
IMPORT Message;

(* other stuff *)
IMPORT Text;


CONST
  High = ServerToClientEdge.Priority.High;
  Low  = ServerToClientEdge.Priority.Low;

  AllScopes = Symbol.KindSet{
                Symbol.Kind.SyntaxEnvScope, Symbol.Kind.SyntaxPublicScope,
                Symbol.Kind.SyntaxDefinitionScope,
                Symbol.Kind.SyntaxPrivateScope,
                Symbol.Kind.SyntaxProgramScope,
                Symbol.Kind.SyntaxFormalScope,
                Symbol.Kind.SyntaxQEntryScope,
                Symbol.Kind.SyntaxUEntryScope,
                Symbol.Kind.SyntaxImportScope,
                Symbol.Kind.SyntaxExportScope,
                Symbol.Kind.SyntaxModuleScope,
                Symbol.Kind.SyntaxOuterScope, Symbol.Kind.SyntaxInnerScope,
                Symbol.Kind.SyntaxExtraScope,
                Symbol.Kind.SyntaxRecordScope,
                Symbol.Kind.SyntaxEnumerationScope,
                Symbol.Kind.SyntaxWithScope,
                Symbol.Kind.SyntaxDesignatorScope,
                Symbol.Kind.SyntaxSubscriptionScope,
                Symbol.Kind.SyntaxQualificationScope};

  OutermostScopes = Symbol.KindSet{Symbol.Kind.SyntaxEnvScope,
                                   Symbol.Kind.SyntaxPublicScope,
                                   Symbol.Kind.SyntaxPrivateScope};


VAR firstPass: BOOLEAN := TRUE;


(** --- LogMessage -------------------------------------------------------------
  * Find corresponding token to symbol and transmit the message.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE LogMessage (graph   : SourceGraph.T;
                      position: Symbol.T;
                      code    : Message.Code   ) =
  VAR t: Symbol.T;

  BEGIN
    IF (ISTYPE(position, Token.T)) THEN
      t := position;
    ELSE
      t := SyntaxSupport.FindLeftmostToken(graph, position);
    END;
    Message.Write(graph := graph, token := t, code := code);
  END LogMessage;


(** --- LinkIdentifiersOfGraph -------------------------------------------------
  * Calls LinkIdentifiersOfUnit for all units in the graph.
  *
  * This must be done in make order.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE LinkIdentifiersOfGraph (graph: SourceGraph.T) =
  VAR
    unit: SourceGraph.Anchor;
    i   : MakeGraph.MakeIterator;

  BEGIN
    <* ASSERT (firstPass) *>
    firstPass := FALSE;

    i := graph.iterateMakes();
    unit := i.next();

    WHILE (unit # NIL) DO
      Message.Write(code := Message.Code.None,
                    info := "\tlinking identifiers of file "
                              & unit.getName() & unit.getSuffix());
      LinkIdentifiersOfUnit(graph, unit);
      unit := i.next();
    END;
  END LinkIdentifiersOfGraph;


(** --- LinkIdentifiersOfUnit --------------------------------------------------
  * Links all identifiers of this unit.
  *
  * The works is done with 3 phases:
  *  (1) linking declaring idents to scopes,
  *  (2) linking client scopes to server scopes and finally
  *  (3) linking applying idents to declaring idents via scopes.
  *
  * Phase (1) can be done immediate on the token stream.
  * Phases (2) and (3) are relating to each other, they start with the
  * environment scope.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE LinkIdentifiersOfUnit (graph : SourceGraph.T;
                                 anchor: SourceGraph.Anchor) =
  <* FATAL BaseGraph.NodeNotInGraph *>

  (** --- LinkDeclToScope ------------------------------------------------------
    * Links all declaring identifiers of the token stream, connected to anchor,
    * to it's declaration scope. The needed declaration scope is the nearest
    * scope over the current token.
    * --------------------------------------------------------------------------
    **)
  PROCEDURE LinkDeclToScope (graph : SourceGraph.T;
                             anchor: SourceGraph.Anchor) =
    <* FATAL TokenGraph.NoAnchor, BaseGraph.NodeNotInGraph,
             BaseGraph.EdgeInGraph *>

    VAR
      token    : Token.T;
      declScope: Syntax.T;

    BEGIN
      token := graph.getFirstToken(anchor, Token.Language.M2);
      WHILE (token # NIL) DO
        IF ((token.getKind() = Symbol.Kind.Identifier)
              AND (Token.Usage.Decl IN token.getUsageSet())) THEN
          declScope := FindSurroundingScope(graph, token);
          IF (declScope # NIL) THEN
            graph.insertScopeToDeclEdge(declScope, token);
          END;
        END;
        token := graph.getNextToken(token, Token.Language.M2);
      END;
    END LinkDeclToScope;

  (* LinkIdentifiersOfUnit *)
  BEGIN
    LinkDeclToScope(graph, anchor);
    LinkScopesAndAppls(graph, graph.getEnvScope(), graph.getRoot(anchor));
  END LinkIdentifiersOfUnit;


(** --- FindSurroundingScope ---------------------------------------------------
  * Search the nearest parent node of an arbitrary symbol node which is also a
  * scope. This may be the node itself!
  *
  * If no surrounding scope can be found by searching up to the root the
  * environment scope will be returned.
  *
  * (This function is exported)
  * ----------------------------------------------------------------------------
  **)
PROCEDURE FindSurroundingScope (graph: SourceGraph.T; s: Symbol.T):
  Syntax.T =
  <* FATAL BaseGraph.NodeNotInGraph *>

  VAR result: Symbol.T;

  BEGIN
    result := s;
    WHILE ((result # NIL) AND NOT (result.getKind() IN AllScopes)) DO
      result := graph.getParentSyntax(result);
    END;

    IF (result = NIL) THEN
      RETURN graph.getEnvScope();
    ELSE
      RETURN NARROW(result, Syntax.T);
    END;
  END FindSurroundingScope;


(** --- LinkScopesAndAppls -----------------------------------------------------
  * Doing phases (2) and (3) of linking; see LinkIdentifiersOfUnit.
  *
  * Calling this procedure assumes that the surrounding scope is already
  * completly bound. Assuming this it is possible to do phase (3),
  * binding all applying identifiers in the actual scope. Now, if needed,
  * triggers for included scopes are also bound and phase (2) - linking client
  * scopes to server scopes - can be done. Having finished this the procedure
  * will work on the included scopes.
  *
  * If argument root is NIL the procedure assumes the argument scope denoting
  * the root of the syntax tree to be scanned and linked.
  *
  * Special cases:
  *  - Import scopes must be linked to its surrounding scope before
  *    realizing phase (2) on the surrounding scope (resp. on the declaration
  *    part of the surrounding scope) itself.
  *    It follows that after having found all import scopes they are
  *    immediatly bound.
  *
  *    PROBLEM: what about local modules?
  *
  *  - Because of recursion (ReverseLinkScopesAndAppls) it is required to
  *    check if included scopes are already bound.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE LinkScopesAndAppls (graph: SourceGraph.T;
                              scope: Syntax.T;
                              root : Syntax.T        := NIL) =
  CONST
    PreferedScopes = Symbol.KindSet{Symbol.Kind.SyntaxImportScope,
                                    Symbol.Kind.SyntaxEnumerationScope,
                                    Symbol.Kind.SyntaxQEntryScope,
                                    Symbol.Kind.SyntaxUEntryScope};

  VAR
    i         : SyntaxSupport.SyntaxTreeIterator;
    symbol    : Symbol.T;
    scopeQueue: ScopeQueue.T;

  (** --- LinkDeclToAppl -------------------------------------------------------
    * Links applying identifier to its declaring identifier if it can be
    * found.
    * --------------------------------------------------------------------------
    **)
  PROCEDURE LinkDeclToAppl (graph: SourceGraph.T;
                            scope: Syntax.T;
                            appl : Token.T        ) =
    <* FATAL BaseGraph.EdgeInGraph, BaseGraph.NodeNotInGraph *>

    BEGIN
      WITH decl = FindDeclOfAppl(graph, scope, appl) DO
        IF (decl # NIL) THEN graph.insertDeclToApplEdge(decl, appl); END;
      END;
    END LinkDeclToAppl;

  (* LinkScopesAndAppls *)
  BEGIN
    (* linking applying idents and save included scopes for later
       linking *)
    scopeQueue := NEW(ScopeQueue.T).init();

    IF (root = NIL) THEN root := scope; END;
    i := NEW(SyntaxSupport.SyntaxTreeIterator).init(graph, root);
    symbol := i.next();

    WHILE (symbol # NIL) DO
      IF (symbol.getKind() IN AllScopes) THEN
        IF (symbol.getKind() IN PreferedScopes) THEN
          LinkClientToServer(graph, symbol, scope);
          LinkScopesAndAppls(graph, symbol);
        ELSE                     (* other scopes are now stored and handled
                                    later *)
          scopeQueue.append(symbol);
        END;
        symbol := i.skip()
      ELSIF ((symbol.getKind() = Symbol.Kind.Identifier)
               AND (Token.Usage.Appl
                      IN NARROW(symbol, Token.T).getUsageSet())) THEN
        LinkDeclToAppl(graph, scope, symbol);
        symbol := i.next();
      ELSE                       (* other stuff *)
        symbol := i.next();
      END;
    END;

    (* linking saved scopes and working recursivly on them too *)
    WHILE (NOT (scopeQueue.isEmpty())) DO
      symbol := scopeQueue.takeFirst();
      IF ((NOT (IsBound(graph, symbol)))
            OR (symbol.getKind() IN OutermostScopes)) THEN
        LinkClientToServer(graph, symbol, scope);
        LinkScopesAndAppls(graph, symbol);
      END;
    END;
  END LinkScopesAndAppls;


(** --- FindDeclOfAppl -------------------------------------------------------
  * Finds the declaring identifier of the applying occurence.
  *
  * First, this function searchs trough the actual scopes, if no decl is
  * found or if appl is also decl the ClientToServer edges are used to
  * search through a propagated scope for decl.
  *
  * A declaring ident may be contained in the closure of a server connected be
  * high or low high priority. In the second step first all high priority
  * servers and then all low priority servers are searched trough.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE FindDeclOfAppl (graph        : SourceGraph.T;
                          scope        : Syntax.T;
                          appl         : Token.T;
                          propagateOnly                  := FALSE):
  Token.T =
  VAR decl: Token.T;

  (** --- FindDeclInScope ------------------------------------------------------
    * Tries to find a declaring identifier corresponding to the given
    * applying identifier within this scope.
    * --------------------------------------------------------------------------
    **)
  PROCEDURE FindDeclInScope (graph: SourceGraph.T;
                             scope: Syntax.T;
                             appl : Token.T        ): Token.T =
    <* FATAL BaseGraph.NodeNotInGraph *>

    VAR
      i   : DeclGraph.DeclsOfScopeIterator;
      decl: Token.T;

    BEGIN
      i := graph.iterateDeclsOfScope(scope);
      decl := i.next();

      WHILE (decl # NIL) DO
        IF (Text.Equal(decl.getText(), appl.getText())) THEN
          RETURN decl;
        END;
        decl := i.next();
      END;
      RETURN NIL;
    END FindDeclInScope;


  PROCEDURE FindDeclInClosure (graph        : SourceGraph.T;
                               scope        : Syntax.T;
                               appl         : Token.T;
                               priority     : ServerToClientEdge.Priority;
                               propagateOnly: BOOLEAN                      ):
    Token.T =
    <* FATAL BaseGraph.NodeNotInGraph *>

    VAR
      decl  : Token.T;
      server: Syntax.T;

    BEGIN
      (* trying to find decl in scope itself *)
      decl := FindDeclInScope(graph, scope, appl);
      IF ((decl # NIL) AND (decl # appl)) THEN RETURN decl; END;
      (*
        Trying to find decl in server with given priority scopes.
        This is done recursivly.
      *)
      IF ((scope.getKind() = Symbol.Kind.SyntaxRecordScope)
            AND (propagateOnly)) THEN
        (* propagateOnly means we got here from inside a WITH statement, so
           terminate recursion if the decl is not in the record *)
        RETURN NIL;
      END;
      WITH i = graph.iterateServersOfClient(scope, priority) DO
        server := i.next();
        WHILE (server # NIL) DO
          decl := FindDeclOfAppl(graph, server, appl, propagateOnly);
          IF (decl # NIL) THEN RETURN decl; END;
          server := i.next();
        END;
      END;
      RETURN NIL;
    END FindDeclInClosure;

  (* FindDeclOfAppl *)
  BEGIN
    IF (Standard.IsPredefinedType(graph, appl)) THEN RETURN NIL; END;
    IF (scope.getKind() = Symbol.Kind.SyntaxWithScope) THEN
      propagateOnly := TRUE;
    END;
    decl := FindDeclInClosure(graph, scope, appl, High, propagateOnly);
    IF (decl = NIL) THEN
      decl := FindDeclInClosure(graph, scope, appl, Low, propagateOnly);
    END;
    RETURN decl;
  END FindDeclOfAppl;


(** --- LinkClientToServer -----------------------------------------------------
  * Create all ClientToServer edges between the (inner) scope and its
  * client and/or server scopes.
  *
  * To get sure that a server scope is already bound when linking it to a
  * client it is neccessary to call ReverseLinkScopesAndAppls if the server
  * scope is different with the surrounding scope.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE LinkClientToServer (graph            : SourceGraph.T;
                              scope, surrounder: Syntax.T       ) =
  <* FATAL BaseGraph.EdgeInGraph, BaseGraph.NodeNotInGraph *>

  VAR tailList: Syntax.T;

  (** --- LinkEnumerationScopes ------------------------------------------------
    * Create all ClientToServer edges between an import scope and enumeration
    * scopes of imported enumeration types. In this way enumeration elements
    * will be imported imlitecitely.
    * --------------------------------------------------------------------------
    **)
  PROCEDURE LinkEnumerationScopes (graph      : SourceGraph.T;
                                   importScope: Syntax.T       ) =
    VAR identList: Syntax.T;

    (** --- TestAndLinkEnumeration ---------------------------------------------
      * Follows an ident to its declaring pendant (this will be done via
      * FindDeclOfAppl because the ident isn't bound yet). The declaring ident
      * will be checked if it's an enumeration type. It it is the related
      * enumeration scope will be linked to the import scope.
      * ------------------------------------------------------------------------
      **)
    PROCEDURE TestAndLinkEnumeration (applIdent: Token.T) =
      BEGIN
        WITH declType = FindRealType(graph, FindTypeOfDecl(
                                              graph, FindDeclOfAppl(
                                                       graph, importScope,
                                                       applIdent))) DO
          IF ((declType # NIL)
                AND (declType.getKind() = Symbol.Kind.SyntaxEnumeration)) THEN
            WITH enumScope = graph.getChildSymbol(
                               declType, 2,
                               Symbol.Kind.SyntaxEnumerationScope) DO
              graph.insertServerToClientEdge(enumScope, importScope, High);
            END;
          END;
        END;
      END TestAndLinkEnumeration;

    (* LinkEnumerationScopes *)
    BEGIN
      <* ASSERT (importScope.getKind () = Symbol.Kind.SyntaxImportScope) *>

      TestAndLinkEnumeration(
        graph.getChildSymbol(importScope, 1, Symbol.Kind.Identifier));

      identList := graph.getChildSymbol(
                     importScope, 2, Symbol.Kind.SyntaxDAIdentList);
      WHILE (0 < identList.getNoOfChildren()) DO
        TestAndLinkEnumeration(
          graph.getChildSymbol(identList, 2, Symbol.Kind.Identifier));
        identList := graph.getChildSymbol(
                       identList, 3, Symbol.Kind.SyntaxDAIdentList);
      END;
    END LinkEnumerationScopes;

  (* LinkClientToServer *)
  BEGIN
    CASE scope.getKind() OF
    | Symbol.Kind.SyntaxDefinitionScope, Symbol.Kind.SyntaxFormalScope,
        Symbol.Kind.SyntaxModuleScope, Symbol.Kind.SyntaxOuterScope,
        Symbol.Kind.SyntaxInnerScope, Symbol.Kind.SyntaxExtraScope,
        Symbol.Kind.SyntaxRecordScope,
        Symbol.Kind.SyntaxSubscriptionScope =>
        graph.insertServerToClientEdge(surrounder, scope, Low);

    | Symbol.Kind.SyntaxPrivateScope =>
      (*
        this scope has nor servers
        nor expicit clients to export something
      *)

    | Symbol.Kind.SyntaxPublicScope =>
        <* ASSERT surrounder.getKind () = Symbol.Kind.SyntaxEnvScope *>
        graph.insertServerToClientEdge(scope, surrounder, Low);

    | Symbol.Kind.SyntaxQEntryScope, Symbol.Kind.SyntaxUEntryScope =>
        graph.insertServerToClientEdge(graph.getEnvScope(), scope, Low);
        graph.insertServerToClientEdge(scope, surrounder, High);
      (*
        The entry scopes themselves are prefered so they will be bound
        immediatly after returning to LinkScopesAndAppls.
      *)

    | Symbol.Kind.SyntaxEnumerationScope =>
        graph.insertServerToClientEdge(scope, surrounder, High);
      (*
        An enumeration scope collects all enumeration elements of one
        enumeration type and serves other scopes, here its surrounder scope.
      *)

    | Symbol.Kind.SyntaxProgramScope =>
        graph.insertServerToClientEdge(surrounder, scope, Low);
        IF (IsImplementationModule(graph, scope)) THEN
          WITH trigger = FindImpliciteTrigger(graph, scope),
               server  = FindImpliciteServer(graph, trigger) DO
            IF (server # NIL) THEN
              IF (NOT (IsBound(graph, server))) THEN
                ReverseLinkScopesAndAppls(graph, server);
              END;
              graph.insertServerToClientEdge(server, scope, High);
            ELSE
              LogMessage(
                graph, trigger, Message.Code.NoInterfaceForImplementation);
            END;
          END;
        END;

    | Symbol.Kind.SyntaxImportScope =>
        WITH trigger = FindImportTrigger(graph, scope),
             server  = FindImportServer(graph, trigger) DO
          IF (server # NIL) THEN
            IF (NOT (IsBound(graph, server))) THEN
              ReverseLinkScopesAndAppls(graph, server);
            END;
            graph.insertServerToClientEdge(server, scope, High);
            LinkEnumerationScopes(graph, scope);
          ELSE
            LogMessage(graph, trigger, Message.Code.NoInterfaceForImport);
          END;
        END;

        (*
          The import scope itself will be bound immediately after returning to
          LinkScopesAndAppls so the required binding of the import scope as
          server can be omitted here.
        *)
        graph.insertServerToClientEdge(scope, surrounder, High);

    | Symbol.Kind.SyntaxExportScope =>
      (* don't know how to handle export scopes *)
      (* LogMessage(graph, scope, Message.Code.UnknownExport);*)

    | Symbol.Kind.SyntaxWithScope =>
        graph.insertServerToClientEdge(surrounder, scope, Low);

        WITH trigger = FindWithTrigger(graph, scope),
             server  = FindWithServer(graph, trigger) DO
          IF (server # NIL) THEN
            IF (NOT (IsBound(graph, server))) THEN
              ReverseLinkScopesAndAppls(graph, server);
            END;
            graph.insertServerToClientEdge(server, scope, High);
          ELSE
            LogMessage(graph, trigger, Message.Code.NoDesignatorServer);
          END;
        END;

    | Symbol.Kind.SyntaxDesignatorScope =>
        WITH trigger = FindDesignatorTrigger(graph, scope, tailList),
             server  = FindDesignatorServer(graph, trigger, tailList) DO
          IF (server # NIL) THEN
            IF (NOT (IsBound(graph, server))) THEN
              ReverseLinkScopesAndAppls(graph, server);
            END;
            graph.insertServerToClientEdge(server, scope, High);
          ELSE
            LogMessage(
              graph, trigger, Message.Code.WrongDesignatorQualification);
          END;
        END;

    | Symbol.Kind.SyntaxQualificationScope =>
        IF (0 < scope.getNoOfChildren()) THEN
          (*
            scope is not empty and therefore it is triggered
          *)
          WITH trigger = FindQualificationTrigger(graph, scope),
               server  = FindQualificationServer(graph, trigger) DO
            IF (server # NIL) THEN
              IF (NOT (IsBound(graph, server))) THEN
                ReverseLinkScopesAndAppls(graph, server);
              END;
              graph.insertServerToClientEdge(server, scope, High);
            ELSE
              LogMessage(graph, trigger, Message.Code.WrongQualification);
            END;
          END;
        ELSE                     (* 0 = scope.getNoOfChildren () *)
          (*
            scope is empty,
            previous ident is not a trigger,
            no work to do
          *)
        END;
    ELSE                         (* CASE scope.getKind () *)
      (* there shouldn't exist other unknown scopes *)
      <* ASSERT FALSE *>
    END;
  END LinkClientToServer;


(** --- IsBound ----------------------------------------------------------------
  * IsBound checks if the given scope is already bound.
  *
  * SPECIFIED SEMANTIC:
  *   A scopes is said to be bound if all neccessary incoming ServerToClient
  *   edges exist and the appls are tried to bound to their decls.
  *
  * IMPLEMENTED SEMANTIC:
  *   This procedure checks only if there is at least one incoming
  *   ServerToClient edge. Otherwise this procedure assumes that the outermost
  *   scope is always bound (this is true because of previous call
  *   LinkIdentifiersOfUnit).
  * ----------------------------------------------------------------------------
  **)
PROCEDURE IsBound (graph: SourceGraph.T; scope: Syntax.T): BOOLEAN =
  <* FATAL BaseGraph.NodeNotInGraph *>

  BEGIN
    RETURN ((scope.getKind() IN OutermostScopes)
              OR graph.existsToClientEdge(scope));
  END IsBound;


(** --- ReverseLinkScopesAndAppls ----------------------------------------------
  * This procedure is used to start the linking process on arbitrary
  * applying idents.
  *
  * To link the outside the normal linking procedure it is required to find
  * the outermost surrounding unbound scope. After binding this scope and
  * all included scopes the given applying ident should be bound also.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE ReverseLinkScopesAndAppls (graph: SourceGraph.T; node: Symbol.T) =
  <* FATAL BaseGraph.NodeNotInGraph *>

  VAR nodeScope, boundScope, unboundScope: Syntax.T;

  BEGIN
    nodeScope := FindSurroundingScope(graph, node);

    (* searching the nearest unbound scope *)
    boundScope := nodeScope;
    WHILE (NOT (IsBound(graph, boundScope))) DO
      unboundScope := boundScope;
      boundScope :=
        FindSurroundingScope(graph, graph.getParentSyntax(unboundScope));
    END;

    (* recursive linking unbound scope *)
    LinkClientToServer(graph, unboundScope, boundScope);
    LinkScopesAndAppls(graph, unboundScope);
    (*
      Now the previous unbound scope should be bounded
      but this can't be guaranteed!
    *)
  END ReverseLinkScopesAndAppls;


(** --- FindTypeOfType ---------------------------------------------------------
  * Searches the more simple component, abstract type of this constructed,
  * abstract type.
  *
  * Yet only some possible constructed types are handled:
  *   Type + PointerType,
  *   Type + ArrayType,                         (* fixed array *)
  *   Type + SetType
  *   FormalType                                (* open array *)
  *
  * (This function is exported)
  * ----------------------------------------------------------------------------
  **)
PROCEDURE FindTypeOfType (graph: SourceGraph.T; type: Syntax.T): Symbol.T =
  <* FATAL BaseGraph.NodeNotInGraph *>

  BEGIN
    CASE type.getKind() OF
    | Symbol.Kind.SyntaxPointerType =>
        RETURN graph.getChildSymbol(type, 3, Symbol.Kind.SyntaxType);

    | Symbol.Kind.SyntaxArrayType =>
        RETURN graph.getChildSymbol(type, 5, Symbol.Kind.SyntaxType);

    | Symbol.Kind.SyntaxSetType =>
        RETURN graph.getChildSymbol(type, 3, Symbol.Kind.SyntaxType);

    | Symbol.Kind.SyntaxFormalType =>
        IF 0 < NARROW(
                 graph.getChildSymbol(type, 1, Symbol.Kind.SyntaxArrayOpt),
                 Syntax.T).getNoOfChildren() THEN
          (* array option exists -> open array detected *)
          RETURN
            graph.getChildSymbol(type, 2, Symbol.Kind.SyntaxQualIdent);
        ELSE
          (*
            empty array option ->
            only qualified ident found but open array expected ->
            this is no legal argument for this procedure
          *)
          <* ASSERT FALSE *>
        END;
    ELSE                         (* CASE type.getKind () *)
      (* unknown 'type' node *)
      <* ASSERT FALSE *>
    END;
  END FindTypeOfType;


(** --- FindRealType -----------------------------------------------------------
  * Resolves an abstract type (e.g. Type, FormalType) to its construction
  * part giving the concrete type.
  *
  * This implies passing all language features like aliasing and importing.
  *
  * Possible results:
  *   Symbol.Kind.SyntaxProcedureType,
  *   Symbol.Kind.SyntaxPointerType,
  *   Symbol.Kind.SyntaxSetType,
  *   Symbol.Kind.SyntaxArrayType,              type: fixed array
  *   Symbol.Kind.SyntaxRecordType,
  *   Symbol.Kind.SyntaxEnumeration,
  *   Symbol.Kind.SyntaxSubrange,
  *   Symbol.Kind.SyntaxQualIdentOrSubrange     type: qualified subrange
  *   Symbol.Kind.SyntaxFormalType              type: open array
  *
  *   Symbol.Kind.SyntaxDefinitionModule,
  *   Symbol.Kind.SyntaxProgramModule,
  *   Symbol.Kind.SyntaxTypeOpt,                type: opaque type
  *   Symbol.Kind.SyntaxProcedureDefinition,
  *   Symbol.Kind.SyntaxModuleDeclaration,
  *   Symbol.Kind.SyntaxProcedureDeclaration,
  *   Symbol.Kind.SyntaxIdentifier              type: enumeration element or
  *                                                   predefined type
  * ? Symbol.Kind.SyntaxRelation                type: boolean
  *
  * (This function is exported)
  * ----------------------------------------------------------------------------
  **)
PROCEDURE FindRealType (graph: SourceGraph.T; type: Symbol.T): Symbol.T =
  <* FATAL BaseGraph.NodeNotInGraph *>

  PROCEDURE FindRealTypeOfSimple (graph      : SourceGraph.T;
                                  simpleChild: Syntax.T       ): Symbol.T =
    BEGIN
      CASE simpleChild.getKind() OF
      | Symbol.Kind.SyntaxEnumeration, Symbol.Kind.SyntaxSubrange =>
          RETURN simpleChild

      | Symbol.Kind.SyntaxQualIdentOrSubrange =>
          IF (0 < NARROW(graph.getChildSymbol(
                           simpleChild, 2, Symbol.Kind.SyntaxSubrangeOpt),
                         Syntax.T).getNoOfChildren()) THEN
            (* optional subrange exists -> subrange type detected *)
            RETURN simpleChild;
          ELSE
            (* empty subrange option -> qualified ident detected *)
            RETURN
              FindTypeOfQualIdent(
                graph, graph.getChildSymbol(
                         simpleChild, 1, Symbol.Kind.SyntaxQualIdent));
          END;
      ELSE
        (* unknown right hand side of rule SimpleType *)
        <* ASSERT FALSE *>
      END
    END FindRealTypeOfSimple;

  (* FindRealType *)
  BEGIN
    IF (type = NIL) THEN RETURN NIL; END;

    CASE type.getKind() OF
    |                            (* these types are already real types *)
      Symbol.Kind.SyntaxProcedureDefinition,
        Symbol.Kind.SyntaxModuleDeclaration,
        Symbol.Kind.SyntaxProcedureDeclaration,
        Symbol.Kind.SyntaxDefinitionModule,
        Symbol.Kind.SyntaxProgramModule, Symbol.Kind.SyntaxTypeOpt =>
        RETURN type;

    | Symbol.Kind.Identifier =>
        (* enumeration element or predefined type*)
        RETURN type;

    | Symbol.Kind.SyntaxQualIdent =>
        RETURN FindTypeOfQualIdent(graph, type);

    | Symbol.Kind.SyntaxType =>
        CASE graph.getChildSymbol(type, 1).getKind() OF
        | Symbol.Kind.SyntaxProcedureType, Symbol.Kind.SyntaxPointerType,
            Symbol.Kind.SyntaxSetType, Symbol.Kind.SyntaxArrayType,
            Symbol.Kind.SyntaxRecordType =>
            RETURN graph.getChildSymbol(type, 1);

        | Symbol.Kind.SyntaxSimpleType =>
            RETURN
              FindRealTypeOfSimple(
                graph, graph.getChildSymbol(
                         graph.getChildSymbol(
                           type, 1, Symbol.Kind.SyntaxSimpleType), 1));

        ELSE
          (* unknown right hand side of rule Type *)
          <* ASSERT FALSE *>
        END;

    | Symbol.Kind.SyntaxFormalType =>
        IF (0 < NARROW(
                  graph.getChildSymbol(type, 1, Symbol.Kind.SyntaxArrayOpt),
                  Syntax.T).getNoOfChildren()) THEN
          (* array option exists -> open array detected *)
          RETURN type;
        ELSE
          (* empty array option -> only qualified ident detected *)
          RETURN FindTypeOfQualIdent(
                   graph, graph.getChildSymbol(
                            type, 2, Symbol.Kind.SyntaxQualIdent));
        END;
    ELSE
      (* unknown 'type' node *)
      <* ASSERT FALSE *>
    END
  END FindRealType;


(** --- FindTypeOfQualIdent ----------------------------------------------------
  * Finds the type of the whole qualified ident,
  * that is the type of the last ident part.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE FindTypeOfQualIdent (graph: SourceGraph.T; qualIdent: Syntax.T):
  Symbol.T =
  <* FATAL BaseGraph.NodeNotInGraph *>

  VAR
    lastIdent: Token.T;
    qualScope: Syntax.T;

  BEGIN
    (* argument should be a qualified ident *)
    <* ASSERT qualIdent.getKind () = Symbol.Kind.SyntaxQualIdent *>
    lastIdent :=
      graph.getChildSymbol(qualIdent, 1, Symbol.Kind.Identifier);
    qualScope := graph.getChildSymbol(
                   qualIdent, 2, Symbol.Kind.SyntaxQualificationScope);
    WHILE (0 < qualScope.getNoOfChildren()) DO
      lastIdent :=
        graph.getChildSymbol(qualScope, 2, Symbol.Kind.Identifier);
      qualScope := graph.getChildSymbol(
                     qualScope, 3, Symbol.Kind.SyntaxQualificationScope);
    END;
    RETURN FindRealType(graph, FindTypeOfAppl(graph, lastIdent));
  END FindTypeOfQualIdent;


(** --- FindTypeName -----------------------------------------------------------
  * Finds the name of an abstract type.
  *
  * The result may be NIL if the type is anonymous.
  *
  * Return values:
  *   Symbol.Kind.SyntaxQualIdent
  *   Symbol.Kind.Identifier
  *
  * (This function is exported)
  * ----------------------------------------------------------------------------
  **)
PROCEDURE FindTypeName (graph: SourceGraph.T; type: Symbol.T): Symbol.T =
  <* FATAL BaseGraph.NodeNotInGraph *>

  PROCEDURE FindTypeNameOfSimple (graph      : SourceGraph.T;
                                  simpleChild: Syntax.T       ): Symbol.T =
    BEGIN
      CASE simpleChild.getKind() OF
      | Symbol.Kind.SyntaxEnumeration, Symbol.Kind.SyntaxSubrange =>
          (* anonymous type detected *)
          RETURN NIL;

      | Symbol.Kind.SyntaxQualIdentOrSubrange =>
          IF (0 < NARROW(graph.getChildSymbol(
                           simpleChild, 2, Symbol.Kind.SyntaxSubrangeOpt),
                         Syntax.T).getNoOfChildren()) THEN
            (* optional subrange exists -> anonymous subrange type
               detected *)
            RETURN NIL;
          ELSE
            (* empty subrange option -> qualified ident detected *)
            RETURN graph.getChildSymbol(
                     simpleChild, 1, Symbol.Kind.SyntaxQualIdent);
          END;
      ELSE
        (* unknown right hand side of rule SimpleType *)
        <* ASSERT FALSE *>
      END
    END FindTypeNameOfSimple;

  (* FindTypeName *)
  BEGIN
    IF (type = NIL) THEN RETURN NIL; END;

    CASE type.getKind() OF
    | Symbol.Kind.SyntaxQualIdent, Symbol.Kind.Identifier => RETURN type;

    | Symbol.Kind.SyntaxType =>
        CASE graph.getChildSymbol(type, 1).getKind() OF
        | Symbol.Kind.SyntaxProcedureType, Symbol.Kind.SyntaxPointerType,
            Symbol.Kind.SyntaxSetType, Symbol.Kind.SyntaxArrayType,
            Symbol.Kind.SyntaxRecordType =>
            (* anonymous type detected *)
            RETURN NIL;

        | Symbol.Kind.SyntaxSimpleType =>
            RETURN
              FindTypeNameOfSimple(
                graph, graph.getChildSymbol(
                         graph.getChildSymbol(
                           type, 1, Symbol.Kind.SyntaxSimpleType), 1));
        ELSE
          (* unknown right hand side of rule Type *)
          <* ASSERT FALSE *>
        END;

    | Symbol.Kind.SyntaxFormalType =>
        IF (0 < NARROW(
                  graph.getChildSymbol(type, 1, Symbol.Kind.SyntaxArrayOpt),
                  Syntax.T).getNoOfChildren()) THEN
          (* array option exists -> anonymous open array detected *)
          RETURN NIL;
        ELSE
          (* empty array option -> only qualified ident detected *)
          RETURN
            graph.getChildSymbol(type, 2, Symbol.Kind.SyntaxQualIdent);
        END;
    ELSE
      (* unknown 'type' node *)
      <* ASSERT FALSE *>
    END;
  END FindTypeName;


(** --- FindTypeOfAppl ---------------------------------------------------------
  * Finds the abstract type of the applying ident.
  *
  * If the applying ident denotes an predefined ident this is also the
  * seached type. Otherwise the type will be obtained by finding its declaring
  * ident and getting its abstract type. This require an already bound
  * applying ident which may start a recursive linking process.
  *
  * (This function is exported)
  * ----------------------------------------------------------------------------
  **)
PROCEDURE FindTypeOfAppl (graph: SourceGraph.T; appl: Token.T): Symbol.T =
  <* FATAL BaseGraph.NodeNotInGraph *>

  BEGIN
    (* appl is expected to be an applying identifier *)
    <* ASSERT Token.Usage.Appl IN appl.getUsageSet () *>

    IF (Standard.IsPredefinedType(graph, appl)) THEN
      RETURN appl;
    ELSE
      IF (firstPass
            AND (NOT (IsBound(graph, FindSurroundingScope(graph, appl))))) THEN
        ReverseLinkScopesAndAppls(graph, appl);
      END;
      RETURN FindTypeOfDecl(graph, graph.getDeclOfAppl(appl));
    END;
  END FindTypeOfAppl;


(** --- FindTypeOfDecl ---------------------------------------------------------
  * Follows the declaring identifier to its abstract type.
  *
  * (This function is exported)
  * ----------------------------------------------------------------------------
  **)
PROCEDURE FindTypeOfDecl (graph: SourceGraph.T; decl: Token.T): Symbol.T =
  <* FATAL BaseGraph.NodeNotInGraph *>

  VAR typeParent: Syntax.T;

  BEGIN
    IF (decl = NIL) THEN RETURN NIL; END;

    (* decl is expected to be an declaring identifier *)
    <* ASSERT Token.Usage.Decl IN decl.getUsageSet () *>

    (* Check if identifier is as well applying as declaring *)
    IF (Token.Usage.Appl IN decl.getUsageSet()) THEN
      RETURN FindTypeOfAppl(graph, decl);
    END;

    typeParent := graph.getParentSyntax(decl);

    (* if decl is in a DIdentList search the relevant parent node *)
    WHILE (typeParent.getKind() = Symbol.Kind.SyntaxDIdentList) DO
      typeParent := graph.getParentSyntax(typeParent);
    END;

    CASE typeParent.getKind() OF
    | Symbol.Kind.SyntaxProcedureDefinition,
        Symbol.Kind.SyntaxModuleDeclaration,
        Symbol.Kind.SyntaxProcedureDeclaration =>
        RETURN typeParent;

    | Symbol.Kind.SyntaxPublicScope =>
        RETURN graph.getParentSyntax(
                 typeParent, Symbol.Kind.SyntaxDefinitionModule);

    | Symbol.Kind.SyntaxPrivateScope =>
        RETURN graph.getParentSyntax(
                 typeParent, Symbol.Kind.SyntaxProgramModule);

    | Symbol.Kind.SyntaxVarList =>
        RETURN graph.getChildSymbol(typeParent, 4, Symbol.Kind.SyntaxType);

    | Symbol.Kind.SyntaxTypeDeclarationList =>
        RETURN graph.getChildSymbol(typeParent, 3, Symbol.Kind.SyntaxType);

    | Symbol.Kind.SyntaxParameterSection =>
        RETURN graph.getChildSymbol(
                 typeParent, 5, Symbol.Kind.SyntaxFormalType);

    | Symbol.Kind.SyntaxSimpleField =>
        RETURN graph.getChildSymbol(typeParent, 4, Symbol.Kind.SyntaxType);

    | Symbol.Kind.SyntaxCaseField =>
        RETURN
          graph.getChildSymbol(typeParent, 4, Symbol.Kind.SyntaxQualIdent);

    | Symbol.Kind.SyntaxEnumerationScope =>
        (*
          Remember: decl points to an enumeration element when
          typeParent points to an enumeration scope node
        *)
        RETURN decl;

    | Symbol.Kind.SyntaxTypeOptList =>
        WITH typeOpt = graph.getChildSymbol(
                         typeParent, 2, Symbol.Kind.SyntaxTypeOpt) DO
          IF (0 < NARROW(typeOpt, Syntax.T).getNoOfChildren()) THEN
            (* optional type definition exists -> visible type detected *)
            RETURN
              graph.getChildSymbol(typeOpt, 2, Symbol.Kind.SyntaxType);
          ELSE
            (* empty type definition option -> opaque type detected *)
            RETURN typeOpt;
          END;
        END;

    | Symbol.Kind.SyntaxConstList =>
        (*
          This case will be not really handled yet,
          the returned value should be used to ignore this case.
        *)
        RETURN NIL;
    ELSE
      (* unknown type of decl *)
      <* ASSERT FALSE *>
    END
  END FindTypeOfDecl;


(** --- IsImplementationModule -------------------------------------------------
  * Checks if the given program scope is part of an implementation module.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE IsImplementationModule (graph: SourceGraph.T; scope: Syntax.T):
  BOOLEAN =
  <* FATAL BaseGraph.NodeNotInGraph *>

  BEGIN
    RETURN
      (NARROW(
         graph.getChildSymbol(
           graph.getParentSyntax(
             graph.getParentSyntax(scope, Symbol.Kind.SyntaxPrivateScope),
             Symbol.Kind.SyntaxProgramModule), 1,
           Symbol.Kind.SyntaxImplementationOpt), Syntax.T).getNoOfChildren()
         > 0);
  END IsImplementationModule;


(** --- FindImpliciteTrigger ---------------------------------------------------
  * Searches the module name of the program module as trigger to the related
  * interface module.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE FindImpliciteTrigger (graph: SourceGraph.T; scope: Syntax.T):
  Token.T =
  <* FATAL BaseGraph.NodeNotInGraph *>

  BEGIN
    RETURN
      NARROW(graph.getChildSymbol(graph.getParentSyntax(
                                    scope, Symbol.Kind.SyntaxPrivateScope),
                                  1, Symbol.Kind.Identifier), Token.T);
  END FindImpliciteTrigger;


(** --- FindImpliciteServer ----------------------------------------------------
  * Searches the interface module related to the "pseudo"-trigger.
  *
  * This trigger is said to be a pseudo trigger because you can't follow a
  * DeclToAppl edge to find the related interface. Instead of this the graph
  * method getUnit is used.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE FindImpliciteServer (graph: SourceGraph.T; trigger: Token.T):
  Syntax.T =
  <* FATAL BaseGraph.NodeNotInGraph *>

  VAR definitionUnit: SourceGraph.Anchor;

  BEGIN
    definitionUnit :=
      graph.getUnit(trigger.getText(), isDefinition := TRUE);

    IF (definitionUnit = NIL) THEN
      RETURN NIL;
    ELSE
      RETURN graph.getChildSymbol(
               graph.getChildSymbol(
                 graph.getChildSymbol(graph.getRoot(definitionUnit), 1,
                                      Symbol.Kind.SyntaxDefinitionModule),
                 4, Symbol.Kind.SyntaxPublicScope), 3,
               Symbol.Kind.SyntaxDefinitionScope);
    END;
  END FindImpliciteServer;


(** --- FindImportTrigger ------------------------------------------------------
  * Searches the trigger of an import scope, this is module name of the
  * interface to import.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE FindImportTrigger (graph: SourceGraph.T; scope: Syntax.T):
  Token.T =
  <* FATAL BaseGraph.NodeNotInGraph *>

  BEGIN
    RETURN graph.getChildSymbol(
             graph.getChildSymbol(
               graph.getParentSyntax(
                 scope, Symbol.Kind.SyntaxUnqualifiedImport), 2,
               Symbol.Kind.SyntaxUEntryScope), 1, Symbol.Kind.Identifier);
  END FindImportTrigger;


(** --- FindImportServer -------------------------------------------------------
  * Searches the server for an import.
  *
  * The server is expected to be an DefinitionScope or ModuleScope and will be
  * found when following the trigger to its declaring pendant.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE FindImportServer (graph: SourceGraph.T; trigger: Token.T):
  Syntax.T =
  <* FATAL BaseGraph.NodeNotInGraph *>

  BEGIN
    WITH type = FindRealType(graph, FindTypeOfAppl(graph, trigger)) DO
      IF (type = NIL) THEN RETURN NIL; END;

      CASE type.getKind() OF
      | Symbol.Kind.SyntaxDefinitionModule =>
          RETURN
            graph.getChildSymbol(
              graph.getChildSymbol(type, 4, Symbol.Kind.SyntaxPublicScope),
              3, Symbol.Kind.SyntaxDefinitionScope);

      | Symbol.Kind.SyntaxModuleDeclaration =>
          RETURN
            graph.getChildSymbol(type, 4, Symbol.Kind.SyntaxModuleScope);

      | Symbol.Kind.SyntaxProgramModule =>
          LogMessage(
            graph, trigger, Message.Code.TypeErrorImportFromProgram);
          RETURN NIL;
      ELSE
        (* unknown import server *)
        <* ASSERT FALSE *>
      END;
    END;
  END FindImportServer;


(** --- FindServerOfQualType ---------------------------------------------------
  * Searches the appropriate server scope to a type node determined by a
  * designation or qualification.
  *
  * The type should denote a record or module kind.
  * The specified trigger is used only for error messages.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE FindServerOfQualType (graph  : SourceGraph.T;
                                trigger: Token.T;
                                type   : Syntax.T       ): Syntax.T =
  <* FATAL BaseGraph.NodeNotInGraph *>

  BEGIN
    IF (type = NIL) THEN RETURN NIL; END;

    CASE type.getKind() OF
    | Symbol.Kind.SyntaxRecordType =>
        RETURN
          graph.getChildSymbol(type, 2, Symbol.Kind.SyntaxRecordScope);

    | Symbol.Kind.SyntaxDefinitionModule =>
        RETURN
          graph.getChildSymbol(
            graph.getChildSymbol(type, 4, Symbol.Kind.SyntaxPublicScope),
            3, Symbol.Kind.SyntaxDefinitionScope);

    | Symbol.Kind.SyntaxProgramModule =>
        RETURN
          graph.getChildSymbol(
            graph.getChildSymbol(type, 3, Symbol.Kind.SyntaxPrivateScope),
            3, Symbol.Kind.SyntaxProgramScope);

    | Symbol.Kind.SyntaxModuleDeclaration =>
        RETURN
          graph.getChildSymbol(type, 5, Symbol.Kind.SyntaxModuleScope);
    ELSE
      LogMessage(graph, trigger, Message.Code.TypeErrorInQualification);
      RETURN NIL;
    END
  END FindServerOfQualType;



(** --- FindDesignatorTrigger --------------------------------------------------
  * Searches for designator trigger.
  *
  * First this procedure goes up in the syntax tree to the
  * DesignatorTailList. From this point the previous identifier will be
  * treated as the searched trigger. The part of the designator tail list
  * between (!) the trigger and the scope will be return as tailList.
  *
  * This part may be empty if the scope is immediately prepended by its
  * qualifying identifier. In this case the return value of tailList becomes
  * NIL.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE FindDesignatorTrigger (    graph   : SourceGraph.T;
                                     scope   : Syntax.T;
                                 VAR tailList: Syntax.T       ): Token.T =
  <* FATAL BaseGraph.NodeNotInGraph *>

  CONST
    UpSet = Symbol.KindSet{Symbol.Kind.SyntaxReference,
                           Symbol.Kind.SyntaxSubscriptionScope};

  VAR
    listParent: Syntax.T;
    trigger   : Token.T;

  (** --- FindLastQualIdent-----------------------------------------------------
    *  Searches for last identifier in a QualIdentList.
    * --------------------------------------------------------------------------
    **)
  PROCEDURE FindLastQualIdent (graph: SourceGraph.T; qual: Syntax.T):
    Token.T =
    <* FATAL BaseGraph.NodeNotInGraph *>

    VAR
      lastIdent: Token.T;
      qualScope: Syntax.T;

    BEGIN
      lastIdent := graph.getChildSymbol(qual, 1, Symbol.Kind.Identifier);
      qualScope := graph.getChildSymbol(
                     qual, 2, Symbol.Kind.SyntaxQualificationScope);
      WHILE (qualScope.getNoOfChildren() > 0) DO
        lastIdent :=
          graph.getChildSymbol(qualScope, 2, Symbol.Kind.Identifier);
        qualScope := graph.getChildSymbol(
                       qualScope, 3, Symbol.Kind.SyntaxQualificationScope);
      END;
      RETURN lastIdent;
    END FindLastQualIdent;

  (* FindDesignatorTrigger *)
  BEGIN
    listParent :=
      graph.getParentSyntax(
        graph.getParentSyntax(
          graph.getParentSyntax(scope, Symbol.Kind.SyntaxDesignatorTail),
          Symbol.Kind.SyntaxDesignatorTailList));
    tailList := NIL;

    WHILE ((listParent.getKind() = Symbol.Kind.SyntaxDesignatorTailList)
             AND (NARROW(graph.getChildSymbol(
                           graph.getChildSymbol(
                             listParent, 1,
                             Symbol.Kind.SyntaxDesignatorTail), 1),
                         Symbol.T).getKind() IN UpSet)) DO
      tailList := listParent;
      listParent := graph.getParentSyntax(listParent);
    END;

    CASE listParent.getKind() OF
    | Symbol.Kind.SyntaxDesignatorTailList =>
        trigger := graph.getChildSymbol(
                     graph.getChildSymbol(
                       graph.getChildSymbol(
                         listParent, 1, Symbol.Kind.SyntaxDesignatorTail),
                       1, Symbol.Kind.SyntaxDesignatorScope), 2,
                     Symbol.Kind.Identifier);

    | Symbol.Kind.SyntaxDesignator =>
        trigger :=
          graph.getChildSymbol(listParent, 1, Symbol.Kind.Identifier);

    | Symbol.Kind.SyntaxCall =>
        trigger := FindLastQualIdent(
                     graph, graph.getChildSymbol(
                              graph.getParentSyntax(
                                graph.getParentSyntax(
                                  listParent, Symbol.Kind.SyntaxSetOrCall),
                                Symbol.Kind.SyntaxQualSetOrCall), 1,
                              Symbol.Kind.SyntaxQualIdent));
    ELSE
      <* ASSERT FALSE *>
    END;
    RETURN trigger;
  END FindDesignatorTrigger;


(** --- FindDesignatorServer ---------------------------------------------------
  * Searches for the server of a designator trigger.
  *
  * This procedure works simmilar to FindWithServer: first the type of the
  * trigger will be determined. Next the tailList and the type are
  * simultaneously traversed or followed respectively until the designator
  * scope in the tailList is  reached. Now the related type should point to a
  * record or module kind where the searched server scope is quite near.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE FindDesignatorServer (graph   : SourceGraph.T;
                                trigger : Token.T;
                                tailList: Syntax.T       ): Syntax.T =
  <* FATAL  BaseGraph.NodeNotInGraph *>

  VAR
    type              : Syntax.T;
    typeKind, tailKind: Symbol.Kind;
    exprList          : Syntax.T;

  BEGIN
    type := NARROW(FindRealType(graph, FindTypeOfAppl(graph, trigger)),
                   Syntax.T);

    IF (tailList # NIL) THEN
      WITH tail = graph.getChildSymbol(
                    graph.getChildSymbol(
                      tailList, 1, Symbol.Kind.SyntaxDesignatorTail), 1) DO
        tailKind := tail.getKind();
        IF (tailKind = Symbol.Kind.SyntaxSubscriptionScope) THEN
          exprList :=
            graph.getChildSymbol(
              tail, no := 3, expectedKind := Symbol.Kind.SyntaxExprList);
        END;
      END;
      WHILE ((type # NIL)
               AND (tailKind # Symbol.Kind.SyntaxDesignatorScope)) DO
        typeKind := type.getKind();
        IF
          (* Array *)
          (((typeKind = Symbol.Kind.SyntaxArrayType)
              AND (tailKind = Symbol.Kind.SyntaxSubscriptionScope)) OR

             (* Open Array *)
             ((typeKind = Symbol.Kind.SyntaxFormalType)
                AND (tailKind = Symbol.Kind.SyntaxSubscriptionScope)) OR

             (* Pointer *)
             ((typeKind = Symbol.Kind.SyntaxPointerType)
                AND (tailKind = Symbol.Kind.SyntaxReference))) THEN

          IF ((tailKind = Symbol.Kind.SyntaxSubscriptionScope)
                AND (exprList.getNoOfChildren() > 0)) THEN
            exprList := graph.getChildSymbol(
                          exprList, no := 3,
                          expectedKind := Symbol.Kind.SyntaxExprList);
          ELSE
            tailList :=
              graph.getChildSymbol(
                tailList, 2, Symbol.Kind.SyntaxDesignatorTailList);
            WITH tail = graph.getChildSymbol(
                          graph.getChildSymbol(
                            tailList, 1, Symbol.Kind.SyntaxDesignatorTail),
                          1) DO
              tailKind := tail.getKind();
              IF (tailKind = Symbol.Kind.SyntaxSubscriptionScope) THEN
                exprList := graph.getChildSymbol(
                              tail, no := 3,
                              expectedKind := Symbol.Kind.SyntaxExprList);
              END;
            END;
          END;
          type := FindRealType(graph, FindTypeOfType(graph, type));
        ELSE
          LogMessage(graph, trigger, Message.Code.TypeErrorInDesignator);
          RETURN NIL;
        END;
      END;
    END;
    RETURN FindServerOfQualType(graph, trigger, type);
  END FindDesignatorServer;


(** --- FindQualificationTrigger -----------------------------------------------
  * Searches the trigger of an qualification scope.
  *
  * The procedure searches up to the previous QualificationScope or
  * QualIdent. The identifier within this rules is the wanted trigger.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE FindQualificationTrigger (graph: SourceGraph.T; scope: Syntax.T):
  Token.T =
  <* FATAL BaseGraph.NodeNotInGraph *>

  VAR qualParent: Syntax.T;

  BEGIN
    qualParent := graph.getParentSyntax(scope);

    CASE qualParent.getKind() OF
    | Symbol.Kind.SyntaxQualificationScope =>
        RETURN graph.getChildSymbol(qualParent, 2, Symbol.Kind.Identifier);

    | Symbol.Kind.SyntaxQualIdent =>
        RETURN graph.getChildSymbol(qualParent, 1, Symbol.Kind.Identifier);
    ELSE
      (* unknown qualification context *)
      <* ASSERT FALSE *>
    END
  END FindQualificationTrigger;


(** --- FindQualificationServer ------------------------------------------------
  * Searches the related server scope to the given trigger.
  *
  * The wanted server can simply be found by getting the type of the trigger
  * and applying the procedure FindServerOfQualType to this.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE FindQualificationServer (graph: SourceGraph.T; trigger: Token.T):
  Syntax.T =
  BEGIN
    TYPECASE FindRealType(graph, FindTypeOfAppl(graph, trigger)) OF
      Syntax.T (qualType) =>
        RETURN FindServerOfQualType(graph, trigger, qualType);
    ELSE
      RETURN NIL;
    END;
  END FindQualificationServer;


(** --- FindWithTrigger --------------------------------------------------------
  * Last identifier in the designator must be the trigger.
  *
  * Trigger can't be NIL otherwise you should have received a ParseError
  *
  * (This function is exported)
  * ----------------------------------------------------------------------------
  **)
PROCEDURE FindWithTrigger (graph: SourceGraph.T; scope: Syntax.T):
  Token.T =
  <* FATAL BaseGraph.NodeNotInGraph *>

  VAR
    lastIdent       : Token.T;
    actualNode, tail: Syntax.T;

  BEGIN
    actualNode :=
      graph.getChildSymbol(
        graph.getParentSyntax(scope, Symbol.Kind.SyntaxWithStatement), 2,
        Symbol.Kind.SyntaxDesignator);
    lastIdent :=
      graph.getChildSymbol(actualNode, 1, Symbol.Kind.Identifier);
    actualNode := graph.getChildSymbol(
                    actualNode, 2, Symbol.Kind.SyntaxDesignatorTailList);

    WHILE (0 < actualNode.getNoOfChildren()) DO
      tail := graph.getChildSymbol(
                graph.getChildSymbol(
                  actualNode, 1, Symbol.Kind.SyntaxDesignatorTail), 1);
      IF (tail.getKind() = Symbol.Kind.SyntaxDesignatorScope) THEN
        lastIdent := graph.getChildSymbol(tail, 2, Symbol.Kind.Identifier);
      END;
      actualNode := graph.getChildSymbol(
                      actualNode, 2, Symbol.Kind.SyntaxDesignatorTailList);
    END;
    RETURN lastIdent;
  END FindWithTrigger;


(** --- FindWithServer ---------------------------------------------------------
  * Following simultaneously trough the designator tail behind the trigger and
  * the related type position to finally get the serving record scope.
  *
  * (This function is exported)
  * ----------------------------------------------------------------------------
  **)
PROCEDURE FindWithServer (graph: SourceGraph.T; trigger: Token.T):
  Syntax.T =
  <* FATAL BaseGraph.NodeNotInGraph *>

  VAR
    tailList, d       : Syntax.T;
    type              : Symbol.T;
    typeKind, tailKind: Symbol.Kind;
    exprList          : Syntax.T;

  BEGIN
    (* Find DesignatorTailList of trigger *)
    d := graph.getParentSyntax(trigger);
    CASE d.getKind() OF
    | Symbol.Kind.SyntaxDesignator =>
        tailList :=
          graph.getChildSymbol(d, 2, Symbol.Kind.SyntaxDesignatorTailList);

    | Symbol.Kind.SyntaxDesignatorScope =>
        tailList :=
          graph.getChildSymbol(
            graph.getParentSyntax(
              graph.getParentSyntax(d, Symbol.Kind.SyntaxDesignatorTail),
              Symbol.Kind.SyntaxDesignatorTailList), 2,
            Symbol.Kind.SyntaxDesignatorTailList);
    ELSE
      (* unknown grammar *)
      <* ASSERT FALSE *>
    END;

    IF (tailList.getNoOfChildren() > 0) THEN
      WITH tail = graph.getChildSymbol(
                    graph.getChildSymbol(
                      tailList, 1, Symbol.Kind.SyntaxDesignatorTail), 1) DO
        IF (tail.getKind() = Symbol.Kind.SyntaxSubscriptionScope) THEN
          exprList :=
            graph.getChildSymbol(
              tail, no := 3, expectedKind := Symbol.Kind.SyntaxExprList);
        END;
      END;
    END;

    (* Resolving array subsciptions and dereference pointers *)
    type := FindRealType(graph, FindTypeOfAppl(graph, trigger));
    WHILE ((type # NIL) AND (tailList.getNoOfChildren() > 0)) DO
      tailKind :=
        graph.getChildSymbol(
          graph.getChildSymbol(
            tailList, 1, Symbol.Kind.SyntaxDesignatorTail), 1).getKind();
      typeKind := type.getKind();

      IF
        (* Array *)
        (((typeKind = Symbol.Kind.SyntaxArrayType)
            AND (tailKind = Symbol.Kind.SyntaxSubscriptionScope)) OR

           (* Open Array *)
           ((typeKind = Symbol.Kind.SyntaxFormalType)
              AND (tailKind = Symbol.Kind.SyntaxSubscriptionScope)) OR

           (* Pointer *)
           ((typeKind = Symbol.Kind.SyntaxPointerType)
              AND (tailKind = Symbol.Kind.SyntaxReference))) THEN

        IF ((tailKind = Symbol.Kind.SyntaxSubscriptionScope)
              AND (exprList.getNoOfChildren() > 0)) THEN
          exprList := graph.getChildSymbol(
                        exprList, no := 3,
                        expectedKind := Symbol.Kind.SyntaxExprList);
        ELSE
          tailList := graph.getChildSymbol(
                        tailList, 2, Symbol.Kind.SyntaxDesignatorTailList);
          IF (tailList.getNoOfChildren() > 0) THEN
            WITH tail = graph.getChildSymbol(
                          graph.getChildSymbol(
                            tailList, 1, Symbol.Kind.SyntaxDesignatorTail),
                          1) DO
              IF (tail.getKind() = Symbol.Kind.SyntaxSubscriptionScope) THEN
                exprList := graph.getChildSymbol(
                              tail, no := 3,
                              expectedKind := Symbol.Kind.SyntaxExprList);
              END;
            END;
          END;
        END;
        type := FindRealType(graph, FindTypeOfType(graph, type));
      ELSE
        LogMessage(
          graph, trigger, Message.Code.TypeErrorInWithDifferentTypes);
        RETURN NIL;
      END;
    END;

    (*
      FindTypeOfAppl or FindTypeOfType may return NIL
      so we can't find a server
    *)
    IF (type = NIL) THEN RETURN NIL; END;

    (* type.kind should be Symbol.Kind.Record and tailList is empty *)
    IF (type.getKind() = Symbol.Kind.SyntaxRecordType) THEN
      RETURN graph.getChildSymbol(type, 2, Symbol.Kind.SyntaxRecordScope);
    ELSE
      LogMessage(
        graph, trigger, Message.Code.TypeErrorInWithRecordExpected);
      RETURN NIL;
    END;
  END FindWithServer;

BEGIN
END IdentifierLinker.
