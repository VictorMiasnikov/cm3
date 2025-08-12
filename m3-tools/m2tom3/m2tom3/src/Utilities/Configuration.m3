MODULE Configuration;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Peter Klein                                               *)

(** pk
    1.2
    1995/02/14 15:37:55
    Configuration.m3,v
# Revision 1.2  1995/02/14  15:37:55  pk
# Support for -r flag inserted.
#
# Revision 1.1  1994/11/30  15:09:46  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT Text, TextSeq, Pathname, Stdio, Wr, Rd, Fmt, Thread, Env, Params,
       Lex, TextRd, FloatMode, FS, RegularFile, File, Scan, OSError;


CONST EnvVarName = "M2TOM3_OPTIONS";


VAR
  options: TextSeq.T;

  writeGRL       : BOOLEAN    := FALSE;
  dumpRestriction: BOOLEAN    := FALSE;
  dumpRadius     : CARDINAL   := 10;
  m2             : BOOLEAN    := FALSE;
  noM3           : BOOLEAN    := FALSE;
  keepFor        : BOOLEAN    := FALSE;
  keepStrings    : BOOLEAN    := FALSE;
  insertReadonly : BOOLEAN    := FALSE;
  quiet          : BOOLEAN    := FALSE;
  verbose        : BOOLEAN    := FALSE;
  toFile         : BOOLEAN    := FALSE;
  inputPaths     : TextSeq.T  := NIL;
  outputPath     : Pathname.T := NIL;
  files          : TextSeq.T  := NIL;
  fromStdin      : BOOLEAN    := FALSE;

  stop: BOOLEAN := FALSE;

  out := Stdio.stderr;


EXCEPTION Error(TEXT);


<* FATAL Wr.Failure, Thread.Alerted, Rd.Failure *>


PROCEDURE ScanOptions (): BOOLEAN =
  BEGIN
    options := NEW(TextSeq.T).init();
    inputPaths := NEW(TextSeq.T).init();
    files := NEW(TextSeq.T).init();

    ReadEnvironment();
    ReadCommandLine();
    TRY ProcessOptions(); EXCEPT Error (p) => ProcessError(p); END;
    RETURN (NOT stop);
  END ScanOptions;


PROCEDURE WriteGRL (): BOOLEAN =
  BEGIN
    RETURN writeGRL;
  END WriteGRL;


PROCEDURE DumpRestriction (): BOOLEAN =
  BEGIN
    RETURN dumpRestriction;
  END DumpRestriction;


PROCEDURE DumpRadius (): CARDINAL =
  BEGIN
    RETURN dumpRadius;
  END DumpRadius;


PROCEDURE M2 (): BOOLEAN =
  BEGIN
    RETURN m2;
  END M2;


PROCEDURE NoM3 (): BOOLEAN =
  BEGIN
    RETURN noM3;
  END NoM3;


PROCEDURE KeepFor (): BOOLEAN =
  BEGIN
    RETURN keepFor;
  END KeepFor;


PROCEDURE KeepStrings (): BOOLEAN =
  BEGIN
    RETURN keepStrings;
  END KeepStrings;


PROCEDURE InsertReadonly (): BOOLEAN =
  BEGIN
    RETURN insertReadonly;
  END InsertReadonly;


PROCEDURE Quiet (): BOOLEAN =
  BEGIN
    RETURN quiet;
  END Quiet;


PROCEDURE Verbose (): BOOLEAN =
  BEGIN
    RETURN verbose;
  END Verbose;


PROCEDURE ToFile (): BOOLEAN =
  BEGIN
    RETURN toFile;
  END ToFile;


PROCEDURE InputPaths (): TextSeq.T =
  BEGIN
    RETURN inputPaths;
  END InputPaths;


PROCEDURE OutputPath (): Pathname.T =
  BEGIN
    RETURN outputPath;
  END OutputPath;


PROCEDURE Files (): TextSeq.T =
  BEGIN
    RETURN files;
  END Files;


PROCEDURE FromStdin (): BOOLEAN =
  BEGIN
    RETURN fromStdin;
  END FromStdin;


(* Add options from the environment variable to options. *)
PROCEDURE ReadEnvironment () RAISES {} =
  VAR
    envVar           := Env.Get(EnvVarName);
    rd    : TextRd.T;

  BEGIN
    IF (envVar = NIL) THEN RETURN; END;
    rd := NEW(TextRd.T).init(envVar);
    WHILE (NOT Rd.EOF(rd)) DO
      options.addhi(Lex.Scan(rd));
      Lex.Skip(rd);
    END;
  END ReadEnvironment;


(* Add options from the command line to options. *)
PROCEDURE ReadCommandLine () RAISES {} =
  BEGIN
    FOR i := 1 TO Params.Count - 1 DO options.addhi(Params.Get(i)); END;
  END ReadCommandLine;


PROCEDURE ProcessOptions () RAISES {Error} =
  VAR
    current              := 0;
    noOfOptions          := options.size();
    option     : TEXT;
    dumpLevel  : INTEGER;

  BEGIN
    WHILE (current < noOfOptions) DO
      option := options.get(current);
      IF (Text.GetChar(option, 0) = '-') THEN
        IF (Text.Length(option) = 1) THEN
          fromStdin := TRUE;
          IF (files.size() > 0) THEN
            RAISE Error("no files when reading from stdin");
          END;
        ELSE
          CASE Text.GetChar(option, 1) OF
          | 'g' =>
              writeGRL := TRUE;
              IF (GetOptionalInt(current + 1, dumpLevel)) THEN
                IF (dumpLevel = 1) THEN
                  dumpRestriction := FALSE;
                ELSIF (dumpLevel = 2) THEN
                  dumpRestriction := TRUE;
                ELSE
                  RAISE Error(Fmt.Int(dumpLevel)
                                & " not a valid dump level for -g");
                END;
                INC(current);
              END;

          | 'd' =>
              VAR tmp: INTEGER;
              BEGIN
                IF (NOT GetOptionalInt(current + 1, tmp)) THEN
                  RAISE Error("no dump radius given for -d");
                END;
                IF (tmp < 0) THEN
                  RAISE Error("negative dump radius given for -d");
                END;
                dumpRadius := tmp;
              END;
              INC(current);

          | 'm' => m2 := TRUE;

          | 'n' => noM3 := TRUE;

          | 'f' => keepFor := TRUE;

          | 's' => keepStrings := TRUE;

          | 'r' => insertReadonly := TRUE;

          | 'q' => quiet := TRUE;

          | 'v' => verbose := TRUE;

          | 'F' => toFile := TRUE;

          | 'I' =>
              inputPaths.addhi(GetPath(current + 1, dir := TRUE));
              INC(current);

          | 'O' =>
              outputPath := GetPath(current + 1, dir := TRUE);
              INC(current);

          | 'h' => Help();

          ELSE
            RAISE Error("unknown option " & option);
          END;
        END;
      ELSE
        (* not an option, should be a file *)
        IF (fromStdin) THEN
          RAISE Error("no files when reading from stdin");
        END;
        files.addhi(GetPath(current, dir := FALSE));
      END;
      INC(current);
    END;
  END ProcessOptions;


(* Try to read an integer from position pos in options.  If no integer can
   be found, the function returns FALSE. *)
PROCEDURE GetOptionalInt (pos: CARDINAL; VAR value: INTEGER): BOOLEAN
  RAISES {} =
  VAR param: TEXT;

  BEGIN
    IF (pos >= options.size()) THEN RETURN FALSE; END;
    param := options.get(pos);
    TRY
      value := Scan.Int(param);
    EXCEPT
      Lex.Error, FloatMode.Trap => RETURN FALSE;
    END;
    RETURN TRUE;
  END GetOptionalInt;


(* Try to read a path from position pos in options.  If dir is TRUE and the
   path is not a directory of if dir is FALSE and the path is not a file,
   Error will be raised. *)
PROCEDURE GetPath (pos: CARDINAL; dir: BOOLEAN): Pathname.T
  RAISES {Error} =
  VAR
    path  : TEXT;
    status: File.Status;

  BEGIN
    IF (pos >= options.size()) THEN RAISE Error("no path given"); END;
    path := options.get(pos);
    IF (dir AND Text.GetChar(path, Text.Length(path) - 1) # '/') THEN
      path := path & "/";
    END;
    TRY
      status := FS.Status(path);
    EXCEPT
      OSError.E => RAISE Error("path " & path & " does not exist");
    END;
    IF (dir) THEN
      IF (status.type # FS.DirectoryFileType) THEN
        RAISE Error(path & " is not a directory");
      END;
    ELSE
      IF (status.type # RegularFile.FileType) THEN
        RAISE Error(path & " is not a regular file");
      END;
    END;
    RETURN path;
  END GetPath;


(* Write help text to stdout. *)
PROCEDURE Help () RAISES {} =
  BEGIN
    Wr.PutText(out, "Options:\n");
    Wr.PutText(out, "-g [dl]\twrite GRL file for EDGE\n");
    Wr.PutText(out, "\toptional dump level means:\n");
    Wr.PutText(out, "\t\t1 -> dump all nodes (default)\n");
    Wr.PutText(out, "\t\t2 -> dump only tokens and scopes\n");
    Wr.PutText(
      out, "-d rad\tset radius for graph information (default 10)\n");
    Wr.PutText(out, "-m\tadditional Modula-2 output\n");
    Wr.PutText(
      out,
      "-n\tsuppress Modula-3 output (and generation of Modula-3 tokens)\n");
    Wr.PutText(out, "-f\tdo not change FOR-loops into WHILE-loops\n");
    Wr.PutText(
      out, "-s\tdo not change string literals into ARRAYs OF CHAR\n");
    Wr.PutText(out, "-r\tmake all call-by-value ARRAYs READONLY\n");
    Wr.PutText(out, "-q\tquiet: report no warnings, only errors\n");
    Wr.PutText(out, "-v\tverbose: report course of action to stdout\n");
    Wr.PutText(
      out,
      "-F\tinclude errors and warnings in the generated Modula-3 source code\n");
    Wr.PutText(out, "-I path\tadd a search path for Modula-2 imports\n");
    Wr.PutText(out, "-O path\tset path for Modula-3 output\n");
    Wr.PutText(out, "-h\tthis help\n");
    Wr.PutText(out, "file\tadd a file to be processed\n");
    Wr.PutText(out, "-\tread from stdin\n");
    Wr.PutText(out, "All boolean flags default to FALSE.\n");
    Wr.PutText(
      out,
      "All options may be repeated. If the argument does not accumulate,\nthe last occurance is active.\n");
    Wr.Flush(out);
    stop := TRUE;
  END Help;


(* Handle an error. *)
PROCEDURE ProcessError (message: TEXT) RAISES {} =
  BEGIN
    Wr.PutText(out, "Error: " & message & "\n");
    Usage();
    stop := TRUE;
  END ProcessError;


PROCEDURE Usage () RAISES {} =
  BEGIN
    Wr.PutText(out, "Usage:\n");
    Wr.PutText(
      out,
      Params.Get(0)
        & " [-g [dl]] [-d rad] [-n] [-f] [-s] [-r] [-q] [-v] [-F] [-I path] [-O path] [-h] [file] [-]\n");
    Wr.PutText(out, "Use -h for help.\n");
    Wr.Flush(out);
  END Usage;

BEGIN
END Configuration.
