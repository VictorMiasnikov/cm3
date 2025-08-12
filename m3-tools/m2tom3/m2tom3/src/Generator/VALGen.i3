INTERFACE VALGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Peter Klein                                               *)

(** pk
    1.1
    1994/11/30 15:06:10
    VALGen.i3,v
# Revision 1.1  1994/11/30  15:06:10  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT SourceGraph, Token;


PROCEDURE HandleVAL (graph : SourceGraph.T;
                     anchor: SourceGraph.Anchor;
                     val   : Token.T             );

END VALGen.
