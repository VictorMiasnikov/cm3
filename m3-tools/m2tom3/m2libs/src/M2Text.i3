INTERFACE M2Text;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Peter Klein                                               *)

(** pk
    1.1
    1994/11/30 15:02:50
    M2Text.i3,v
# Revision 1.1  1994/11/30  15:02:50  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

FROM M2Files IMPORT File, FileState;

IMPORT Word;


PROCEDURE EOL (file: File): BOOLEAN;
  (* Returns true if last operation was not performed due to end of line or
     error *)


PROCEDURE ReadChar (file: File; VAR ch: CHAR; VAR state: FileState);
  (* Read a char from a TextFile.  .... *)


PROCEDURE ReadString (    file : File;
                      VAR str  : ARRAY OF CHAR;
                      VAR state: FileState      );
  (* Read a string from a text file until EOL, EOF, or end of string *)


PROCEDURE ReadLn (file: File; VAR state: FileState);
  (* eat characters until EOL, then eat EOL *)


PROCEDURE UndoRead (file: File; VAR state: FileState);
  (* allow most recently read CHAR to be read again *)


PROCEDURE CondRead (    file   : File;
                    VAR ch     : CHAR;
                    VAR success: BOOLEAN;
                    VAR state  : FileState);
  (* attempt to read a char: return TRUE in "success" if read succeeds;
     return FALSE in "success" if read fails.  If read fails, value in "ch"
     is undefined *)


PROCEDURE WriteChar (file: File; ch: CHAR; VAR state: FileState);
  (* Write a single character to a text file *)


PROCEDURE WriteString (         file : File;
                       READONLY str  : ARRAY OF CHAR;
                       VAR      state: FileState      );
  (* Write a string of characters to a text file *)


PROCEDURE WriteLn (file: File; VAR state: FileState);
  (* Write an EOL to a text file *)


PROCEDURE WriteInt (    file : File;
                        int  : INTEGER;
                        width: CARDINAL;
                    VAR state: FileState );


PROCEDURE WriteCard (    file : File;
                         card : Word.T;
                         width: CARDINAL;
                     VAR state: FileState );

END M2Text.
