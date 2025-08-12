INTERFACE CopyTokenSubstream;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Peter Klein                                               *)

(** pk
    1.1
    1994/11/30 15:04:56
    CopyTokenSubstream.i3,v
# Revision 1.1  1994/11/30  15:04:56  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT SourceGraph, Syntax, Token;


PROCEDURE F (    graph         : SourceGraph.T;
                 anchor        : SourceGraph.Anchor;
                 syntax        : Syntax.T;
                 begin         : Token.T              := NIL;
                 end           : Token.T              := NIL;
             VAR insertionPoint: Token.T;
                 resetM3       : BOOLEAN                      );
  (* Copies all tokens under syntax or between start and end behind
     insertionPoint.  If syntax is not NIL, the tokens between
     SyntaxSupport.FindLeft/RightmostToken are copied.  If it is NIL, all
     tokens between begin and end are copied.  If resetM3 is TRUE, M3 is
     removed from the language set of all tokens in the source
     substream. *)

END CopyTokenSubstream.
