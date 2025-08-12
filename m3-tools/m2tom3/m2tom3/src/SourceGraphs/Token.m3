MODULE Token;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:09:09
    Token.m3,v
# Revision 1.1  1994/11/30  15:09:09  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- Token ------------------------------------------------------------------
  * Assumptions about hashing:
  *  hashing is yet irrelevant
  * ----------------------------------------------------------------------------
  **)

IMPORT Symbol AS Super;
IMPORT Symbol;


REVEAL
  T = Public BRANDED OBJECT
        text     : TEXT;
        languages: LanguageSet;
        usageSet : UsageSet;
        line     : INTEGER;
      OVERRIDES
        init           := Init;
        getLine        := GetLine;
        getText        := GetText;
        renameText     := RenameText;
        setLanguage    := SetLanguage;
        removeLanguage := RemoveLanguage;
        getLanguages   := GetLanguages;
        setUsageSet    := SetUsageSet;
        getUsageSet    := GetUsageSet;
      END;


PROCEDURE Init (self     : T;
                kind     : Symbol.Kind;
                text     : TEXT;
                languages: LanguageSet;
                usage    : UsageSet;
                line     : INTEGER       := 0): T =
  BEGIN
    self := Super.T.init(self, kind);
    self.text := text;
    self.languages := languages;
    self.usageSet := usage;
    self.line := line;
    RETURN self;
  END Init;


PROCEDURE GetLine (self: T): INTEGER =
  BEGIN
    RETURN self.line;
  END GetLine;


PROCEDURE GetText (self: T): TEXT =
  BEGIN
    RETURN self.text;
  END GetText;


PROCEDURE RenameText (self: T; text: TEXT) =
  BEGIN
    self.text := text;
  END RenameText;


PROCEDURE SetLanguage (self: T; language: Language) =
  BEGIN
    self.languages := self.languages + LanguageSet{language};
  END SetLanguage;


PROCEDURE RemoveLanguage (self: T; language: Language) =
  BEGIN
    self.languages := self.languages - LanguageSet{language};
  END RemoveLanguage;


PROCEDURE GetLanguages (self: T): LanguageSet =
  BEGIN
    RETURN self.languages;
  END GetLanguages;


PROCEDURE SetUsageSet (self: T; usage: UsageSet) =
  BEGIN
    self.usageSet := usage;
  END SetUsageSet;


PROCEDURE GetUsageSet (self: T): UsageSet =
  BEGIN
    RETURN self.usageSet;
  END GetUsageSet;

BEGIN
END Token.
