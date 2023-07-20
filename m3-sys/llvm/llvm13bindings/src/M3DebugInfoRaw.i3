(*******************************************************************************
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 4.0.1
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
*******************************************************************************)

INTERFACE M3DebugInfoRaw;


IMPORT Ctypes AS C;




<* EXTERNAL LLVMDebugMetadataVersion *>
PROCEDURE LLVMDebugMetadataVersion (): C.unsigned_int;

<* EXTERNAL LLVMGetModuleDebugMetadataVersion *>
PROCEDURE LLVMGetModuleDebugMetadataVersion (Module: ADDRESS; ):
  C.unsigned_int;

<* EXTERNAL LLVMStripModuleDebugInfo *>
PROCEDURE LLVMStripModuleDebugInfo (Module: ADDRESS; ): BOOLEAN;

<* EXTERNAL LLVMCreateDIBuilderDisallowUnresolved *>
PROCEDURE LLVMCreateDIBuilderDisallowUnresolved (M: ADDRESS; ): ADDRESS;

<* EXTERNAL LLVMCreateDIBuilder *>
PROCEDURE LLVMCreateDIBuilder (M: ADDRESS; ): ADDRESS;

<* EXTERNAL LLVMDisposeDIBuilder *>
PROCEDURE LLVMDisposeDIBuilder (Builder: ADDRESS; );

<* EXTERNAL LLVMDIBuilderFinalize *>
PROCEDURE Finalize (Builder: ADDRESS; );

<* EXTERNAL LLVMDIBuilderCreateCompileUnit *>
PROCEDURE CreateCompileUnit
  (Builder             : ADDRESS;
   Lang                : C.int (* LLVMDWARFSourceLanguage *);
   FileRef             : ADDRESS;
   Producer            : C.char_star;
   ProducerLen         : C.unsigned_int;
   isOptimized         : BOOLEAN;
   Flags               : C.char_star;
   FlagsLen, RuntimeVer: C.unsigned_int;
   SplitName           : C.char_star;
   SplitNameLen        : C.unsigned_int;
   Kind                : C.int (* LLVMDWARFEmissionKind *);
   DWOId               : C.unsigned_int;
   SplitDebugInlining, DebugInfoForProfiling: BOOLEAN;
   SysRoot                                  : C.char_star;
   SysRootLen                               : C.unsigned_int;
   SDK                                      : C.char_star;
   SDKLen                                   : C.unsigned_int; ): ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateFile *>
PROCEDURE CreateFile (Builder     : ADDRESS;
                      Filename    : C.char_star;
                      FilenameLen : C.unsigned_int;
                      Directory   : C.char_star;
                      DirectoryLen: C.unsigned_int; ): ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateModule *>
PROCEDURE CreateModule (Builder, ParentScope: ADDRESS;
                        Name                : C.char_star;
                        NameLen             : C.unsigned_int;
                        ConfigMacros        : C.char_star;
                        ConfigMacrosLen     : C.unsigned_int;
                        IncludePath         : C.char_star;
                        IncludePathLen      : C.unsigned_int;
                        APINotesFile        : C.char_star;
                        APINotesFileLen     : C.unsigned_int; ): ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateNameSpace *>
PROCEDURE CreateNameSpace (Builder, ParentScope: ADDRESS;
                           Name                : C.char_star;
                           NameLen             : C.unsigned_int;
                           ExportSymbols       : BOOLEAN;        ):
  ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateFunction *>
PROCEDURE CreateFunction (Builder, Scope             : ADDRESS;
                          Name                       : C.char_star;
                          NameLen                    : C.unsigned_int;
                          LinkageName                : C.char_star;
                          LinkageNameLen             : C.unsigned_int;
                          File                       : ADDRESS;
                          LineNo                     : C.unsigned_int;
                          Ty                         : ADDRESS;
                          IsLocalToUnit, IsDefinition: BOOLEAN;
                          ScopeLine                  : C.unsigned_int;
                          Flags      : C.int (* LLVMDIFlags *);
                          IsOptimized: BOOLEAN;                 ): ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateLexicalBlock *>
