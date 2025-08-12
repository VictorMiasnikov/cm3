INTERFACE ImportSupport;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Roland Baumann                                            *)

(** pk
    1.1
    1994/11/30 15:05:24
    ImportSupport.i3,v
# Revision 1.1  1994/11/30  15:05:24  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT SourceGraph;

(* This module provides a unified access to the import list of a scanned
   and parsed unit.  It supports other Generator modules, which have to
   insert or remove items from the import list of a module (and is part of
   the we-want-a-pretty-SyntaxGen-module movement).  All procedures take a
   graph, a unit anchor and two strings as argument.  The first string is
   the name of a Modula 2 module from which items should be imported.  The
   second string is optional and is the name of a specific item in an
   import list.  To avoid confusion: if you have to handle 'IMPORT M' you
   would call e.g.  IsImported(graph, anchor, M).  IF you have 'FROM M
   IMPORT x' it would be IsImported(graph, anchor, M, x). *)


PROCEDURE IsImported (g   : SourceGraph.T;
                      a   : SourceGraph.Anchor;
                      mod : TEXT;
                      item: TEXT                 := NIL): BOOLEAN
  RAISES {};
  (* IsImported checks if 'mod' is in the import list of the unit a in
     graph g.  if item is not NIL IsImported tries to find a sequence of
     the form 'FROM mod IMPORT ...  item ...' otherwise the sequence
     'IMPORT ...  mod' is searched. *)


PROCEDURE AddImport (g   : SourceGraph.T;
                     a   : SourceGraph.Anchor;
                     mod : TEXT;
                     item: TEXT                 := NIL) RAISES {};
  (* AddImport adds 'IMPORT mod' or 'FROM mod IMPORT item' to the import
     list depending on item being NIL or not.  AddImport only inserts an
     import to the list if the import does not already exist. *)


PROCEDURE RemoveImport (g   : SourceGraph.T;
                        a   : SourceGraph.Anchor;
                        mod : TEXT;
                        item: TEXT                 := NIL) RAISES {};
  (* RemoveImport removes an import from the import list of unit a in graph
     g.  If this leads to an empty import list (FROM mod IMPORT; or
     IMPORT;) this will be discrded, too. *)

END ImportSupport.
