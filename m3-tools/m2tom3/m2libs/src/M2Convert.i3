INTERFACE M2Convert;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Peter Klein                                               *)

(** pk
    1.1
    1994/11/30 15:02:34
    M2Convert.i3,v
# Revision 1.1  1994/11/30  15:02:34  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT Word;


PROCEDURE IntToStr (    int    : INTEGER;
                    VAR str    : ARRAY OF CHAR;
                        width  : Word.T;
                    VAR success: BOOLEAN        );

PROCEDURE CardToStr (    card   : Word.T;
                     VAR str    : ARRAY OF CHAR;
                         width  : Word.T;
                     VAR success: BOOLEAN        );

PROCEDURE NumToStr (    num    : Word.T;
                    VAR str    : ARRAY OF CHAR;
                        base   : Word.T (* [2..36] *);
                        width  : Word.T;
                    VAR success: BOOLEAN               );

PROCEDURE StrToInt (READONLY str    : ARRAY OF CHAR;
                    VAR      int    : INTEGER;
                    VAR      success: BOOLEAN        );

PROCEDURE StrToCard (READONLY str    : ARRAY OF CHAR;
                     VAR      card   : Word.T;
                     VAR      success: BOOLEAN        );

PROCEDURE StrToNum (READONLY str    : ARRAY OF CHAR;
                    VAR      num    : Word.T;
                             base   : Word.T (* [2..36] *);
                    VAR      success: BOOLEAN               );

END M2Convert.
