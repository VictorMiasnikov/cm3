MODULE M2Text;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Peter Klein                                               *)

(** pk
    1.1
    1994/11/30 15:02:52
    M2Text.m3,v
# Revision 1.1  1994/11/30  15:02:52  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

FROM M2Files IMPORT File, FileState;

IMPORT M2Files;

IMPORT ASCII, Fmt, Text, Word;


PROCEDURE EOL (file: File): BOOLEAN =
  BEGIN
    IF (file = NIL) THEN RETURN TRUE; END;
    WITH state = M2Files.State(file) DO
      IF (state = M2Files.FileState.endError) THEN
        RETURN FALSE;
      ELSIF (state # M2Files.FileState.ok) THEN
        RETURN TRUE;
      END;
    END;
    RETURN (M2Files.RereadByte(file) = '\n');
  END EOL;


PROCEDURE ReadChar (file: File; VAR ch: CHAR; VAR state: FileState) =
  VAR pos: M2Files.FilePosition;

  BEGIN
    M2Files.GetFilePos(file, pos);
    M2Files.ReadByte(file, ch, state);
    IF ((state = FileState.ok) AND (ch = '\n')) THEN
      M2Files.SetFilePos(file, pos, state);
    END;
  END ReadChar;


PROCEDURE ReadString (    file : File;
                      VAR str  : ARRAY OF CHAR;
                      VAR state: FileState      ) =
  VAR
    index                       := 0;
    char : CHAR;
    pos  : M2Files.FilePosition;

  BEGIN
    state := FileState.ok;
    LOOP
      IF (M2Files.EOF(file)) THEN RETURN; END;
      M2Files.ReadByte(file, char, state);
      IF (state # FileState.ok) THEN RETURN; END;
      IF (char = '\n') THEN
        M2Files.GetFilePos(file, pos);
        M2Files.SetFilePos(file, pos - 1, state);
        IF (index <= LAST(str)) THEN str[index] := ASCII.NUL; END;
        RETURN;
      ELSE
        IF (index > LAST(str)) THEN
          state := FileState.otherError;
          RETURN;
        END;
        str[index] := char;
        IF (str[index] = ASCII.NUL) THEN RETURN; END;
      END;
      INC(index);
    END;
  END ReadString;


PROCEDURE ReadLn (file: File; VAR state: FileState) =
  VAR char: CHAR;

  BEGIN
    state := FileState.ok;
    LOOP
      IF (M2Files.EOF(file)) THEN RETURN; END;
      M2Files.ReadByte(file, char, state);
      IF ((state # FileState.ok) OR (char = '\n')) THEN RETURN; END;
    END;
  END ReadLn;


PROCEDURE UndoRead (file: File; VAR state: FileState) =
  VAR pos: M2Files.FilePosition;

  BEGIN
    M2Files.GetFilePos(file, pos);
    IF (pos = 0) THEN state := FileState.outsideFile; RETURN END;
    M2Files.SetFilePos(file, pos - 1, state);
  END UndoRead;


PROCEDURE CondRead (    file   : File;
                    VAR ch     : CHAR;
                    VAR success: BOOLEAN;
                    VAR state  : FileState) =
  BEGIN
    M2Files.ReadByte(file, ch, state);
    success := (state = FileState.ok);
  END CondRead;


PROCEDURE WriteChar (file: File; ch: CHAR; VAR state: FileState) =
  BEGIN
    M2Files.WriteByte(file, ch, state);
  END WriteChar;


PROCEDURE WriteString (         file : File;
                       READONLY str  : ARRAY OF CHAR;
                       VAR      state: FileState      ) =
  VAR index := 0;

  BEGIN
    state := FileState.ok;
    LOOP
      IF ((index > LAST(str)) OR (str[index] = ASCII.NUL)) THEN
        RETURN;
      END;
      M2Files.WriteByte(file, str[index], state);
      IF (state # FileState.ok) THEN RETURN; END;
      INC(index);
    END;
  END WriteString;


PROCEDURE WriteLn (file: File; VAR state: FileState) =
  BEGIN
    M2Files.WriteByte(file, '\n', state);
  END WriteLn;


PROCEDURE WriteInt (    file : File;
                        int  : INTEGER;
                        width: CARDINAL;
                    VAR state: FileState ) =
  VAR a := ARRAY [0 .. 30] OF CHAR{ASCII.NUL, ..};

  BEGIN
    WITH t = Fmt.Pad(Fmt.Int(int), width) DO
      Text.SetChars(a, t);
      WriteString(file, a, state);
    END;
  END WriteInt;


PROCEDURE WriteCard (    file : File;
                         card : Word.T;
                         width: CARDINAL;
                     VAR state: FileState ) =
  VAR a := ARRAY [0 .. 30] OF CHAR{ASCII.NUL, ..};

  BEGIN
    WITH t = Fmt.Pad(Fmt.Unsigned(card, 10), width) DO
      Text.SetChars(a, t);
      WriteString(file, a, state);
    END;
  END WriteCard;

BEGIN
END M2Text.
