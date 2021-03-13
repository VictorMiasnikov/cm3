(* Copyright (C) 1994, Digital Equipment Corporation           *)
(* All rights reserved.                                        *)
(* See the file COPYRIGHT for a full description.              *)
(*                                                             *)
(* Last modified on Mon Jun 20 15:34:10 PDT 1994 by kalsow     *)

UNSAFE MODULE RTPacking;

IMPORT FloatMode, Word;

CONST
  Bits = ARRAY [0..3] OF INTEGER { 8, 16, 32, 64 };

VAR
  init_done := FALSE;
  local     : T;

TYPE Inner = RECORD F : BITS 24 FOR CHAR END; 
  (* STRICTALIGN will require this record to have alignment of 32, 
     to prevent it's crossing a word boundary if it were to be allocated,
     as a field of a containing record, starting at the last or next-to-last
     byte of a machine word.  
     LAZYALIGN will allow alignment of 8 bits.
  *) 

TYPE Outer 
    = RECORD 
        A : CHAR; 
        B : Inner
      (* ^There will be padding before B IFF alignment of Inner is > 8. *) 
      END; 

PROCEDURE IsLazy ( ) : BOOLEAN =
  VAR V : Outer;
      Offset : CARDINAL;  
  BEGIN 
    Offset := ADR ( V . B ) - ADR ( V . A );
    RETURN Offset = ADRSIZE ( CHAR )  
  END IsLazy; 

PROCEDURE Local (): T =
  VAR
    a: RECORD ch: CHAR;  x: EXTENDED; END;
    b: RECORD ch: CHAR;  x: RECORD ch: CHAR; END; END;
    i: INTEGER := 1;
    x: ADDRESS := ADR (i);
    p: UNTRACED REF CHAR := x;
    s: SET OF [0..7];
  BEGIN
    IF NOT init_done THEN
      local.word_size     := SizeOf (ADRSIZE (INTEGER));
      local.long_size     := SizeOf (ADRSIZE (LONGINT));
      local.max_align     := SizeOf (ADR (a.x) - ADR (a.ch));
      local.struct_align  := SizeOf (ADR (b.x) - ADR (b.ch));
      local.little_endian := (p^ = VAL (1, CHAR));
      local.float         := FloatKind.IEEE;
      IF NOT FloatMode.IEEE THEN local.float := FloatKind.VAX; END;
      local.lazy_align    := IsLazy();
      local.widechar_size := SizeOf (ADRSIZE (WIDECHAR));
      local.small_sets    := BITSIZE (s) = 8;
      init_done := TRUE;
    END;
    RETURN local;
  END Local;

PROCEDURE SizeOf (n: INTEGER): CARDINAL =
  BEGIN
    (* convert address units to bits *)
    n := n DIV ADRSIZE(CHAR) * BITSIZE(CHAR);

    (* look for a known size *)
    FOR i := FIRST (Bits) TO LAST (Bits) DO
      IF (Bits[i] = n) THEN RETURN n; END;
    END;
    <*ASSERT FALSE*>
  END SizeOf;

PROCEDURE Encode (READONLY t: T): INTEGER =
  VAR n := 0;
  VAR wc: INTEGER; 
  BEGIN
    IF t.widechar_size = 32 
    THEN wc := BitSize (32)
    ELSE wc := BitSize (8)
    END; 
      (* Always BitSize (t.widechar_size) would be the consistent thing to use
         here, but that will cause older versions that don't put WIDECHAR size
         in a T to suffer an assert failure during Decode.  The only WIDECHAR 
         sizes are 16 and 32, and Decode interprets 8 to really mean 16, 
         so it will correctly decode values written by older Encode.  
         So we also encode 16 in the old way too, so older Decode will not 
         choke on Ts we write with 16-bit WIDECHAR. *) 
    n := Word.Or (Word.Shift (n, 1), ORD (t.small_sets));
    n := Word.Or (Word.Shift (n, 2), wc );
    n := Word.Or (Word.Shift (n, 1), ORD (t.lazy_align));
    n := Word.Or (Word.Shift (n, 2), BitSize (t.long_size));
    n := Word.Or (Word.Shift (n, 2), BitSize (t.word_size));
    n := Word.Or (Word.Shift (n, 2), BitSize (t.max_align));
    n := Word.Or (Word.Shift (n, 2), BitSize (t.struct_align));
    n := Word.Or (Word.Shift (n, 1), ORD (t.little_endian));
    n := Word.Or (Word.Shift (n, 2), ORD (t.float));
    RETURN n;
  END Encode;

PROCEDURE Decode (i: INTEGER): T =
  VAR t: T;
  BEGIN
    t.float       := VAL (Word.And (i, 3), FloatKind); i := Word.Shift (i, -2);
    t.little_endian := VAL (Word.And (i, 1), BOOLEAN); i := Word.Shift (i, -1);
    t.struct_align  := Bits[Word.And (i, 3)];    i := Word.Shift (i, -2);
    t.max_align     := Bits[Word.And (i, 3)];    i := Word.Shift (i, -2);
    t.word_size     := Bits[Word.And (i, 3)];    i := Word.Shift (i, -2);
    t.long_size     := Bits[Word.And (i, 3)];    i := Word.Shift (i, -2);
    t.lazy_align    := VAL (Word.And (i, 1), BOOLEAN); i := Word.Shift (i, -1);
    t.widechar_size := Bits[Word.And (i, 3)];    i := Word.Shift (i, -2);
    IF t.widechar_size = 8 
    THEN (* Was written by older RTPacking, without a widechar_size. *)
      t.widechar_size := 16 
    END; 
    t.small_sets    := VAL (Word.And (i, 1), BOOLEAN); i := Word.Shift (i, -1);
    (* Ignore any remaining bits, in case we get a value from a later version
       that has additional properties. *) 
    RETURN t;
  END Decode;

PROCEDURE BitSize (n: CARDINAL): [FIRST (Bits) .. LAST (Bits)]  =
  BEGIN
    FOR i := FIRST (Bits) TO LAST (Bits) DO
      IF (Bits[i] = n) THEN RETURN i; END;
    END;
    <*ASSERT FALSE*>
  END BitSize;

BEGIN
END RTPacking.
