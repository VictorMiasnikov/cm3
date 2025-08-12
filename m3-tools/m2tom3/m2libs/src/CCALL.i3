INTERFACE CCALL;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Kai Michael Degner                                        *)

(** pk
    1.3
    1995/01/24 10:52:27
    CCALL.i3,v
# Revision 1.3  1995/01/24  10:52:27  pk
# open, lockf, close deleted.
#
# Revision 1.2  1995/01/24  10:49:59  pk
# New CCALL resources bzero, open, lockf, close.
#
# Revision 1.1  1994/11/30  15:02:28  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

<* EXTERNAL *> PROCEDURE bcopy (from, to: ADDRESS; len: INTEGER);

<* EXTERNAL *> PROCEDURE bzero (from: ADDRESS; len: INTEGER);

<* EXTERNAL *> PROCEDURE random (): INTEGER;

END CCALL.
