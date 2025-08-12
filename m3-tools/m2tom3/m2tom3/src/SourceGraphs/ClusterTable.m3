MODULE ClusterTable;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:07:57
    ClusterTable.m3,v
# Revision 1.1  1994/11/30  15:07:57  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- ClusterTable ------------------------------------------------------------
  * Items in the table are stored via closed hashing.
  *
  * Entry values:
  *   NIL                       = unused, empty entry,
  *                               this value terminates a search by hash.
  *   DeletedItem               = previous used, deleted entry,
  *                               this value refers to a predefined item,
  *                               it must be skiped through search.
  *   <other>                   = valid item.
  *
  * table = HashArray[0..n]
  *   table[0] .. table[n-2]    item storage,
  *   table[n-1]                free entry, i.e. table[n-1] = NIL,
  *                             terminate searching if no hash is given.
  *
  * Hashing:
  *   p                         = position to search an entry,
  *   h                         = external given hash value,
  *   hashSize = n-1            = number of item storage.
  *
  * regular case:       p := (h * 3 DIV 2) MOD hashSize
  * collision case:     p := (p + 1) MOD hashSize
  *
  *
  * The additional empty entry at the end of the hash table handles the special
  * case on non-hash search if no item was found.
  *
  * The table size will be dynamically adjusted to be filled between 40% and 80%
  * but able to contain at least the specified minimum of items.
  * ----------------------------------------------------------------------------
  **)


CONST NoPosition = LAST(CARDINAL);


TYPE
  HashArray = ARRAY OF Item;
  HashTable = REF HashArray;


REVEAL
  T = Public BRANDED OBJECT
        actualItems,             (* number of stored items *)
          minItems: CARDINAL;    (* minimum size of table *)
        hashTable      : HashTable;  (* dynamic hash table *)
        existenceChecks: BOOLEAN;    (* flag to supervision *)

      OVERRIDES
        init       := InitTable;
        doChecks   := DoChecks;
        insertItem := InsertItem;
        deleteItem := DeleteItem;
        getItem    := GetItem;
      END;


  ItemIterator = ItemIteratorPublic BRANDED OBJECT
                   ready: BOOLEAN;  (* iteration finished *)
                   position,     (* actual entry position *)
                     firstPosition: CARDINAL;  (* first pos in iteration*)
                   table     : T;     (* cluster table *)
                   sampleItem: Item;

                 OVERRIDES
                   init := InitItemIterator;
                   next := NextItem
                 END;


VAR
  DeletedItem: Item              (* special item marking *)
             := NEW(Item);       (* former used entries *)


(*
 * --- support procedures ------------------------------------------------------
 *)

