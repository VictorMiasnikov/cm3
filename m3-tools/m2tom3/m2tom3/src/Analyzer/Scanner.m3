MODULE Scanner;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Robert Kiehne                                             *)

(** pk
    1.2
    1995/01/20 16:18:13
    Scanner.m3,v
# Revision 1.2  1995/01/20  16:18:13  pk
# Besides C, now c is also allowed for denoting character literals in
# the 0C form.
#
# Revision 1.1  1994/11/30  15:04:07  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- Scanner ----------------------------------------------------------------
  * The scanner uses a hash table to detect reserved words and
  * a simple table to determine token kinds of single character literals.
  * ----------------------------------------------------------------------------
  **)

IMPORT Rd, FileRd, Stdio, Thread, ASCII, Text, Fmt, OSError;
IMPORT BaseGraph;
IMPORT Symbol;
IMPORT Token, TokenGraph;
IMPORT SourceGraph;
FROM ScanBuffer IMPORT ClearBuffer, AppendToBuffer, GetText;

(*
  --- Stuff for Hashtable ------------------------------------------------------
*)

CONST HashTableSize = 97;


TYPE
  HashTableIndex = [0 .. HashTableSize - 1];
  HashTableEntry = RECORD
                     used : BOOLEAN       := FALSE;
                     id   : TEXT          := "";
                     token: Symbol.Kind;
                   END;


VAR table: ARRAY HashTableIndex OF HashTableEntry;


PROCEDURE InitHashTable () =
  PROCEDURE AddToHash (s: TEXT; t: Symbol.Kind) =
    VAR h, d: HashTableIndex;

    BEGIN
      h := 0;
      FOR i := 0 TO Text.Length(s) - 1 DO
        h := (2 * h + ORD(Text.GetChar(s, i))) MOD HashTableSize;
      END;
      d := 1;
      WHILE table[h].used DO
        h := (h + d) MOD HashTableSize;
        d := d + 2;
      END;
      table[h] := HashTableEntry{used := TRUE, id := s, token := t};
    END AddToHash;

  (* InitHashTable *)
  BEGIN
    FOR i := 0 TO HashTableSize - 1 DO
      table[i].used := FALSE;
      table[i].id := "";
    END;
    AddToHash("AND", Symbol.Kind.And);
    AddToHash("ARRAY", Symbol.Kind.Array);
    AddToHash("BEGIN", Symbol.Kind.Begin);
    AddToHash("BY", Symbol.Kind.By);
    AddToHash("CASE", Symbol.Kind.Case);
    AddToHash("CONST", Symbol.Kind.Const);
    AddToHash("DEFINITION", Symbol.Kind.Definition);
    AddToHash("DIV", Symbol.Kind.Div);
    AddToHash("DO", Symbol.Kind.Do);
    AddToHash("ELSE", Symbol.Kind.Else);
    AddToHash("ELSIF", Symbol.Kind.Elsif);
    AddToHash("END", Symbol.Kind.End);
    AddToHash("EXIT", Symbol.Kind.Exit);
    AddToHash("EXPORT", Symbol.Kind.Export);
    AddToHash("FOR", Symbol.Kind.For);
    AddToHash("FORWARD", Symbol.Kind.Forward);
    AddToHash("FROM", Symbol.Kind.From);
    AddToHash("IF", Symbol.Kind.If);
    AddToHash("IMPLEMENTATION", Symbol.Kind.Implementation);
    AddToHash("IMPORT", Symbol.Kind.Import);
    AddToHash("IN", Symbol.Kind.In);
    AddToHash("LOOP", Symbol.Kind.Loop);
    AddToHash("MOD", Symbol.Kind.Mod);
    AddToHash("MODULE", Symbol.Kind.Module);
    AddToHash("NOT", Symbol.Kind.Not);
    AddToHash("OF", Symbol.Kind.Of);
    AddToHash("OR", Symbol.Kind.Or);
    AddToHash("POINTER", Symbol.Kind.Pointer);
    AddToHash("PROCEDURE", Symbol.Kind.Procedure);
    AddToHash("QUALIFIED", Symbol.Kind.Qualified);
    AddToHash("REM", Symbol.Kind.Rem);
    AddToHash("RECORD", Symbol.Kind.Record);
    AddToHash("REPEAT", Symbol.Kind.Repeat);
    AddToHash("RETURN", Symbol.Kind.Return);
    AddToHash("SET", Symbol.Kind.Set);
    AddToHash("THEN", Symbol.Kind.Then);
    AddToHash("TO", Symbol.Kind.To);
    AddToHash("TYPE", Symbol.Kind.Type);
    AddToHash("UNTIL", Symbol.Kind.Until);
    AddToHash("VAR", Symbol.Kind.Var);
    AddToHash("WHILE", Symbol.Kind.While);
    AddToHash("WITH", Symbol.Kind.With);
  END InitHashTable;


