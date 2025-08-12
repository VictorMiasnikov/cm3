INTERFACE ScopeQueue;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:04:10
    ScopeQueue.i3,v
# Revision 1.1  1994/11/30  15:04:10  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT Syntax;


TYPE
  T <: Public;

  Public = OBJECT
           METHODS
             init (): T;
                   (* Initializes the scope. *)


             isEmpty (): BOOLEAN;
                      (* Test if the queue contains no element. *)


             append (scope: Syntax.T);
                     (* Appends the new element scope to the queue.
                        Argument scope must be non-NIL. *)


             takeFirst (): Syntax.T;
                        (* Retrieves and removes the first element from the
                           queue.  If the queue is empty you'll get NIL. *)
           END;

END ScopeQueue.
