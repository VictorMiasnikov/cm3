INTERFACE DeclSupport;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Peter Klein                                               *)

(** pk
    1.1
    1994/11/30 15:08:03
    DeclSupport.i3,v
# Revision 1.1  1994/11/30  15:08:03  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT SourceGraph, Token;


TYPE
  CallIterator <: CallIteratorPublic;
  CallIteratorPublic = OBJECT METHODS next (): Token.T; END;


PROCEDURE IterateProcCalls (graph: SourceGraph.T; ident: Token.T):
  CallIterator;
  (* Returns an iterator over all calls to the procedure ident.  ident may
     be a procedure identifier in a procedure declaration or definition.
     The iterator's next method returns all applications of this procedure
     identifier when it is possible that the application results in a call
     to the procedure, i.e.  it won't return the application at the end of
     the procedure declaration, but it will follow imports to return
     possible procedure calls from another module.  The only exception from
     this is that the iterator returns applications where the procedure is
     used as an instance of the appropriate procedure type, e.g.  when it
     is assigned or passed to a procedure variable.  Note that the iterator
     only returns applications inside a module if the ident is part of a
     procedure declaration, whereas it returns only applications from other
     modules if it is part of a procedure definition. *)

END DeclSupport.
