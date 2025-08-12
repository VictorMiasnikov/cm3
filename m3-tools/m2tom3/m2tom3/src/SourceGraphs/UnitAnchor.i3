INTERFACE UnitAnchor;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:09:28
    UnitAnchor.i3,v
# Revision 1.1  1994/11/30  15:09:28  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- UnitAnchor -----------------------------------------------------------
  * Abstract data type module to represent handles (anchors) to units.
  *
  * This anchors base on syntax anchors and extend them by a units name and
  * work and definition flags.
  * You should mark a unit with a set work flag if it'll be changed.
  * You should mark a unit with a set definition flag if is a Modula-2
  * interface file.
  * ----------------------------------------------------------------------------
  **)

IMPORT SyntaxAnchor AS Super;


TYPE
  T <: Public;

  Public =
    Super.T OBJECT
    METHODS
      init (name, path, suffix: TEXT; isWork, isDefinition: BOOLEAN): T;
            (* initializes an anchor with it's attributes (see module
               comment) *)

      getName (): TEXT;
               (* retrieves the name of a unit, represented by it's
                  anchor *)

      getPath (): TEXT;
               (* retrieves the path of a unit, represented by it's anchor.
                  If path is empty './' is returned to specify current
                  workdirectory. *)

      getSuffix (): TEXT;
                 (* retrieves the suffix of a unit, represented by it's
                    anchor *)

      isWork (): BOOLEAN;

      isDefinition (): BOOLEAN;
                    (* retrieves the value of the work / definition flag of
                       a unit, represented by it's anchor *)

      setWork ();
               (* sets the work flag of a unit. *)
    END;

END UnitAnchor.