PROCEDURE CreateLexicalBlock
  (Builder, Scope, File: ADDRESS; Line, Column: C.unsigned_int; ): ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateLexicalBlockFile *>
PROCEDURE CreateLexicalBlockFile
  (Builder, Scope, File: ADDRESS; Discriminator: C.unsigned_int; ):
  ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateImportedModuleFromNamespace *>
PROCEDURE CreateImportedModuleFromNamespace
  (Builder, Scope, NS, File: ADDRESS; Line: C.unsigned_int; ): ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateImportedModuleFromAlias *>
PROCEDURE CreateImportedModuleFromAlias
  (Builder, Scope, ImportedEntity, File: ADDRESS; Line: C.unsigned_int; ):
  ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateImportedModuleFromModule *>
PROCEDURE CreateImportedModuleFromModule
  (Builder, Scope, M, File: ADDRESS; Line: C.unsigned_int; ): ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateImportedDeclaration *>
PROCEDURE CreateImportedDeclaration (Builder, Scope, Decl, File: ADDRESS;
                                     Line   : C.unsigned_int;
                                     Name   : C.char_star;
                                     NameLen: C.unsigned_int; ): ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateDebugLocation *>
PROCEDURE CreateDebugLocation (Ctx             : ADDRESS;
                               Line, Column    : C.unsigned_int;
                               Scope, InlinedAt: ADDRESS;        ):
  ADDRESS;

<* EXTERNAL LLVMDILocationGetLine *>
PROCEDURE LLVMDILocationGetLine (Location: ADDRESS; ): C.unsigned_int;

<* EXTERNAL LLVMDILocationGetColumn *>
PROCEDURE LLVMDILocationGetColumn (Location: ADDRESS; ): C.unsigned_int;

<* EXTERNAL LLVMDILocationGetScope *>
PROCEDURE LLVMDILocationGetScope (Location: ADDRESS; ): ADDRESS;

<* EXTERNAL LLVMDILocationGetInlinedAt *>
PROCEDURE LLVMDILocationGetInlinedAt (Location: ADDRESS; ): ADDRESS;

<* EXTERNAL LLVMDIScopeGetFile *>
PROCEDURE LLVMDIScopeGetFile (Scope: ADDRESS; ): ADDRESS;

<* EXTERNAL LLVMDIFileGetDirectory *>
PROCEDURE LLVMDIFileGetDirectory
  (File: ADDRESS; VAR Len: C.unsigned_int; ): C.char_star;

<* EXTERNAL LLVMDIFileGetFilename *>
PROCEDURE LLVMDIFileGetFilename (File: ADDRESS; VAR Len: C.unsigned_int; ):
  C.char_star;

<* EXTERNAL LLVMDIFileGetSource *>
PROCEDURE LLVMDIFileGetSource (File: ADDRESS; VAR Len: C.unsigned_int; ):
  C.char_star;

<* EXTERNAL LLVMDIBuilderGetOrCreateTypeArray *>
PROCEDURE GetOrCreateTypeArray
  (Builder: ADDRESS; Data: ADDRESS; NumElements: C.unsigned_int; ):
  ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateSubroutineType *>
PROCEDURE CreateSubroutineType (Builder, File    : ADDRESS;
                                ParameterTypes   : ADDRESS;
                                NumParameterTypes: C.unsigned_int;
                                Flags: C.int (* LLVMDIFlags *); ): ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateMacro *>
PROCEDURE CreateMacro
  (Builder, ParentMacroFile: ADDRESS;
   Line                    : C.unsigned_int;
   RecordType              : C.int (* LLVMDWARFMacinfoRecordType *);
   Name                    : C.char_star;
   NameLen                 : C.unsigned_int;
   Value                   : C.char_star;
   ValueLen                : C.unsigned_int;                         ):
  ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateTempMacroFile *>
PROCEDURE CreateTempMacroFile (Builder, ParentMacroFile: ADDRESS;
                               Line                    : C.unsigned_int;
                               File                    : ADDRESS;        ):
  ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateEnumerator *>
