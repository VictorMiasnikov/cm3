INTERFACE IdentifierLinker;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:03:42
    IdentifierLinker.i3,v
# Revision 1.1  1994/11/30  15:03:42  pk
# Release Version 2.00.
#
*)
(***************************************************************************)


(** --- IdentifierLinker -------------------------------------------------------
  * This functional module supports functions to link declaring identifiers to
  * their related applying identifiers.
  *
  * Further this module exports some internal functions to analyse the graph
  * used for the linkage process which may be useful otherwhere.
  *
  * Please beware:
  *  - in this module we distuinguish between 'abstract' and 'real'
  *    types and the type's name itself.
  *  - for predefined types (see module Standard, procedure IsPredefindedType)
  *    the applying identifier is regarded to be the real type as well as its
  *    type name.
  *
  * ----------------------------------------------------------------------------
  **)

IMPORT SourceGraph;
IMPORT DeclGraph;
IMPORT Syntax;
IMPORT Token;
IMPORT Symbol;


(*
  --- `main` function ----------------------------------------------------------
*)
PROCEDURE LinkIdentifiersOfGraph (graph: DeclGraph.T);
  (* Links declaring identifiers in the whole graph to their applying
     identifiers by creating a DeclToScope edge between them (see
     DeclGraph). *)


(*
  --- graph navigation support -------------------------------------------------
*)
PROCEDURE FindSurroundingScope (graph: SourceGraph.T; s: Symbol.T):
  Syntax.T;
  (* Search the nearest parent node of an arbitrary symbol node which is
     also a scope.  This may be the node itself!  If no surrounding scope
     can be found by searching up to the root the environment scope will be
     returned. *)


(*
  --- type navigation support --------------------------------------------------
*)
PROCEDURE FindTypeOfAppl (graph: SourceGraph.T; appl: Token.T): Symbol.T;
  (* Finds the abstract type of the applying ident. *)


PROCEDURE FindTypeOfDecl (graph: SourceGraph.T; decl: Token.T): Symbol.T;
  (* Follows the declaring identifier to its abstract type. *)


PROCEDURE FindTypeOfType (graph: SourceGraph.T; type: Syntax.T): Symbol.T;
  (**
    Searches the more simple component, abstract type of this constructed,
    abstract type.
    Yet only some possible constructed types are handled:
      Type + PointerType,
      Type + ArrayType,                         (* fixed array *)
      Type + SetType
      FormalType                                (* open array *)
  **)


PROCEDURE FindRealType (graph: SourceGraph.T; type: Symbol.T): Symbol.T;
  (**
    Resolves an abstract type (e.g. Type, FormalType) to its construction
    part giving the concrete type.
    This implies passing all language features like aliasing and importing.
    Possible results:
      Symbol.Kind.SyntaxProcedureType,
      Symbol.Kind.SyntaxPointerType,
      Symbol.Kind.SyntaxSetType,
      Symbol.Kind.SyntaxArrayType,              type: fixed array
      Symbol.Kind.SyntaxRecordType,
      Symbol.Kind.SyntaxEnumeration,
      Symbol.Kind.SyntaxSubrange,
      Symbol.Kind.SyntaxQualIdentOrSubrange     type: qualified subrange
      Symbol.Kind.SyntaxFormalType              type: open array

      Symbol.Kind.SyntaxDefinitionModule,
      Symbol.Kind.SyntaxProgramModule,
      Symbol.Kind.SyntaxTypeOpt,                type: opaque type
      Symbol.Kind.SyntaxProcedureDefinition,
      Symbol.Kind.SyntaxModuleDeclaration,
      Symbol.Kind.SyntaxProcedureDeclaration,
      Symbol.Kind.SyntaxIdentifier              type: enumeration element or
                                                      predefined type
    ? Symbol.Kind.SyntaxRelation                type: boolean
  **)


PROCEDURE FindTypeName (graph: SourceGraph.T; type: Symbol.T): Symbol.T;
  (**
    Finds the name of an abstract type.
    The result may be NIL if the type is anonymous.
    Return values:
      Symbol.Kind.SyntaxQualIdent
      Symbol.Kind.Identifier
  **)


PROCEDURE FindWithTrigger (graph: SourceGraph.T; scope: Syntax.T): Token.T;
  (* Determines the trigger identifier of a with scope. *)


PROCEDURE FindWithServer (graph: SourceGraph.T; trigger: Token.T):
  Syntax.T;
  (* Following simultaneously trough the designator tail behind the trigger
     and the related type position to finally get the serving record scope.
     You may get NIL if the linkage chain between trigger and server is
     broken. *)

END IdentifierLinker.
