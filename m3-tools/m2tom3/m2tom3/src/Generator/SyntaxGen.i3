INTERFACE SyntaxGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Juergen Goebbels                                          *)

(** pk
    1.1
    1994/11/30 15:06:03
    SyntaxGen.i3,v
# Revision 1.1  1994/11/30  15:06:03  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT SourceGraph, UnitAnchor;


(* adds Modula-3 token to graph,for example appends token INTERFACE behind
   the Modula-2 token DEFINITION MODULE *)
PROCEDURE AppendM3toM2Syntax (graph: SourceGraph.T; anchor: UnitAnchor.T);

END SyntaxGen.
