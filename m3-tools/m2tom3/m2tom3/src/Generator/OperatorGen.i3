INTERFACE OperatorGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Alexander Poensgen                                        *)

(** pk
    1.1
    1994/11/30 15:05:38
    OperatorGen.i3,v
# Revision 1.1  1994/11/30  15:05:38  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT Syntax;
IMPORT SourceGraph;


PROCEDURE HandleOperatorPrecedence (graph : SourceGraph.T;
                                    anchor: SourceGraph.Anchor;
                                    expr  : Syntax.T            );
  (* This procedure inserts missing brackets caused by different operator
     hierarchy.*)

END OperatorGen.
