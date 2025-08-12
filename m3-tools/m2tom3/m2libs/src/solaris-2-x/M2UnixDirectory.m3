UNSAFE MODULE M2UnixDirectory;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Peter Klein                                               *)

(** pk
    1.1
    1995/08/15 14:36:21
    M2UnixDirectory.m3,v
# Revision 1.1  1995/08/15  14:36:21  pk
# Separate versions for solaris 2 and sunos 4.
#
# Revision 1.1  1994/11/30  15:02:56  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT Text, Word, M3toC, Ustat, Unix, Ctypes, Utypes;


PROCEDURE Access (READONLY name: ARRAY OF CHAR; mode: AccessSet): INTEGER =
  VAR
    UnixFileName          := M3toC.CopyTtoS(Text.FromChars(name));
    umode                 := 0;
    Result      : INTEGER;

  BEGIN
    IF (Accessmode.accessX IN mode) THEN INC(umode, Unix.X_OK); END;
    IF (Accessmode.accessW IN mode) THEN INC(umode, Unix.W_OK); END;
    IF (Accessmode.accessR IN mode) THEN INC(umode, Unix.R_OK); END;

    Result := Unix.access(UnixFileName, umode);
    M3toC.FreeCopiedS(UnixFileName);
    RETURN Result;
  END Access;


PROCEDURE Chdir (READONLY name: ARRAY OF CHAR): INTEGER =
  VAR
    UnixFileName          := M3toC.CopyTtoS(Text.FromChars(name));
    Result      : INTEGER;

  BEGIN
    Result := Unix.chdir(UnixFileName);
    M3toC.FreeCopiedS(UnixFileName);
    RETURN Result;
  END Chdir;


PROCEDURE Chmod (READONLY name: ARRAY OF CHAR; mode: PermissionSet):
  INTEGER =
  VAR
    UnixFileName          := M3toC.CopyTtoS(Text.FromChars(name));
    Result      : INTEGER;

  BEGIN
    Result := Unix.chmod(UnixFileName, PermSetToMode(mode));
    M3toC.FreeCopiedS(UnixFileName);
    RETURN Result;
  END Chmod;


PROCEDURE Link (READONLY name1, name2: ARRAY OF CHAR): INTEGER =
  VAR
    UnixFileName1          := M3toC.CopyTtoS(Text.FromChars(name1));
    UnixFileName2          := M3toC.CopyTtoS(Text.FromChars(name2));
    Result       : INTEGER;

  BEGIN
    Result := Unix.link(UnixFileName1, UnixFileName2);
    M3toC.FreeCopiedS(UnixFileName1);
    M3toC.FreeCopiedS(UnixFileName2);
    RETURN Result;
  END Link;


PROCEDURE Mkdir (READONLY name: ARRAY OF CHAR; mode: PermissionSet):
  INTEGER =
  VAR
    UnixFileName          := M3toC.CopyTtoS(Text.FromChars(name));
    Result      : INTEGER;

  BEGIN
    Result := Unix.mkdir(UnixFileName, PermSetToMode(mode));
    M3toC.FreeCopiedS(UnixFileName);
    RETURN Result;
  END Mkdir;


PROCEDURE Rename (READONLY old, new: ARRAY OF CHAR): INTEGER =
  VAR
    UnixFileName1          := M3toC.CopyTtoS(Text.FromChars(old));
    UnixFileName2          := M3toC.CopyTtoS(Text.FromChars(new));
    Result       : INTEGER;

  BEGIN
    Result := Unix.rename(UnixFileName1, UnixFileName2);
    M3toC.FreeCopiedS(UnixFileName1);
    M3toC.FreeCopiedS(UnixFileName2);
    RETURN Result;
  END Rename;


PROCEDURE Rmdir (READONLY name: ARRAY OF CHAR): INTEGER =
  VAR
    UnixFileName          := M3toC.CopyTtoS(Text.FromChars(name));
    Result      : INTEGER;

  BEGIN
    Result := Unix.rmdir(UnixFileName);
    M3toC.FreeCopiedS(UnixFileName);
    RETURN Result;
  END Rmdir;


PROCEDURE Stat (READONLY name: ARRAY OF CHAR; VAR buf: FStatType):
  INTEGER =
  VAR
    UnixFileName := M3toC.CopyTtoS(Text.FromChars(name));
    UnixStat: Ustat.struct_stat_star;
    Result  : INTEGER;

  BEGIN
    UnixStat := NEW(Ustat.struct_stat_star);
    Result := Ustat.stat(UnixFileName, UnixStat);

    buf := FStatType{
             UnixStat.st_dev, UnixStat.st_pad, UnixStat.st_ino,
             ModeToPermSet(UnixStat.st_mode), UnixStat.st_nlink,
             UnixStat.st_uid, UnixStat.st_gid, UnixStat.st_rdev,
             UnixStat.st_pad2, UnixStat.st_size, UnixStat.st_pad3,
             Utypes.timestruc_t{UnixStat.st_atime, UnixStat.st_spare1},
             Utypes.timestruc_t{UnixStat.st_mtime, UnixStat.st_spare2},
             Utypes.timestruc_t{UnixStat.st_ctime, UnixStat.st_spare3},
             UnixStat.st_blksize, UnixStat.st_blocks, UnixStat.st_fstype,
             UnixStat.st_pad4, ModeToSFT(UnixStat.st_mode)};

    M3toC.FreeCopiedS(UnixFileName);
    DISPOSE(UnixStat);
    RETURN Result;
  END Stat;


PROCEDURE Unlink (READONLY name: ARRAY OF CHAR): INTEGER =
  VAR
    UnixFileName          := M3toC.CopyTtoS(Text.FromChars(name));
    Result      : INTEGER;

  BEGIN
    Result := Unix.unlink(UnixFileName);
    M3toC.FreeCopiedS(UnixFileName);
    RETURN Result;
  END Unlink;


PROCEDURE PermSetToMode (S: PermissionSet): Ctypes.int =
  VAR Result := 0;

  BEGIN
    IF (Permission.permOX IN S) THEN INC(Result, Ustat.S_OEXEC); END;
    IF (Permission.permOW IN S) THEN INC(Result, Ustat.S_OWRITE); END;
    IF (Permission.permOR IN S) THEN INC(Result, Ustat.S_OREAD); END;

    IF (Permission.permGX IN S) THEN INC(Result, Ustat.S_GEXEC); END;
    IF (Permission.permGW IN S) THEN INC(Result, Ustat.S_GWRITE); END;
    IF (Permission.permGR IN S) THEN INC(Result, Ustat.S_GREAD); END;

    IF (Permission.permUX IN S) THEN INC(Result, Ustat.S_IEXEC); END;
    IF (Permission.permUW IN S) THEN INC(Result, Ustat.S_IWRITE); END;
    IF (Permission.permUR IN S) THEN INC(Result, Ustat.S_IREAD); END;

    IF (Permission.permSGID IN S) THEN INC(Result, Ustat.S_ISGID); END;
    IF (Permission.permSUID IN S) THEN INC(Result, Ustat.S_ISUID); END;
    RETURN Result;
  END PermSetToMode;


PROCEDURE ModeToPermSet (mode: Ctypes.int): PermissionSet =
  VAR Result := PermissionSet{};

  BEGIN
    IF (Word.And(mode, Ustat.S_OEXEC) # 0) THEN
      Result := Result + PermissionSet{Permission.permOX};
    END;
    IF (Word.And(mode, Ustat.S_OWRITE) # 0) THEN
      Result := Result + PermissionSet{Permission.permOW};
    END;
    IF (Word.And(mode, Ustat.S_OREAD) # 0) THEN
      Result := Result + PermissionSet{Permission.permOR};
    END;

    IF (Word.And(mode, Ustat.S_GEXEC) # 0) THEN
      Result := Result + PermissionSet{Permission.permGX};
    END;
    IF (Word.And(mode, Ustat.S_GWRITE) # 0) THEN
      Result := Result + PermissionSet{Permission.permGW};
    END;
    IF (Word.And(mode, Ustat.S_GREAD) # 0) THEN
      Result := Result + PermissionSet{Permission.permGR};
    END;

    IF (Word.And(mode, Ustat.S_IEXEC) # 0) THEN
      Result := Result + PermissionSet{Permission.permUX};
    END;
    IF (Word.And(mode, Ustat.S_IWRITE) # 0) THEN
      Result := Result + PermissionSet{Permission.permUW};
    END;
    IF (Word.And(mode, Ustat.S_IREAD) # 0) THEN
      Result := Result + PermissionSet{Permission.permUR};
    END;

    IF (Word.And(mode, Ustat.S_ISGID) # 0) THEN
      Result := Result + PermissionSet{Permission.permSGID};
    END;
    IF (Word.And(mode, Ustat.S_ISUID) # 0) THEN
      Result := Result + PermissionSet{Permission.permSUID};
    END;
    RETURN Result;
  END ModeToPermSet;


PROCEDURE ModeToSFT (mode: Ctypes.int): StatFileType =
  VAR Result: StatFileType;

  BEGIN
    IF (Word.And(mode, Ustat.S_IFREG) # 0) THEN
      RETURN StatFileType.statRegular;
    ELSIF (Word.And(mode, Ustat.S_IFDIR) # 0) THEN
      RETURN StatFileType.statDirectory;
    ELSIF (Word.And(mode, Ustat.S_IFCHR) # 0) THEN
      RETURN StatFileType.statCharacter;
    ELSIF (Word.And(mode, Ustat.S_IFBLK) # 0) THEN
      RETURN StatFileType.statBlock;
    ELSIF (Word.And(mode, Ustat.S_IFLNK) # 0) THEN
      RETURN StatFileType.statSymLink;
    ELSIF (Word.And(mode, Ustat.S_IFSOCK) # 0) THEN
      RETURN StatFileType.statSocket;
    END;
    RETURN Result;
  END ModeToSFT;

BEGIN
END M2UnixDirectory.
