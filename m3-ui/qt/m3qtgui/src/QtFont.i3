(*******************************************************************************
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 2.0.4
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
*******************************************************************************)

INTERFACE QtFont;

FROM QtStringList IMPORT QStringList;
FROM QGuiStubs IMPORT QPaintDevice;


TYPE T = QFont;


CONST                            (* Enum StyleHint *)
  Helvetica  = 0;
  SansSerif  = 0;
  Times      = 1;
  Serif      = 1;
  Courier    = 2;
  TypeWriter = 2;
  OldEnglish = 3;
  Decorative = 3;
  System     = 4;
  AnyStyle   = 5;
  Cursive    = 6;
  Monospace  = 7;
  Fantasy    = 8;

TYPE                             (* Enum StyleHint *)
  StyleHint = [0 .. 8];

CONST                            (* Enum StyleStrategy *)
  PreferDefault       = 1;
  PreferBitmap        = 2;
  PreferDevice        = 4;
  PreferOutline       = 8;
  ForceOutline        = 16;
  PreferMatch         = 32;
  PreferQuality       = 64;
  PreferAntialias     = 128;
  NoAntialias         = 256;
  OpenGLCompatible    = 512;
  ForceIntegerMetrics = 1024;
  NoFontMerging       = 32768;

TYPE                             (* Enum StyleStrategy *)
  StyleStrategy = [1 .. 32768];

CONST                            (* Enum HintingPreference *)
  PreferDefaultHinting  = 0;
  PreferNoHinting       = 1;
  PreferVerticalHinting = 2;
  PreferFullHinting     = 3;

TYPE                             (* Enum HintingPreference *)
  HintingPreference = [0 .. 3];

CONST                            (* Enum Weight *)
  Light    = 25;
  Normal   = 50;
  DemiBold = 63;
  Bold     = 75;
  Black    = 87;

TYPE                             (* Enum Weight *)
  Weight = [25 .. 87];

TYPE                             (* Enum Style *)
  Style = {StyleNormal, StyleItalic, StyleOblique};

CONST                            (* Enum Stretch *)
  UltraCondensed = 50;
  ExtraCondensed = 62;
  Condensed      = 75;
  SemiCondensed  = 87;
  Unstretched    = 100;
  SemiExpanded   = 112;
  Expanded       = 125;
  ExtraExpanded  = 150;
  UltraExpanded  = 200;

TYPE                             (* Enum Stretch *)
  Stretch = [50 .. 200];

TYPE                             (* Enum Capitalization *)
  Capitalization =
    {MixedCase, AllUppercase, AllLowercase, SmallCaps, Capitalize};

TYPE                             (* Enum SpacingType *)
  SpacingType = {PercentageSpacing, AbsoluteSpacing};

CONST                            (* Enum ResolveProperties *)
  FamilyResolved            = 1;
  SizeResolved              = 2;
  StyleHintResolved         = 4;
  StyleStrategyResolved     = 8;
  WeightResolved            = 16;
  StyleResolved             = 32;
  UnderlineResolved         = 64;
  OverlineResolved          = 128;
  StrikeOutResolved         = 256;
  FixedPitchResolved        = 512;
  StretchResolved           = 1024;
  KerningResolved           = 2048;
  CapitalizationResolved    = 4096;
  LetterSpacingResolved     = 8192;
  WordSpacingResolved       = 16384;
  HintingPreferenceResolved = 32768;
  StyleNameResolved         = 65536;
  AllPropertiesResolved     = 131071;

TYPE                             (* Enum ResolveProperties *)
  ResolveProperties = [1 .. 131071];
PROCEDURE Substitute (arg1: TEXT; ): TEXT;

PROCEDURE Substitutes (arg1: TEXT; ): QStringList;

PROCEDURE Substitutions (): QStringList;

PROCEDURE InsertSubstitution (arg1, arg2: TEXT; );

PROCEDURE InsertSubstitutions (arg1: TEXT; arg2: QStringList; );

