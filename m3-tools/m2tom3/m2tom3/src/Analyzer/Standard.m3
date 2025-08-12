MODULE Standard;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:04:17
    Standard.m3,v
# Revision 1.1  1994/11/30  15:04:17  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT BaseGraph;
IMPORT Symbol;
IMPORT Token;
IMPORT Syntax;
IMPORT SourceGraph;
IMPORT TextF, Text;


PROCEDURE IsPredefinedType (graph: SourceGraph.T; symbol: Symbol.T):
  BOOLEAN =
  <* FATAL BaseGraph.NodeNotInGraph *>

  CONST
    PredefinedTypes =            (* by Wirth *)
    ",CARDINAL,INTEGER,BOOLEAN,CHAR,REAL,BITSET,PROC," &

      (* from SYSTEM *)
      "ADDRESS,WORD,PROCESS," &

      (* ISO types *)
      "BYTE,LONGREAL" &

      (* EPC Modula-2*)
      "BYTEINT,SHORTINT,LONGINT," & "BYTECARD,SHORTCARD,LONGCARD,"
      & "BYTEBITSET,SHORTBITSET,";

  VAR
    index, length: CARDINAL := 0;
    tokenText    : TEXT;
    found        : BOOLEAN;

  BEGIN
    IF (symbol.getKind() = Symbol.Kind.SyntaxQualIdent) THEN
      IF NARROW(graph.getChildSymbol(
                  symbol, 2, Symbol.Kind.SyntaxQualificationScope),
                Syntax.T).getNoOfChildren() > 0 THEN
        RETURN FALSE;
      END;
      symbol := graph.getChildSymbol(symbol, 1, Symbol.Kind.Identifier);
    END;

    IF (symbol.getKind() = Symbol.Kind.Identifier) THEN
      tokenText := NARROW(symbol, Token.T).getText();
      found := FindSub(PredefinedTypes, tokenText, index);
      IF (found) THEN
        length := Text.Length(tokenText);
        found :=
          (Text.GetChar(PredefinedTypes, index - 1) = ',')
            AND (Text.GetChar(PredefinedTypes, index + length) = ',');
      END;
      RETURN found;
    ELSE
      (* symbol unknown type *)
      <* ASSERT FALSE *>
    END;
  END IsPredefinedType;


(* From M3TK *)
EXCEPTION BadFind;


PROCEDURE FindSub (t, sub: TEXT; VAR index: CARDINAL): BOOLEAN RAISES {} =
  VAR
    i   : CARDINAL := index;
    lt  : CARDINAL := Text.Length(t);
    lsub: CARDINAL := Text.Length(sub);

  BEGIN
    IF (i > lt) THEN             <*FATAL BadFind*>
      BEGIN
        RAISE BadFind;
      END;
    END;
    IF (lsub = 0) THEN
      RETURN TRUE;
    ELSE
      IF (lsub <= lt) THEN
        VAR
          lastStart := lt - lsub;
          firstCh   := sub[0];
        BEGIN
          WHILE (i <= lastStart) DO
            IF (t[i] = firstCh) THEN
              VAR j: CARDINAL := 1;
              BEGIN
                LOOP
                  IF (j = lsub) THEN
                    index := i;
                    RETURN TRUE;
                  ELSIF (i + j >= lt OR t[i + j] # sub[j]) THEN
                    EXIT;
                  ELSE
                    INC(j);
                  END;
                END;
              END;
            END;
            INC(i);
          END;
        END;
      END;
      index := lt;
      RETURN FALSE;
    END;
  END FindSub;

BEGIN
END Standard.
