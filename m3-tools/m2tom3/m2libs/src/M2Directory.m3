UNSAFE MODULE M2Directory;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Peter Klein                                               *)

(** pk
    1.1
    1994/11/30 15:02:39
    M2Directory.m3,v
# Revision 1.1  1994/11/30  15:02:39  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

FROM M2Files IMPORT FileState;

IMPORT Text;

IMPORT Ctypes, Unix, Pathname, M3toC, Uerror, ASCII;


PROCEDURE Rename (READONLY fromName: ARRAY OF CHAR;
                  READONLY toName  : ARRAY OF CHAR;
                  VAR      state   : FileState      ) =
  VAR
    p0, p1: Ctypes.char_star;
    result: Ctypes.int;

  BEGIN
    state := FileState.ok;
    WITH from = Text.FromChars(fromName),
         to   = Text.FromChars(toName)    DO
      IF (NOT (Pathname.Valid(from) AND Pathname.Valid(to))) THEN
        state := FileState.nameError;
        RETURN;
      END;
      p0 := M3toC.CopyTtoS(from);
      p1 := M3toC.CopyTtoS(to);
    END;
    result := Unix.rename(p0, p1);
    M3toC.FreeCopiedS(p0);
    M3toC.FreeCopiedS(p1);
    IF (result < 0) THEN
      CASE Uerror.errno OF
        Uerror.EACCES => state := FileState.accessError;
      | Uerror.EDQUOT => state := FileState.noMoreRoom;
      | Uerror.EIO => state := FileState.deviceError;
      | Uerror.ENAMETOOLONG => state := FileState.nameError;
      | Uerror.ENOENT => state := FileState.noFile;
      | Uerror.ENOSPC => state := FileState.noMoreRoom;
      | Uerror.EROFS => state := FileState.accessError;
      ELSE
        state := FileState.otherError;
      END;
    END;
  END Rename;


PROCEDURE Delete (READONLY fileName: ARRAY OF CHAR; VAR state: FileState) =
  VAR
    p     : Ctypes.char_star;
    result: Ctypes.int;

  BEGIN
    state := FileState.ok;
    WITH file = Text.FromChars(fileName) DO
      IF (NOT Pathname.Valid(file)) THEN
        state := FileState.nameError;
        RETURN;
      END;
      p := M3toC.CopyTtoS(file);
    END;
    result := Unix.unlink(p);
    M3toC.FreeCopiedS(p);
    IF (result < 0) THEN
      CASE Uerror.errno OF
        Uerror.EACCES => state := FileState.accessError;
      | Uerror.EIO => state := FileState.deviceError;
      | Uerror.ENAMETOOLONG => state := FileState.nameError;
      | Uerror.ENOENT => state := FileState.noFile;
      | Uerror.EROFS => state := FileState.accessError;
      ELSE
        state := FileState.otherError;
      END;
    END;
  END Delete;


PROCEDURE TypeOfFileName (READONLY name: ARRAY OF CHAR): FileNameType =
  VAR
    type := FileNameType.singleName;
    i    := 0;

  BEGIN
    LOOP
      IF ((i > LAST(name)) OR (name[i] = ASCII.NUL)) THEN RETURN type; END;
      IF ((name[i] < ' ') OR (name[i] > '~') OR (i > 129)) THEN
        RETURN FileNameType.invalidName;
      END;
      IF (name[i] IN SET OF CHAR{'*', '?', '$', '['}) THEN
        type := FileNameType.wildName;
      END;
      INC(i);
    END;
  END TypeOfFileName;

BEGIN
END M2Directory.
