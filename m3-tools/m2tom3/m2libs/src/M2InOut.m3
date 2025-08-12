MODULE M2InOut;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Peter Klein                                               *)

(** pk
    1.1
    1994/11/30 15:02:46
    M2InOut.m3,v
# Revision 1.1  1994/11/30  15:02:46  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT Rd, Wr, Stdio, Fmt, Text, Scan, Word, ASCII;


PROCEDURE Read (VAR ch: CHAR) =
  BEGIN
    TRY ch := Rd.GetChar(Stdio.stdin); EXCEPT ELSE Done := FALSE; END;
  END Read;


PROCEDURE ReadString (VAR s: ARRAY OF CHAR) =
  BEGIN
    TRY
      WITH t = Rd.GetLine(Stdio.stdin),
           l = Text.Length(t)           DO
        IF (NUMBER(s) < l) THEN
          Done := FALSE;
        ELSE
          Text.SetChars(s, t);
          IF (l < LAST(s)) THEN s[l] := ASCII.NUL; END;
        END;
      END;
    EXCEPT
    ELSE
      Done := FALSE;
    END;
  END ReadString;


PROCEDURE ReadInt (VAR x: INTEGER) =
  BEGIN
    TRY
      x := Scan.Int(Rd.GetLine(Stdio.stdin));
    EXCEPT
    ELSE
      Done := FALSE;
    END;
  END ReadInt;


PROCEDURE ReadCard (VAR x: Word.T) =
  BEGIN
    TRY
      x := Scan.Unsigned(Rd.GetLine(Stdio.stdin), 10);
    EXCEPT
    ELSE
      Done := FALSE;
    END;
  END ReadCard;


PROCEDURE Write (ch: CHAR) =
  BEGIN
    TRY
      Wr.PutChar(Stdio.stdout, ch);
      Wr.Flush(Stdio.stdout);
    EXCEPT
    ELSE
      Done := FALSE;
    END;
  END Write;


PROCEDURE WriteLn () =
  BEGIN
    TRY
      Wr.PutChar(Stdio.stdout, '\n');
      Wr.Flush(Stdio.stdout);
    EXCEPT
    ELSE
      Done := FALSE;
    END;
  END WriteLn;


PROCEDURE WriteString (READONLY s: ARRAY OF CHAR) =
  VAR
    t: TEXT;
    l: INTEGER;

  BEGIN
    TRY
      t := Text.FromChars(s);
      l := Text.FindChar(t, '\000');
      IF (l >= 0) THEN t := Text.Sub(t, 0, l); END;
      Wr.PutText(Stdio.stdout, t);
      Wr.Flush(Stdio.stdout);
    EXCEPT
    ELSE
      Done := FALSE;
    END;
  END WriteString;


PROCEDURE WriteInt (x: INTEGER; n: CARDINAL) =
  BEGIN
    TRY
      Wr.PutText(Stdio.stdout, Fmt.Pad(Fmt.Int(x), n));
      Wr.Flush(Stdio.stdout);
    EXCEPT
    ELSE
      Done := FALSE;
    END;
  END WriteInt;


PROCEDURE WriteCard (x: Word.T; n: CARDINAL) =
  BEGIN
    TRY
      Wr.PutText(Stdio.stdout, Fmt.Pad(Fmt.Unsigned(x, 10), n));
      Wr.Flush(Stdio.stdout);
    EXCEPT
    ELSE
      Done := FALSE;
    END;
  END WriteCard;

BEGIN
  Done := TRUE;
END M2InOut.
