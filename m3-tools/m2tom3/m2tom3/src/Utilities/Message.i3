INTERFACE Message;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Peter Klein                                               *)

(** pk
    1.2
    1995/01/17 10:53:07
    Message.i3,v
# Revision 1.2  1995/01/17  10:53:07  pk
# New warning message for short actual parameter lists (thanks to Rodney
# Bates).
#
# Revision 1.1  1994/11/30  15:09:47  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

IMPORT Token, SourceGraph;


TYPE
  Code =
    {
    (* no predefined message code *)
    None,

    (* 'generic' message: please USE it if just no other code matches your
       problem but CREATE a matching code as soon as possible. *)
    UnknownError, UnknownWarning,

    (* analyzer: parser *)
    TokenExpected, ModuleExpected, DefinitionExpected, ImportExpected,
    DeclarationExpected, TypeExpected, CaseFieldExpected,
    SimpleTypeExpected, StatementExpected, DesignatorItemExpected,
    RelationExpected, SumOperatorExpected, BinaryAddExpected,
    MulOperatorExpected, FactorExpected, ConstantFactorExpected,

    (* analyzer: identifier linker *)
    NoInterfaceForImplementation, NoInterfaceForImport, UnknownExport,
    NoDesignatorServer, WrongDesignatorQualification, WrongQualification,
    TypeErrorImportFromProgram, TypeErrorInQualification,
    TypeErrorInDesignator, TypeErrorInWithDifferentTypes,
    TypeErrorInWithRecordExpected, ShortActualParameterList,

    (* generator: common errors *)
    AnonymousType, UnableToHandleLocalModules,

    (* generator: variant generator *)
    VariantAppl,

    (* generator: opaque types generator *)
    TypeErrorOpaqueTypeExpected, UnregularOpaqueType,

    (* generator: ADR handler *)
    UnhandledADR,

    (* main program *)
    IoError, ParserError, OutOfTokens, GraphError, NoAnchor,
    TerminateProgram, MissingSource};


PROCEDURE Write (graph: SourceGraph.T := NIL;
                 token: Token.T       := NIL;
                 code : Code          := Code.None;
                 info : TEXT          := NIL        );
  (* Writes some message corresponding to the given code.  If graph is NIL
     and token # NIL, the token text will be appended to the message text.
     If info is not NIL, the info text will be appended to the message
     text.  If graph and token are both not NIL and the appropriate
     Configuration switch is set, the message text will be included in the
     graph at this position as a comment. *)

END Message.
