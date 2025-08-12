INTERFACE SimpleGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Kai Michael Degner                                        *)

(** pk
    1.1
    1994/11/30 15:05:55
    SimpleGen.i3,v
# Revision 1.1  1994/11/30  15:05:55  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- SimpleGen---------------------------------------------------------------
  * This functional module collects simple generations of Modula-3 syntax.
  * ----------------------------------------------------------------------------
  **)

IMPORT SourceGraph;


(** --- HandleSyntaxTree -------------------------------------------------------
  * This procedure iterates through the syntax tree, checks the kind of the
  * actual syntax node and calls if the check is successful a handling
  * procedure.
  *
  * You may insert your own check for your needed syntax node kind and call a
  * handling procedure which performs the desired transformations on the token
  * stream.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE HandleSyntaxTree (graph : SourceGraph.T;
                            anchor: SourceGraph.Anchor);

END SimpleGen.