PROCEDURE RemoveSubstitution (arg1: TEXT; );

PROCEDURE Initialize ();

PROCEDURE Cleanup ();

PROCEDURE CacheStatistics ();


TYPE
  QFont <: QFontPublic;
  QFontPublic =
    BRANDED OBJECT
      cxxObj: ADDRESS;
    METHODS
      init_0 (): QFont;
      init_1 (family: TEXT; pointSize, weight: INTEGER; italic: BOOLEAN; ):
              QFont;
      init_2           (family: TEXT; pointSize, weight: INTEGER; ): QFont;
      init_3           (family: TEXT; pointSize: INTEGER; ): QFont;
      init_4           (family: TEXT; ): QFont;
      init_5           (arg1: QFont; pd: QPaintDevice; ): QFont;
      init_6           (arg1: QFont; ): QFont;
      family           (): TEXT;
      setFamily        (arg1: TEXT; );
      styleName        (): TEXT;
      setStyleName     (arg1: TEXT; );
      pointSize        (): INTEGER;
      setPointSize     (arg1: INTEGER; );
      pointSizeF       (): LONGREAL;
      setPointSizeF    (arg1: LONGREAL; );
      pixelSize        (): INTEGER;
      setPixelSize     (arg1: INTEGER; );
      weight           (): INTEGER;
      setWeight        (arg1: INTEGER; );
      bold             (): BOOLEAN;
      setBold          (arg1: BOOLEAN; );
      setStyle         (style: Style; );
      style            (): Style;
      italic           (): BOOLEAN;
      setItalic        (b: BOOLEAN; );
      underline        (): BOOLEAN;
      setUnderline     (arg1: BOOLEAN; );
      overline         (): BOOLEAN;
      setOverline      (arg1: BOOLEAN; );
      strikeOut        (): BOOLEAN;
      setStrikeOut     (arg1: BOOLEAN; );
      fixedPitch       (): BOOLEAN;
      setFixedPitch    (arg1: BOOLEAN; );
      kerning          (): BOOLEAN;
      setKerning       (arg1: BOOLEAN; );
      styleHint        (): StyleHint;
      styleStrategy    (): StyleStrategy;
      setStyleHint     (arg1: StyleHint; arg2: StyleStrategy; );
      setStyleHint1    (arg1: StyleHint; );
      setStyleStrategy (s: StyleStrategy; );
      stretch          (): INTEGER;
      setStretch       (arg1: INTEGER; );
      letterSpacing    (): LONGREAL;
      letterSpacingType    (): SpacingType;
      setLetterSpacing     (type: SpacingType; spacing: LONGREAL; );
      wordSpacing          (): LONGREAL;
      setWordSpacing       (spacing: LONGREAL; );
      setCapitalization    (arg1: Capitalization; );
      capitalization       (): Capitalization;
      setHintingPreference (hintingPreference: HintingPreference; );
      hintingPreference    (): HintingPreference;
      rawMode              (): BOOLEAN;
      setRawMode           (arg1: BOOLEAN; );
      exactMatch           (): BOOLEAN;
      Op_Assign            (arg1: QFont; ): QFont;
      Op_Equals            (arg1: QFont; ): BOOLEAN;
      Op_NotEquals         (arg1: QFont; ): BOOLEAN;
      Op_LessThan          (arg1: QFont; ): BOOLEAN;
      isCopyOf             (arg1: QFont; ): BOOLEAN;
      setRawName           (arg1: TEXT; );
      rawName              (): TEXT;
      key                  (): TEXT;
      toString             (): TEXT;
      fromString           (arg1: TEXT; ): BOOLEAN;
      defaultFamily        (): TEXT;
      lastResortFamily     (): TEXT;
      lastResortFont       (): TEXT;
      resolve              (arg1: QFont; ): QFont;
      resolve1             (): CARDINAL;
      resolve2             (mask: CARDINAL; );
      destroyCxx           ();
    END;


END QtFont.
