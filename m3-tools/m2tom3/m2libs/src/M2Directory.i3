INTERFACE M2Directory;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Peter Klein                                               *)

(** pk
    1.1
    1994/11/30 15:02:38
    M2Directory.i3,v
# Revision 1.1  1994/11/30  15:02:38  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

FROM M2Files IMPORT FileState;


TYPE FileNameType = {invalidName, singleName, wildName};


PROCEDURE Rename (READONLY fromName: ARRAY OF CHAR;
                  READONLY toName  : ARRAY OF CHAR;
                  VAR      state   : FileState      );


PROCEDURE Delete (READONLY fileName: ARRAY OF CHAR; VAR state: FileState);
  (* The two previous procedures do not accept wild-card file names, as
     returned states from such calls would not be meaningful.  It would be
     appropriate to call them from within a DirQueryProc *)


PROCEDURE TypeOfFileName (READONLY name: ARRAY OF CHAR): FileNameType;
  (* Determine if a file name is syntactically valid *)
  (** Here are the rules:
   * o any character found with the HIGH-ORDER BIT SET immediately qualifies the
   * string as an invalidName, as do non-printing characters.
   * o if the character *, ?, $, or [ are found, the string is considered a
   * wildName.  Note that ~ is NOT part of this set.  Backslash escaping does
   * not work in this context.
   * o if the name is too long (currently 129 characters), then the string is
   * an invalidName.  Sorry.
   * o any other strings are singleName's *)

END M2Directory.
