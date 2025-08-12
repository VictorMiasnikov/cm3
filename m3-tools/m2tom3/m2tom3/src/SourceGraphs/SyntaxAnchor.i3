INTERFACE SyntaxAnchor;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:08:45
    SyntaxAnchor.i3,v
# Revision 1.1  1994/11/30  15:08:45  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- SyntaxAnchor -----------------------------------------------------------
  * Abstract data type module to represent anchors of a syntax tree.
  * Because of inheritance this anchors represents at the same time anchors
  * of the related token stream.
  *
  * No further information than the type of the anchor itself is
  * yet neccessary so there are not data or methods fields.
  * ----------------------------------------------------------------------------
  **)

IMPORT TokenAnchor AS Super;


TYPE
  T <: Public;
  Public = Super.T OBJECT END;

END SyntaxAnchor.
