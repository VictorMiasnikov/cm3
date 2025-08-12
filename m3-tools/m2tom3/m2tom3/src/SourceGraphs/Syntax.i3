INTERFACE Syntax;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:08:41
    Syntax.i3,v
# Revision 1.1  1994/11/30  15:08:41  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- Syntax -----------------------------------------------------------------
  * This abstract data type module represents non-terminal symbols based on
  * Symbol.T.
  *
  * The number of children is stored as attribut for speed reasons.
  * ----------------------------------------------------------------------------
  **)

IMPORT Symbol AS Super;


TYPE
  T <: Public;

  Public =
    Super.T OBJECT
    METHODS
      getNoOfChildren (): CARDINAL;
                       (* Retrieves the actual stored number of children *)

      setNoOfChildren (value: CARDINAL);
                       (* Sets the number of children. *)
    END;

END Syntax.
