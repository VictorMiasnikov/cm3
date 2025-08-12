UNSAFE MODULE Storage;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.2
    1995/03/15 11:49:49
    Storage.m3,v
# Revision 1.2  1995/03/15  11:49:49  pk
# Pointers are reset to NIL after deallocation.
#
# Revision 1.1  1994/11/30  15:03:10  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT Cstdlib;
IMPORT RTHeapRep;


PROCEDURE ALLOCATE (VAR adr: ADDRESS; size: CARDINAL) =
  BEGIN
    adr := RTHeapRep.Malloc(size);
  END ALLOCATE;


PROCEDURE DEALLOCATE (VAR adr: ADDRESS; <*UNUSED *> size: CARDINAL) =
  BEGIN
    Cstdlib.free(adr);
    adr := NIL;
  END DEALLOCATE;


PROCEDURE Allocate (VAR adr: ADDRESS; size: CARDINAL) =
  BEGIN
    ALLOCATE(adr, size);
  END Allocate;


PROCEDURE Available (<*UNUSED *> size: CARDINAL): BOOLEAN =
  BEGIN
    RETURN TRUE;
  END Available;

BEGIN
END Storage.
