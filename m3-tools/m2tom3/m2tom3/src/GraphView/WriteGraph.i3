INTERFACE WriteGraph;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Thomas Stockheim                                          *)

(** pk
    1.1
    1994/11/30 15:06:56
    WriteGraph.i3,v
# Revision 1.1  1994/11/30  15:06:56  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT BaseNode, SourceGraph;


PROCEDURE WriteGrl (graph          : SourceGraph.T;
                    filename       : TEXT;
                    node           : BaseNode.T;
                    depth          : CARDINAL;
                    dumpRestriction: BOOLEAN        );

END WriteGraph.
