INTERFACE ForGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Thomas Stockheim                                          *)

(** pk
    1.1
    1994/11/30 15:05:09
    ForGen.i3,v
# Revision 1.1  1994/11/30  15:05:09  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT Token;
IMPORT SourceGraph;


PROCEDURE ChangeToWhile (graph : SourceGraph.T;
                         anchor: SourceGraph.Anchor;
                         token : Token.T             );
  (* Transforms a FOR-statement to a semantic equivalent
     while-statement. *)

END ForGen.