PROCEDURE CreateEnumerator (Builder   : ADDRESS;
                            Name      : C.char_star;
                            NameLen   : C.unsigned_int;
                            Value     : C.long_long;
                            IsUnsigned: BOOLEAN;        ): ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateEnumerationType *>
PROCEDURE CreateEnumerationType (Builder, Scope: ADDRESS;
                                 Name          : C.char_star;
                                 NameLen       : C.unsigned_int;
                                 File          : ADDRESS;
                                 LineNumber    : C.unsigned_int;
                                 SizeInBits    : C.unsigned_long_long;
                                 AlignInBits   : C.unsigned_int;
                                 Elements      : ADDRESS;
                                 NumElements   : C.unsigned_int;
                                 ClassTy       : ADDRESS;              ):
  ADDRESS;

<<<<<<< HEAD
(* VVM:
<* EXTERNAL LLVMDIBuilderCreateSetType *>
PROCEDURE CreateSetType (Builder, Scope: ADDRESS;
                         Name          : C.char_star;
                         NameLen       : C.unsigned_int;
                         File          : ADDRESS;
                         LineNumber    : C.unsigned_int;
                         SizeInBits    : C.unsigned_long_long;
                         AlignInBits   : C.unsigned_int;
                         BaseTy        : ADDRESS;              ): ADDRESS;
*)

(* VVM:
<* EXTERNAL LLVMDIBuilderGetSubrangeConst *>
PROCEDURE GetSubrangeConst (Builder, Scope   : ADDRESS;
                            Name             : C.char_star;
                            NameLen          : C.unsigned_int;
                            File, BaseTy     : ADDRESS;
                            LowerBound, Count: C.long_long;    ): ADDRESS;
*)

(* VVM:
<* EXTERNAL LLVMDIBuilderGetSubrangeExpr *>
PROCEDURE GetSubrangeExpr (Builder, Scope: ADDRESS;
                           Name          : C.char_star;
                           NameLen       : C.unsigned_int;
                           File, BaseTy, LowerBound, Count: ADDRESS; ):
  ADDRESS;
*)

=======
>>>>>>> rodney-new
<* EXTERNAL LLVMDIBuilderCreateUnionType *>
PROCEDURE CreateUnionType (Builder, Scope: ADDRESS;
                           Name          : C.char_star;
                           NameLen       : C.unsigned_int;
                           File          : ADDRESS;
                           LineNumber    : C.unsigned_int;
                           SizeInBits    : C.unsigned_long_long;
                           AlignInBits   : C.unsigned_int;
                           Flags         : C.int (* LLVMDIFlags *);
                           Elements      : ADDRESS;
                           NumElements, RunTimeLang: C.unsigned_int;
                           UniqueId                : C.char_star;
                           UniqueIdLen             : C.unsigned_int; ):
  ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateArrayType *>
PROCEDURE CreateArrayType (Builder      : ADDRESS;
                           Size         : C.unsigned_long_long;
                           AlignInBits  : C.unsigned_int;
                           Ty           : ADDRESS;
                           Subscripts   : ADDRESS;
                           NumSubscripts: C.unsigned_int;       ): ADDRESS;

<<<<<<< HEAD
(* VVM:
<* EXTERNAL LLVMDIBuilderCreateDynamicArrayType *>
PROCEDURE CreateDynamicArrayType
  (Builder                                  : ADDRESS;
   Size                                     : C.unsigned_long_long;
   AlignInBits                              : C.unsigned_int;
   Ty                                       : ADDRESS;
   Subscripts                               : ADDRESS;
   NumSubscripts                            : C.unsigned_int;
   DataLocation, Associated, Allocated, Rank: ADDRESS;              ):
  ADDRESS;
*)
 
