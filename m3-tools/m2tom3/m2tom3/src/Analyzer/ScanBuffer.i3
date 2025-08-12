INTERFACE ScanBuffer;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:04:00
    ScanBuffer.i3,v
# Revision 1.1  1994/11/30  15:04:00  pk
# Release Version 2.00.
#
*)
(***************************************************************************)


(** --- ScanBuffer -------------------------------------------------------------
  * This abstract data object module provides a scan buffer.
  *
  * The scan buffer presents you an optimized data structure to store a
  * continous sequence of characters and retrieve them as a single string.
  * The buffer contains as many characters as you like.
  * ----------------------------------------------------------------------------
  **)

PROCEDURE ClearBuffer ();
  (* Resets the buffer. *)


PROCEDURE AppendToBuffer (char: CHAR);
  (* Store the char at the end of the buffer. *)


PROCEDURE GetText (): TEXT;
  (* Retrieves all stored characters in a single string.  The buffer will
     not be cleared automatically. *)

END ScanBuffer.
