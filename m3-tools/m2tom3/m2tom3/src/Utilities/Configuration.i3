INTERFACE Configuration;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Peter Klein                                               *)

(** pk
    1.2
    1995/02/14 15:37:53
    Configuration.i3,v
# Revision 1.2  1995/02/14  15:37:53  pk
# Support for -r flag inserted.
#
# Revision 1.1  1994/11/30  15:09:44  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT TextSeq, Pathname;


PROCEDURE ScanOptions (): BOOLEAN;
  (* Initializes the options.  If the function returns FALSE, help was
     required and the program should stop. *)


PROCEDURE WriteGRL (): BOOLEAN;
  (* Returns TRUE if a GRL file should be written. *)


PROCEDURE DumpRestriction (): BOOLEAN;
  (* Returns TRUE if only tokens and scopes should be dumped. *)


PROCEDURE DumpRadius (): CARDINAL;
  (* Returns the dump radius for GRL output. *)


PROCEDURE M2 (): BOOLEAN;
  (* Returns TRUE if additional Modula-2 output should be written. *)


PROCEDURE NoM3 (): BOOLEAN;
  (* Returns TRUE if no Modula-3 output should be written. *)


PROCEDURE KeepFor (): BOOLEAN;
  (* Returns TRUE if FOR-loops should be left untouched. *)


PROCEDURE KeepStrings (): BOOLEAN;
  (* Returns TRUE if string literals should be left untouched. *)


PROCEDURE InsertReadonly (): BOOLEAN;
  (* Returns TRUE if call-by-value arrays should be made READONLY. *)


PROCEDURE Quiet (): BOOLEAN;
  (* Returns TRUE if the program should be quiet. *)


PROCEDURE Verbose (): BOOLEAN;
  (* Returns TRUE if the program should be verbose. *)


PROCEDURE ToFile (): BOOLEAN;
  (* Returns TRUE if the program should write warnings into the file. *)


PROCEDURE InputPaths (): TextSeq.T;
  (* Returns the input paths to contain Modula-2 interfaces. *)


PROCEDURE OutputPath (): Pathname.T;
  (* Returns the output path into which Modula-3 should be written. *)


PROCEDURE Files (): TextSeq.T;
  (* Returns the files to be processed. *)


PROCEDURE FromStdin (): BOOLEAN;
  (* Returns TRUE if stdin should be processed instead of files. *)

END Configuration.
