MODULE Message;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Peter Klein                                               *)

(** pk
    1.2
    1995/01/17 10:53:08
    Message.m3,v
# Revision 1.2  1995/01/17  10:53:08  pk
# New warning message for short actual parameter lists (thanks to Rodney
# Bates).
#
# Revision 1.1  1994/11/30  15:09:49  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT Token, SourceGraph, Configuration, Symbol, BaseGraph, TokenGraph;

IMPORT Stdio, Wr, Fmt, Thread;


TYPE
  Type = {Report, Warning, Error};

  MessageInfo = RECORD
                  type: Type;
                  text: TEXT;
                END;


CONST
  Prefix = ARRAY Type OF TEXT{"", "m2tom3 warning: ", "m2tom3 error: "};

  Info = ARRAY Code OF
           MessageInfo{
           (* None *)
           MessageInfo{Type.Report, ""},

           (* UnknownError *) MessageInfo{Type.Error, "unknown error"},

           (* UnknownWarning *)
           MessageInfo{Type.Warning, "unknown warning"},

           (* TokenExpected *) MessageInfo{Type.Error, "unexpected"},

           (* ModuleExpected *)
           MessageInfo{Type.Error, "module expected, but found:"},

           (* DefinitionExpected *)
           MessageInfo{Type.Error, "definition expected, but found:"},

           (* ImportExpected *)
           MessageInfo{Type.Error, "import expected, but found:"},

           (* DeclarationExpected *)
           MessageInfo{Type.Error, "declaration expected, but found:"},

           (* TypeExpected *)
           MessageInfo{Type.Error, "type expected, but found:"},

           (* CaseFieldExpected *)
           MessageInfo{Type.Error, "case field expected, but found:"},

           (* SimpleTypeExpected *)
           MessageInfo{Type.Error, "simple type expected, but found:"},

           (* StatementExpected *)
           MessageInfo{Type.Error, "statement expected, but found:"},

           (* DesignatorItemExpected *)
           MessageInfo{Type.Error, "designator item expected, but found:"},

           (* RelationExpected *)
           MessageInfo{Type.Error, "relation expected, but found:"},

           (* SumOperatorExpected *)
           MessageInfo{Type.Error, "sum operator expected, but found:"},

           (* BinaryAddExpected *)
           MessageInfo{Type.Error, "'+', '-', 'OR' expected, but found:"},

           (* MulOperatorExpected *)
           MessageInfo{Type.Error, "mult operator expected, but found:"},

           (* FactorExpected *)
           MessageInfo{Type.Error, "factor expected, but found:"},

           (* ConstantFactorExpected *)
           MessageInfo{Type.Error, "constant factor expected, but found:"},

           (* NoInterfaceForImplementation *)
           MessageInfo{
             Type.Warning, "unable to find interface for implementation"},

           (* NoInterfaceForImport *)
           MessageInfo{Type.Warning, "unable to find interface for import"},

           (* UnknownExport *)
           MessageInfo{Type.Warning, "don't know how to handle export"},

           (* NoDesignatorServer *)
           MessageInfo{Type.Warning, "unable to follow designator"},

           (* WrongDesignatorQualification *)
           MessageInfo{
             Type.Warning, "unable to resolve qualification in designator"},

           (* WrongQualification *)
           MessageInfo{Type.Warning, "unable to resolve qualification"},

           (* TypeErrorImportFromProgram *)
           MessageInfo{
             Type.Error,
             "type mismatch in import: cannot import from program module"},

           (* TypeErrorInQualification *)
           MessageInfo{
             Type.Error,
             "type mismatch in qualification: record or module type expected"},

           (* TypeErrorInDesignator *)
           MessageInfo{
             Type.Error,
             "type mismatch in designator part: variable usage differs to declared type"},

           (* TypeErrorInWithDifferentTypes *)
           MessageInfo{
             Type.Error,
             "type mismatch in WITH designator: variable differs to declared type"},

           (* TypeErrorInWithRecordExpected *)
           MessageInfo{
             Type.Error,
             "type mismatch in WITH designator: record type expected for"},

           (* ShortActualParameterList *)
           MessageInfo{Type.Warning,
                       "actual parameter list is too short for procedure"},

           (* AnonymousType *)
           MessageInfo{
             Type.Warning,
             "anonymous type found: transformation restricted for"},

           (* UnableToHandleLocalModules *)
           MessageInfo{Type.Warning, "unable to handle local module"},

           (*VariantAppl *)
           MessageInfo{Type.Warning,
                       "application of variant field, possible cast of"},

           (* TypeErrorOpaqueTypeExpected *)
           MessageInfo{
             Type.Error,
             "type mismatch in implementation:  opaque type expected"},

           (* UnregularOpaqueType *)
           MessageInfo{
             Type.Warning, "non-pointer opaque type moved to interface"},

           (* UnhandledADR *)
           MessageInfo{Type.Warning, "unhandled ADR parameter"},

           (* IoError *) MessageInfo{Type.Error, "I/O error"},

           (* ParserError *) MessageInfo{Type.Error, "parser error"},

           (* OutOfTokens *)
           MessageInfo{Type.Error, "unexpected end of input file"},

           (* GraphError *)
           MessageInfo{Type.Error, "fatal error in graph at:"},

           (* NoAnchor *) MessageInfo{Type.Error, "missing anchor"},

           (* TerminateProgram *)
           MessageInfo{
             Type.Error, "fatal error, program terminated abnormally"},

           (* MissingSource *)
           MessageInfo{Type.Warning, "missing source files to transform"}};


VAR out := Stdio.stdout;


PROCEDURE Write (graph: SourceGraph.T := NIL;
                 token: Token.T       := NIL;
                 code : Code          := Code.None;
                 info : TEXT          := NIL        ) =
  VAR message: TEXT;

  <* FATAL Wr.Failure, Thread.Alerted *>

  BEGIN
    (* set up message text *)
    message := Prefix[Info[code].type] & Info[code].text;
    IF (token # NIL) THEN
      WITH tokenText = "'" & token.getText() & "' in line "
                         & Fmt.Int(token.getLine()) DO
        message := message & " " & tokenText;
      END;
    END;
    IF (info # NIL) THEN message := message & info; END;
    message := message & "\n";

    (* write to terminal *)
    VAR write: BOOLEAN;
    BEGIN
      CASE Info[code].type OF
      | Type.Report =>
          write := Configuration.Verbose() AND (NOT Configuration.Quiet());
      | Type.Warning => write := NOT Configuration.Quiet();
      | Type.Error => write := TRUE;
      END;
      IF (write) THEN Wr.PutText(out, message); Wr.Flush(out); END;
    END;

    (* write to file *)
    IF ((Info[code].type # Type.Report) AND Configuration.ToFile()
          AND (graph # NIL) AND (token # NIL)) THEN
      TRY
        WITH anchor = graph.findAnchor(token),
             commentToken = NEW(Token.T).init(
                              Symbol.Kind.Comment,
                              "(* $$ " & message & " $$ *)") DO
          graph.appendToken(anchor, commentToken, token);
        END;
      EXCEPT
        BaseGraph.NodeInGraph, BaseGraph.NodeNotInGraph,
            TokenGraph.NoAnchor, TokenGraph.NotInStream =>
          Wr.PutText(
            out, Prefix[Type.Warning] & "writing to file failed\n");
          Wr.Flush(out);
      END;
    END;
  END Write;

BEGIN
END Message.
