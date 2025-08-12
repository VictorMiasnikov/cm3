INTERFACE Parser;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Thomas Stockheim                                          *)

(** pk
    1.1
    1994/11/30 15:03:53
    Parser.i3,v
# Revision 1.1  1994/11/30  15:03:53  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT SyntaxGraph, SyntaxAnchor;
IMPORT Token, TokenGraph;
IMPORT Message;


TYPE
  Error = RECORD
            token: Token.T;
            code : Message.Code;
          END;


EXCEPTION
  SyntaxError(Error);
  (* Syntax error in the Modula-2 source code *)

  OutOfTokens;
  (* TokenStream is empty earlier than expected - can be a syntax error as
     well! *)

  GraphError;
  (* Any kind of Error while building the SyntaxGraph - probably a bug in
     the data structures BaseGraph, SyntaxGraph or TokenGraph! *)


PROCEDURE Parse (graph: SyntaxGraph.T; anchor: SyntaxAnchor.T)
  RAISES {SyntaxError, OutOfTokens, GraphError, TokenGraph.NoAnchor};
  (* Procedure Parse adds a SyntaxGraph above the TokenStream.  SyntaxGraph
     and SyntaxAnchor must be generated from the calling program,
     SyntaxGraph should contain a token stream. *)

END Parser.
