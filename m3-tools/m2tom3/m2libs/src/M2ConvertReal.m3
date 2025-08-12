MODULE M2ConvertReal;

(***************************************************************************)
(** Created by:  Roland Baumann						   *)

(** pk
    1.1
    1995/09/04 09:00:33
    M2ConvertReal.m3,v
# Revision 1.1  1995/09/04  09:00:33  pk
# Initial revision
#
*)
(***************************************************************************)

IMPORT FmtBuf, Scan, Text;


PROCEDURE RealToStr (    real: REAL;
                     VAR str : ARRAY OF CHAR;
                     width    : CARDINAL;  (* width of field in char *)
                     decPlaces: INTEGER;   (* neg -> sci; 0 -> no point *)
                     VAR success: BOOLEAN) =
  VAR
    buf   : ARRAY [0 .. 255] OF CHAR;
    blanks: ARRAY [0 .. 255] OF CHAR := ARRAY [0 .. 255] OF CHAR{' ', ..};
    len   : CARDINAL;
    sci   : BOOLEAN                  := FALSE;

  BEGIN
    IF ((width > LAST(str)) OR (decPlaces > width)) THEN
      success := FALSE;
      RETURN;
    END;
    IF (decPlaces >= 0) THEN
      len := FmtBuf.Real(buf, real, FmtBuf.Style.Fix, decPlaces);
    ELSE
      len := FmtBuf.Real(buf, real, FmtBuf.Style.Auto, -decPlaces, TRUE);
      FOR i := len - 1 TO 0 BY -1 DO
        IF (buf[i] = 'e') THEN buf[i] := 'E'; sci := TRUE; END;
      END;
      IF (NOT sci) THEN
        buf[len] := 'E';
        buf[len + 1] := '0';
        INC(len, 2);
      END;
    END;
    IF (len > LAST(str)) THEN success := FALSE; RETURN; END;
    IF (len <= width) THEN
      SUBARRAY(str, 0, width - len) := SUBARRAY(blanks, 0, width - len);
      SUBARRAY(str, width - len, len) := SUBARRAY(buf, 0, len);
      IF (NUMBER(str) > width) THEN str[width] := '\000'; END;
      success := TRUE;
    ELSE
      success := FALSE;
    END;
  END RealToStr;


PROCEDURE StrToReal (READONLY str    : ARRAY OF CHAR;
                     VAR      real   : REAL;
                     VAR      success: BOOLEAN        ) =
  BEGIN
    TRY
      real := Scan.Real(Text.FromChars(str));
      success := TRUE;
    EXCEPT
    ELSE
      success := FALSE;
    END;
  END StrToReal;

BEGIN
END M2ConvertReal.
