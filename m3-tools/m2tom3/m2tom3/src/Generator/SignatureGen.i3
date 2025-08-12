INTERFACE SignatureGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Kai Michael Degner                                        *)

(** pk
    1.2
    1995/02/14 15:36:53
    SignatureGen.i3,v
# Revision 1.2  1995/02/14  15:36:53  pk
# New InsertReadonly procedure makes call-by-value ARRAY parameters
# READONLY.
#
# Revision 1.1  1994/11/30  15:05:51  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT SourceGraph;
IMPORT Syntax;


PROCEDURE InsertEmptyParameterList (graph : SourceGraph.T;
                                    anchor: SourceGraph.Anchor;
                                    proc  : Syntax.T            );
  (* Inserts missing empty paratheses after a procedure declaration.  Call
     this procedure on every syntax tree node with kind
     SyntaxProcedureDeclaration or SyntaxProcedureDefinition. *)


PROCEDURE ChangeSemicolon (graph   : SourceGraph.T;
                           anchor  : SourceGraph.Anchor;
                           procDecl: Syntax.T            );
  (* Changes a ';' at the end of procedure declaration to a '=' needed in
     Modula-3.  Call this procedure on every syntax tree node with kind
     SyntaxProcedureDeclaration. *)


PROCEDURE ExtendProcedureType (graph   : SourceGraph.T;
                               anchor  : SourceGraph.Anchor;
                               procType: Syntax.T            );
  (* Extends a formal parameter list of a procedure type declaration by
     unique identifiers.  If procedure type has an empty parameter list
     '()' will be inserted if needed.  Call this procedure on every syntax
     tree node with kind ProcedureType. *)


PROCEDURE InsertReadonly (graph   : SourceGraph.T;
                          anchor  : SourceGraph.Anchor;
                          procType: Syntax.T            );
  (* Make all call-by-value ARRAYs READONLY. *)

END SignatureGen.
