INTERFACE SourceGraph;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:08:35
    SourceGraph.i3,v
# Revision 1.1  1994/11/30  15:08:35  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT DeclGraph AS Super;
IMPORT UnitAnchor AS SuperAnchor;


TYPE
  T = Super.T;
  Anchor = SuperAnchor.T;

END SourceGraph.