=======
>>>>>>> rodney-new
<* EXTERNAL LLVMDIBuilderCreateVectorType *>
PROCEDURE CreateVectorType (Builder      : ADDRESS;
                            Size         : C.unsigned_long_long;
                            AlignInBits  : C.unsigned_int;
                            Ty           : ADDRESS;
                            Subscripts   : ADDRESS;
                            NumSubscripts: C.unsigned_int;       ):
  ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateUnspecifiedType *>
PROCEDURE CreateUnspecifiedType
  (Builder: ADDRESS; Name: C.char_star; NameLen: C.unsigned_int; ):
  ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateBasicType *>
PROCEDURE CreateBasicType (Builder   : ADDRESS;
                           Name      : C.char_star;
                           NameLen   : C.unsigned_int;
                           SizeInBits: C.unsigned_long_long;
                           Encoding  : C.unsigned_int;
                           Flags     : C.int (* LLVMDIFlags *); ): ADDRESS;

<* EXTERNAL LLVMDIBuilderCreatePointerType *>
PROCEDURE CreatePointerType (Builder, PointeeTy: ADDRESS;
                             SizeInBits        : C.unsigned_long_long;
                             AlignInBits, AddressSpace: C.unsigned_int;
                             Name                     : C.char_star;
                             NameLen                  : C.unsigned_int; ):
  ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateStructType *>
PROCEDURE CreateStructType (Builder, Scope: ADDRESS;
                            Name          : C.char_star;
                            NameLen       : C.unsigned_int;
                            File          : ADDRESS;
                            LineNumber    : C.unsigned_int;
                            SizeInBits    : C.unsigned_long_long;
                            AlignInBits   : C.unsigned_int;
                            Flags         : C.int (* LLVMDIFlags *);
                            DerivedFrom   : ADDRESS;
                            Elements      : ADDRESS;
                            NumElements, RunTimeLang: C.unsigned_int;
                            VTableHolder            : ADDRESS;
                            UniqueId                : C.char_star;
                            UniqueIdLen             : C.unsigned_int; ):
  ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateMemberType *>
PROCEDURE CreateMemberType (Builder, Scope: ADDRESS;
                            Name          : C.char_star;
                            NameLen       : C.unsigned_int;
                            File          : ADDRESS;
                            LineNo        : C.unsigned_int;
                            SizeInBits    : C.unsigned_long_long;
                            AlignInBits   : C.unsigned_int;
                            OffsetInBits  : C.unsigned_long_long;
                            Flags         : C.int (* LLVMDIFlags *);
                            Ty            : ADDRESS;                 ):
  ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateStaticMemberType *>
PROCEDURE CreateStaticMemberType
  (Builder, Scope: ADDRESS;
   Name          : C.char_star;
   NameLen       : C.unsigned_int;
   File          : ADDRESS;
   LineNumber    : C.unsigned_int;
   Type          : ADDRESS;
   Flags         : C.int (* LLVMDIFlags *);
   ConstantVal   : ADDRESS;
   AlignInBits   : C.unsigned_int;          ): ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateMemberPointerType *>
PROCEDURE CreateMemberPointerType
  (Builder, PointeeType, ClassType: ADDRESS;
   SizeInBits                     : C.unsigned_long_long;
   AlignInBits                    : C.unsigned_int;
   Flags                          : C.int (* LLVMDIFlags *); ): ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateObjCIVar *>
PROCEDURE CreateObjCIVar (Builder         : ADDRESS;
                          Name            : C.char_star;
                          NameLen         : C.unsigned_int;
                          File            : ADDRESS;
                          LineNo          : C.unsigned_int;
                          SizeInBits      : C.unsigned_long_long;
                          AlignInBits     : C.unsigned_int;
                          OffsetInBits    : C.unsigned_long_long;
                          Flags           : C.int (* LLVMDIFlags *);
                          Ty, PropertyNode: ADDRESS;                 ):
  ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateObjCProperty *>
PROCEDURE CreateObjCProperty
  (Builder                          : ADDRESS;
   Name                             : C.char_star;
   NameLen                          : C.unsigned_int;
   File                             : ADDRESS;
   LineNo                           : C.unsigned_int;
   GetterName                       : C.char_star;
   GetterNameLen                    : C.unsigned_int;
   SetterName                       : C.char_star;
   SetterNameLen, PropertyAttributes: C.unsigned_int;
   Ty                               : ADDRESS;        ): ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateObjectPointerType *>
