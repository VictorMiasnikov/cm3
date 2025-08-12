INTERFACE M2String;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Peter Klein                                               *)

(** pk
    1.1
    1994/11/30 15:02:47
    M2String.i3,v
# Revision 1.1  1994/11/30  15:02:47  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT Word;


TYPE CompareResult = {less, equal, greater};


PROCEDURE Length (READONLY str: ARRAY OF CHAR) (* in this string *)
  : Word.T;                      (* count of data chars *)


PROCEDURE Assign (READONLY source: ARRAY OF CHAR;  (* copy from this str *)
                  VAR      dest  : ARRAY OF CHAR;  (* to this string *)
                  VAR success: BOOLEAN);


PROCEDURE Insert (READONLY source: ARRAY OF CHAR;  (* insert this string *)
                  VAR      dest  : ARRAY OF CHAR;  (* into this string *)
                      index  : Word.T;  (* before this char pos*)
                  VAR success: BOOLEAN                           );


PROCEDURE Delete (VAR str    : ARRAY OF CHAR;  (* from this string *)
                      index  : Word.T;         (* 1st char to delete *)
                      len    : Word.T;         (* cnt of chars to del *)
                  VAR success: BOOLEAN                                  );


PROCEDURE Position (READONLY pattern: ARRAY OF CHAR;  (* search for this
                                                         one *)
                    READONLY source: ARRAY OF CHAR;  (* within this one *)
                    VAR index: Word.T;  (* 1st char of match *)
                    VAR found: BOOLEAN                         );


PROCEDURE Substring (READONLY source: ARRAY OF CHAR;  (* copy from this
                                                         str *)
                         index  : Word.T;         (* at this char postn *)
                         len    : Word.T;         (* for this char count *)
                     VAR dest   : ARRAY OF CHAR;  (* into this string *)
                     VAR success: BOOLEAN                                  );


PROCEDURE Concat (READONLY source1: ARRAY OF CHAR;  (* this string with *)
                  READONLY source2: ARRAY OF CHAR;  (* this str on the
                                                       end *)
                  VAR dest   : ARRAY OF CHAR;  (* assigned to this str*)
                  VAR success: BOOLEAN                                  );


PROCEDURE Compare (READONLY string1: ARRAY OF CHAR;  (* compare this
                                                        string *)
                   READONLY string2: ARRAY OF CHAR (* to this string *)):
  CompareResult;

END M2String.
