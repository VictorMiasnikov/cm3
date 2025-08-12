INTERFACE WithGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Thomas Stockheim                                          *)

(** pk
    1.1
    1994/11/30 15:06:16
    WithGen.i3,v
# Revision 1.1  1994/11/30  15:06:16  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT Token;
IMPORT SourceGraph;


PROCEDURE ChangeWith (graph : SourceGraph.T;
                      anchor: SourceGraph.Anchor;
                      token : Token.T             );
  (* Add an identifier to be designated by the common Modula-2 designator
     and qualify all field identifiers with this newly created
     designator. *)

END WithGen.
