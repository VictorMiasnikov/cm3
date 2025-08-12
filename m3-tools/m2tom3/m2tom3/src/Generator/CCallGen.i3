INTERFACE CCallGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Kai Michael Degner                                        *)

(** pk
    1.1
        RemoveCcall(graph, anchor, token);
    1994/11/30 15:04:43
    CCallGen.i3,v
# Revision 1.1  1994/11/30  15:04:43  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- CCallGen----------------------------------------------------------------
  * Functional module to handle Modula-2 procedure CCALL.
  * ----------------------------------------------------------------------------
  **)

IMPORT SourceGraph;
IMPORT Token;


PROCEDURE HandleCCall (graph : SourceGraph.T;
                       anchor: SourceGraph.Anchor;
                       ccall : Token.T             );
  (* This procedure must be called on the Identifier CCALL.  It changes the
     statement to call the appropriate procedure of module CCALL. *)

END CCallGen.
