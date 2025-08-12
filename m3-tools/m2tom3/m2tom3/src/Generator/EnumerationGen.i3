INTERFACE EnumerationGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:05:00
    EnumerationGen.i3,v
# Revision 1.1  1994/11/30  15:05:00  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT Syntax;
IMPORT SourceGraph;


PROCEDURE ChangeParentheses (graph: SourceGraph.T;
                             unit : SourceGraph.Anchor;
                             enum : Syntax.T            );
  (* Replace the parentheses '(' ')' of the enumeration declaration by
     bracets '{' '}'. *)


PROCEDURE QualifyEnumeration (graph: SourceGraph.T; enumType: Syntax.T);
  (* Prepending all applying enumeration element identifiers with its
     enumeration type name. *)

END EnumerationGen.
