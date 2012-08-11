MODULE RegExpLexStd;
(* generated by kext *)
IMPORT RegExpLex;
IMPORT Rd;
IMPORT Interval;
IMPORT NFA;
IMPORT Scan;
IMPORT Text;
IMPORT CharRange;
IMPORT CharCodes;
IMPORT FloatMode, Lex;
<* FATAL FloatMode.Trap, Lex.Error *>

PROCEDURE ParseInterval(t: TEXT): Interval.T =
  VAR
    inter: TEXT := CharCodes.StripDelims(t);
    pos := Text.FindChar(inter, ',');
    loStr,hiStr: TEXT;
  PROCEDURE GetInt(str: TEXT; default: INTEGER): INTEGER =
    BEGIN
      IF Text.Length(str) = 0 THEN
        RETURN default;
      ELSE
        RETURN Scan.Int(str);
      END;
    END GetInt;
  BEGIN
    IF pos = -1 THEN
      loStr := inter;
      hiStr := inter;
    ELSE
      loStr := Text.Sub(inter, 0, pos);
      hiStr := Text.Sub(inter, pos+1, LAST(INTEGER));
    END;
(*    Term.WrLn("lo = " & loStr & ", hi = " & hiStr); *)
    RETURN Interval.T{GetInt(loStr,0), GetInt(hiStr,NFA.OrMore)};
  END ParseInterval;

REVEAL
  T = Public BRANDED "RegExpLexStd" OBJECT
    allocate_CHAR_RANGE: Allocator := NIL;
    allocate_COUNT: Allocator := NIL;
    allocate_STRING: Allocator := NIL;
    allocate_IDENTIFIER: Allocator := NIL;
  OVERRIDES
    init := Init;
    purge := Proc_Purge;
    COUNT := Proc_COUNT;
    STRING := Proc_STRING;
    brac_CHAR_RANGE := Proc_brac_CHAR_RANGE;
    dot_CHAR_RANGE := Proc_dot_CHAR_RANGE;
    IDENTIFIER := Proc_IDENTIFIER;
  END;


PROCEDURE Init(self: T; rd: Rd.T): RdLexer =
  BEGIN
    EVAL RegExpLex.T.init(self, rd);
    RETURN self;
  END Init;

PROCEDURE Proc_Purge(self: T): INTEGER =
  BEGIN
    RETURN RegExpLex.T.purge(self)
      + Purge(self.allocate_CHAR_RANGE)
      + Purge(self.allocate_COUNT)
      + Purge(self.allocate_STRING)
      + Purge(self.allocate_IDENTIFIER);
  END Proc_Purge;

(* expression procedures *)
PROCEDURE Proc_COUNT(self: T): Token =
  BEGIN (* user code *)
   VAR result:COUNT:=NewPT(self.allocate_COUNT,TYPECODE(COUNT));BEGIN BEGIN
    result.val := ParseInterval(self.getText())
   END;RETURN result;END
  END Proc_COUNT;

PROCEDURE Proc_IDENTIFIER(self: T): Token =
  BEGIN (* user code *)
   VAR result:IDENTIFIER:=NewPT(self.allocate_IDENTIFIER,TYPECODE(IDENTIFIER));BEGIN BEGIN
    result.val := self.getText()
   END;RETURN result;END
  END Proc_IDENTIFIER;

PROCEDURE Proc_brac_CHAR_RANGE(self: T): Token =
  BEGIN (* user code *)
   VAR result:CHAR_RANGE:=NewPT(self.allocate_CHAR_RANGE,TYPECODE(CHAR_RANGE));BEGIN BEGIN
    result.val := CharRange.FromText(self.getText())
   END;RETURN result;END
  END Proc_brac_CHAR_RANGE;

PROCEDURE Proc_dot_CHAR_RANGE(self: T): Token =
  BEGIN (* user code *)
   VAR result:CHAR_RANGE:=NewPT(self.allocate_CHAR_RANGE,TYPECODE(CHAR_RANGE));BEGIN BEGIN
    result.val := CharRange.AllExceptNewline
   END;RETURN result;END
  END Proc_dot_CHAR_RANGE;

PROCEDURE Proc_STRING(self: T): Token =
  BEGIN (* user code *)
   VAR result:STRING:=NewPT(self.allocate_STRING,TYPECODE(STRING));BEGIN BEGIN
    result.val := CharCodes.ParseString(self.getText())
   END;RETURN result;END
  END Proc_STRING;

BEGIN
END RegExpLexStd.