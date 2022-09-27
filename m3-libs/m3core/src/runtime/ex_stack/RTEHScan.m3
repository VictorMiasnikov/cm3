UNSAFE MODULE RTEHScan;

(* Scan the gcc except table embedded in the code stream to find
   an exception handling address and match the exception type uid. *)

IMPORT RTStack,RTError,RTIO,RTParams,Word;

CONST
  DW_EH_PE_absptr   = 16_00;
  DW_EH_PE_uleb128  = 16_01;
  DW_EH_PE_udata2   = 16_02;
  DW_EH_PE_udata4   = 16_03;
  DW_EH_PE_udata8   = 16_04;
  DW_EH_PE_sleb128  = 16_09;
  DW_EH_PE_sdata2   = 16_0A;
  DW_EH_PE_sdata4   = 16_0B;
  DW_EH_PE_sdata8   = 16_0C;
  DW_EH_PE_pcrel    = 16_10;
  DW_EH_PE_textrel  = 16_20;
  DW_EH_PE_datarel  = 16_30;
  DW_EH_PE_funcrel  = 16_40;
  DW_EH_PE_aligned  = 16_50;
  DW_EH_PE_indirect = 16_80;
  DW_EH_PE_omit     = 16_FF;

TYPE
  Byte = [0..255];
  EncType = Byte;
  RefByte = UNTRACED REF Byte;

VAR
  DEBUG := FALSE;

PROCEDURE ReadMiscPtr(VAR data : RefByte; len : INTEGER) : INTEGER =
  VAR
    res,shift,t : Word.T := 0;
    p : RefByte;
    b : Byte;
  BEGIN
    p := data;
    FOR i := 0 TO len - 1 DO
      b := p^;
      INC(p);
      t := Word.LeftShift(Word.And(b, 16_FF), shift);
      res := Word.Or(res, t);
      INC(shift,8);
    END;
    data := p;
    RETURN res;
  END ReadMiscPtr;

PROCEDURE ReadULEB(VAR data : RefByte) : Word.T =
  VAR
    res,shift,t : Word.T := 0;
    b : Byte;
    p : RefByte;
  BEGIN
    p := data;
    REPEAT
      b := p^;
      INC(p);
      t := Word.LeftShift(Word.And(b, 16_7F), shift);
      res := Word.Or(res, t);
      INC(shift,7);
    UNTIL Word.And(b,16_80) = 0;
    data := p;
    RETURN res;
  END ReadULEB;

PROCEDURE ReadSLEB(VAR data : RefByte) : INTEGER =
  VAR
    res,shift,t : INTEGER := 0;
    p : RefByte;
    b : Byte;
  BEGIN
    p := data;
    REPEAT
      b := p^;
      INC(p);
      t := Word.LeftShift(Word.And(b, 16_7F), shift);
      res := Word.Or(res, t);
      INC(shift,7);
    UNTIL Word.And(b,16_80) = 0;
    data := p;
    IF Word.And(b, 16_40) > 0 AND shift < BITSIZE(res) THEN
      t := Word.LeftShift(Word.Not(0), shift);
      res := Word.Or(res, t);
    END;
    RETURN res;
  END ReadSLEB;

PROCEDURE ReadEncodedPointer(VAR data : RefByte; encoding : EncType; base : INTEGER := 0) : ADDRESS =
  VAR
    res : INTEGER;
    ret : ADDRESS;
    enc : EncType;
    p : RefByte;
  BEGIN
    p := data;
    IF encoding = DW_EH_PE_omit THEN
      RETURN NIL;
    END;
    (* first get a value *)
    enc := Word.And(encoding,16_0F);
    CASE enc OF
    | DW_EH_PE_absptr => res := ReadMiscPtr(p,BYTESIZE(INTEGER));
    | DW_EH_PE_uleb128 => res := ReadULEB(p);
    | DW_EH_PE_sleb128 => res := ReadSLEB(p);
    | DW_EH_PE_udata2 => res := ReadMiscPtr(p,2);
    | DW_EH_PE_udata4 => res := ReadMiscPtr(p,4);
    | DW_EH_PE_udata8 => res := ReadMiscPtr(p,8);
    | DW_EH_PE_sdata2 => res := ReadMiscPtr(p,2);
    | DW_EH_PE_sdata4 => res := ReadMiscPtr(p,4);
    | DW_EH_PE_sdata8 => res := ReadMiscPtr(p,8);
    ELSE
      RTError.Msg(NIL,0,"eh table type not supported");
    END;

    (* then add relative offset *)
    enc := Word.And(encoding,16_70);
    CASE enc OF
    | DW_EH_PE_absptr => (* nothing *)
    | DW_EH_PE_pcrel =>
       IF res > 0 THEN
         INC(res, LOOPHOLE(data,INTEGER));
       END;
    | DW_EH_PE_datarel =>
       <*ASSERT base # 0 *>
       IF res > 0 THEN
         INC(res,base);
       END;
    | DW_EH_PE_textrel, DW_EH_PE_funcrel, DW_EH_PE_aligned =>
    ELSE
      RTError.Msg(NIL,0,"eh table encoding not supported");
    END;

    (* then apply indirection *)
    enc := Word.And(encoding,16_80);
    IF res > 0 AND enc = DW_EH_PE_indirect THEN
      res := LOOPHOLE(res,REF INTEGER)^;
    END;
    data := p;
    ret := LOOPHOLE(res,ADDRESS);
    RETURN ret;
  END ReadEncodedPointer;

