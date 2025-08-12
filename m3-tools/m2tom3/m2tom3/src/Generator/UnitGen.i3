INTERFACE UnitGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:06:07
    UnitGen.i3,v
# Revision 1.1  1994/11/30  15:06:07  pk
# Release Version 2.00.
#
*)
(***************************************************************************)


(** --- UnitGen ----------------------------------------------------------------
  * This functional modul should transform the beginning of compilation units.
  *
  * All modules will be treated as UNSAFE wether they use unsafe features or
  * not.
  * ----------------------------------------------------------------------------
  **)

IMPORT Syntax;
IMPORT SourceGraph;


PROCEDURE ChangeInterface (graph    : SourceGraph.T;
                           unit     : SourceGraph.Anchor;
                           defModule: Syntax.T            );
  (* This function should be called on DefinitionModule syntax nodes, it
     changes 'DEFINITION MODULE' into 'UNSAFE INTERFACE'. *)


PROCEDURE ChangeProgram (graph     : SourceGraph.T;
                         unit      : SourceGraph.Anchor;
                         progModule: Syntax.T            );
  (* This function should be called on ProgramModule syntax nodes, it
     changes implementation units.

     Implementation module: 'IMPLEMENTATION MODULE' into 'UNSAFE MODULE'.
     Program module: 'MODULE M' into 'UNSAFE MODULE M EXPORTS Main' *)


PROCEDURE ChangeModule (graph     : SourceGraph.T;
                        unit      : SourceGraph.Anchor;
                        moduleDecl: Syntax.T            );
  (* This function should be called on ModuleDeclaration syntax nodes, it
     changes 'MODULE' into 'UNSAFE MODULE'.  Other transformation
     (extracting the local module, generating the missing interface(s))
     will yet not be done! *)

END UnitGen.
