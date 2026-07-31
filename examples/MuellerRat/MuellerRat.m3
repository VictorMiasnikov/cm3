(*
Rational Arithmetic Applied to Mueller's Recurrence Relation

Mueller's recurrence relation is a classic example of a problem where it is clearly 
visible how rational arithmetic fundamentally differs from working with floating-point 
numbers.

 1. What is Mueller's recurrence relation

By "Mueller's recurrence relation" we usually mean an artificially constructed sequence 
that has an unstable fixed point (e.g., x=5), which the sequence approaches under 
exact calculations, but the slightest rounding errors cause the values to very quickly 
"diverge" in a different direction.

This is exactly why this sequence is used in educational courses as a demonstration 
of catastrophic error accumulation in standard floating-point arithmetic.

 2. Why rational arithmetic "cures" the problem

If you calculate the terms of this sequence using rational arithmetic (i.e., representing 
each value as an irreducible fraction p/q with integers p, q), then:

- no rounding occurs at each step, since all operations are performed exactly on integers;
- the fixed point (e.g., 5) remains truly fixed: if you start exactly at 5, all subsequent 
  values will be exactly 5;
- even with non-ideal initial conditions, the dynamics of the sequence will reflect the 
  "true" properties of the recurrence relation rather than rounding artifacts.

Thus, rational arithmetic makes Mueller's sequence a mathematically correct model, 
while floating-point makes it a numerically unstable approximation.
*)

MODULE MuellerRat EXPORTS Main;

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
  steps: INTEGER;
  c815, c1500, c108: F.T;

BEGIN
  xPrev := F.T{n := BI.FromInteger(4),  d := BI.FromInteger(1)};
  xCurr := F.T{n := BI.FromInteger(17), d := BI.FromInteger(4)};
  
  c815  := F.T{n := BI.FromInteger(815),  d := BI.FromInteger(1)};
  c1500 := F.T{n := BI.FromInteger(1500), d := BI.FromInteger(1)};
  c108  := F.T{n := BI.FromInteger(108),  d := BI.FromInteger(1)};
  
  steps := 110;

  IO.Put("0: "); PrintRatFast(xPrev); IO.Put("\n");
  IO.Put("1: "); PrintRatFast(xCurr); IO.Put("\n");

  FOR n := 2 TO steps DO
    TRY
      xNext := F.Sub(c108, F.Div(F.Sub(c815, F.Div(c1500, xPrev)), xCurr));
    EXCEPT Arithmetic.Error =>
      IO.Put("Division error at step " & Fmt.Int(n) & "\n");
      EXIT;
    END;
    
    IF n <= 26 THEN
      IO.Put(Fmt.Int(n) & ": "); PrintRatFast(xNext); IO.Put("\n");
    ELSE
      PrintRatPrecise(xNext, n);
    END;
    
    xPrev := xCurr;
    xCurr := xNext;
  END;
END MuellerRat.
