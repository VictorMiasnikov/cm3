INTERFACE M2InOut;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Peter Klein                                               *)

(** pk
    1.1
    1994/11/30 15:02:44
    M2InOut.i3,v
# Revision 1.1  1994/11/30  15:02:44  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT Word;

CONST
  EOL = '\012';
  (* Unix line separator *)


VAR Done: BOOLEAN;               (* Indicates prev operation's Success *)


PROCEDURE Read (VAR ch: CHAR);
  (* Done == NOT end-of-file on reading.  If true, ch is a valid character,
     or is EOL.  If false, ch is 0C and end of file has been reached. *)


PROCEDURE ReadString (VAR s: ARRAY OF CHAR);
  (* Ignoring leading white space, read a sequence of chars not including
     blanks or control chars.  The char which follows the string is
     assigned to termCH.  It will not be seen in subsequent call to any
     Read routine. *)


PROCEDURE ReadInt (VAR x: INTEGER);
  (* Combination of ReadString and conversion to INTEGER.  Syntax :
     ["+"|"-"] digit { digit } .  Leading blanks are ignored.  Variable
     termCH is set as in ReadString.  Done == "an integer was successfully
     read" *)


PROCEDURE ReadCard (VAR x: Word.T);
  (* Combination of ReadString and conversion to CARDINAL.  Syntax : digit
     { digit } .  Leading blanks are ignored.  Variable termCH is set as in
     ReadString.  Done == "a cardinal was successfully read" *)


(* Output Procedures *)


PROCEDURE Write (ch: CHAR);
  (* Put ch to the output stream.  Write (EOL) is equivalent to WriteLn.
     Other control characters have terminal- dependent effects. *)


PROCEDURE WriteLn ();
  (* Write a line separator character (EOL).  Under normal conditions, this
     will send both carriage return and line feed to tty device, or the EOL
     character to a file. *)


PROCEDURE WriteString (READONLY s: ARRAY OF CHAR);
  (* Write the string s to the output stream.  Embedded EOL characters have
     the same effect as in Write.  Other control characters have
     terminal-dependent effects. *)


PROCEDURE WriteInt (x: INTEGER; n: CARDINAL);
  (* Write the integer x with at least n characters of width.  Leading
     zeroes are suppressed.  If n is greater than the needed number of
     columns, the number is right-justified. *)


PROCEDURE WriteCard (x: Word.T; n: CARDINAL);
  (* Write the cardinal x with at least n characters of width.  Leading
     zeroes are suppressed.  If n is greater than the * needed number of
     columns, the number is right-justified. *)

END M2InOut.