(** --- CreateTable ------------------------------------------------------------
  * Allocate and initialize an empty table to store the given number of items.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE CreateTable (actualItems: CARDINAL): HashTable =
  BEGIN
    WITH table = NEW(HashTable, actualItems + 1) DO
      FOR i := FIRST(table^) TO LAST(table^) DO table^[i] := NIL END;
      RETURN table;
    END;
  END CreateTable;


(** --- FindFreeEntry ----------------------------------------------------------
  * Search an entry to store an item using the hash value.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE FindFreeEntry (READONLY table: HashArray; item: Item): CARDINAL =
  VAR
    position: CARDINAL;
    hashSize: CARDINAL := NUMBER(table) - 1;

  BEGIN
    position := (item.hash() * 3 DIV 2) MOD hashSize;
    WHILE (table[position] # NIL) AND (table[position] # DeletedItem) DO
      position := (position + 1) MOD hashSize;
    END;
    RETURN position;
  END FindFreeEntry;


(** --- FindNextEntry ----------------------------------------------------------
  * Search a specified entry.
  *
  * This may be done using a hash value if an sample item is given.
  * You may determine an old position to start searching or ommit the
  * position (NoPosition) to search from the first entry.
  * You may specify a predicate to match the searched item.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE FindNextEntry (READONLY table    : HashArray;
                                  item     : Item;
                                  predicate: ItemPredicate;
                         lastPosition: CARDINAL := NoPosition): CARDINAL =

  VAR
    hashSize               : CARDINAL := NUMBER(table) - 1;
    firstPosition, position: CARDINAL;

  BEGIN
    IF (item = NIL) THEN
      (* no hash to use -> search from first to last position *)
      IF (lastPosition = NoPosition) THEN
        position := 0;
      ELSE
        position := lastPosition + 1;
      END;

      WHILE ((position < hashSize)
               AND ((table[position] = NIL)
                      OR (table[position] = DeletedItem)
                      OR ((predicate # NIL)
                            AND (NOT predicate(table[position]))))) DO
        INC(position);
      END;
    ELSE
      (* use hash -> search from hash position to first empty position *)
      WITH sampleHash = item.hash() DO
        IF (lastPosition = NoPosition) THEN
          position := (sampleHash * 3 DIV 2) MOD hashSize;
          firstPosition := position;
        ELSE
          position := (lastPosition + 1) MOD hashSize;
          firstPosition := lastPosition;
        END;

        WHILE ((table[position] # NIL)
                 AND ((table[position] = DeletedItem)
                        OR (sampleHash # table[position].hash())
                        OR (predicate # NIL)
                             AND (NOT predicate(table[position])))) DO
          position := (position + 1) MOD hashSize;
          IF (position = firstPosition) THEN RETURN hashSize; END;
        END;
      END;
    END;
    RETURN position;
  END FindNextEntry;



(** --- ReOrgTable -------------------------------------------------------------
  * Creates a new table of the given size and rehash all items into this new
  * table.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE ReOrgTable (VAR table: HashTable; size: CARDINAL) =
  BEGIN
    WITH newTable = CreateTable(size) DO
      FOR i := FIRST(table^) TO LAST(table^) - 1 DO
        WITH entry = table^[i] DO
          IF ((entry # NIL) AND (entry # DeletedItem)) THEN
            newTable^[FindFreeEntry(newTable^, entry)] := entry;
          END;
        END;
      END;
      table := newTable;
    END;
  END ReOrgTable;


(*
 * --- Table procedures ---------------------------------------------------------
 *)

(** --- InitTable ---------------------------------------------------------------
  *
  * ----------------------------------------------------------------------------
  **)
PROCEDURE InitTable (self: T; minItems: CARDINAL; existenceChecks: BOOLEAN):
  T =
  BEGIN
    self.minItems := MAX(2, minItems);
    self.existenceChecks := existenceChecks;
    self.actualItems := 0;
    self.hashTable := CreateTable(self.minItems);
    RETURN self;
  END InitTable;


(** --- DoChecks ---------------------------------------------------------------
  *
  * ----------------------------------------------------------------------------
  **)
PROCEDURE DoChecks (self: T): BOOLEAN =
  BEGIN
    RETURN self.existenceChecks;
  END DoChecks;


(** --- InsertItem -------------------------------------------------------------
  *
  * ----------------------------------------------------------------------------
  **)
PROCEDURE InsertItem (self: T; item: Item) RAISES {ItemInTable} =

  PROCEDURE ThisItem (actual: Item): BOOLEAN =
    BEGIN
      RETURN (actual = item);
    END ThisItem;

  (* InsertItem *)
  BEGIN
    IF ((NUMBER(self.hashTable^) - 1) * 4 DIV 5 < self.actualItems) THEN
      ReOrgTable(self.hashTable, NUMBER(self.hashTable^) * 2);
    END;

    IF (self.existenceChecks) THEN
      WITH position = FindNextEntry(self.hashTable^, item, ThisItem) DO
        IF (self.hashTable^[position] = item) THEN RAISE ItemInTable; END;
      END;
    END;

    self.hashTable^[FindFreeEntry(self.hashTable^, item)] := item;
    INC(self.actualItems);
  END InsertItem;


(** --- DeleteItem -------------------------------------------------------------
  *
  * ----------------------------------------------------------------------------
  **)
PROCEDURE DeleteItem (self: T; item: Item) RAISES {ItemNotInTable} =
  PROCEDURE ThisItem (actual: Item): BOOLEAN =
    BEGIN
      RETURN (actual = item);
    END ThisItem;

  (* DeleteItem *)
  BEGIN
    WITH position = FindNextEntry(self.hashTable^, item, ThisItem) DO
      IF (self.hashTable^[position] # item) THEN
        RAISE ItemNotInTable;
      ELSE
        self.hashTable^[position] := DeletedItem;
        DEC(self.actualItems);
      END;
    END;

    WITH lessItems    = (NUMBER(self.hashTable^) - 1) * 2 DIV 5,
         currentItems = MAX(self.actualItems, self.minItems)     DO
      IF (currentItems < lessItems) THEN
        ReOrgTable(self.hashTable, (currentItems * 3 DIV 5) + 1);
      END;
    END;
  END DeleteItem;


(** --- GetItem ----------------------------------------------------------------
  *
  * ----------------------------------------------------------------------------
  **)
PROCEDURE GetItem (self      : T;
                   sampleItem: Item;
                   predicate : ItemPredicate := NIL): Item
  RAISES {ItemNotUnique} =
  BEGIN
    WITH firstPosition = FindNextEntry(
                           self.hashTable^, sampleItem, predicate),
         firstItem = self.hashTable^[firstPosition] DO
      IF (firstItem # NIL) THEN
        WITH nextPosition = FindNextEntry(self.hashTable^, sampleItem,
                                          predicate, firstPosition),
             nextItem = self.hashTable^[nextPosition] DO
          IF (nextItem # NIL) THEN RAISE ItemNotUnique; END;
        END;
      END;
      RETURN firstItem;
    END;
  END GetItem;


(*
 * --- item iterator procedures ------------------------------------------------
 *)

(** --- InitItemIterator -------------------------------------------------------
  *
  * ----------------------------------------------------------------------------
  **)
PROCEDURE InitItemIterator (self      : ItemIterator;
                            table     : T;
                            sampleItem: Item           := NIL):
  ItemIterator =
  BEGIN
    self.firstPosition := FindNextEntry(table.hashTable^, sampleItem, NIL);
    self.position := self.firstPosition;
    self.ready := (table.hashTable[self.firstPosition] = NIL);
    self.table := table;
    self.sampleItem := sampleItem;
    RETURN self;
  END InitItemIterator;


(** --- NextItem ---------------------------------------------------------------
  *
  * ----------------------------------------------------------------------------
  **)
PROCEDURE NextItem (self: ItemIterator): Item =
  BEGIN
    IF (self.ready) THEN
      RETURN NIL;
    ELSE
      WITH entry = self.table.hashTable^[self.position] DO
        self.position :=
          FindNextEntry(
            self.table.hashTable^, self.sampleItem, NIL, self.position);
        self.ready :=
          (entry = NIL) OR (self.position = self.firstPosition);
        RETURN entry;
      END;
    END;
  END NextItem;

BEGIN
END ClusterTable.
