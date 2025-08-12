INTERFACE BeginGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Alexander Poensgen                                        *)

(** pk
    1.1
    1994/11/30 15:04:39
    BeginGen.i3,v
# Revision 1.1  1994/11/30  15:04:39  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT Syntax;
IMPORT SourceGraph;


PROCEDURE InsertBegin (graph   : SourceGraph.T;
                       anchor  : SourceGraph.Anchor;
                       stateopt: Syntax.T            );
  (* This procedure inserts a missing BEGIN into the token stream.  In
     Modula-2 grammar a BEGIN statement is unnecessary if the statement
     sequence is empty (see rule Block of copper - grammar).  In Modula-3
     this BEGIN statement is obligatory.*)

END BeginGen.
