INTERFACE M2Files;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Peter Klein                                               *)

(** pk
    1.1
    1995/08/15 14:36:15
    M2Files.i3,v
# Revision 1.1  1995/08/15  14:36:15  pk
# Separate versions for solaris 2 and sunos 4.
#
# Revision 1.2  1995/03/02  10:41:06  pk
# File is now an untraced pointer.
#
# Revision 1.1  1994/11/30  15:02:41  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT Word, Utypes;


TYPE
  File <: ADDRESS;

  BinTextMode = {binMode, textMode};
  ReadWriteMode = {readOnly, readWrite, appendOnly};
  ReplaceMode = {noReplace, replace};

  FileState = {ok,

               (* errors opening files *)
               nameError,        (* illegal syntax in file name as
                                    passed *)
               noFile,           (* file with specified name not found *)
               existingFile,     (* file already exists *)

               (* errors opening or operating *)
               deviceError,      (* some hardware error during I/O *)
               noMoreRoom,       (* no room on volume/medium/directory *)
               accessError,      (* protect, read/write, binary/text
                                    error *)

               (* errors operating upon a file *)
               notOpen,          (* operation on unopened file *)
               endError,         (* read attempted after EOL or EOF *)
               outsideFile,      (* position before BOF or after EOF *)

               (* and *)
               otherError        (* error unanticipated by this
                                    definition *)
              };

  FilePosition = Utypes.off_t;


PROCEDURE Open (VAR      file     : File;
                READONLY name     : ARRAY OF CHAR;
                         binText  : BinTextMode;
                         writeMode: ReadWriteMode;
                VAR      state    : FileState      );
  (* Open an existing external file; error if not present *)


PROCEDURE Create (VAR      file    : File;
                  READONLY name    : ARRAY OF CHAR;
                           binText : BinTextMode;
                           replMode: ReplaceMode;
                  VAR      state   : FileState      );
  (* Create a new external file.  If named file already exists, then
     replace only if replMode = replace, otherwise, error *)


PROCEDURE Close (VAR file: File; VAR state: FileState);
  (* Close the file, saving the external file *)


PROCEDURE Remove (VAR file: File; VAR state: FileState);
  (* Close the file, removing the external file *)


PROCEDURE Reset (file: File; VAR state: FileState);
  (* Reposition to the start of the file *)


PROCEDURE Rewrite (file: File; VAR state: FileState);
  (* Reposition to start of file and then truncate file *)


PROCEDURE Truncate (file: File; VAR state: FileState);
  (* Set the end of the file to the current position *)


PROCEDURE Flush (file: File; VAR state: FileState);
  (* Writes any modified buffers to the storage medium *)


PROCEDURE EOF (file: File): BOOLEAN;
  (* Returns true if last operation was not performed due to end of file or
     error *)


PROCEDURE State (file: File): FileState;
  (* Returns the current state of the file *)


PROCEDURE ResetState (file: File; VAR state: FileState);
  (* Allows continued operation in presence of error conditions;
     reevaluates EOF/EOL so that they really indicate file position *)


PROCEDURE GetFileName (    file : File;
                       VAR name : ARRAY OF CHAR;
                       VAR state: FileState      );
  (* Returns the complete and unambiguous name of the file *)


PROCEDURE ReadByte (file: File; VAR byte: CHAR; VAR state: FileState);
  (* read one byte from a binary file *)


PROCEDURE ReadWord (file: File; VAR word: Word.T; VAR state: FileState);
  (* Read one word from a binary file *)


PROCEDURE ReadBlock (    file : File;
                     VAR block: ARRAY OF CHAR;
                     VAR state: FileState      );
  (* Read an arbitrary variable from a binary file *)


PROCEDURE ReadBytes (    file     : File;
                         addr     : ADDRESS;
                         bytes    : CARDINAL;
                     VAR bytesRead: CARDINAL;
                     VAR state    : FileState );
  (* Read an arbitrary number of bytes from a binary file. *)
  (* WARNING: ReadBytes does NOT yield the expected result if addr points
     to an array!!! *)


PROCEDURE WriteByte (file: File; byte: CHAR; VAR state: FileState);
  (* Write one byte to a binary file *)


PROCEDURE WriteWord (file: File; word: Word.T; VAR state: FileState);
  (* Write one word to a binary file *)


PROCEDURE WriteBlock (         file : File;
                      READONLY block: ARRAY OF CHAR;
                      VAR      state: FileState      );
  (* Write an arbitrary variable to a binary file *)


PROCEDURE WriteBytes (    file     : File;
                          addr     : ADDRESS;
                          bytecount: CARDINAL;
                      VAR state    : FileState );
  (* Write an arbitrary number of bytes to a binary file *)
  (* WARNING: WriteBytes does NOT yield the expected result if addr points
     to an array!!! *)


PROCEDURE GetFilePos (file: File; VAR pos: FilePosition);
  (* returns the current position in the file *)


PROCEDURE GetEOF (file: File; VAR pos: FilePosition);
  (* returns a FilePosition of the current end of the file *)


PROCEDURE GetBOF (file: File; VAR pos: FilePosition);
  (* returns a FilePosition of the current beginning of the file *)


PROCEDURE CalcFilePos (    file         : File;
                       VAR pos          : FilePosition;
                           numOfElements: INTEGER;
                           elementLength: CARDINAL      );
  (* Calculate a file position relative to pos, offset by NumOfElements,
     each of size elementLength.  Return the rsulting position in pos *)


PROCEDURE SetFilePos (file: File; pos: FilePosition; VAR state: FileState);
  (* positions the file as specified.  illegal position leaves the file as
     it was before the call and returns a bad state *)


PROCEDURE RereadByte (file: File): CHAR;
  (* Returns the last character read from the file. *)

END M2Files.