PROCEDURE GetTypeInfo(tTypeIndex : INTEGER;
                      typeInfo : RefByte;
                      tTypeEncoding : Byte) : ADDRESS =
  VAR
    enc : EncType;
    res : ADDRESS;
  BEGIN
    IF typeInfo = NIL THEN
      RTError.Msg(NIL,0,"eh table type info nil");
    END;

    enc := Word.And(tTypeEncoding,16_0F);
    CASE enc OF
    | DW_EH_PE_absptr =>
         tTypeIndex := tTypeIndex * BYTESIZE(ADDRESS);
    | DW_EH_PE_sdata2, DW_EH_PE_udata2 =>
         tTypeIndex := tTypeIndex * 2;
    | DW_EH_PE_sdata4, DW_EH_PE_udata4 =>
         tTypeIndex := tTypeIndex * 4;
    | DW_EH_PE_sdata8, DW_EH_PE_udata8 =>
         tTypeIndex := tTypeIndex * 8;
    ELSE
      RTError.Msg(NIL,0,"eh table error bad type info");
    END;

    DEC(typeInfo, tTypeIndex);
    res := ReadEncodedPointer(typeInfo, tTypeEncoding);
    RETURN res;
  END GetTypeInfo;

PROCEDURE ScanEHTable(VAR f : RTStack.Frame; excUid : INTEGER) : BOOLEAN =
  VAR
    callSiteTableLength, typeInfoOffset, actionEntry, length : INTEGER;
    lpStartEncoding,tTypeEncoding,callSiteEncoding : Byte;
    ip,funcStart,lpStart,ipOfs : ADDRESS;
    callSiteTableStart,callSiteTableEnd,actionTableStart : ADDRESS;
    start,end,lenPtr,landingPad : ADDRESS;
    lsda,callSitePtr,typeInfo : RefByte;
    base : INTEGER := 0;
    (* At one stage I thought the front end could pass scope kind in the
       type info of the exception table. It would be the left 32 bit int
       of a 64 bit value, the right hand containing the exception uid.
       The only use I could think that it could be usefule if it was RAISES
       to detect exception not found cases. But we dont get a uid in
       that case to pass it. So irrelevant. If ever we did find it useful
       this value would be a field in the frame passed in.
       scopeKind : INTEGER;
    *)

