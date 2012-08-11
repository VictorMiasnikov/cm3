(* Copyright 1989 Digital Equipment Corporation.               *)
(* Distributed only by permission.                             *)
(* Created on Sep 15 1988 by Jorge Stolfi                      *)
(* Last modified on Tue Jun 22 10:23:41 PDT 1993 by steveg     *)
(*      modified on Sun Jul 19 11:51:03 PDT 1992 by harrison   *)
(*      modified on Mon Jan 15 12:28:33 PST 1990 by stolfi     *)

MODULE R2;

(********************************************************************)
(*                                                                  *)
(* WARNING: DO NOT EDIT THIS FILE.  IT WAS GENERATED MECHANICALLY.  *)
(* See the  Makefile for more details.                              *)
(*                                                                  *)
(********************************************************************)

  (*************************************************************)
  (* Disclaimer: the numerical algorithms were quickly hacked  *)
  (*   from the Modula-2+ version.  They are not suppose to be *)
  (*   the best possible, not even close. There are surely     *)
  (*   gross blunders, especially in the choice of LONGREAL vs *)
  (*   REAL for intermediary results.                          *)
  (*************************************************************)

IMPORT Math, Random, Fmt;

PROCEDURE Unit(i: Axis): T =
  VAR rr: T;
  BEGIN
    rr := Origin;
    rr[i] := 1.0;
    RETURN rr
  END Unit;

PROCEDURE Equal(READONLY x, y: T): BOOLEAN =
  BEGIN
    RETURN (x[0] = y[0])
      AND  (x[1] = y[1])

  END Equal;

PROCEDURE IsZero(READONLY x: T): BOOLEAN =
  BEGIN
    RETURN (x[0] = 0.0)
      AND  (x[1] = 0.0)

  END IsZero;

PROCEDURE Add(READONLY x, y: T): T =
  VAR rr: T;
  BEGIN
    rr[0] := x[0] + y[0];
    rr[1] := x[1] + y[1];

    RETURN rr
  END Add;

PROCEDURE Sub(READONLY x, y: T): T =
  VAR rr: T;
  BEGIN
    rr[0] := x[0] - y[0];
    rr[1] := x[1] - y[1];

    RETURN rr
  END Sub;

PROCEDURE Minus(READONLY x: T): T =
  VAR rr: T;
  BEGIN
    rr[0] := - x[0];
    rr[1] := - x[1];

    RETURN rr
  END Minus;

PROCEDURE Scale(alpha: REAL; READONLY x: T): T =
  VAR rr: T;
  BEGIN
    rr[0] := alpha * x[0];
    rr[1] := alpha * x[1];

    RETURN rr
  END Scale;

PROCEDURE Shift(READONLY x: T; delta: REAL): T =
  VAR rr: T;
  BEGIN
    rr[0] := x[0] + delta;
    rr[1] := x[1] + delta;

    RETURN rr
  END Shift;

PROCEDURE Mix(READONLY x: T; alpha: REAL; READONLY y: T; beta: REAL): T =
  VAR rr: T;
  BEGIN
    rr[0] := x[0]*alpha + y[0]*beta;
    rr[1] := x[1]*alpha + y[1]*beta;

    RETURN rr
  END Mix;

PROCEDURE Weigh(READONLY x, y: T): T =
  VAR rr: T;
  BEGIN
    rr[0] := x[0] * y[0];
    rr[1] := x[1] * y[1];

    RETURN rr
  END Weigh;

PROCEDURE FMap(READONLY x: T; F: Function): T =
  VAR rr: T;
  BEGIN
    rr[0] := F(x[0]);
    rr[1] := F(x[1]);

    RETURN rr
  END FMap;

PROCEDURE Sum (READONLY x: T): REAL =
  VAR dd: LONGREAL;
  BEGIN
    dd :=
        FLOAT(x[0], LONGREAL)
      + FLOAT(x[1], LONGREAL)

      ;
    RETURN FLOAT(dd)
  END Sum;

PROCEDURE Max(READONLY x: T): REAL =
  BEGIN

    RETURN MAX(x[0], x[1])

  END Max;

PROCEDURE MaxAbsAxis(READONLY x: T): Axis =
  VAR
    a: Axis;
  BEGIN
    IF ABS(x[0]) > ABS(x[1]) THEN a := 0 ELSE a := 1 END;

    RETURN a;
  END MaxAbsAxis;

PROCEDURE Min(READONLY x: T): REAL =
  BEGIN

    RETURN MIN(x[0], x[1])

  END Min;

PROCEDURE SumSq(READONLY x: T): REAL =
  BEGIN
    RETURN
        x[0] * x[0]
      + x[1] * x[1]

  END SumSq;

PROCEDURE L1Norm(READONLY x: T): REAL =

  BEGIN

    RETURN
        ABS(x[0])
      + ABS(x[1])

  END L1Norm;

PROCEDURE LInfNorm(READONLY x: T): REAL =

  BEGIN

    RETURN MAX(ABS(x[0]), ABS(x[1]))

  END LInfNorm;

PROCEDURE LInfDist(READONLY x, y: T): REAL =

  BEGIN

    RETURN MAX(ABS(x[0] - y[0]), ABS(x[1] - y[1]))

  END LInfDist;

