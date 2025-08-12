UNSAFE INTERFACE Storage;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:03:08
    Storage.i3,v
# Revision 1.1  1994/11/30  15:03:08  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- Storage ----------------------------------------------------------------
  * Compatibility module to "standard" Modula-2 module.
  *
  * Beware that the correct usage of this module depends on several unsafe
  * features.
  * ----------------------------------------------------------------------------
  **)


PROCEDURE ALLOCATE (VAR adr: ADDRESS; size: CARDINAL);
  (* Makes an new area of the given size accessable and returns its
     address.  It is a checked runtime error if no space is available. *)


PROCEDURE DEALLOCATE (VAR adr: ADDRESS; size: CARDINAL);
  (* Frees an previous created area by ALLOCATE. *)


PROCEDURE Allocate (VAR adr: ADDRESS; size: CARDINAL);
  (* Synonym for ALLOCATE. *)


PROCEDURE Available (size: CARDINAL): BOOLEAN;
  (* Tests if an area of the given size could be allocated.  This
     implementation yet returns allways TRUE! *)

END Storage.