PROCEDURE ScanEHActions() : BOOLEAN =
  VAR
    actionRecord,catchType : ADDRESS;
    tTypeIndex,actionOffset,infoUid : INTEGER;
    action,temp : RefByte;
    info : REF INTEGER;
  BEGIN
    action := actionTableStart + (actionEntry - 1); 
    (* scan action entries until find a matching handler or end of list *)

    IF DEBUG THEN
      RTIO.PutText("excuid "); RTIO.PutInt(excUid); RTIO.PutText("\n");
      RTIO.PutText("actionentry "); RTIO.PutInt(actionEntry); RTIO.PutText("\n");
      RTIO.Flush();
    END;

    LOOP
      actionRecord := action;
      tTypeIndex := ReadSLEB(action);
      f.tTypeIndex := tTypeIndex;

      IF DEBUG THEN
        RTIO.PutText("tTypeIndex "); RTIO.PutInt(tTypeIndex); RTIO.PutText("\n");
        RTIO.Flush();
      END;

      IF tTypeIndex > 0 THEN
        (* found a catch check if correct one *)
        catchType := GetTypeInfo(tTypeIndex, typeInfo, tTypeEncoding);

        info := LOOPHOLE(catchType,REF INTEGER);
        infoUid := info^;
        (*
          If we ever have to handle scope kind. The uid is in the right
          32 bits and the scope kind the left. Would need changes to
          front end.
        infoUid := Word.And(info^,16_FFFFFFFF); <- fix this preserve sign
        scopeKind := Word.RightShift(info^,32);
        *)

        IF DEBUG THEN
          RTIO.PutText("infoUid "); RTIO.PutInt(infoUid); RTIO.PutText("\n");
          RTIO.Flush();
        END;

        IF catchType = NIL THEN
          (* found a catch(...) catches everything *)
          (* we dont generate catch all *)
          RTError.Msg(NIL,0,"catchType = NIL - eh table error");
        END;
        IF infoUid = excUid OR infoUid = 0 THEN
          (* matched the exception *)
          RETURN TRUE;
        END;
      ELSIF tTypeIndex < 0 THEN
        (* We dont have negative type indexes. These are exception
           specifications. See C++ handling abi. *)
        RTError.Msg(NIL,0,"tTypeIndx < 0 - eh table error");
      END;
      temp := action;
      actionOffset := ReadSLEB(temp);
      IF actionOffset = 0 THEN
        (* end of action list  - exception not found *)
        RETURN FALSE;
      END;
      INC(action,actionOffset);
    END; (* loop *)
  END ScanEHActions;

  BEGIN
    lsda := f.lsda;
    f.tTypeIndex := 0;

    (* get the current ip and offset it before the next instruction
       in the current frame which threw the exception *)
    ip := f.pc - 1;

    (* get the start of the current frame's code (as defined by the
       emitted dwarf code)*)
    funcStart := f.startIP;
    ipOfs := LOOPHOLE(ip - funcStart, ADDRESS);

    (* parse the LSDA header *)
    lpStartEncoding := lsda^; INC(lsda);

    lpStart := ReadEncodedPointer(lsda, lpStartEncoding, base);
    IF lpStart = NIL THEN
      lpStart := funcStart;
    END;
    tTypeEncoding := lsda^; INC(lsda);

    IF tTypeEncoding # DW_EH_PE_omit THEN
      (* type info table *)
      typeInfoOffset := ReadULEB(lsda);
      typeInfo := lsda + typeInfoOffset;
    END;

    (* Walk call-site table searching for range that includes current PC *)
    callSiteEncoding := lsda^; INC(lsda);

    callSiteTableLength := ReadULEB(lsda);
    callSiteTableStart := lsda;
    callSiteTableEnd := callSiteTableStart + callSiteTableLength;
    actionTableStart := callSiteTableEnd;
    callSitePtr := callSiteTableStart;

    WHILE callSitePtr < callSiteTableEnd DO
      (* there is one entry per call-site.
         the call-sites are non-overlapping in [start, start+length]
         the call-sites are ordered in increasing value of start. *)

      start := ReadEncodedPointer(callSitePtr, callSiteEncoding);
      lenPtr := ReadEncodedPointer(callSitePtr, callSiteEncoding);
      length := LOOPHOLE(lenPtr,INTEGER);
      landingPad := ReadEncodedPointer(callSitePtr, callSiteEncoding);
      actionEntry := ReadULEB(callSitePtr);

      end := start + length;
      IF start <= ipOfs AND ipOfs < end THEN
        (* found call site containing ip *)
        IF landingPad = NIL THEN
          RETURN FALSE;
        END;

        INC(landingPad, LOOPHOLE(lpStart,INTEGER));

        (* save landingPad to pass to unwinder *)
        f.landingPad := landingPad;
        IF actionEntry = 0 THEN
          (* found a cleanup - should not have cleanups *)
          RETURN FALSE;
        END;
        RETURN ScanEHActions();
      ELSIF ipOfs < start THEN
        (* abort *)
        RTError.Msg(NIL,0,"eh table error");
      END;
    END; (* while call site parse *)
    RETURN FALSE;
  END ScanEHTable;

BEGIN
  DEBUG := RTParams.IsPresent ("debugehtab");
END RTEHScan.
