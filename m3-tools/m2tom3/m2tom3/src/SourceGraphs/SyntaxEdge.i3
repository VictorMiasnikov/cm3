INTERFACE SyntaxEdge;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:08:49
    SyntaxEdge.i3,v
# Revision 1.1  1994/11/30  15:08:49  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- SyntaxEdge -------------------------------------------------------------
  * Abstract data type module. Syntax edges are used to link an anchor
  * (SyntaxAnchor), terminal symbols (Token) and non-terminal symbols (Syntax)
  * to a syntax tree. To identify one child of a syntax node the edges are
  * attributed by a number.
  * ----------------------------------------------------------------------------
  **)

IMPORT BaseEdge AS Super;


TYPE
  T <: Public;

  Public = Super.T OBJECT
           METHODS
             init  (no: CARDINAL): T;
             setNo (no: CARDINAL);
             getNo (): CARDINAL;
           END;

END SyntaxEdge.
