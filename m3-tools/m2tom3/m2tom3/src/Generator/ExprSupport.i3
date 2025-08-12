INTERFACE ExprSupport;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Peter Klein                                               *)

(** pk
    1.1
    1994/11/30 15:05:05
    ExprSupport.i3,v
# Revision 1.1  1994/11/30  15:05:05  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT SourceGraph, Syntax, Token;


PROCEDURE GetQualIdentInExpr (graph: SourceGraph.T; expr: Syntax.T):
  Syntax.T;
  (* If expr contains only a QualIdent, return it.  If not, return NIL. *)


PROCEDURE GetQualIdentInConstExpr (graph    : SourceGraph.T;
                                   constExpr: Syntax.T       ): Syntax.T;
  (* If constExpr contains only a QualIdent, return it.  If not, return
     NIL. *)


PROCEDURE GetIdentInQualIdent (graph: SourceGraph.T; qualIdent: Syntax.T):
  Token.T;
  (* Returns the last ident in a QualIdent. *)

END ExprSupport.
