INTERFACE CHRGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Kai Michael Degner                                        *)

(** pk
    1.1
    1994/11/30 15:04:47
    CHRGen.i3,v
# Revision 1.1  1994/11/30  15:04:47  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT SourceGraph;
IMPORT Token;


PROCEDURE HandleCHR (graph : SourceGraph.T;
                     anchor: SourceGraph.Anchor;
                     chr   : Token.T             );
  (* Changes CHR(...) to VAL(...,CHAR).  Call this procedure on every Token
     with Kind Identifier and Text 'CHR'. *)

END CHRGen.