PROCEDURE CreateObjectPointerType (Builder, Type: ADDRESS; ): ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateQualifiedType *>
PROCEDURE CreateQualifiedType
  (Builder: ADDRESS; Tag: C.unsigned_int; Type: ADDRESS; ): ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateReferenceType *>
PROCEDURE CreateReferenceType
  (Builder: ADDRESS; Tag: C.unsigned_int; Type: ADDRESS; ): ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateNullPtrType *>
PROCEDURE CreateNullPtrType (Builder: ADDRESS; ): ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateTypedef *>
PROCEDURE CreateTypedef (Builder, Type: ADDRESS;
                         Name         : C.char_star;
                         NameLen      : C.unsigned_int;
                         File         : ADDRESS;
                         LineNo       : C.unsigned_int;
                         Scope        : ADDRESS;
                         AlignInBits  : C.unsigned_int; ): ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateInheritance *>
PROCEDURE CreateInheritance
  (Builder, Ty, BaseTy: ADDRESS;
   BaseOffset         : C.unsigned_long_long;
   VBPtrOffset        : C.unsigned_int;
   Flags              : C.int (* LLVMDIFlags *); ): ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateForwardDecl *>
PROCEDURE CreateForwardDecl (Builder            : ADDRESS;
                             Tag                : C.unsigned_int;
                             Name               : C.char_star;
                             NameLen            : C.unsigned_int;
                             Scope, File        : ADDRESS;
                             Line, RuntimeLang  : C.unsigned_int;
                             SizeInBits         : C.unsigned_long_long;
                             AlignInBits        : C.unsigned_int;
                             UniqueIdentifier   : C.char_star;
                             UniqueIdentifierLen: C.unsigned_int;       ):
  ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateReplaceableCompositeType *>
PROCEDURE CreateReplaceableCompositeType
  (Builder            : ADDRESS;
   Tag                : C.unsigned_int;
   Name               : C.char_star;
   NameLen            : C.unsigned_int;
   Scope, File        : ADDRESS;
   Line, RuntimeLang  : C.unsigned_int;
   SizeInBits         : C.unsigned_long_long;
   AlignInBits        : C.unsigned_int;
   Flags              : C.int (* LLVMDIFlags *);
   UniqueIdentifier   : C.char_star;
   UniqueIdentifierLen: C.unsigned_int;          ): ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateBitFieldMemberType *>
PROCEDURE CreateBitFieldMemberType
  (Builder, Scope                               : ADDRESS;
   Name                                         : C.char_star;
   NameLen                                      : C.unsigned_int;
   File                                         : ADDRESS;
   LineNumber                                   : C.unsigned_int;
   SizeInBits, OffsetInBits, StorageOffsetInBits: C.unsigned_long_long;
   Flags                                        : C.int (* LLVMDIFlags *);
   Type                                         : ADDRESS;                 ):
  ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateClassType *>
PROCEDURE CreateClassType (Builder, Scope: ADDRESS;
                           Name          : C.char_star;
                           NameLen       : C.unsigned_int;
                           File          : ADDRESS;
                           LineNumber    : C.unsigned_int;
                           SizeInBits    : C.unsigned_long_long;
                           AlignInBits   : C.unsigned_int;
                           OffsetInBits  : C.unsigned_long_long;
                           Flags         : C.int (* LLVMDIFlags *);
                           DerivedFrom   : ADDRESS;
                           Elements      : ADDRESS;
                           NumElements   : C.unsigned_int;
                           VTableHolder, TemplateParamsNode: ADDRESS;
                           UniqueIdentifier                : C.char_star;
                           UniqueIdentifierLen: C.unsigned_int; ): ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateArtificialType *>
PROCEDURE CreateArtificialType (Builder, Type: ADDRESS; ): ADDRESS;

