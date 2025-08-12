INTERFACE M2ConvertReal;

(***************************************************************************)
(** Created by:  Roland Baumann						   *)

(** pk
    1.1
    1995/09/04 09:00:31
    M2ConvertReal.i3,v
# Revision 1.1  1995/09/04  09:00:31  pk
# Initial revision
#
*)
(***************************************************************************)

PROCEDURE RealToStr (    real: REAL;
                     VAR str : ARRAY OF CHAR;
                     width    : CARDINAL;  (* width of field in char *)
                     decPlaces: INTEGER;   (* neg -> sci; 0 -> no point *)
                     VAR success: BOOLEAN);


PROCEDURE StrToReal (READONLY str    : ARRAY OF CHAR;
                     VAR      real   : REAL;
                     VAR      success: BOOLEAN        );

END M2ConvertReal.
