MODULE M2Convert;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Peter Klein                                               *)

(** pk
    1.1
    1994/11/30 15:02:36
    M2Convert.m3,v
# Revision 1.1  1994/11/30  15:02:36  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT Word, Text, Fmt, Scan, Lex, FloatMode, ASCII, M2String;


PROCEDURE IntToStr (    int    : INTEGER;
                    VAR str    : ARRAY OF CHAR;
                        width  : Word.T;
                    VAR success: BOOLEAN        ) =
  BEGIN
    WITH t = Fmt.Pad(Fmt.Int(int), width),
         l = Text.Length(t)                DO
      IF (l > NUMBER(str)) THEN success := FALSE; RETURN; END;
      Text.SetChars(str, t);
      IF (l <= LAST(str)) THEN str[l] := ASCII.NUL; END;
    END;
    success := TRUE;
  END IntToStr;


PROCEDURE CardToStr (    card   : Word.T;
                     VAR str    : ARRAY OF CHAR;
                         width  : Word.T;
                     VAR success: BOOLEAN        ) =
  BEGIN
    WITH t = Fmt.Pad(Fmt.Unsigned(card, base := 10), width),
         l = Text.Length(t)                                  DO
      IF (l > NUMBER(str)) THEN success := FALSE; RETURN; END;
      Text.SetChars(str, t);
      IF (l <= LAST(str)) THEN str[l] := ASCII.NUL; END;
    END;
    success := TRUE;
  END CardToStr;


PROCEDURE NumToStr (    num    : Word.T;
                    VAR str    : ARRAY OF CHAR;
                        base   : Word.T (* [2..36] *);
                        width  : Word.T;
                    VAR success: BOOLEAN               ) =
  BEGIN
    WITH t = Fmt.Pad(Fmt.Unsigned(num, base), width),
         l = Text.Length(t)                           DO
      IF (l > NUMBER(str)) THEN success := FALSE; RETURN; END;
      Text.SetChars(str, t);
      IF (l <= LAST(str)) THEN str[l] := ASCII.NUL; END;
    END;
    success := TRUE;
  END NumToStr;


PROCEDURE StrToInt (READONLY str    : ARRAY OF CHAR;
                    VAR      int    : INTEGER;
                    VAR      success: BOOLEAN        ) =
  BEGIN
    success := TRUE;
    TRY
      WITH t = Text.FromChars(SUBARRAY(str, 0, M2String.Length(str))) DO
        int := Scan.Int(t);
      END;
    EXCEPT
      Lex.Error, FloatMode.Trap => success := FALSE;
    END;
  END StrToInt;


PROCEDURE StrToCard (READONLY str    : ARRAY OF CHAR;
                     VAR      card   : Word.T;
                     VAR      success: BOOLEAN        ) =
  BEGIN
    success := TRUE;
    TRY
      WITH t = Text.FromChars(SUBARRAY(str, 0, M2String.Length(str))) DO
        card := Scan.Unsigned(t, defaultBase := 10);
      END;
    EXCEPT
      Lex.Error, FloatMode.Trap => success := FALSE;
    END;
  END StrToCard;


PROCEDURE StrToNum (READONLY str    : ARRAY OF CHAR;
                    VAR      num    : Word.T;
                             base   : Word.T (* [2..36] *);
                    VAR      success: BOOLEAN               ) =
  BEGIN
    success := TRUE;
    TRY
      WITH t = Text.FromChars(SUBARRAY(str, 0, M2String.Length(str))) DO
        num := Scan.Unsigned(t, base);
      END;
    EXCEPT
      Lex.Error, FloatMode.Trap => success := FALSE;
    END;
  END StrToNum;

BEGIN
END M2Convert.
