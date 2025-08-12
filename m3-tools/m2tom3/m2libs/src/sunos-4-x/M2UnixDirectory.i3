INTERFACE M2UnixDirectory;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Peter Klein                                               *)

(** pk
    1.1
    1995/08/15 14:36:44
    M2UnixDirectory.i3,v
# Revision 1.1  1995/08/15  14:36:44  pk
# Separate versions for solaris 2 and sunos 4.
#
# Revision 1.1  1994/11/30  15:02:54  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT Ctypes, Utypes;


TYPE
  Accessmode = {accessX,         (* executable by caller *)
                accessW,         (* writable by caller *)
                accessR          (* readable by caller *)
               };

  AccessSet = SET OF Accessmode;

  Permission = {permOX,          (* other execute *)
                permOW,          (* other write *)
                permOR,          (* other read *)
                permGX,          (* group execute *)
                permGW,          (* group write *)
                permGR,          (* group read *)
                permUX,          (* user execute *)
                permUW,          (* user write *)
                permUR,          (* user read *)
                permSGID,        (* set group id on execution *)
                permSUID         (* set user id on execution *)
               };

  PermissionSet = SET OF Permission;

  StatFileType = {statRegular,   (* regular file *)
                  statDirectory, (* directory *)
                  statCharacter, (* character special *)
                  statBlock,     (* block special *)
                  statSymLink,   (* symbolic link *)
                  statSocket     (* socket *)
                 };

  FStatType = RECORD             (* what FStat returns stuff into *)
                dev    : Utypes.dev_t;
                ino    : Utypes.ino_t;
                mode   : PermissionSet;
                nlink  : Ctypes.short;
                uid    : Ctypes.short;
                gid    : Ctypes.short;
                rdev   : Utypes.dev_t;
                size   : Utypes.off_t;
                atime  : Utypes.time_t;
                spare1 : Ctypes.int;
                mtime  : Utypes.time_t;
                spare2 : Ctypes.int;
                ctime  : Utypes.time_t;
                spare3 : Ctypes.int;
                blksize: Ctypes.long;
                blocks : Ctypes.long;
                spare4 : ARRAY [0 .. 1] OF Ctypes.long;
                type   : StatFileType;
              END;


CONST
  (* PermissionSet constants *)
  permAll = PermissionSet{Permission.permOX.. Permission.permUR};
  (* rwxrwxrwx or 0777 *)
  permNone = PermissionSet{};    (* no permissions *)

  (* AccessSet constant *)
  accessF = AccessSet{};         (* does file exist *)


PROCEDURE Access (READONLY name: ARRAY OF CHAR; mode: AccessSet): INTEGER;
  (* determine existence and accessability of file *)


PROCEDURE Chdir (READONLY name: ARRAY OF CHAR): INTEGER;
  (* change current working directory *)


PROCEDURE Chmod (READONLY name: ARRAY OF CHAR; mode: PermissionSet):
  INTEGER;
  (* change access permissions of file *)


PROCEDURE Link (READONLY name1, name2: ARRAY OF CHAR): INTEGER;
  (* make a (hard) file system link from existing file (name1) to new name
     (name2) *)


PROCEDURE Mkdir (READONLY name: ARRAY OF CHAR; mode: PermissionSet):
  INTEGER;
  (* make a new directory *)


PROCEDURE Rename (READONLY old, new: ARRAY OF CHAR): INTEGER;
  (* rename a file *)


PROCEDURE Rmdir (READONLY name: ARRAY OF CHAR): INTEGER;
  (* delete a directory *)


PROCEDURE Stat (READONLY name: ARRAY OF CHAR; VAR buf: FStatType): INTEGER;
  (* determine characteristics of named file *)


PROCEDURE Unlink (READONLY name: ARRAY OF CHAR): INTEGER;
  (* remove link/file from file system *)

END M2UnixDirectory.
