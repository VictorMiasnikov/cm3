MODULE Main;
IMPORT RTIO, Word, Long;
FROM RTIO IMPORT PutText, PutLong, PutHex, PutLongHex, Flush;


(* decrease these for faster runs *)
VAR insertextract_max_ab := 33;
VAR insertextract_max_mn := 10;

(* turn a constant into not a constant, from m3back's point of view *)
PROCEDURE NotConstL(a: LONGINT): LONGINT =
BEGIN
  RETURN a;
END NotConstL;

PROCEDURE NotConstI(a: INTEGER): INTEGER =
BEGIN
  RETURN a;
END NotConstI;

PROCEDURE NL() =
BEGIN
  PutT("\n");
END NL;

CONST PutT = PutText;
CONST PutH = PutHex;
CONST PutLH = PutLongHex;

PROCEDURE TestInsert() =
VAR result32: CARDINAL := 0;
    result64: LONGINT := 0L;
BEGIN
  FOR a32 := 0 TO insertextract_max_ab DO
    FOR b32 := 0 TO insertextract_max_ab DO
      FOR m := 0 TO insertextract_max_mn DO
        FOR n := 0 TO insertextract_max_mn DO
          result32 := Word.Insert(a32, b32, m, n);
          PutT("insert32(a:"); PutH(a32);
          PutT(", b:"); PutH(b32);
          PutT(", m:"); PutH(m);
          PutT(", n:"); PutH(n);
          PutT("):"); PutH(result32);
          NL();
          IF n = 0 THEN
            <* ASSERT result32 = a32 *>
          END
        END
      END
    END
  END;

  FOR a64 := 0L TO VAL(insertextract_max_ab, LONGINT) DO
    FOR b64 := 0L TO VAL(insertextract_max_ab, LONGINT) DO
      FOR m := 0 TO insertextract_max_mn DO
        FOR n := 0 TO insertextract_max_mn DO
          result64 := Long.Insert(a64, b64, m, n);
          PutT("insert64(a:"); PutLH(a64);
          PutT(", b:"); PutLH(b64);
          PutT(", m:"); PutH(m);
          PutT(", n:"); PutH(n);
          PutT("):"); PutLH(result64);
          NL();
          IF n = 0 THEN
            <* ASSERT result64 = a64 *>
          END
        END
      END
    END
  END;
  Flush();
END TestInsert;

PROCEDURE TestExtract() =
CONST sign_extend = 0;
VAR result32: CARDINAL := 0;
    result64: LONGINT := 0L;
BEGIN
  FOR a32 := 0 TO insertextract_max_ab DO
     FOR m := 0 TO insertextract_max_mn DO
      FOR n := 0 TO insertextract_max_mn DO
        result32 := Word.Extract(a32, m, n);
        PutT("extract32(value:"); PutH(a32);
        PutT(", m:"); PutH(m);
        PutT(", n:"); PutH(n);
        PutT(", sign_extend:"); PutH(sign_extend);
        PutT("):"); PutH(result32);
        NL();
        IF n = 0 THEN
          <* ASSERT result32 = 0 *>
        END
      END
    END
  END;

  FOR a64 := 0L TO VAL(insertextract_max_ab, LONGINT) DO
    FOR m := 0 TO insertextract_max_mn DO
      FOR n := 0 TO insertextract_max_mn DO
        result64 := Long.Extract(a64, m, n);
        PutT("extract64(value:"); PutLH(a64);
        PutT(", m:"); PutH(m);
        PutT(", n:"); PutH(n);
        PutT(", sign_extend:"); PutH(sign_extend);
        PutT("):"); PutLH(result64);
        NL();
        IF n = 0 THEN
          <* ASSERT result64 = 0L *>
        END
      END
    END
  END;
  Flush();
END TestExtract;

(*VAR a := 1234L;
VAR b := 5678L;
VAR c := 1024L * 1024L * 1024L * 8L;*)
VAR a, b, c: LONGINT;
VAR d: INTEGER;
CONST expect_true = ARRAY BOOLEAN OF TEXT{"bad\n","good\n"};
CONST expect_false = ARRAY BOOLEAN OF TEXT{"good\n","bad\n"};
CONST falsetrue = ARRAY BOOLEAN OF TEXT{"false\n","true\n"};

<*UNUSED*>PROCEDURE Add(a, b: LONGINT): LONGINT =
BEGIN
  RETURN a + b;
END Add;

<*UNUSED*>PROCEDURE Sub(a, b: LONGINT): LONGINT =
BEGIN
  RETURN a - b;
END Sub;

<*UNUSED*>PROCEDURE Mult(a, b: LONGINT): LONGINT =
BEGIN
  RETURN a * b;
END Mult;

<*UNUSED*>PROCEDURE Div(a, b: LONGINT): LONGINT =
BEGIN
  RETURN a DIV b;
END Div;

<*UNUSED*>PROCEDURE Rem(a, b: LONGINT): LONGINT =
BEGIN
  RETURN a MOD b;
END Rem;

<*UNUSED*>PROCEDURE DivU(a, b: LONGCARD): LONGCARD =
BEGIN
  RETURN a DIV b;
END DivU;

<*UNUSED*>PROCEDURE RemU(a, b: LONGCARD): LONGCARD =
BEGIN
  RETURN a MOD b;
END RemU;

<*UNUSED*>PROCEDURE LT(a, b: LONGINT): BOOLEAN =
BEGIN
  RETURN a < b;
END LT;

<*UNUSED*>PROCEDURE LTU(a, b: LONGINT): BOOLEAN =
BEGIN
  RETURN Long.LT(a, b);
END LTU;

<*UNUSED*>PROCEDURE EQ(a, b: LONGINT): BOOLEAN =
BEGIN
  RETURN a = b;
END EQ;

<*UNUSED*>PROCEDURE NE(a, b: LONGINT): BOOLEAN =
BEGIN
  RETURN a # b;
END NE;

(* shifting without constants *)

PROCEDURE TestShiftLeftInteger() =
VAR a: INTEGER;
BEGIN
  PutT("\nTestShiftLeftInteger\n");
  a := NotConstI(1);
  FOR i := 0 TO 40 DO
    PutT("1 << "); PutH(i); PutT(":"); PutH(a); PutT("\n");
    a := Word.LeftShift(a, NotConstI(1));
  END;
END TestShiftLeftInteger;

PROCEDURE TestShiftLeftLongint() =
VAR a: LONGINT;
BEGIN
  PutT("\nTestShiftLeftLongint\n");
  a := NotConstL(1L);
  FOR i := 0 TO 40 DO
    PutT("1 << "); PutH(i); PutT(":"); PutLH(a); PutT("\n");
    a := Long.LeftShift(a, NotConstI(1));
  END;
END TestShiftLeftLongint;

PROCEDURE TestShiftRightInteger() =
VAR a: INTEGER;
BEGIN
  PutT("\nTestShiftRightInteger\n");
  a := NotConstI(FIRST(INTEGER));
  FOR i := 0 TO 40 DO
    PutT("FIRST(INTEGER) >> "); PutH(i); PutT(":"); PutH(a); PutT("\n");
    a := Word.RightShift(a, NotConstI(1));
  END;
END TestShiftRightInteger;

PROCEDURE TestShiftRightLongint() =
VAR a: LONGINT;
BEGIN
  PutT("\nTestShiftLeftInteger\n");
  a := NotConstL(FIRST(LONGINT));
  FOR i := 0 TO 40 DO
    PutT("FIRST(LONGINT) >> "); PutH(i); PutT(":"); PutLH(a); PutT("\n");
    a := Long.RightShift(a, NotConstI(1));
  END;
END TestShiftRightLongint;


PROCEDURE TestShiftInteger() =
VAR a: INTEGER;
BEGIN
  PutT("\nTestShiftLeftInteger\n");
  a := Word.Shift(NotConstI(1), NotConstI(15));
  FOR i := -30 TO 30 DO
    PutT("1 << "); PutH(i); PutT(":"); PutH(a); PutT("\n");
    a := Word.Shift(a, NotConstI(1));
  END;
END TestShiftInteger;

PROCEDURE TestShiftLongint() =
VAR a: LONGINT;
BEGIN
  PutT("\nTestShiftLeftInteger\n");
  a := Long.Shift(NotConstL(1L), NotConstI(15));
  FOR i := -30 TO 30 DO
    PutT("1 << "); PutH(i); PutT(":"); PutLH(a); PutT("\n");
    a := Long.Shift(a, NotConstI(1));
  END;
END TestShiftLongint;


(* shifting by a constant *)

PROCEDURE TestShiftLeftNInteger() =
VAR a: INTEGER;
BEGIN
  PutT("\nTestShiftLeftNInteger\n");
  a := NotConstI(1);
  PutT("1 << 1"); PutT(":"); PutH(Word.Shift(a, 1)); PutT("\n");
  PutT("1 << 2"); PutT(":"); PutH(Word.Shift(a, 2)); PutT("\n");
  PutT("1 << 3"); PutT(":"); PutH(Word.Shift(a, 3)); PutT("\n");
END TestShiftLeftNInteger;

PROCEDURE TestShiftLeftNLongint() =
VAR a: LONGINT;
BEGIN
  PutT("\nTestShiftLeftNLongint\n");
  a := NotConstL(1L);
  PutT("1 << 1"); PutT(":"); PutLH(Long.Shift(a, 1)); PutT("\n");
  PutT("1 << 2"); PutT(":"); PutLH(Long.Shift(a, 2)); PutT("\n");
  PutT("1 << 3"); PutT(":"); PutLH(Long.Shift(a, 3)); PutT("\n");
  PutT("1 << 30"); PutT(":"); PutLH(Long.Shift(a, 30)); PutT("\n");
  PutT("1 << 40"); PutT(":"); PutLH(Long.Shift(a, 40)); PutT("\n");
  PutT("1 << 50"); PutT(":"); PutLH(Long.Shift(a, 50)); PutT("\n");
END TestShiftLeftNLongint;

PROCEDURE TestShiftRightNInteger() =
VAR a: INTEGER;
BEGIN
  PutT("\nTestShiftRightNInteger\n");
  a := NotConstI(FIRST(INTEGER));
  PutT("FIRST(INTEGER) >> 1"); PutT(":"); PutH(Word.Shift(a, 1)); PutT("\n");
  PutT("FIRST(INTEGER) >> 2"); PutT(":"); PutH(Word.Shift(a, 2)); PutT("\n");
  PutT("FIRST(INTEGER) >> 3"); PutT(":"); PutH(Word.Shift(a, 3)); PutT("\n");
  PutT("FIRST(INTEGER) >> 30"); PutT(":"); PutH(Word.Shift(a, 30)); PutT("\n");
  PutT("FIRST(INTEGER) >> 40"); PutT(":"); PutH(Word.Shift(a, 40)); PutT("\n");
  PutT("FIRST(INTEGER) >> 50"); PutT(":"); PutH(Word.Shift(a, 50)); PutT("\n");
END TestShiftRightNInteger;

PROCEDURE TestShiftRightNLongint() =
VAR a: LONGINT;
BEGIN
  PutT("\nTestShiftRightNLongint\n");
  a := NotConstL(FIRST(LONGINT));
  PutT("FIRST(LONGINT) >> 1"); PutT(":"); PutLH(Long.Shift(a, 1)); PutT("\n");
  PutT("FIRST(LONGINT) >> 2"); PutT(":"); PutLH(Long.Shift(a, 2)); PutT("\n");
  PutT("FIRST(LONGINT) >> 3"); PutT(":"); PutLH(Long.Shift(a, 3)); PutT("\n");
  PutT("FIRST(LONGINT) >> 30"); PutT(":"); PutLH(Long.Shift(a, 30)); PutT("\n");
  PutT("FIRST(LONGINT) >> 40"); PutT(":"); PutLH(Long.Shift(a, 40)); PutT("\n");
  PutT("FIRST(LONGINT) >> 50"); PutT(":"); PutLH(Long.Shift(a, 50)); PutT("\n");
END TestShiftRightNLongint;

PROCEDURE TestShiftNInteger() =
BEGIN
  PutT("\nTestShiftNInteger\n");
END TestShiftNInteger;

PROCEDURE TestShiftNLongint() =
BEGIN
  PutT("\nTestShiftNLongint\n");
END TestShiftNLongint;

(* shifting constant by a constant *)

PROCEDURE TestShiftLeftMNInteger() =
BEGIN
  PutT("\nTestShiftLeftMNInteger\n");
END TestShiftLeftMNInteger;

PROCEDURE TestShiftLeftMNLongint() =
BEGIN
  PutT("\nTestShiftLeftNLongint\n");
END TestShiftLeftMNLongint;

PROCEDURE TestShiftRightMNInteger() =
BEGIN
  PutT("\nTestShiftRightMNInteger\n");
END TestShiftRightMNInteger;

PROCEDURE TestShiftRightMNLongint() =
BEGIN
  PutT("\nTestShiftRightMNLongint\n");
END TestShiftRightMNLongint;

PROCEDURE TestShiftMNInteger() =
BEGIN
  PutT("\nTestShiftMNInteger\n");
END TestShiftMNInteger;

PROCEDURE TestShiftMNLongint() =
BEGIN
  PutT("\nTestShiftMNLongint\n");
END TestShiftMNLongint;


(* shifting constant by a non-constant (not particularly special, except for shifting zero) *)

PROCEDURE TestShiftLeftMInteger() =
BEGIN
  PutT("\nTestShiftLeftMInteger\n");
END TestShiftLeftMInteger;

PROCEDURE TestShiftLeftMLongint() =
BEGIN
  PutT("\nTestShiftLeftNLongint\n");
END TestShiftLeftMLongint;

PROCEDURE TestShiftRightMInteger() =
BEGIN
  PutT("\nTestShiftRightMInteger\n");
END TestShiftRightMInteger;

PROCEDURE TestShiftRightMLongint() =
BEGIN
  PutT("\nTestShiftRightMLongint\n");
END TestShiftRightMLongint;

PROCEDURE TestShiftMInteger() =
BEGIN
  PutT("\nTestShiftMInteger\n");
END TestShiftMInteger;

PROCEDURE TestShiftMLongint() =
BEGIN
  PutT("\nTestShiftMLongint\n");
END TestShiftMLongint;


BEGIN
  PutLong(a);
  NL();
  PutLH(c);
  NL();

  EVAL Long.Insert(1L, 2L, 3, 4);
  EVAL Long.Extract(1L, 3, 4);

  (* shifting with no constants *)
  TestShiftLeftInteger();
  TestShiftLeftLongint();
  TestShiftRightInteger();
  TestShiftRightLongint();
  TestShiftInteger();
  TestShiftLongint();

  (* shifting by a constant *)
  TestShiftLeftNInteger();
  TestShiftLeftNLongint();
  TestShiftRightNInteger();
  TestShiftRightNLongint();
  TestShiftNInteger();
  TestShiftNLongint();

  (* shifting constant by a constant *)
  TestShiftLeftMNInteger();
  TestShiftLeftMNLongint();
  TestShiftRightMNInteger();
  TestShiftRightMNLongint();
  TestShiftMNInteger();
  TestShiftMNLongint();

  (* shifting constant by a non-constant (not particularly special, except for shifting zero) *)
  TestShiftLeftMInteger();
  TestShiftLeftMLongint();
  TestShiftRightMInteger();
  TestShiftRightMLongint();
  TestShiftMInteger();
  TestShiftMLongint();


  PutT("           :"); PutLH(NotConstL(16_123456789L)); NL();
  <* ASSERT Long.Rotate(16_123456789L, 56) = Long.Rotate(NotConstL(16_123456789L), NotConstI(56)) *>

  PutT("     Rotate:"); PutLH(Long.Rotate(NotConstL(16_123456789L), NotConstI(56))); NL();
  <* ASSERT Long.Rotate(16_123456789L, 56) = Long.Rotate(NotConstL(16_123456789L), NotConstI(56)) *>

  PutT("    -Rotate:"); PutLH(Long.Rotate(NotConstL(16_123456789L), -NotConstI(56))); NL();
  <* ASSERT Long.Rotate(16_123456789L, -56) = Long.Rotate(NotConstL(16_123456789L), -NotConstI(56)) *>

  PutT("RightRotate:"); PutLH(Long.RightRotate(NotConstL(16_123456789L), NotConstI(56))); NL();
  <* ASSERT Long.RightRotate(16_123456789L, 56) = Long.RightRotate(NotConstL(16_123456789L), NotConstI(56)) *>

  PutT(" LeftRotate:"); PutLH(Long.LeftRotate(NotConstL(16_123456789L), NotConstI(56))); NL();
  <* ASSERT Long.LeftRotate(16_123456789L, 56) = Long.LeftRotate(NotConstL(16_123456789L), NotConstI(56)) *>

  PutT("      Shift:"); PutLH(Long.Shift(NotConstL(16_123456789L), NotConstI(16))); NL();
  <* ASSERT Long.Shift(16_123456789L, 16) = Long.Shift(NotConstL(16_123456789L), NotConstI(16)) *>

  PutT("     -Shift:"); PutLH(Long.Shift(NotConstL(16_123456789L), -NotConstI(16))); NL();
  <* ASSERT Long.Shift(16_123456789L, -16) = Long.Shift(NotConstL(16_123456789L), -NotConstI(16)) *>

  PutT(" RightShift:"); PutLH(Long.RightShift(NotConstL(16_123456789L), NotConstI(16))); NL();
  <* ASSERT Long.RightShift(16_123456789L, 16) = Long.RightShift(NotConstL(16_123456789L), NotConstI(16)) *>

  PutT("  LeftShift:"); PutLH(Long.LeftShift(NotConstL(16_123456789L), NotConstI(16))); NL();
  <* ASSERT Long.LeftShift(16_123456789L, 16) = Long.LeftShift(NotConstL(16_123456789L), NotConstI(16)) *>

  PutT("        min:"); PutLH(MIN(NotConstL(16_123456789L), NotConstL(16_876543210L))); NL();
  <* ASSERT MIN(16_123456789L, 16_876543210L) = MIN(NotConstL(16_123456789L), NotConstL(16_876543210L)) *>

  PutT("        max:"); PutLH(MAX(NotConstL(16_123456789L), NotConstL(16_876543210L))); NL();
  <* ASSERT MAX(16_123456789L, 16_876543210L) = MAX(NotConstL(16_123456789L), NotConstL(16_876543210L)) *>

  PutT("       100L:"); PutLH(NotConstL(100L)); NL();
  <* ASSERT 100L = NotConstL(100L) *>

  PutT(falsetrue[           100L  >           0L]); Flush();
  PutT(falsetrue[           100L  <           0L]); Flush();
  PutT(falsetrue[          -100L  >           0L]); Flush();
  PutT(falsetrue[          -100L  <           0L]); Flush();
  PutT(falsetrue[NotConstL( 100L) > NotConstL(0L)]); Flush();
  PutT(falsetrue[NotConstL( 100L) < NotConstL(0L)]); Flush();
  PutT(falsetrue[NotConstL(-100L) > NotConstL(0L)]); Flush();
  PutT(falsetrue[NotConstL(-100L) < NotConstL(0L)]); Flush();

  <* ASSERT (NotConstL(  100L) > NotConstL(0L)) = TRUE *>
  <* ASSERT (NotConstL(  100L) < NotConstL(0L)) = FALSE *>
  <* ASSERT (NotConstL( -100L) > NotConstL(0L)) = FALSE *>
  <* ASSERT (NotConstL( -100L) < NotConstL(0L)) = TRUE *>

  PutT("        neg:"); PutLH(-NotConstL(100L)); NL();
  <* ASSERT -100L = -NotConstL(100L) *>

  PutT("        neg:"); PutLH(-NotConstL(-NotConstL(100L))); NL();
  <* ASSERT -(-100L) = -NotConstL(-(NotConstL(100L))) *>

  PutT("        abs:"); PutLH(ABS(NotConstL(-100L))); NL();
  <* ASSERT ABS(-100L) = ABS(NotConstL(-100L)) *>

  PutT("        abs:"); PutLH(ABS(NotConstL(100L))); NL();
  <* ASSERT ABS(100L) = ABS(NotConstL(100L)) *>

  PutLong(a);
  NL();
  Flush();
  a := 1L;
  b := 1L + 2L;
  c := a + b;
  c := a - b;
  PutT(expect_true[c = (a - b)]);
  PutT(expect_false[c = (a + b)]);
  PutT(expect_true[(a + b) > a]);
  Flush();

  d := -1;
  a := VAL(d, LONGINT);
  PutLong(a);
  NL();

  a := -1L;
  PutLong(a);
  NL();

  a := VAL(LAST(INTEGER), LONGINT);
  INC(a);
  PutLong(a);
  NL();

  a := VAL(FIRST(INTEGER), LONGINT);
  PutLong(a);
  NL();

  a := VAL(FIRST(INTEGER), LONGINT);
  DEC(a);
  PutLong(a);
  NL();

  insertextract_max_ab := 2;
  insertextract_max_mn := 2;

  PutLong(FIRST(LONGINT));
  NL();

  PutLong(NotConstL(FIRST(LONGINT)));
  NL();

  PutLong(LAST(LONGINT));
  NL();

  PutLong(NotConstL(LAST(LONGINT)));
  NL();

  PutLong(NotConstL(LAST(LONGINT)) DIV NotConstL(2L));
  NL();

  PutLong(NotConstL(FIRST(LONGINT)) DIV NotConstL(2L));
  NL();

  PutLong(NotConstL(FIRST(LONGINT)) DIV NotConstL(2L));
  NL();

  TestInsert();
  TestExtract();
  Flush();

END Main.
