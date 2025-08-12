INTERFACE ActualToFormalType;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Peter Klein                                               *)

(** pk
    1.1
    1994/11/30 15:03:38
    ActualToFormalType.i3,v
# Revision 1.1  1994/11/30  15:03:38  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT SourceGraph, Syntax;


PROCEDURE Bind (graph: SourceGraph.T);
  (* Bind all actual procedure parameters (Expr) to their formal parameter
     type (FormalType). *)


PROCEDURE Get (graph: SourceGraph.T; actualParam: Syntax.T): Syntax.T;
  (* Returns the formal parameter type for actualParam or NIL if the
     procedure declaration is unknown. *)


PROCEDURE IterateActuals (graph: SourceGraph.T; formalType: Syntax.T):
  EdgeIterator;
  (* Returns an iterator over all actual parameter nodes which are bound to
     formalType. *)


TYPE
  EdgeIterator <: EdgeIteratorPublic;
  EdgeIteratorPublic = OBJECT METHODS next (): Syntax.T; END;

END ActualToFormalType.
