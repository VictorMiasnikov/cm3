MODULE ScanBuffer;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:04:02
    ScanBuffer.m3,v
# Revision 1.1  1994/11/30  15:04:02  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- ScanBuffer -------------------------------------------------------------
  * The buffer is represented internally as dynamic array.
  * ----------------------------------------------------------------------------
  **)

IMPORT Text;


CONST
  initialSize   = 20 * 1024;
  incrementSize = 4 * 1024;
  empty         = -1;


TYPE Buffer = REF ARRAY OF CHAR;


VAR
  last  : INTEGER := empty;
  buffer: Buffer;


PROCEDURE ClearBuffer () =
  BEGIN
    last := empty;
  END ClearBuffer;


PROCEDURE AppendToBuffer (char: CHAR) =
  BEGIN
    (* expand buffer *)
    IF (last = NUMBER(buffer^)) THEN
      WITH oldSize   = NUMBER(buffer^),
           newBuffer = NEW(Buffer, oldSize + incrementSize) DO
        SUBARRAY(newBuffer^, 0, oldSize) := SUBARRAY(buffer^, 0, oldSize);
        buffer := newBuffer;
      END;
    END;

    (* insert new character *)
    INC(last);
    buffer^[last] := char;
  END AppendToBuffer;


PROCEDURE GetText (): TEXT =
  BEGIN
    RETURN Text.FromChars(SUBARRAY(buffer^, 0, last + 1));
  END GetText;

BEGIN
  buffer := NEW(Buffer, initialSize);
END ScanBuffer.