PROCEDURE TestReservedWord (name: TEXT): Symbol.Kind =
  VAR h, d: HashTableIndex;

  BEGIN
    h := 0;
    FOR i := 0 TO Text.Length(name) - 1 DO
      h := (2 * h + ORD(Text.GetChar(name, i))) MOD HashTableSize;
    END;
    d := 1;
    WHILE (table[h].used AND (NOT Text.Equal(name, table[h].id))) DO
      h := (h + d) MOD HashTableSize;
      d := d + 2;
    END;
    IF (table[h].used) THEN
      RETURN table[h].token;
    ELSE
      RETURN Symbol.Kind.Identifier;
    END;
  END TestReservedWord;


(*
  --- Stuff for Simpletable ----------------------------------------------------
*)
CONST
  SimpleChars = SET OF
                  CHAR{'+', '-', '*', '/', '&', ',', ';', ')', '[', ']',
                       '{', '}', '^', '~', '=', '#', '|'};


TYPE
  SimpleEntry = RECORD
                  kind: Symbol.Kind;
                  text: TEXT;
                END;

  SimpleTable = ARRAY CHAR OF SimpleEntry;


VAR simpleTable: SimpleTable;


PROCEDURE InitSimpleTable () =
  PROCEDURE AddToSimpleTable (simpleChar: CHAR;
                              simpleKind: Symbol.Kind;
                              simpleText: TEXT         ) =
    BEGIN
      simpleTable[simpleChar] :=
        SimpleEntry{kind := simpleKind, text := simpleText};
    END AddToSimpleTable;

  (* InitSimpleTable *)
  BEGIN
    AddToSimpleTable('+', Symbol.Kind.Plus, "+");
    AddToSimpleTable('-', Symbol.Kind.Minus, "-");
    AddToSimpleTable('*', Symbol.Kind.Mult, "*");
    AddToSimpleTable('/', Symbol.Kind.Division, "/");
    AddToSimpleTable('&', Symbol.Kind.Ampersand, "&");
    AddToSimpleTable(',', Symbol.Kind.Comma, ",");
    AddToSimpleTable(';', Symbol.Kind.Semicolon, ";");
    AddToSimpleTable(')', Symbol.Kind.RBracket, ")");
    AddToSimpleTable('[', Symbol.Kind.ALBracket, "[");
    AddToSimpleTable(']', Symbol.Kind.ARBracket, "]");
    AddToSimpleTable('{', Symbol.Kind.CLBracket, "{");
    AddToSimpleTable('}', Symbol.Kind.CRBracket, "}");
    AddToSimpleTable('^', Symbol.Kind.Arrow, "^");
    AddToSimpleTable('~', Symbol.Kind.Not, "~");
    AddToSimpleTable('=', Symbol.Kind.Equal, "=");
    AddToSimpleTable('#', Symbol.Kind.NEqual, "#");
    AddToSimpleTable('|', Symbol.Kind.Bar, "|");
  END InitSimpleTable;


