INTERFACE Scanner;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Robert Kiehne                                             *)

(** pk
    1.1
    1994/11/30 15:04:04
    Scanner.i3,v
# Revision 1.1  1994/11/30  15:04:04  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT TokenGraph;
IMPORT SourceGraph;


EXCEPTION
  IOError(TEXT);                 (* File not found, and other IOErrors *)
  GraphError;                    (* Any error while building Tokenstream -
                                    if this happens, there must be a bug in
                                    the data structures for TokenStream or
                                    BaseGraph ! *)


PROCEDURE Scan (fileName: TEXT;
                graph   : SourceGraph.T;
                anchor  : SourceGraph.Anchor)
  RAISES {IOError, GraphError, TokenGraph.NoAnchor};
  (* Procedure Scan generates a token stream from a text file.  SourceGraph
     and TokenAnchor have to be created and initalized in the calling
     programm. *)

END Scanner.
