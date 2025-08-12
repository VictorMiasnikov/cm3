MODULE ScopeQueue;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:04:13
    ScopeQueue.m3,v
# Revision 1.1  1994/11/30  15:04:13  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT Syntax;


TYPE
  QueueElement = OBJECT
                   scope: Syntax.T;
                   next : QueueElement;
                 END;


REVEAL
  T = Public BRANDED OBJECT
        first, last: QueueElement := NIL;
      OVERRIDES
        init      := Init;
        isEmpty   := IsEmpty;
        append    := Append;
        takeFirst := TakeFirst;
      END;


PROCEDURE Init (self: T): T =
  BEGIN
    RETURN self;
  END Init;


PROCEDURE IsEmpty (self: T): BOOLEAN =
  BEGIN
    RETURN (self.first = NIL);
  END IsEmpty;


PROCEDURE Append (self: T; scope: Syntax.T) =
  BEGIN
    IF (scope = NIL) THEN RETURN; END;

    WITH queueElement = NEW(QueueElement, scope := scope, next := NIL) DO
      IF (self.last # NIL) THEN
        self.last.next := queueElement;
      ELSE
        self.first := queueElement;
      END;
      self.last := queueElement;
    END;
  END Append;


PROCEDURE TakeFirst (self: T): Syntax.T =
  VAR oldFirst: QueueElement;

  BEGIN
    IF (self.first = NIL) THEN
      RETURN NIL;
    ELSE
      oldFirst := self.first;
      self.first := oldFirst.next;
      RETURN oldFirst.scope;
    END;
  END TakeFirst;

BEGIN
END ScopeQueue.
