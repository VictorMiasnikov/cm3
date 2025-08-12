INTERFACE TokenAnchor;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:09:11
    TokenAnchor.i3,v
# Revision 1.1  1994/11/30  15:09:11  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- TokenAnchor ------------------------------------------------------------
  * Abstract data type module to represent the anchor of a token stream. When
  * using several streams you can identify a stream by it's anchor. This
  * anchor is also used to identify the first and last token of the stream.
  *
  * IMPORTANT:
  *  For token anchors the general assumption about arbitrary hash values of
  *  nodes is changed: the dynamic type is used to calculate the hash value.
  *  As result all token anchors are collected in the same hash class.
  * WARNING:
  *  It is not correct to assume that NO OTHER nodes than token anchors are in
  *  this hash class.
  *
  * No further public information than the type of the anchor itself is
  * yet neccessary so there are no visible data or methods fields.
  * ----------------------------------------------------------------------------
  **)

IMPORT BaseNode AS Super;


TYPE
  T <: Public;
  Public = Super.T OBJECT END;

END TokenAnchor.
