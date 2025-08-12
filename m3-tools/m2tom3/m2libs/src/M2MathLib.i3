INTERFACE M2MathLib;

(***************************************************************************)
(** Created by:  Roland Baumann						   *)

(** pk
    1.1
    1995/09/04 09:00:28
    M2MathLib.i3,v
# Revision 1.1  1995/09/04  09:00:28  pk
# Initial revision
#
*)
(***************************************************************************)


PROCEDURE Sqrt (real: REAL): REAL;

PROCEDURE Exp (real: REAL): REAL;

PROCEDURE Ln (real: REAL): REAL;

PROCEDURE Sin (real: REAL): REAL; (* radians *)

PROCEDURE Cos (real: REAL): REAL;

PROCEDURE Arctan (real: REAL): REAL;

PROCEDURE Entier (real: REAL): INTEGER; (* trunc toward neg inf *)

PROCEDURE Power (real: REAL; exp: REAL): REAL; (* real to the power exp *)

END M2MathLib.
