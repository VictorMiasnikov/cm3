MODULE M2UnixParam;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Peter Klein                                               *)

(** pk
    1.1
    1994/11/30 15:03:02
    M2UnixParam.m3,v
# Revision 1.1  1994/11/30  15:03:02  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT Params, Env, Text, Word, ASCII;


PROCEDURE NoOfArguments (): Word.T =
  BEGIN
    RETURN Params.Count;
  END NoOfArguments;


PROCEDURE GetArgument (    argNr : Word.T;
                       VAR arg   : ARRAY OF CHAR;
                       VAR result: UPResult       ) =
  BEGIN
    IF (argNr >= Params.Count) THEN
      result := UPResult.upNotFound;
      RETURN;
    END;
    WITH t = Params.Get(argNr),
         l = Text.Length(t)     DO
      Text.SetChars(arg, t);
      IF (l > NUMBER(arg)) THEN
        result := UPResult.upTruncated;
      ELSE
        IF (l <= LAST(arg)) THEN arg[l] := ASCII.NUL; END;
        result := UPResult.upDone;
      END;
    END;
  END GetArgument;


PROCEDURE GetEnvVariable (READONLY name  : ARRAY OF CHAR;
                          VAR      value : ARRAY OF CHAR;
                          VAR      result: UPResult       ) =
  BEGIN
    WITH t = Env.Get(Text.FromChars(name)) DO
      IF (t = NIL) THEN result := UPResult.upNotFound; RETURN; END;
      WITH l = Text.Length(t) DO
        Text.SetChars(value, t);
        IF (l > NUMBER(value)) THEN
          result := UPResult.upTruncated;
        ELSE
          IF (l <= LAST(value)) THEN value[l] := ASCII.NUL; END;
          result := UPResult.upDone;
        END;
      END;
    END;
  END GetEnvVariable;

BEGIN
END M2UnixParam.
