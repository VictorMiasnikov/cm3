INTERFACE M2Clock;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Peter Klein                                               *)

(** pk
    1.1
    1994/11/30 15:02:30
    M2Clock.i3,v
# Revision 1.1  1994/11/30  15:02:30  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT Word;


TYPE
  LocalTime = RECORD
                second   : Word.T;
                minute   : Word.T;
                hour     : Word.T;
                day      : Word.T;
                month    : Word.T;
                year     : Word.T;
                dayOfWeek: Word.T;
              END;


PROCEDURE GetLocalTime (VAR locTime: LocalTime);
  (* access to current time on the systems real-time clock *)


(* conversion of local time into strings *)

PROCEDURE ConvertDate (VAR locTime: LocalTime; VAR string: ARRAY OF CHAR);
  (* date string of the form "day month year" *)

PROCEDURE ConvertTime (VAR locTime: LocalTime; VAR string: ARRAY OF CHAR);
  (* time string of the form "hh:mm:ss" *)

PROCEDURE ConvertDateAndTime (VAR locTime: LocalTime;
                              VAR string : ARRAY OF CHAR);
  (* generate a string of the form "day month year hh:mm:ss" *)

END M2Clock.
