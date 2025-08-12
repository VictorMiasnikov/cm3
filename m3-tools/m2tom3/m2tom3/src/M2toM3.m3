MODULE M2toM3 EXPORTS Main;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Thomas Stockheim                                          *)

(** pk
    1.1
    1994/11/30 15:03:23
    M2toM3.m3,v
# Revision 1.1  1994/11/30  15:03:23  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(* subsystem SourceGraph *)
IMPORT BaseNode, BaseGraph;
IMPORT Token, TokenGraph;
IMPORT UnitGraph;
IMPORT SourceGraph;

(* subsystem Analyzer *)
IMPORT Scanner, Parser, ImportClosure, IdentifierLinker, ActualToFormalType;

(* subsystem GraphView *)
IMPORT WriteGraph;

(* subsystem Utilities *)
IMPORT Configuration, Message;

(* subsystem Generator *)
IMPORT Generator;

(* other stuff *)
IMPORT Thread, Wr, Text, IO, FS, File, OSError, Pathname, TextSeq;


(* The exception TerminateProgram is raised when an error occurs which
   doesn't allow a usefull continuation of the program.*)
EXCEPTION TerminateProgram;


<* FATAL Thread.Alerted, Wr.Failure *>


CONST
  M2DefExtension = ".def";
  M2ModExtension = ".mod";


(** --- ReadUnit----------------------------------------------------------------
  *
  * ASSUMPTION: same unit name and filename (without suffix or path).
  *             POSIX type file system with / as separator.
  *
  * This procedure scanns and parses a given new unit.
  * Parameter name specifies a file or a unit name, isDefiniton and
  * isWork specifies typ and status of unit.
  * If name is a filename, the unit name will be extracted of this and the
  * suffix will be stored in attribute suffix of anchor.
  * If name contains a path this will be stored in attribute path of anchor.
  * Returns a new anchor, if an error occurs return NIL.
  * If the unit allready exists in the graph, then return NIL.
  *
  * line of action:
  *
  * - check if name contains a filename.
  *   split filename in path , unitname and suffix.
  * - extend name to module filename (including suffix).
  * - search include path (given by -I parameter) for filename.
  *   if not found return NIL.
  * - insert new anchor for unit
  * - call scanner for filename
  * - call parser for filename
  * ----------------------------------------------------------------------------
  **)
PROCEDURE ReadUnit (graph               : SourceGraph.T;
                    name                : TEXT;
                    isDefinition, isWork: BOOLEAN        ):
  SourceGraph.Anchor RAISES {TerminateProgram} =
  <* FATAL BaseGraph.NodeInGraph, UnitGraph.UnitNotUnique *>

  VAR
    fileName  : Pathname.T;
    path      : Pathname.T;
    suffix    : Pathname.T;
    unitName  : Pathname.T;
    i         : CARDINAL;
    found     : BOOLEAN;
    fileStatus: File.Status;
    anchor    : SourceGraph.Anchor;
    inputPaths: TextSeq.T;

  BEGIN
    (* for evaluation process only !!! *)
    (* Split name to path and filename *)
    WITH p = Text.FindCharR(name, '/') DO
      IF p = -1 THEN
        path := "";
        fileName := name;
      ELSE
        path := Text.Sub(name, 0, p + 1);
        fileName := Text.Sub(name, p + 1);
      END;
    END;

    (*
      fileName := Pathname.Last(name);
      path := Pathname.Prefix(name);
    *)

    IF (isWork) THEN workPath := path; END;

    suffix := Pathname.LastExt(fileName);
    unitName := Pathname.LastBase(fileName);
    IF (Text.Empty(suffix)) THEN
      IF (isDefinition) THEN
        suffix := M2DefExtension;
      ELSE
        suffix := M2ModExtension;
      END;
    ELSE
      suffix := "." & suffix;
    END;

    (* now workPath contains the path of file name, unitName contains
       basename of unit and suffix contains the files suffix. *)

    (* Check if unit exists in graph *)
    anchor := graph.getUnit(unitName, isDefinition);
    IF (anchor # NIL) THEN
      (* unit is in the graph *)
      (* mark unit as work unit if parameter isWork is set *)
      IF (isWork) THEN anchor.setWork(); END;
      RETURN NIL;
    END;

    (* search file in workPath and search paths. *)
    found := TRUE;
    TRY
      fileStatus := FS.Status(workPath & unitName & suffix);
      path := workPath;
    EXCEPT
    | OSError.E => found := FALSE;
    END;

    i := 0;
    inputPaths := Configuration.InputPaths();
    WHILE ((NOT found) AND (i < inputPaths.size())) DO
      TRY
        path := inputPaths.get(i);
        fileStatus := FS.Status(path & unitName & suffix);
        found := TRUE;
      EXCEPT
      | OSError.E =>
          (* File doesn't exist.*)
          INC(i);
      END;
    END;

    IF (NOT found) THEN RETURN NIL; END;

    anchor := NEW(SourceGraph.Anchor).init(
                unitName, path, suffix, isWork, isDefinition);
    graph.insertAnchor(anchor);

    TRY
      Message.Write(code := Message.Code.None,
                    info := "\tscanning " & unitName & suffix);
      Scanner.Scan(path & unitName & suffix, graph, anchor);

      Message.Write(code := Message.Code.None,
                    info := "\tparsing " & unitName & suffix);
      Parser.Parse(graph, anchor);

    EXCEPT
    | Scanner.IOError =>
        Message.Write(code := Message.Code.IoError);
        RAISE TerminateProgram;

    | Parser.SyntaxError (error) =>
        Message.Write(
          graph := graph, token := error.token, code := error.code);
        RAISE TerminateProgram;

    | Parser.OutOfTokens =>
        Message.Write(code := Message.Code.OutOfTokens);
        RAISE TerminateProgram;

    | Parser.GraphError, Scanner.GraphError =>
        Message.Write(code := Message.Code.GraphError);
        RAISE TerminateProgram;

    | TokenGraph.NoAnchor =>
        Message.Write(code := Message.Code.NoAnchor);
        RAISE TerminateProgram;
    END;

    RETURN anchor;
  END ReadUnit;


PROCEDURE Run (graph: SourceGraph.T) RAISES ANY =
  VAR
    anchor           : SourceGraph.Anchor;
    suffix, newSuffix: TEXT               := "";
    actualPath       : Pathname.T;
    isDef, filesOut  : BOOLEAN;
    workFileName     : Pathname.T;
    files            : TextSeq.T;

  BEGIN
    files := Configuration.Files();
    FOR actualArgument := 0 TO files.size() - 1 DO
      workFileName := files.get(actualArgument);
      Message.Write(code := Message.Code.None,
                    info := "\nreading work file " & workFileName & "...");

      (* determine type of unit *)
      suffix := "." & Pathname.LastExt(workFileName);
      IF (Text.Equal(M2DefExtension, suffix)) THEN
        isDef := TRUE;
      ELSE
        isDef := FALSE;
      END;

      (* Read in work module *)
      anchor := ReadUnit(graph, workFileName, isDefinition := isDef,
                         isWork := TRUE);

      IF (anchor # NIL) THEN
        Message.Write(code := Message.Code.None,
                      info := "generating import closure...");
        ImportClosure.MakeImportClosure(graph, anchor, ReadUnit);
      END;
    END;

    Message.Write(
      code := Message.Code.None, info := "\nlinking identifiers...");
    IdentifierLinker.LinkIdentifiersOfGraph(graph);

    Message.Write(
      code := Message.Code.None, info := "\nlinking parameters...");
    ActualToFormalType.Bind(graph);

    IF (NOT Configuration.NoM3()) THEN
      Message.Write(code := Message.Code.None,
                    info := "\ngenerating Modula-3 source...");
      Generator.GenerateM3Source(graph);
    END;

    Message.Write(
      code := Message.Code.None, info := "\nsaving generated source...");
    filesOut := FALSE;

    WITH iter = graph.iterateUnits() DO
      anchor := iter.next();
      WHILE (anchor # NIL) DO
        IF (anchor.isWork()) THEN
          workFileName := anchor.getName();
          suffix := anchor.getSuffix();
          IF Text.Equal(M2DefExtension, suffix) THEN
            newSuffix := ".i3";
          ELSE
            newSuffix := ".m3";
          END;

          IF (Configuration.M2()) THEN
            Message.Write(
              code := Message.Code.None,
              info := "\twriting Modula-2 file " & anchor.getPath()
                        & workFileName & suffix & ".new");
            WriteUnit(graph, anchor, Token.Language.M2,
                      anchor.getPath() & workFileName & suffix & ".new");
            filesOut := TRUE;
          END;

          IF (NOT Configuration.NoM3()) THEN
            IF (Configuration.OutputPath() # NIL) THEN
              actualPath := Configuration.OutputPath();
            ELSE
              actualPath := anchor.getPath();
            END;

            Message.Write(code := Message.Code.None,
                          info := "\twriting Modula-3 file " & actualPath
                                    & workFileName & newSuffix);
            WriteUnit(graph, anchor, Token.Language.M3,
                      actualPath & workFileName & newSuffix);
            filesOut := TRUE;
          END;
        END;
        anchor := iter.next();
      END;
    END;
    IF (NOT filesOut) THEN
      Message.Write(
        code := Message.Code.None, info := "\tno files to write.");
    END;

    IF (Configuration.WriteGRL()) THEN
      WITH iter = graph.iterateUnits() DO anchor := iter.next(); END;
      IF (anchor # NIL) THEN
        WriteGraph.WriteGrl(
          graph, files.get(0) & ".m3.grl", NARROW(anchor, BaseNode.T),
          Configuration.DumpRadius(), Configuration.DumpRestriction());
      END;
    END;
  END Run;


PROCEDURE WriteUnit (graph   : SourceGraph.T;
                     anchor  : SourceGraph.Anchor;
                     language: Token.Language;
                     filename: Pathname.T          ) =
  VAR
    token: Token.T;
    file : Wr.T;

  <* FATAL BaseGraph.NodeNotInGraph, TokenGraph.NoAnchor *>

  BEGIN
    file := IO.OpenWrite(filename);
    IF (file # NIL) THEN
      token := graph.getFirstToken(anchor, language);
      WHILE (token # NIL) DO
        Wr.PutText(file, token.getText());
        token := graph.getNextToken(token, language);
      END;
      Wr.PutText(file, "\n");
      Wr.Close(file);
    ELSE
      Message.Write(code := Message.Code.IoError)
    END
  END WriteUnit;


VAR
  graph   : SourceGraph.T;
  workPath: Pathname.T    := "";

BEGIN
  TRY
    IF (NOT Configuration.ScanOptions()) THEN RAISE TerminateProgram; END;
    IF (Configuration.Files().size() > 0) THEN
      graph := NEW(SourceGraph.T).init();
      Run(graph);
    ELSE
      Message.Write(code := Message.Code.MissingSource);
    END;
  EXCEPT
  | TerminateProgram =>
      Message.Write(code := Message.Code.TerminateProgram);
  ELSE
    Message.Write(code := Message.Code.UnknownError);
  END;
END M2toM3.
