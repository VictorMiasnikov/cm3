INTERFACE SyntaxStack;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Alexander Poensgen                                        *)

(** pk
    1.1
    1994/11/30 15:08:58
    SyntaxStack.i3,v
# Revision 1.1  1994/11/30  15:08:58  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT Symbol;


TYPE
  T <: Public;

  Public =
    OBJECT
    METHODS
      init (): T;
            (* Initializes the stack. *)


      isEmpty (): BOOLEAN;
               (* Test if the stack contains no element. *)


      push (parent: Symbol.T; edgeNumber: CARDINAL);
            (* pushes the arguments onto stack. *)


      pop (VAR parent: Symbol.T; VAR edgeNumber: CARDINAL);
           (* Retrieves and removes the top element of the stack.  If the
              stack is empty parent is NIL and edgeNumber 0. *)
    END;

END SyntaxStack.
