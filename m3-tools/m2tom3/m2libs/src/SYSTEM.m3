UNSAFE MODULE SYSTEM;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Markus Jansen                                             *)

(** pk
    1.1
    1994/11/30 15:03:06
    SYSTEM.m3,v
# Revision 1.1  1994/11/30  15:03:06  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

EXCEPTION ProgramHalt;


PROCEDURE HALT () =
  <* FATAL ProgramHalt *>

  BEGIN
    RAISE ProgramHalt;
  END HALT;


PROCEDURE ODD (i: INTEGER): BOOLEAN =
  BEGIN
    RETURN ((i MOD 2) = 1);
  END ODD;

BEGIN
END SYSTEM.
