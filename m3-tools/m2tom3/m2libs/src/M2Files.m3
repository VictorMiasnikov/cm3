UNSAFE MODULE M2Files;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Peter Klein                                               *)

(** pk
    1.4
    1995/03/29 13:59:57
    M2Files.m3,v
# Revision 1.4  1995/03/29  13:59:57  pk
# SetFilePos now works when the file is in end error state.
#
# Revision 1.3  1995/03/15  11:49:09  pk
# Read/WriteBlock now use NUMBER instead of BYTESIZE to compute the
# number of bytes in the array.
# Flush resets the file state from endError to ok.
#
# Revision 1.2  1995/03/02  10:41:07  pk
# File is now an untraced pointer.
#
# Revision 1.1  1994/11/30  15:02:43  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT Word, Text, Ctypes, Cstdlib, M3toC, Unix, Uuio, Uerror;


REVEAL File = UNTRACED BRANDED REF FileInfo;


TYPE
  FileInfo = RECORD
               fdesc   : Ctypes.int;
               fnam    : Path;
               fstat   : FileState;
               lastRead: CHAR         := '\000';
             END;

  Path = Ctypes.char_star;


PROCEDURE Open (             VAR      file     : File;
                             READONLY name     : ARRAY OF CHAR;
                <* UNUSED *>          binText  : BinTextMode;
                                      writeMode: ReadWriteMode;
                             VAR      state    : FileState      ) =
  VAR
    flags, result: Ctypes.int;
    unixFileName : Path;

  BEGIN
    CASE writeMode OF
      ReadWriteMode.readOnly => flags := Unix.O_RDONLY;
    | ReadWriteMode.readWrite => flags := Unix.O_RDWR;
    | ReadWriteMode.appendOnly => flags := Unix.O_APPEND + Unix.O_WRONLY;
    END;

    unixFileName := GetFullPathName(name);
    result := Unix.open(unixFileName, flags, 0);

    IF (result > 0) THEN
      file := NEW(File, fdesc := result, fnam := unixFileName,
                  fstat := FileState.ok);
      state := FileState.ok;
    ELSE
      state := ErrnoToFileState();
    END;
  END Open;


PROCEDURE Create (             VAR      file    : File;
                               READONLY name    : ARRAY OF CHAR;
                  <* UNUSED *>          binText : BinTextMode;
                                        replMode: ReplaceMode;
                               VAR      state   : FileState      ) =
  VAR
    flags, result: Ctypes.int;
    unixFileName : Path;

  BEGIN
    flags := Unix.O_RDWR + Unix.O_CREAT;
    IF (replMode = ReplaceMode.noReplace) THEN
      INC(flags, Unix.O_EXCL);
    END;

    unixFileName := GetFullPathName(name);
    result := Unix.open(unixFileName, flags, Unix.MROWNER + Unix.MWOWNER);

    IF (result > 0) THEN
      file := NEW(File, fdesc := result, fnam := unixFileName,
                  fstat := FileState.ok);
      state := FileState.ok;
    ELSE
      state := ErrnoToFileState();
    END;
  END Create;


PROCEDURE Close (VAR file: File; VAR state: FileState) =
  BEGIN
    IF (file = NIL) THEN
      state := FileState.notOpen;
    ELSE
      IF (Unix.close(file.fdesc) = 0) THEN
        state := FileState.ok;
      ELSE
        state := ErrnoToFileState();
      END;
      M3toC.FreeCopiedS(file.fnam);
      DISPOSE(file);
    END;
  END Close;


PROCEDURE Remove (VAR file: File; VAR state: FileState) =
  BEGIN
    IF (file = NIL) THEN
      state := FileState.notOpen;
    ELSE
      EVAL Unix.close(file.fdesc);
      IF (Unix.unlink(file.fnam) = 0) THEN
        state := FileState.ok;
      ELSE
        state := ErrnoToFileState();
      END;
      M3toC.FreeCopiedS(file.fnam);
      DISPOSE(file);
    END;
  END Remove;


PROCEDURE Reset (file: File; VAR state: FileState) =
  BEGIN
    IF (file = NIL) THEN state := FileState.notOpen; RETURN; END;
    IF (file.fstat = FileState.ok) THEN
      IF (Unix.lseek(file.fdesc, 0, Unix.L_SET) # 0) THEN
        file.fstat := ErrnoToFileState();
      ELSE
        file.fstat := FileState.ok;
      END;
    END;
    state := file.fstat;
  END Reset;


PROCEDURE Rewrite (file: File; VAR state: FileState) =
  BEGIN
    IF (file = NIL) THEN state := FileState.notOpen; RETURN; END;
    IF (file.fstat = FileState.ok) THEN
      IF (Unix.lseek(file.fdesc, 0, Unix.L_SET) # 0) THEN
        file.fstat := ErrnoToFileState();
      ELSE
        IF (Unix.ftruncate(file.fdesc, 0) # 0) THEN
          file.fstat := ErrnoToFileState();
        ELSE
          file.fstat := FileState.ok;
        END;
      END;
    END;
    state := file.fstat;
  END Rewrite;


PROCEDURE Truncate (file: File; VAR state: FileState) =
  VAR current: CARDINAL;

  BEGIN
    IF (file = NIL) THEN state := FileState.notOpen; RETURN; END;
    IF (file.fstat = FileState.ok) THEN
      current := Unix.lseek(file.fdesc, 0, Unix.L_INCR);
      IF (Unix.ftruncate(file.fdesc, current) # 0) THEN
        file.fstat := ErrnoToFileState();
      ELSE
        file.fstat := FileState.ok;
      END;
    END;
    state := file.fstat;
  END Truncate;


PROCEDURE Flush (file: File; VAR state: FileState) =
  BEGIN
    IF (file.fstat = FileState.endError) THEN
      state := FileState.ok;
    ELSE
      state := file.fstat;
    END;
  END Flush;


PROCEDURE EOF (file: File): BOOLEAN =
  BEGIN
    RETURN ((file = NIL) OR (file.fstat # FileState.ok));
  END EOF;


PROCEDURE State (file: File): FileState =
  BEGIN
    IF (file = NIL) THEN
      RETURN FileState.notOpen;
    ELSE
      RETURN file.fstat;
    END;
  END State;


PROCEDURE ResetState (file: File; VAR state: FileState) =
  BEGIN
    IF (file = NIL) THEN
      state := FileState.notOpen;
    ELSE
      file.fstat := FileState.ok;
    END;
    state := file.fstat;
  END ResetState;


PROCEDURE GetFileName (    file : File;
                       VAR name : ARRAY OF CHAR;
                       VAR state: FileState      ) =
  BEGIN
    IF (file = NIL) THEN
      state := FileState.notOpen;
    ELSE
      Text.SetChars(name, M3toC.StoT(file.fnam));
      state := file.fstat;
    END;
  END GetFileName;


PROCEDURE ReadByte (file: File; VAR byte: CHAR; VAR state: FileState) =
  VAR bytesRead: CARDINAL;

  BEGIN
    ReadBytes(file, ADR(byte), BYTESIZE(CHAR), bytesRead, state);
  END ReadByte;


PROCEDURE ReadWord (file: File; VAR word: Word.T; VAR state: FileState) =
  VAR bytesRead: CARDINAL;

  BEGIN
    ReadBytes(file, ADR(word), BYTESIZE(Word.T), bytesRead, state);
  END ReadWord;


PROCEDURE ReadBlock (    file : File;
                     VAR block: ARRAY OF CHAR;
                     VAR state: FileState      ) =
  VAR bytesRead: CARDINAL;

  BEGIN
    ReadBytes(file, ADR(block[0]), NUMBER(block), bytesRead, state);
  END ReadBlock;


PROCEDURE ReadBytes (    file     : File;
                         addr     : ADDRESS;
                         bytes    : CARDINAL;
                     VAR bytesRead: CARDINAL;
                     VAR state    : FileState ) =
  VAR retCode: Ctypes.int;

  BEGIN
    IF (file = NIL) THEN state := FileState.notOpen; RETURN; END;

    IF (file.fstat = FileState.ok) THEN
      retCode := Uuio.read(file.fdesc, addr, bytes);
      IF (retCode <= 0) THEN
        IF (retCode < 0) THEN
          file.fstat := ErrnoToFileState();
        ELSE
          file.fstat := FileState.endError;
        END;
      ELSE
        file.fstat := FileState.ok;
        bytesRead := retCode;
      END;
    END;
    file.lastRead := LOOPHOLE(addr + bytes - 1, UNTRACED REF CHAR)^;
    state := file.fstat;
  END ReadBytes;


PROCEDURE WriteByte (file: File; byte: CHAR; VAR state: FileState) =
  BEGIN
    WriteBytes(file, ADR(byte), BYTESIZE(CHAR), state);
  END WriteByte;


PROCEDURE WriteWord (file: File; word: Word.T; VAR state: FileState) =
  BEGIN
    WriteBytes(file, ADR(word), BYTESIZE(Word.T), state);
  END WriteWord;


PROCEDURE WriteBlock (         file : File;
                      READONLY block: ARRAY OF CHAR;
                      VAR      state: FileState      ) =
  BEGIN
    WriteBytes(file, ADR(block[0]), NUMBER(block), state);
  END WriteBlock;


PROCEDURE WriteBytes (    file     : File;
                          addr     : ADDRESS;
                          bytecount: CARDINAL;
                      VAR state    : FileState ) =
  VAR retCode: Ctypes.int;

  BEGIN
    IF (file = NIL) THEN state := FileState.notOpen; RETURN; END;

    IF (file.fstat = FileState.ok) THEN
      retCode := Uuio.write(file.fdesc, addr, bytecount);
      IF (retCode < 0) THEN
        file.fstat := ErrnoToFileState();
      ELSE
        file.fstat := FileState.ok;
      END;
    END;
    state := file.fstat;
  END WriteBytes;


PROCEDURE GetFilePos (file: File; VAR pos: FilePosition) =
  BEGIN
    pos := Unix.lseek(file.fdesc, 0, Unix.L_INCR);
  END GetFilePos;


PROCEDURE GetEOF (file: File; VAR pos: FilePosition) =
  VAR current: CARDINAL;

  BEGIN
    current := Unix.lseek(file.fdesc, 0, Unix.L_INCR);
    pos := Unix.lseek(file.fdesc, 0, Unix.L_XTND);
    current := Unix.lseek(file.fdesc, current, Unix.L_SET);
  END GetEOF;


PROCEDURE GetBOF (<* UNUSED *> file: File; VAR pos: FilePosition) =
  BEGIN
    pos := 0;
  END GetBOF;


PROCEDURE CalcFilePos (<* UNUSED *>     file         : File;
                                    VAR pos          : FilePosition;
                                        numOfElements: INTEGER;
                                        elementLength: CARDINAL      ) =
  BEGIN
    INC(pos, numOfElements * elementLength);
  END CalcFilePos;


PROCEDURE SetFilePos (file: File; pos: FilePosition; VAR state: FileState) =
  BEGIN
    IF (file = NIL) THEN state := FileState.notOpen; RETURN; END;

    IF ((file.fstat = FileState.ok) OR (file.fstat = FileState.endError)) THEN
      pos := Unix.lseek(file.fdesc, pos, Unix.L_SET);
      IF (pos < 0) THEN
        file.fstat := ErrnoToFileState();
      ELSE
        file.fstat := FileState.ok;
      END;
    END;
    state := file.fstat;
  END SetFilePos;


PROCEDURE RereadByte (file: File): CHAR =
  BEGIN
    RETURN file.lastRead;
  END RereadByte;


PROCEDURE ErrnoToFileState (): FileState =
  VAR state: FileState;

  BEGIN
    CASE Uerror.errno OF
    | Uerror.ENAMETOOLONG, Uerror.ENOTDIR => state := FileState.nameError;
    | Uerror.ENOENT => state := FileState.noFile;
    | Uerror.EEXIST => state := FileState.existingFile;
    | Uerror.EIO, Uerror.EFAULT => state := FileState.deviceError;
    | Uerror.ENFILE, Uerror.EDQUOT, Uerror.EFBIG, Uerror.EMFILE,
        Uerror.EMLINK, Uerror.ENOMEM, Uerror.ENOSPC, Uerror.EUSERS =>
        state := FileState.noMoreRoom;
    | Uerror.EACCES, Uerror.EISDIR, Uerror.EBADF, Uerror.ENODEV,
        Uerror.ENOTEMPTY, Uerror.EPERM, Uerror.EROFS =>
        state := FileState.accessError;
    ELSE
      state := FileState.otherError;
    END;
    RETURN state;
  END ErrnoToFileState;


PROCEDURE GetFullPathName (READONLY rp: ARRAY OF CHAR): Path =
  VAR
    unixPath: Path;
    base    : TEXT;
    name           := Text.FromChars(rp);

  BEGIN
    IF (Text.GetChar(name, 0) = '/') THEN
      base := "";
    ELSE
      unixPath := Cstdlib.malloc(Unix.MaxPathLen);
      unixPath := Unix.getwd(unixPath);
      base := M3toC.CopyStoT(unixPath) & "/";
      Cstdlib.free(unixPath);
    END;
    RETURN M3toC.CopyTtoS(base & name);
  END GetFullPathName;

BEGIN
END M2Files.
