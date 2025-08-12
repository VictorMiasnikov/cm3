INTERFACE ClusterTable;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:07:55
    ClusterTable.i3,v
# Revision 1.1  1994/11/30  15:07:55  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- ClusterTable -----------------------------------------------------------
  * This abstract data type module provides a dynamically organized table to
  * store items.
  *
  * Items are predefined objects which expect a, yet not defined (!), hash
  * method. This method is used to classify items into several hash
  * classes. To determine one item or a group of items you may specify the
  * hash class via a sample item beeing in the same class and / or using a
  * predicate which should be evaluated to true.
  *
  * All data types of this modules are objects, so the may be effeciently
  * expanded and specialized.
  * ----------------------------------------------------------------------------
  **)

IMPORT Word;

EXCEPTION
  ItemInTable;
  ItemNotInTable;
  ItemNotUnique;


TYPE
  Item = BRANDED OBJECT
         METHODS
           hash (): Word.T;      (* to define ! *)
         END;


  T <: Public;

  Public =
    OBJECT
    METHODS
      init (minItems: CARDINAL := 4; existenceChecks: BOOLEAN := FALSE): T;
            (* Initializes a table to contain at least the specified number
               of items.  If the flag existenceChecks is set some
               additional tests on the table will be done. *)


      doChecks (): BOOLEAN;
                (* Retrieves the init value of the attribute. *)


      insertItem (item: Item) RAISES {ItemInTable};
                  (* Inserts an item to the table.  You'll get the
                     exception ItemInTable if the item is allready
                     contained in the table. *)


      deleteItem (item: Item) RAISES {ItemNotInTable};
                  (* Removes the item out of the table.  You'll get the
                     exception ItemNotInTable if the item isn't contained
                     in the table. *)


      getItem (sampleItem: Item; predicate: ItemPredicate := NIL): Item
               RAISES {ItemNotUnique};
               (* Retrieves one item fro the table.  If necessary, the item
                  must be specified by the sampleItem and the predicate to
                  be unique.  Otherwise you'll get the exception
                  ItemNotUnique.  If appropriate no item can be found
                  you'll get NIL. *)
    END;


  ItemPredicate = PROCEDURE (item: Item): BOOLEAN;

  ItemIterator <: ItemIteratorPublic;

  ItemIteratorPublic =
    OBJECT
    METHODS
      init (list: T; sampleItem: Item := NIL): ItemIterator;
            (* Initializes the item iterator to iterate through all items
               of the list.  The iteration may be restricted to a special
               hash class using a sample item. *)

      next (): Item;
            (* Retrieves the next item of this iteration. *)
    END;

END ClusterTable.
