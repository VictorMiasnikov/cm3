(* Copyright (C) 1994, Digital Equipment Corporation. *)
(* All rights reserved.                               *)
(* See the file COPYRIGHT for a full description.     *)
 
MODULE Main;

IMPORT Test, Wr, Stdio, Fmt;
<*FATAL ANY*>

(* VVM 2023-04-18 13-33
CONST Last32 = 16_7FFFFFFF;
CONST First32 = - Last32 - 1;
*)

TYPE
(* VVM 2023-04-18 13-33
  Int32A = BITS 32 FOR [First32 .. Last32];
  Int32B = (*BITS 32 FOR*) [First32 .. Last32];
*)
(* VVM 2023-04-18 13-33 *)
  Int32A = BITS 32 FOR [-16_7fffffff-1..16_7FFFFFFF];
  Int32B = (*BITS 32 FOR*) [-16_7fffffff-1..16_7FFFFFFF];
(* *)

  EventIDA = ARRAY [0..1] OF Int32A; (* lsw..msw *)
  EventIDB = ARRAY [0..1] OF Int32B; (* lsw..msw *)

  WireRep_T = ARRAY [0..15] OF BITS 8 FOR [0..255];

TYPE
  Key = WireRep_T;
  ValueA = RECORD 
    dirty: BOOLEAN;
    keep:  BOOLEAN;
    ts: EventIDA;
  END;
  ValueB = RECORD 
    dirty: BOOLEAN;
    keep:  BOOLEAN;
    ts: EventIDB;
  END;

TYPE
  EntryA = RECORD  
      key: Key; 
      value: ValueA;
      occupied: BOOLEAN;
    END;
  EntryB = RECORD  
      key: Key; 
      value: ValueB;
      occupied: BOOLEAN;
    END;

(*
  Buckets = REF ARRAY OF EntryA;
*)

(* VVM 2023-04-18 13-33
VAR BucketsVal := NEW (Buckets, 1);
*)

PROCEDURE Out (tag: TEXT;  val: INTEGER) =
  BEGIN
    Wr.PutText (Stdio.stderr, tag);
    Wr.PutText (Stdio.stderr, " = ");
    Wr.PutText (Stdio.stderr, Fmt.Int (val));
    Wr.PutText (Stdio.stderr, "\n");
  END Out;

BEGIN
  Out ("Int32", BITSIZE (Int32A));
  Test.checkI (BITSIZE (Int32A), BITSIZE (Int32B));
  Out ("EventID", BITSIZE (EventIDA));
  Test.checkI (BITSIZE (EventIDA), BITSIZE (EventIDB));
  Out ("WireRep_T", BITSIZE (WireRep_T));
  Out ("Key", BITSIZE (Key));
  Out ("Value", BITSIZE (ValueA));
  Test.checkI (BITSIZE (ValueA), BITSIZE (ValueB));
  Out ("Entry", BITSIZE (EntryA));
  Test.checkI (BITSIZE (EntryA), BITSIZE (EntryB));
(* VVM 2023-04-18 13-33
  Test.checkI (BITSIZE (BucketsVal^), BITSIZE (EntryA));
  Out ("BucketsVal^", BITSIZE (BucketsVal^));
*)
  Test.done ();
END Main.
