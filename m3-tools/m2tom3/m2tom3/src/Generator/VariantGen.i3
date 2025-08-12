INTERFACE VariantGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:06:13
    VariantGen.i3,v
# Revision 1.1  1994/11/30  15:06:13  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- VariantGen -------------------------------------------------------------
  * This functional module handles the transformation of variant records.
  * ----------------------------------------------------------------------------
  **)

IMPORT SourceGraph;
IMPORT Syntax;


PROCEDURE IsVariantRecord (graph: SourceGraph.T; recordType: Syntax.T):
  BOOLEAN;
  (* Checks whether a record type is variant or not. *)


PROCEDURE FlatRecord (graph     : SourceGraph.T;
                      unit      : SourceGraph.Anchor;
                      recordType: Syntax.T;
                      inWork    : BOOLEAN             );
  (* Transforms a variant record into a 'flat' record.  A flat record
     contains all variant parts occupying an own memory place.  All
     applying occurences of variant fields will be marked as 'warning:
     applying of variant field'. *)

END VariantGen.
