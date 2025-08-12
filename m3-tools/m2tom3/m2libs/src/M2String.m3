MODULE M2String;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Peter Klein                                               *)

(** pk
    1.1
    1994/11/30 15:02:49
    M2String.m3,v
# Revision 1.1  1994/11/30  15:02:49  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT Word, ASCII, Text;


PROCEDURE Length (READONLY str: ARRAY OF CHAR): Word.T =
  VAR count: Word.T := 0;

  BEGIN
    WHILE ((count <= LAST(str)) AND (str[count] # ASCII.NUL)) DO
      INC(count);
    END;
    RETURN count;
  END Length;


PROCEDURE Assign (READONLY source : ARRAY OF CHAR;
                  VAR      dest   : ARRAY OF CHAR;
                  VAR      success: BOOLEAN        ) =
  BEGIN
    WITH sourceLength = Length(source) DO
      IF (sourceLength > NUMBER(dest)) THEN success := FALSE; RETURN; END;
      SUBARRAY(dest, 0, sourceLength) := SUBARRAY(source, 0, sourceLength);
      IF (LAST(dest) >= sourceLength) THEN
        dest[sourceLength] := ASCII.NUL;
      END;
    END;
    success := TRUE;
  END Assign;


PROCEDURE Insert (READONLY source : ARRAY OF CHAR;
                  VAR      dest   : ARRAY OF CHAR;
                           index  : Word.T;
                  VAR      success: BOOLEAN        ) =
  BEGIN
    WITH sourceLength = Length(source),
         destLength   = Length(dest)    DO
      IF ((NUMBER(dest) < sourceLength + destLength)
            OR (LAST(dest) < index)) THEN
        success := FALSE;
        RETURN;
      END;
      SUBARRAY(dest, index + sourceLength, destLength - index) :=
        SUBARRAY(dest, index, destLength - index);
      SUBARRAY(dest, index, sourceLength) :=
        SUBARRAY(source, 0, sourceLength);
    END;
    success := TRUE;
  END Insert;


PROCEDURE Delete (VAR str    : ARRAY OF CHAR;
                      index  : Word.T;
                      len    : Word.T;
                  VAR success: BOOLEAN        ) =
  BEGIN
    IF (NUMBER(str) < index + len) THEN success := FALSE; RETURN; END;
    SUBARRAY(str, index, NUMBER(str) - index - len) :=
      SUBARRAY(str, index + len, NUMBER(str) - index - len);
    str[NUMBER(str) - len] := ASCII.NUL;
    success := TRUE;
  END Delete;


PROCEDURE Position (READONLY pattern: ARRAY OF CHAR;
                    READONLY source : ARRAY OF CHAR;
                    VAR      index  : Word.T;
                    VAR      found  : BOOLEAN        ) =
  BEGIN
    index := 0;
    WITH sourceLength  = Length(source),
         patternLength = Length(pattern) DO
      WHILE (index <= sourceLength - patternLength) DO
        IF (SUBARRAY(source, index, patternLength)
              = SUBARRAY(pattern, 0, patternLength)) THEN
          found := TRUE;
          RETURN;
        END;
        INC(index);
      END;
    END;
    found := FALSE;
  END Position;


PROCEDURE Substring (READONLY source : ARRAY OF CHAR;
                              index  : Word.T;
                              len    : Word.T;
                     VAR      dest   : ARRAY OF CHAR;
                     VAR      success: BOOLEAN        ) =
  BEGIN
    IF (NUMBER(dest) < len) THEN success := FALSE; RETURN; END;
    SUBARRAY(dest, 0, len) := SUBARRAY(source, index, len);
    IF (LAST(dest) >= len) THEN dest[len] := ASCII.NUL; END;
    success := TRUE;
  END Substring;


PROCEDURE Concat (READONLY source1: ARRAY OF CHAR;
                  READONLY source2: ARRAY OF CHAR;
                  VAR      dest   : ARRAY OF CHAR;
                  VAR      success: BOOLEAN        ) =
  BEGIN
    WITH source1Length = Length(source1),
         source2Length = Length(source2),
         totalLength   = source1Length + source2Length DO
      IF (NUMBER(dest) < totalLength) THEN success := FALSE; RETURN; END;
      SUBARRAY(dest, 0, source1Length) :=
        SUBARRAY(source1, 0, source1Length);
      SUBARRAY(dest, source1Length, source2Length) :=
        SUBARRAY(source2, 0, source2Length);
      IF (LAST(dest) >= totalLength) THEN
        dest[totalLength] := ASCII.NUL;
      END;
      success := TRUE;
    END;
  END Concat;


PROCEDURE Compare (READONLY string1: ARRAY OF CHAR;
                   READONLY string2: ARRAY OF CHAR  ): CompareResult =
  CONST
    Conv = ARRAY [-1 .. 1] OF
             CompareResult{CompareResult.less, CompareResult.equal,
                           CompareResult.greater};

  BEGIN
    WITH s1 = SUBARRAY(string1, 0, Length(string1)),
         s2 = SUBARRAY(string2, 0, Length(string2)),
         t1 = Text.FromChars(s1),
         t2 = Text.FromChars(s2)                     DO
      RETURN Conv[Text.Compare(t1, t2)];
    END;
  END Compare;

BEGIN
END M2String.
