INTERFACE Token;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:09:08
    Token.i3,v
# Revision 1.1  1994/11/30  15:09:08  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- Token ------------------------------------------------------------------
  * This abstract data type module represents a terminal symbol based on
  * Symbol.T attributed with a text, a language set and a line number.
  * We'll say your token is a "member of language A" iff A in this language
  * set.
  *
  * Tokens, especially tokens with kind Ident, may be marked as declaring
  * and/or applying idents.
  * ----------------------------------------------------------------------------
  **)

IMPORT Symbol AS Super;
IMPORT Symbol;


CONST
  M2Only = LanguageSet{Language.M2};
  M3Only = LanguageSet{Language.M3};


TYPE
  Language = {M2, M3, C};
  LanguageSet = SET OF Language;

  Usage = {Decl, Appl};
  UsageSet = SET OF Usage;


  T <: Public;

  Public =
    Super.T OBJECT
    METHODS
      init (kind: Symbol.Kind;
            text: TEXT;
            languages          := LanguageSet{Language.M2, Language.M3};
            usage              := UsageSet{};
            line     : INTEGER := 0                                      ):
            T;
            (* initialize a token with it's kind, text, languages and
               usage.  The languages and usage may change later. *)

      getLine (): INTEGER;
               (* retrieves the value of the attribute line. *)

      getText (): TEXT;
               (* retrieves the token's text *)

      renameText (text: TEXT);

      setLanguage (language: Language);
      removeLanguage (language: Language);
                      (* include (exclude) a token of the membership of the
                         given language. *)

      getLanguages (): LanguageSet;
                    (* retrieves the whole language set from the token. *)

      setUsageSet (usage: UsageSet);
      getUsageSet (): UsageSet;
                   (* retrieves and sets the ident marks identifying idents
                      as declaring and or applying idents. *)
    END;

END Token.
