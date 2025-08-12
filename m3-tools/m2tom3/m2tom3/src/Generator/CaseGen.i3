INTERFACE CaseGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Kai Michael Degner                                        *)

(** pk
    1.1
    1994/11/30 15:04:53
    CaseGen.i3,v
# Revision 1.1  1994/11/30  15:04:53  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT Syntax;
IMPORT SourceGraph;


PROCEDURE ModifyCase (graph        : SourceGraph.T;
                      anchor       : SourceGraph.Anchor;
                      caseStatement: Syntax.T            );
  (* Converts Modula-2's ':' to Modula-3's '=>'. *)

END CaseGen.
