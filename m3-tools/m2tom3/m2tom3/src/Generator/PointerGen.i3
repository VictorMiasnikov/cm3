INTERFACE PointerGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:05:46
    PointerGen.i3,v
# Revision 1.1  1994/11/30  15:05:46  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT Syntax;
IMPORT SourceGraph;


PROCEDURE ChangeToReference (graph      : SourceGraph.T;
                             anchor     : SourceGraph.Anchor;
                             pointerType: Syntax.T            );
  (* Changes the type definition of a pointer type: POINTER TO T ->
     UNTRACED BRANDED REF T *)

END PointerGen.