<* EXTERNAL LLVMDITypeGetName *>
PROCEDURE LLVMDITypeGetName (DType: ADDRESS; VAR Length: C.unsigned_int; ):
  C.char_star;

<* EXTERNAL LLVMDITypeGetSizeInBits *>
PROCEDURE LLVMDITypeGetSizeInBits (DType: ADDRESS; ): C.unsigned_long_long;

<* EXTERNAL LLVMDITypeGetOffsetInBits *>
PROCEDURE LLVMDITypeGetOffsetInBits (DType: ADDRESS; ):
  C.unsigned_long_long;

<* EXTERNAL LLVMDITypeGetAlignInBits *>
PROCEDURE LLVMDITypeGetAlignInBits (DType: ADDRESS; ): C.unsigned_int;

<* EXTERNAL LLVMDITypeGetLine *>
PROCEDURE LLVMDITypeGetLine (DType: ADDRESS; ): C.unsigned_int;

<* EXTERNAL LLVMDITypeGetFlags *>
PROCEDURE LLVMDITypeGetFlags (DType: ADDRESS; ): C.int;

<* EXTERNAL LLVMDIBuilderGetOrCreateSubrange *>
PROCEDURE GetOrCreateSubrange
  (Builder: ADDRESS; LowerBound, Count: C.long_long; ): ADDRESS;

<* EXTERNAL LLVMDIBuilderGetOrCreateArray *>
PROCEDURE GetOrCreateArray
  (Builder: ADDRESS; Data: ADDRESS; NumElements: C.unsigned_int; ):
  ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateExpression *>
PROCEDURE CreateExpression (Builder: ADDRESS;
                            Addr   : UNTRACED REF C.long_long;
                            Length : C.unsigned_int;           ): ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateConstantValueExpression *>
PROCEDURE CreateConstantValueExpression
  (Builder: ADDRESS; Value: C.long_long; ): ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateGlobalVariableExpression *>
PROCEDURE CreateGlobalVariableExpression
  (Builder, Scope: ADDRESS;
   Name          : C.char_star;
   NameLen       : C.unsigned_int;
   Linkage       : C.char_star;
   LinkLen       : C.unsigned_int;
   File          : ADDRESS;
   LineNo        : C.unsigned_int;
   Ty            : ADDRESS;
   LocalToUnit   : BOOLEAN;
   Expr, Decl    : ADDRESS;
   AlignInBits   : C.unsigned_int; ): ADDRESS;

<* EXTERNAL LLVMDIGlobalVariableExpressionGetVariable *>
PROCEDURE LLVMDIGlobalVariableExpressionGetVariable (GVE: ADDRESS; ):
  ADDRESS;

<* EXTERNAL LLVMDIGlobalVariableExpressionGetExpression *>
PROCEDURE LLVMDIGlobalVariableExpressionGetExpression (GVE: ADDRESS; ):
  ADDRESS;

<* EXTERNAL LLVMDIVariableGetFile *>
PROCEDURE LLVMDIVariableGetFile (Var: ADDRESS; ): ADDRESS;

<* EXTERNAL LLVMDIVariableGetScope *>
PROCEDURE LLVMDIVariableGetScope (Var: ADDRESS; ): ADDRESS;

<* EXTERNAL LLVMDIVariableGetLine *>
PROCEDURE LLVMDIVariableGetLine (Var: ADDRESS; ): C.unsigned_int;

<* EXTERNAL LLVMTemporaryMDNode *>
PROCEDURE LLVMTemporaryMDNode
  (Ctx: ADDRESS; Data: ADDRESS; NumElements: C.unsigned_int; ): ADDRESS;

<* EXTERNAL LLVMDisposeTemporaryMDNode *>
PROCEDURE LLVMDisposeTemporaryMDNode (TempNode: ADDRESS; );

<* EXTERNAL LLVMMetadataReplaceAllUsesWith *>
PROCEDURE LLVMMetadataReplaceAllUsesWith
  (TempTargetMetadata, Replacement: ADDRESS; );

