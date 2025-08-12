INTERFACE M2UnixParam;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Peter Klein                                               *)

(** pk
    1.1
    1994/11/30 15:02:59
    M2UnixParam.i3,v
# Revision 1.1  1994/11/30  15:02:59  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT Word;


TYPE UPResult = {upDone, upNotFound, upTruncated};


PROCEDURE NoOfArguments (): Word.T;


PROCEDURE GetArgument (    argNr : Word.T;
                       VAR arg   : ARRAY OF CHAR;
                       VAR result: UPResult       );


PROCEDURE GetEnvVariable (READONLY name  : ARRAY OF CHAR;
                          VAR      value : ARRAY OF CHAR;
                          VAR      result: UPResult       );

END M2UnixParam.