PROCEDURE L1Dist(READONLY x, y: T): REAL =

  BEGIN

    RETURN
        ABS(x[0] - y[0])
      + ABS(x[1] - y[1])

  END L1Dist;

PROCEDURE Dist(READONLY x, y: T): REAL =

  BEGIN

    RETURN FLOAT(Math.hypot(FLOAT(x[0] - y[0], LONGREAL), FLOAT(x[1] - y[1], LONGREAL)))

  END Dist;

PROCEDURE L2Dist(READONLY x, y: T): REAL =

  BEGIN

    RETURN FLOAT(Math.hypot(FLOAT(x[0] - y[0], LONGREAL), FLOAT(x[1] - y[1], LONGREAL)))

  END L2Dist;

PROCEDURE L2DistSq(READONLY x, y: T): REAL =
  VAR t, dd: REAL;
  BEGIN

    t := x[0] - y[0]; dd := t*t;
    t := x[1] - y[1]; dd := dd + t*t;

    RETURN dd
  END L2DistSq;

PROCEDURE RelDist(READONLY x, y: T; eps: REAL := 1.0e-37): REAL =
  VAR u, v: REAL;
      s, m: REAL;
  BEGIN
    s := 0.0;
    FOR i := 0 TO 1 DO
      u := x[i]; v := y[i];
      m := MAX(MAX(ABS(u), ABS(v)), eps);
      s := MAX(ABS(u/m - v/m) - eps/m, s);
    END;
    RETURN s
  END RelDist;

PROCEDURE Dot(READONLY x, y: T): REAL =
  BEGIN
    RETURN FLOAT(
        FLOAT(x[0], LONGREAL) * FLOAT(y[0], LONGREAL)
      + FLOAT(x[1], LONGREAL) * FLOAT(y[1], LONGREAL)

    )
  END Dot;

PROCEDURE Cos (READONLY x, y: T): REAL =
  VAR xy, xx, yy: LONGREAL;
      tx, ty, mx, my: REAL;
  BEGIN
    (* Compute rescaling factors to avoid spurious overflow: *)

    mx := MAX(ABS(x[0]), ABS(x[1]));
    my := MAX(ABS(y[0]), ABS(y[1]));

    (* Now collect dot product and lengths (rescaled): *)

    tx := x[0]/mx; ty := y[0]/my;
    xx := FLOAT(tx*tx, LONGREAL); yy := FLOAT(ty*ty, LONGREAL);
    xy := FLOAT(tx, LONGREAL)*FLOAT(ty, LONGREAL);

    tx := x[1]/mx; ty := y[1]/my;
    xx := xx + FLOAT(tx*tx, LONGREAL); yy := yy + FLOAT(ty*ty, LONGREAL);
    xy := xy + FLOAT(tx, LONGREAL) * FLOAT(ty, LONGREAL);

    xx := 1.0d0 / Math.sqrt(FLOAT(xx*yy, LONGREAL));
    xx := xx*xy;
    RETURN FLOAT(xx)
  END Cos;

PROCEDURE Length(READONLY x: T): REAL =

  BEGIN

    RETURN FLOAT(Math.hypot(FLOAT(x[0], LONGREAL), FLOAT(x[1], LONGREAL)))

  END Length;

PROCEDURE L2Norm(READONLY x: T): REAL =

  BEGIN

    RETURN FLOAT(Math.hypot(FLOAT(x[0], LONGREAL), FLOAT(x[1], LONGREAL)))

  END L2Norm;

PROCEDURE Direction(READONLY x: T): T =
  (* !!!!! Should try to avoid spurious overflow by prescaling x *)

  VAR d: REAL;
      rr: T;
  BEGIN

    d := 1.0/FLOAT(Math.hypot(FLOAT(x[0], LONGREAL), FLOAT(x[1], LONGREAL)));

    rr[0] := d*x[0];
    rr[1] := d*x[1];

    RETURN rr
  END Direction;

PROCEDURE Det(READONLY p0, p1: T): REAL =
  (* !!!!!! Should use double precision !!!!!! *)

  BEGIN

    RETURN
      p0[0]*p1[1] - p0[1]*p1[0]

  END Det;

PROCEDURE Cross(READONLY p1: T): T =
  (* !!!!!! Should use double precision !!!!!! *)
  VAR rr: T;

  BEGIN

    rr[0] :=  p1[1];
    rr[1] := -p1[0];

    RETURN rr
  END Cross;

PROCEDURE Throw(lo, hi: REAL; src: Random.T := NIL): T =
  VAR rr: T; dd, xx: REAL;
  BEGIN
    IF src = NIL THEN src := NEW(Random.Default).init() END;
    dd := hi - lo;
    <* ASSERT dd > 0.0 *>
    <* ASSERT dd/MAX(1.0E-25, MAX(ABS(hi), ABS(lo))) > 1.0E-6 *>
    FOR i := 0 TO 1 DO
      REPEAT
        xx := src.real()
      UNTIL xx > 0.0;
      rr[i] := lo + dd*xx
    END;
    RETURN rr
  END Throw;

PROCEDURE ToText(READONLY x: T): TEXT =
BEGIN
  RETURN
    "(" & Fmt.Real(x[0]) &
    " " & Fmt.Real(x[1]) &

    ")";
END ToText;

BEGIN
END R2.