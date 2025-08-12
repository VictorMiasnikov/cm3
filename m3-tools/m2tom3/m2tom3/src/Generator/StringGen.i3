INTERFACE StringGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:06:00
    StringGen.i3,v
# Revision 1.1  1994/11/30  15:06:00  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(* subsystem SourceGraph *)
IMPORT Token;
IMPORT SourceGraph;


PROCEDURE ConvertString (graph      : SourceGraph.T;
                         anchor     : SourceGraph.Anchor;
                         constString: Token.T             );
  (* Converts a string literal into a constant array of characters since
     Modula-3 otherwise interprets these literals as TEXT rather than ARRAY
     OF CHAR. *)

END StringGen.
