INTERFACE ADRGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Peter Klein                                               *)

(** pk
    1.1
    1994/11/30 15:04:31
    ADRGen.i3,v
# Revision 1.1  1994/11/30  15:04:31  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT SourceGraph, Token;


PROCEDURE HandleADR (graph : SourceGraph.T;
                     anchor: SourceGraph.Anchor;
                     token : Token.T             );
  (* Correct ADR computation if parameter is an array. *)

END ADRGen.
