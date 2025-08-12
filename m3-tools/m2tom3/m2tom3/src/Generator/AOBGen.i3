INTERFACE AOBGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Peter Klein                                               *)

(** pk
    1.1
    1994/11/30 15:04:35
    AOBGen.i3,v
# Revision 1.1  1994/11/30  15:04:35  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT SourceGraph, Syntax;


PROCEDURE CastAOBs (graph : SourceGraph.T;
                    anchor: SourceGraph.Anchor;
                    symbol: Syntax.T            );
  (* If the procedure contains formal parameters of type ARRAY OF BYTE,
     loophole all actual parameters accordingly *)

END AOBGen.
