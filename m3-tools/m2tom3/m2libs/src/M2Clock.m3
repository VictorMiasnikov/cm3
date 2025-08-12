MODULE M2Clock;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Peter Klein                                               *)

(** pk
    1.1
    1994/11/30 15:02:32
    M2Clock.m3,v
# Revision 1.1  1994/11/30  15:02:32  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT Text, Fmt, ASCII, Date, Time;


PROCEDURE GetLocalTime (VAR locTime: LocalTime) =
  BEGIN
    WITH time = Date.FromTime(Time.Now(), Date.Local) DO
      locTime.second := time.second;
      locTime.minute := time.minute;
      locTime.hour := time.hour;
      locTime.day := time.day;
      locTime.month := ORD(time.month) + 1;
      locTime.year := time.year;
      locTime.dayOfWeek := ORD(time.weekDay) + 1;
    END;
  END GetLocalTime;


PROCEDURE ConvertDate (VAR locTime: LocalTime; VAR string: ARRAY OF CHAR) =
  BEGIN
    ToChar(GetDate(locTime), string);
  END ConvertDate;


PROCEDURE ConvertTime (VAR locTime: LocalTime; VAR string: ARRAY OF CHAR) =
  BEGIN
    ToChar(GetTime(locTime), string);
  END ConvertTime;


PROCEDURE ConvertDateAndTime (VAR locTime: LocalTime;
                              VAR string : ARRAY OF CHAR) =
  BEGIN
    ToChar(GetDate(locTime) & " " & GetTime(locTime), string);
  END ConvertDateAndTime;


PROCEDURE GetDate (VAR locTime: LocalTime): TEXT =
  BEGIN
    RETURN Fmt.Int(locTime.day) & " " & Fmt.Int(locTime.month) & " "
             & Fmt.Int(locTime.year);
  END GetDate;


PROCEDURE GetTime (VAR locTime: LocalTime): TEXT =
  BEGIN
    RETURN Fmt2(locTime.hour) & ":" & Fmt2(locTime.minute) & ":"
             & Fmt2(locTime.second);
  END GetTime;


PROCEDURE ToChar (t: TEXT; VAR s: ARRAY OF CHAR) =
  BEGIN
    Text.SetChars(s, t);
    WITH l = Text.Length(t) DO
      IF (l < LAST(s)) THEN s[l] := ASCII.NUL; END;
    END;
  END ToChar;


PROCEDURE Fmt2 (i: INTEGER): TEXT =
  BEGIN
    RETURN Fmt.Pad(Fmt.Int(i), 2, '0');
  END Fmt2;

BEGIN
END M2Clock.