<* EXTERNAL LLVMDIBuilderCreateTempGlobalVariableFwdDecl *>
PROCEDURE CreateTempGlobalVariableFwdDecl
  (Builder, Scope: ADDRESS;
   Name          : C.char_star;
   NameLen       : C.unsigned_int;
   Linkage       : C.char_star;
   LnkLen        : C.unsigned_int;
   File          : ADDRESS;
   LineNo        : C.unsigned_int;
   Ty            : ADDRESS;
   LocalToUnit   : BOOLEAN;
   Decl          : ADDRESS;
   AlignInBits   : C.unsigned_int; ): ADDRESS;

<* EXTERNAL LLVMDIBuilderInsertDeclareBefore *>
PROCEDURE InsertDeclareBefore
  (Builder, Storage, VarInfo, Expr, DebugLoc, Instr: ADDRESS; ): ADDRESS;

<* EXTERNAL LLVMDIBuilderInsertDeclareAtEnd *>
PROCEDURE InsertDeclareAtEnd
  (Builder, Storage, VarInfo, Expr, DebugLoc, Block: ADDRESS; ): ADDRESS;

<* EXTERNAL LLVMDIBuilderInsertDbgValueBefore *>
PROCEDURE InsertDbgValueBefore
  (Builder, Val, VarInfo, Expr, DebugLoc, Instr: ADDRESS; ): ADDRESS;

<* EXTERNAL LLVMDIBuilderInsertDbgValueAtEnd *>
PROCEDURE InsertDbgValueAtEnd
  (Builder, Val, VarInfo, Expr, DebugLoc, Block: ADDRESS; ): ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateAutoVariable *>
PROCEDURE CreateAutoVariable (Builder, Scope: ADDRESS;
                              Name          : C.char_star;
                              NameLen       : C.unsigned_int;
                              File          : ADDRESS;
                              LineNo        : C.unsigned_int;
                              Ty            : ADDRESS;
                              AlwaysPreserve: BOOLEAN;
                              Flags         : C.int (* LLVMDIFlags *);
                              AlignInBits   : C.unsigned_int;          ):
  ADDRESS;

<* EXTERNAL LLVMDIBuilderCreateParameterVariable *>
PROCEDURE CreateParameterVariable (Builder, Scope: ADDRESS;
                                   Name          : C.char_star;
                                   NameLen, ArgNo: C.unsigned_int;
                                   File          : ADDRESS;
                                   LineNo        : C.unsigned_int;
                                   Ty            : ADDRESS;
                                   AlwaysPreserve: BOOLEAN;
                                   Flags: C.int (* LLVMDIFlags *); ):
  ADDRESS;

<* EXTERNAL LLVMGetSubprogram *>
PROCEDURE LLVMGetSubprogram (Func: ADDRESS; ): ADDRESS;

<* EXTERNAL LLVMSetSubprogram *>
PROCEDURE LLVMSetSubprogram (Func, SP: ADDRESS; );

<* EXTERNAL LLVMDISubprogramGetLine *>
PROCEDURE LLVMDISubprogramGetLine (Subprogram: ADDRESS; ): C.unsigned_int;

<* EXTERNAL LLVMInstructionGetDebugLoc *>
PROCEDURE LLVMInstructionGetDebugLoc (Inst: ADDRESS; ): ADDRESS;

<* EXTERNAL LLVMInstructionSetDebugLoc *>
PROCEDURE LLVMInstructionSetDebugLoc (Inst, Loc: ADDRESS; );

<* EXTERNAL LLVMGetMetadataKind *>
PROCEDURE LLVMGetMetadataKind (Metadata: ADDRESS; ): C.unsigned_int;

<<<<<<< HEAD
(* VVM:
<* EXTERNAL LLVMReplaceArrays *>
PROCEDURE LLVMReplaceArrays
  (Builder: ADDRESS; T, Elements: ADDRESS; NumElements: C.unsigned_int; );
*)

=======
>>>>>>> rodney-new
END M3DebugInfoRaw.
