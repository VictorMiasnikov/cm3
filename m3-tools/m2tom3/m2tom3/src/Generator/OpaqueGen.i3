INTERFACE OpaqueGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Kai Michael Degner                                        *)

(** pk
    1.1
    1994/11/30 15:05:33
    OpaqueGen.i3,v
# Revision 1.1  1994/11/30  15:05:33  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- OpaqueGen --------------------------------------------------------------
  * This functional module handles opaque types of Modula-2.
  * ----------------------------------------------------------------------------
  **)

IMPORT SourceGraph, Syntax;


PROCEDURE IsOpaqueType (type: Syntax.T): BOOLEAN;
  (* Checks whether type refers to an opaque type declaration or not. *)


PROCEDURE HandleOpaqueType (graph  : SourceGraph.T;
                            anchor : SourceGraph.Anchor;
                            typeOpt: Syntax.T            );

(* Converts a given opaque type and the corresponding definition.  This may
   only occure in definition modules.  It is checked whether type refers to
   a declaration of an opaque type or not.  An opaque type will only be
   handled if definition module has status isWork or if a corresponding
   implementation module exists.  Check the type definition in the
   corresponding implementation module if module is known.  Extend the type
   declaration to a Modula-3 opaque type declaration and reveal the type
   definition.

   Special case: Some Modula-2 compilers allows other types (integer,
   cardinal..) as an opaque type.  In this case opaque type is become
   public and type definition will be removed because Modula-3 doesn't
   allow other opaque types as pointers. *)

END OpaqueGen.
