(*
Rational Arithmetic Applied to Mueller's Recurrence Relation

Mueller's recurrence relation is a classic example of a problem where it is clearly 
visible how rational arithmetic fundamentally differs from working with floating-point 
numbers.

 1. What is Mueller's recurrence relation

By "Mueller's recurrence relation" we usually mean an artificially constructed sequence 
that has an unstable fixed point (e.g., x=6), which the sequence approaches under 
exact calculations, but the slightest rounding errors cause the values to very quickly 
"diverge" in a different direction.

This is exactly why this sequence is used in educational courses as a demonstration 
of catastrophic error accumulation in standard floating-point arithmetic.

 2. Why rational arithmetic "cures" the problem

If you calculate the terms of this sequence using rational arithmetic (i.e., representing 
each value as an irreducible fraction p/q with integers p, q), then:

- no rounding occurs at each step, since all operations are performed exactly on integers;
- the fixed point (e.g., 6) remains truly fixed: if you start exactly at 6, all subsequent 
  values will be exactly 6;
- even with non-ideal initial conditions, the dynamics of the sequence will reflect the 
  "true" properties of the recurrence relation rather than rounding artifacts.

Thus, rational arithmetic makes Mueller's sequence a mathematically correct model, 
while floating-point makes it a numerically unstable approximation.
*)

MODULE MuellerSeq EXPORTS Main;

IMPORT IO, Fmt, BigIntegerFraction AS F, BigInteger AS BI, 
       Arithmetic, BigIntegerFmtLex AS BIFmt;

PROCEDURE PrintRatFast(r: F.T) =
  BEGIN
    IO.Put(Fmt.Int(BI.ToInteger(r.n)));
    
    IF BI.Compare(r.d, BI.FromInteger(1)) # 0 THEN 
      IO.Put(" / "); 
      IO.Put(Fmt.Int(BI.ToInteger(r.d))); 
    END;
    
    IO.Put(" = "); 
    IO.PutReal(FLOAT(BI.ToInteger(r.n), REAL) / FLOAT(BI.ToInteger(r.d), REAL));
  END PrintRatFast;

PROCEDURE PrintRatPrecise(r: F.T; step: INTEGER) =
  BEGIN
    IO.Put(Fmt.Int(step) & ": ");
    IO.Put(BIFmt.Fmt(r.n) & " / " & BIFmt.Fmt(r.d));
    IO.Put("\n");
  END PrintRatPrecise;

VAR
  xPrev, xCurr, xNext: F.T;
  n, steps: INTEGER;
  c111, c1130, c3000: F.T;

BEGIN
  (* Initial values *)
  xPrev := F.T{n := BI.FromInteger(11), d := BI.FromInteger(2)};   (* x1 = 11/2 *)
  xCurr := F.T{n := BI.FromInteger(61), d := BI.FromInteger(11)};  (* x2 = 61/11 *)
  
  (* Constants *)
  c111  := F.T{n := BI.FromInteger(111),  d := BI.FromInteger(1)};
  c1130 := F.T{n := BI.FromInteger(1130), d := BI.FromInteger(1)};
  c3000 := F.T{n := BI.FromInteger(3000), d := BI.FromInteger(1)};
  
  steps := 130;

  IO.Put("1: "); PrintRatFast(xPrev); IO.Put("\n");
  IO.Put("2: "); PrintRatFast(xCurr); IO.Put("\n");

  FOR n := 3 TO steps DO
    TRY
      (* xNext := 111 - 1130/xCurr + 3000/(xCurr * xPrev) *)
      xNext := F.Add(
                 F.Sub(c111, F.Div(c1130, xCurr)),
                 F.Div(c3000, F.Mul(xCurr, xPrev))
               );
    EXCEPT Arithmetic.Error =>
      IO.Put("Division error at step " & Fmt.Int(n) & "\n");
      EXIT;
    END;
    
    IF n <= 24 THEN
      IO.Put(Fmt.Int(n) & ": "); PrintRatFast(xNext); IO.Put("\n");
    ELSE
      PrintRatPrecise(xNext, n);
    END;
    
    xPrev := xCurr;
    xCurr := xNext;
  END;
END MuellerSeq.