(*
  --- Scanning area ------------------------------------------------------------
*)
PROCEDURE Scan (fileName: TEXT;
                graph   : SourceGraph.T;
                anchor  : SourceGraph.Anchor)
  RAISES {IOError, TokenGraph.NoAnchor, GraphError} =
  TYPE CharSet = SET OF CHAR;

  VAR
    scanFile      : Rd.T;
    newToken      : Token.T;
    text          : TEXT;
    kind          : Symbol.Kind;
    lookAhead     : CHAR;
    lastReadWasEOL: BOOLEAN;
    line          : INTEGER     := 1;

  PROCEDURE Init (fileName: TEXT): Rd.T RAISES {IOError} =
    VAR scanFile: Rd.T;

    BEGIN
      IF (Text.Length(fileName) > 0) THEN
        TRY
          scanFile := FileRd.Open(fileName);
        EXCEPT
        | OSError.E => RAISE IOError("error in opening input file");
        END;
      ELSE
        scanFile := Stdio.stdin;
      END;
      line := 1;
      lastReadWasEOL := TRUE;
      RETURN scanFile;
    END Init;


  PROCEDURE Exit (scanFile: Rd.T) RAISES {IOError} =
    BEGIN
      TRY
        Rd.Close(scanFile);
      EXCEPT
        Rd.Failure, Thread.Alerted =>
          RAISE IOError("error in closing input file");
      END;
    END Exit;


  PROCEDURE Read () RAISES {IOError} =
    BEGIN
      IF (lastReadWasEOL) THEN lastReadWasEOL := FALSE; END;
      TRY
        IF (Rd.EOF(scanFile)) THEN
          lookAhead := ASCII.NUL;
        ELSE
          lookAhead := Rd.GetChar(scanFile);
        END;
      EXCEPT
        Rd.Failure, Thread.Alerted, Rd.EndOfFile =>
          RAISE IOError("error in reading input file");
      END;

      lastReadWasEOL := (lookAhead = ASCII.NL);
      IF (lastReadWasEOL) THEN INC(line); END;
    END Read;


  PROCEDURE GetNextToken (VAR text: TEXT; VAR kind: Symbol.Kind)
    RAISES {IOError} =
    VAR
      delimiter   : CHAR;
      commentLevel: CARDINAL;
      length      : CARDINAL;

    BEGIN
      IF (lookAhead IN SimpleChars) THEN
        WITH entry = simpleTable[lookAhead] DO
          kind := entry.kind;
          text := entry.text;
        END;
        Read();
        RETURN;
      END;

      CASE lookAhead OF
      | ASCII.SP, ASCII.NL, ASCII.HT =>
          ClearBuffer();
          AppendToBuffer(lookAhead);
          Read();
          WHILE (lookAhead IN CharSet{ASCII.SP, ASCII.NL, ASCII.HT}) DO
            AppendToBuffer(lookAhead);
            Read();
          END;
          text := GetText();
          kind := Symbol.Kind.WhiteSpace;

      | ':' =>
          Read();
          IF (lookAhead = '=') THEN
            kind := Symbol.Kind.Assign;
            text := ":=";
            Read();
          ELSE
            kind := Symbol.Kind.Colon;
            text := ":";
          END;

      | '.' =>
          Read();
          IF (lookAhead = '.') THEN
            kind := Symbol.Kind.Range;
            text := "..";
            Read();
          ELSE
            kind := Symbol.Kind.Period;
            text := ".";
          END;

      | '(' =>
          Read();
          IF (lookAhead = '*') THEN
            commentLevel := 1;
            ClearBuffer();
            AppendToBuffer('(');
            AppendToBuffer('*');
            Read();
            WHILE (commentLevel > 0) DO
              AppendToBuffer(lookAhead);
              IF (lookAhead = '*') THEN
                Read();
                IF (lookAhead = ')') THEN
                  AppendToBuffer(lookAhead);
                  Read();
                  DEC(commentLevel);
                END;
              ELSIF (lookAhead = '(') THEN
                Read();
                IF (lookAhead = '*') THEN
                  AppendToBuffer(lookAhead);
                  Read();
                  INC(commentLevel);
                END;
              ELSE               (* other character *)
                Read();
              END;               (* IF *)
            END;                 (* WHILE *)
            kind := Symbol.Kind.Comment;
            text := GetText();
          ELSE
            kind := Symbol.Kind.LBracket;
            text := "("
          END;

      | '<' =>
          Read();
          IF (lookAhead = '=') THEN
            kind := Symbol.Kind.LEqual;
            Read();
            text := "<=";
          ELSIF (lookAhead = '>') THEN
            kind := Symbol.Kind.NEqual;
            Read();
            text := "<>";
          ELSE
            kind := Symbol.Kind.Less;
            text := "<";
          END;

      | '>' =>
          Read();
          IF (lookAhead = '=') THEN
            kind := Symbol.Kind.GEqual;
            Read();
            text := ">=";
          ELSE
            kind := Symbol.Kind.Greater;
            text := ">";
          END;

      | '\"', '\'' =>
          delimiter := lookAhead;
          ClearBuffer();
          AppendToBuffer(lookAhead);
          Read();
          TRY
            WHILE ((NOT Rd.EOF(scanFile) AND (lookAhead # delimiter)
                      AND (lookAhead >= ASCII.SP))) DO
              AppendToBuffer(lookAhead);
              Read();
            END
          EXCEPT
          | Rd.Failure, Thread.Alerted =>
              RAISE IOError("error in opening input file")
          END;
          IF (lookAhead = delimiter) THEN
            AppendToBuffer(lookAhead);
            text := GetText();
            (* test for string / char literal *)
            length := Text.Length(text);
            IF ((length = 3)
                  OR ((length = 4) AND (Text.GetChar(text, 1) = '\\'))) THEN
              IF (delimiter = '"') THEN
                WITH contents = Text.Sub(text, 1, length - 2) DO
                  IF (Text.Equal(contents, "'")) THEN
                    text := "'\\''";
                  ELSE
                    text := "'" & contents & "'";
                  END;
                END;
              END;
              kind := Symbol.Kind.CharConst;
            ELSE
              IF (delimiter = '\'') THEN
                text := ("\"" & Text.Sub(text, 1, length - 2) & "\"");
              END;
              kind := Symbol.Kind.StringConst;
            END;
            Read();
          ELSE
            kind := Symbol.Kind.BadToken;
          END;

      | 'A' .. 'Z', 'a' .. 'z', '_' =>
          ClearBuffer();
          AppendToBuffer(lookAhead);
          Read();
          WHILE (lookAhead IN CharSet{'A'.. 'Z', 'a'.. 'z', '0'.. '9', '_'}) DO
            AppendToBuffer(lookAhead);
            Read();
          END;
          text := GetText();
          kind := TestReservedWord(text);

      | '0' .. '9' =>
          ClearBuffer();
          AppendToBuffer(lookAhead);
          Read();
          WHILE (lookAhead IN CharSet{'0'.. '9', 'A'.. 'H', 'c'}) DO
            AppendToBuffer(lookAhead);
            Read();
          END;
          text := GetText();
          length := Text.Length(text) - 1;
          CASE Text.GetChar(text, length) OF
            'H' => text := "16_" & Text.Sub(text, 0, length);
          | 'B' => text := "8_" & Text.Sub(text, 0, length);
          | 'C', 'c' =>
              text := Fmt.F("'\\%03s'", Text.Sub(text, 0, length));
          ELSE
          END;
          IF (lookAhead = '.') THEN
            Read();
            IF (lookAhead = '.') THEN
              Rd.UnGetChar(scanFile);
              kind := Symbol.Kind.IntegerConst;
            ELSE
              text := text & ".";
              WHILE (lookAhead IN CharSet{'0'.. '9'}) DO
                text := text & Text.FromChar(lookAhead);
                Read();
              END;
              IF (lookAhead IN CharSet{'e', 'E'}) THEN
                text := text & Text.FromChar(lookAhead);
                Read();
                IF (lookAhead IN CharSet{'+', '-'}) THEN
                  text := text & Text.FromChar(lookAhead);
                  Read();
                END;
                IF (lookAhead IN CharSet{'0'.. '9'}) THEN
                  WHILE (lookAhead IN CharSet{'0'.. '9'}) DO
                    text := text & Text.FromChar(lookAhead);
                    Read();
                  END;
                  kind := Symbol.Kind.RealConst;
                ELSE
                  kind := Symbol.Kind.BadToken;
                END;
              ELSE
                kind := Symbol.Kind.RealConst;
              END;
            END;
          ELSE
            kind := Symbol.Kind.IntegerConst;
          END;
      ELSE                       (* CASE lookAhead *)
        kind := Symbol.Kind.BadToken;
        Read();
      END;
    END GetNextToken;

  (* Scan *)
  BEGIN
    scanFile := Init(fileName);

    Read();
    WHILE (lookAhead # ASCII.NUL) DO
      GetNextToken(text, kind);
      IF ((kind = Symbol.Kind.RealConst)
            AND (Text.GetChar(text, Text.Length(text) - 1) = '.')) THEN
        text := text & "0";
      END;
      newToken := NEW(Token.T).init(kind, text, line := line);

      TRY
        graph.appendToken(anchor, newToken);
      EXCEPT
        BaseGraph.NodeInGraph, BaseGraph.NodeNotInGraph,
            TokenGraph.NotInStream =>
          RAISE GraphError;
      END;
    END;

    Exit(scanFile);
  END Scan;

BEGIN
  InitHashTable();
  InitSimpleTable();
END Scanner.
