MODULE M2MathLib;

(***************************************************************************)
(** Created by:  Roland Baumann						   *)

(** pk
    1.1
    1995/09/04 09:00:30
    M2MathLib.m3,v
# Revision 1.1  1995/09/04  09:00:30  pk
# Initial revision
#
*)
(***************************************************************************)

IMPORT Math;


PROCEDURE Sqrt (real: REAL): REAL =
  BEGIN
    RETURN FLOAT(Math.sqrt(FLOAT(real, LONGREAL)), REAL);
  END Sqrt;


PROCEDURE Exp (real: REAL): REAL =
  BEGIN
    RETURN FLOAT(Math.exp(FLOAT(real, LONGREAL)), REAL);
  END Exp;


PROCEDURE Ln (real: REAL): REAL =
  BEGIN
    RETURN FLOAT(Math.log(FLOAT(real, LONGREAL)), REAL);
  END Ln;


PROCEDURE Sin (real: REAL): REAL =
  BEGIN
    RETURN FLOAT(Math.sin(FLOAT(real, LONGREAL)), REAL);
  END Sin;


PROCEDURE Cos (real: REAL): REAL =
  BEGIN
    RETURN FLOAT(Math.cos(FLOAT(real, LONGREAL)), REAL);
  END Cos;


PROCEDURE Arctan (real: REAL): REAL =
  BEGIN
    RETURN FLOAT(Math.atan(FLOAT(real, LONGREAL)), REAL);
  END Arctan;


PROCEDURE Entier (real: REAL): INTEGER =
  BEGIN
    IF (real < 0.0) THEN
      RETURN -(CEILING(ABS(real)));
    ELSE
      RETURN CEILING(real);
    END;
  END Entier;


PROCEDURE Power (real: REAL; exp: REAL): REAL =
  BEGIN
    RETURN
      FLOAT(Math.pow(FLOAT(real, LONGREAL), FLOAT(exp, LONGREAL)), REAL);
  END Power;

BEGIN
END M2MathLib.
