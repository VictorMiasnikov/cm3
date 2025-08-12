MODULE SyntaxStack;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Alexander Poensgen                                        *)

(** pk
    1.1
    1994/11/30 15:09:00
    SyntaxStack.m3,v
# Revision 1.1  1994/11/30  15:09:00  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT Symbol;


TYPE
  StackElement = OBJECT
                   parent    : Symbol.T;
                   edgeNumber: CARDINAL;
                   next      : StackElement;
                 END;

REVEAL
  T = Public BRANDED OBJECT
        first: StackElement := NIL;
      OVERRIDES
        init    := Init;
        isEmpty := IsEmpty;
        push    := Push;
        pop     := Pop;
      END;


PROCEDURE Init (self: T): T =
  BEGIN
    RETURN self;
  END Init;


PROCEDURE IsEmpty (self: T): BOOLEAN =
  BEGIN
    RETURN (self.first = NIL);
  END IsEmpty;


PROCEDURE Push (self: T; parent: Symbol.T; edgeNumber: CARDINAL) =
  BEGIN
    WITH newElem = NEW(StackElement, parent := parent,
                       edgeNumber := edgeNumber, next := self.first) DO
      self.first := newElem;
    END;
  END Push;


PROCEDURE Pop (self: T; VAR parent: Symbol.T; VAR edgeNumber: CARDINAL) =
  BEGIN
    IF NOT (self.isEmpty()) THEN
      parent := self.first.parent;
      edgeNumber := self.first.edgeNumber;
      self.first := self.first.next;
    ELSE
      parent := NIL;
      edgeNumber := 0;
    END;
  END Pop;

BEGIN
END SyntaxStack.
