INTERFACE ImportClosure;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Kai Michael Degner                                        *)

(** pk
    1.1
    1994/11/30 15:03:47
    ImportClosure.i3,v
# Revision 1.1  1994/11/30  15:03:47  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- ImportClosure ----------------------------------------------------------
  * This functional module builds the transitive closure of all imports needed
  * by identifier linkage to get type information on imported identifiers.
  *
  * A callback procedure is needed which scans and parse a new unit.
  *
  * A make order on all needed units is established.
  * ----------------------------------------------------------------------------
  **)

IMPORT SourceGraph, Pathname;


TYPE
  (** --- ReadProc----------------------------------------------------------------
    * The type of the needed callback procedure.
    *
    * The procedure scans and parses a new unit which is given by its unit name.
    * Parameters isDef, isWork specify whether the unit is definition or
    * implementation unit and whether the unit will be converted into Modula-3
    * or not.
    * It returns a valid UnitAnchor if no error occured, NIL otherwise.
    * ----------------------------------------------------------------------------
    **)
  ReadProc =
    PROCEDURE
      (graph: SourceGraph.T; name: Pathname.T; isDef, isWork: BOOLEAN):
      SourceGraph.Anchor RAISES ANY;


(** --- MakeImportClosure-------------------------------------------------------
  * This procedure makes the transitive closure over all imports needed by the
  * given unit.
  *
  * A make order is established over all needed units including the given one.
  *
  * Graph specifies the aktual graph, the closure is made over the imports of
  * unit. The procedure readUnit scanns and parses a new unit. (see typ
  * ReadProc for further information.)
  *
  * Exception TokenGraph.NoAnchor will be raised if unit is not a valid anchor.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE MakeImportClosure (graph   : SourceGraph.T;
                             unit    : SourceGraph.Anchor;
                             readUnit: ReadProc            ) RAISES ANY;

END ImportClosure.
