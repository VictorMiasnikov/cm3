MODULE SimpleGen;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Kai Michael Degner                                        *)

(** pk
    1.2
    1995/02/14 15:37:26
    SimpleGen.m3,v
# Revision 1.2  1995/02/14  15:37:26  pk
# Call to InsertReadonly inserted.
#
# Revision 1.1  1994/11/30  15:05:57  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(* subsystem SourceGraph *)
IMPORT BaseGraph;
IMPORT Symbol;
IMPORT Syntax, SyntaxSupport;
IMPORT Token;
IMPORT SourceGraph;

(* subsystem Utilities *)
IMPORT Configuration;

(* subsystem Generator *)
IMPORT OperatorGen, BeginGen, OpaqueGen, VariantGen, EnumerationGen;
IMPORT CCallGen, CaseGen, SignatureGen, CHRGen, VALGen, AOBGen, ADRGen;

IMPORT PointerGen, UnitGen, ForGen, WithGen, ParameterGen, StringGen;

(* other stuff *)
IMPORT Text;


(** --- HandleSyntaxTree -------------------------------------------------------
  * Iterate through a syntax tree and call handling procedures if the
  * appropriate syntax kind is found.
  * ----------------------------------------------------------------------------
  **)
PROCEDURE HandleSyntaxTree (graph : SourceGraph.T;
                            anchor: SourceGraph.Anchor) =
  VAR
    iter  : SyntaxSupport.SyntaxTreeIterator;
    symbol: Symbol.T;

  <* FATAL BaseGraph.NodeNotInGraph *>

  BEGIN
    iter := NEW(SyntaxSupport.SyntaxTreeIterator).init(
              graph, graph.getRoot(anchor));

    symbol := iter.next();
    WHILE (symbol # NIL) DO
      IF (anchor.isWork()) THEN
        TransformationOnWorkUnits(graph, anchor, symbol);
      END;
      TransformationOnAllUnits(graph, anchor, symbol);
      symbol := iter.next();
    END;

    (* Make another run for AOB casting now that all embedded constructs
       are handled *)
    iter := NEW(SyntaxSupport.SyntaxTreeIterator).init(
              graph, graph.getRoot(anchor));

    symbol := iter.next();
    WHILE (symbol # NIL) DO
      IF (symbol.getKind()
            IN Symbol.KindSet{Symbol.Kind.SyntaxProcedureDeclaration,
                              Symbol.Kind.SyntaxProcedureDefinition}) THEN
        AOBGen.CastAOBs(graph, anchor, symbol);
      END;
      symbol := iter.next();
    END;
  END HandleSyntaxTree;


(** --- TransformationOnWorkUnits --------------------------------------------
  * Transformation forced in this procedure take place only in work units.
  * --------------------------------------------------------------------------
  **)
PROCEDURE TransformationOnWorkUnits (graph : SourceGraph.T;
                                     anchor: SourceGraph.Anchor;
                                     symbol: Symbol.T            ) =
  BEGIN
    CASE symbol.getKind() OF
    | Symbol.Kind.SyntaxDefinitionModule =>
        (* Replaces 'DEFINITION MODULE' by 'UNSAFE INTERFACE' *)
        UnitGen.ChangeInterface(graph, anchor, symbol);

    | Symbol.Kind.SyntaxProgramModule =>
        (*
          on implementation:
            'IMPLEMENTATION MODULE' -> 'UNSAFE MODULE'
          on program:
            'MODULE M' -> 'UNSAFE MODULE M EXPORTS Main'
        *)
        UnitGen.ChangeProgram(graph, anchor, symbol);

    | Symbol.Kind.SyntaxModuleDeclaration =>
        (* just add an 'UNSAFE' *)
        UnitGen.ChangeModule(graph, anchor, symbol);

    | Symbol.Kind.SyntaxBlockStatementsOpt =>
        (* Insert missing BEGIN statements *)
        IF (NARROW(symbol, Syntax.T).getNoOfChildren() = 0) THEN
          BeginGen.InsertBegin(graph, anchor, symbol);
        END;

    | Symbol.Kind.SyntaxExpr, Symbol.Kind.SyntaxConstExpr =>
        (* Keep the evaluation of operator precedence *)
        OperatorGen.HandleOperatorPrecedence(graph, anchor, symbol);

    | Symbol.Kind.SyntaxAssignmentOrCallStatement =>
        (* Insert missing parentheses after procedure calls *)
        ParameterGen.InsertParentheses(graph, anchor, symbol);

    | Symbol.Kind.SyntaxEnumeration =>
        (* Change parentheses to bracets in enumeration type definition *)
        EnumerationGen.ChangeParentheses(graph, anchor, symbol);

    | Symbol.Kind.For =>
        (* Change FOR-statement into WHILE-statement *)
        IF (NOT Configuration.KeepFor()) THEN
          ForGen.ChangeToWhile(graph, anchor, symbol);
        END;

    | Symbol.Kind.With => WithGen.ChangeWith(graph, anchor, symbol);

    | Symbol.Kind.StringConst =>
        (* change literal into ARRAY OF CHAR *)
        WITH token = NARROW(symbol, Token.T) DO
          IF (Token.Language.M3 IN token.getLanguages()) THEN
            StringGen.ConvertString(graph, anchor, token);
          END;
        END;

    | Symbol.Kind.SyntaxPointerType =>
        (* change 'POINTER TO T' into 'UNTRACED BRANDED REF T' *)
        PointerGen.ChangeToReference(graph, anchor, symbol);

    | Symbol.Kind.Identifier => TransformOnIdents(graph, anchor, symbol);

    | Symbol.Kind.SyntaxCaseStatement =>
        CaseGen.ModifyCase(graph, anchor, symbol);

    | Symbol.Kind.SyntaxProcedureDeclaration =>
        SignatureGen.InsertEmptyParameterList(graph, anchor, symbol);
        SignatureGen.ChangeSemicolon(graph, anchor, symbol);
        IF (Configuration.InsertReadonly()) THEN
          SignatureGen.InsertReadonly(graph, anchor, symbol);
        END;

    | Symbol.Kind.SyntaxProcedureDefinition =>
        SignatureGen.InsertEmptyParameterList(graph, anchor, symbol);
        IF (Configuration.InsertReadonly()) THEN
          SignatureGen.InsertReadonly(graph, anchor, symbol);
        END;

    | Symbol.Kind.SyntaxProcedureType =>
        SignatureGen.ExtendProcedureType(graph, anchor, symbol);

      (* --> POINT <-- *)
      (* Insert extensions running on work units above this point *)
    ELSE
      (* nothing to do, just relax *)
    END;
  END TransformationOnWorkUnits;


(** --- TransformationOnAllUnits ---------------------------------------------
  * Transformation procedures called here are forced on symbols at the
  * whole graph, not only on work units!
  * --------------------------------------------------------------------------
  **)
PROCEDURE TransformationOnAllUnits (graph : SourceGraph.T;
                                    anchor: SourceGraph.Anchor;
                                    symbol: Symbol.T            ) =
  BEGIN
    CASE symbol.getKind() OF
    | Symbol.Kind.SyntaxEnumeration =>
        (* Qualify enumeration elements by its type name *)
        EnumerationGen.QualifyEnumeration(graph, symbol);

    | Symbol.Kind.SyntaxRecordType =>
        (* handle (just flat) variant record definitions *)
        IF (VariantGen.IsVariantRecord(graph, symbol)) THEN
          VariantGen.FlatRecord(graph, anchor, symbol, anchor.isWork());
        END;

    | Symbol.Kind.SyntaxTypeOpt =>
        (* handle opaque type definition and realization *)
        IF (OpaqueGen.IsOpaqueType(symbol)) THEN
          OpaqueGen.HandleOpaqueType(graph, anchor, symbol);
        END;
      (* --> POINT <-- *)
      (* Insert extensions running on all units above this point *)
    ELSE
      (* other symbols, forcing no transformation *)
    END;
  END TransformationOnAllUnits;


(** --- TransformOnIdents --------------------------------------------------
  * Transformation forced on idents.
  *
  * Beware that every ocurrence of an ident force a handler call, so
  * handlers should work on reserved words only.
  * ------------------------------------------------------------------------
  **)
PROCEDURE TransformOnIdents (graph : SourceGraph.T;
                             anchor: SourceGraph.Anchor;
                             token : Token.T             ) =
  BEGIN
    WITH ident = token.getText() DO
      IF (Text.Equal(ident, "CCALL")) THEN
        (* handle CCALL: change import / call CCALL.x *)
        CCallGen.HandleCCall(graph, anchor, token);
      ELSIF (Text.Equal(ident, "VAL")) THEN
        VALGen.HandleVAL(graph, anchor, token);
      ELSIF (Text.Equal(ident, "CHR")) THEN
        (* handle CHR: change CHR to VAL and insert new parameter CHAR *)
        CHRGen.HandleCHR(graph, anchor, token);
      ELSIF (Text.Equal(ident, "ADR")) THEN
        ADRGen.HandleADR(graph, anchor, token);
      END;
    END;
  END TransformOnIdents;

BEGIN
END SimpleGen.
