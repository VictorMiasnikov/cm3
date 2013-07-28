(*******************************************************************************
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 2.0.4
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
*******************************************************************************)

UNSAFE MODULE QtPixmap;


FROM QtTransform IMPORT QTransform;
FROM QtPoint IMPORT QPoint;
FROM QtNamespace IMPORT ImageConversionFlags, AspectRatioMode,
                        TransformationMode;
FROM QtColor IMPORT QColor;
FROM QGuiStubs IMPORT QPaintEngine, QIODevice;
FROM QtByteArray IMPORT QByteArray;
FROM QtSize IMPORT QSize;
FROM QtImage IMPORT QImage;
FROM QtRect IMPORT QRect;
FROM QtString IMPORT QString;
IMPORT M3toC;
FROM QtMatrix IMPORT QMatrix;
IMPORT QtPixmapRaw;
IMPORT Ctypes AS C;
FROM QtRegion IMPORT QRegion;


IMPORT WeakRef;

PROCEDURE New_QPixmap0 (self: QPixmap; ): QPixmap =
  VAR result: ADDRESS;
  BEGIN
    result := QtPixmapRaw.New_QPixmap0();

    self.cxxObj := result;
    EVAL WeakRef.FromRef(self, Cleanup_QPixmap);

    RETURN self;
  END New_QPixmap0;

PROCEDURE New_QPixmap1 (self: QPixmap; w, h: INTEGER; ): QPixmap =
  VAR result: ADDRESS;
  BEGIN
    result := QtPixmapRaw.New_QPixmap1(w, h);

    self.cxxObj := result;
    EVAL WeakRef.FromRef(self, Cleanup_QPixmap);

    RETURN self;
  END New_QPixmap1;

PROCEDURE New_QPixmap2 (self: QPixmap; arg1: QSize; ): QPixmap =
  VAR
    result : ADDRESS;
    arg1tmp          := LOOPHOLE(arg1.cxxObj, ADDRESS);
  BEGIN
    result := QtPixmapRaw.New_QPixmap2(arg1tmp);

    self.cxxObj := result;
    EVAL WeakRef.FromRef(self, Cleanup_QPixmap);

    RETURN self;
  END New_QPixmap2;

PROCEDURE New_QPixmap3
  (self: QPixmap; fileName, format: TEXT; flags: ImageConversionFlags; ):
  QPixmap =
  VAR
    result       : ADDRESS;
    qstr_fileName              := NEW(QString).initQString(fileName);
    arg1tmp                    := LOOPHOLE(qstr_fileName.cxxObj, ADDRESS);
    arg2tmp      : C.char_star;
  BEGIN
    arg2tmp := M3toC.CopyTtoS(format);
    result := QtPixmapRaw.New_QPixmap3(arg1tmp, arg2tmp, ORD(flags));

    self.cxxObj := result;
    EVAL WeakRef.FromRef(self, Cleanup_QPixmap);



    RETURN self;
  END New_QPixmap3;

PROCEDURE New_QPixmap4 (self: QPixmap; fileName, format: TEXT; ): QPixmap =
  VAR
    result       : ADDRESS;
    qstr_fileName              := NEW(QString).initQString(fileName);
    arg1tmp                    := LOOPHOLE(qstr_fileName.cxxObj, ADDRESS);
    arg2tmp      : C.char_star;
  BEGIN
    arg2tmp := M3toC.CopyTtoS(format);
    result := QtPixmapRaw.New_QPixmap4(arg1tmp, arg2tmp);

    self.cxxObj := result;
    EVAL WeakRef.FromRef(self, Cleanup_QPixmap);



    RETURN self;
  END New_QPixmap4;

PROCEDURE New_QPixmap5 (self: QPixmap; fileName: TEXT; ): QPixmap =
  VAR
    result       : ADDRESS;
    qstr_fileName          := NEW(QString).initQString(fileName);
    arg1tmp                := LOOPHOLE(qstr_fileName.cxxObj, ADDRESS);
  BEGIN
    result := QtPixmapRaw.New_QPixmap5(arg1tmp);

    self.cxxObj := result;
    EVAL WeakRef.FromRef(self, Cleanup_QPixmap);

    RETURN self;
  END New_QPixmap5;

PROCEDURE New_QPixmap6 (self: QPixmap; arg1: QPixmap; ): QPixmap =
  VAR
    result : ADDRESS;
    arg1tmp          := LOOPHOLE(arg1.cxxObj, ADDRESS);
  BEGIN
    result := QtPixmapRaw.New_QPixmap6(arg1tmp);

    self.cxxObj := result;
    EVAL WeakRef.FromRef(self, Cleanup_QPixmap);

    RETURN self;
  END New_QPixmap6;

PROCEDURE Delete_QPixmap (self: QPixmap; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtPixmapRaw.Delete_QPixmap(selfAdr);
  END Delete_QPixmap;

PROCEDURE QPixmap_swap (self, other: QPixmap; ) =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(other.cxxObj, ADDRESS);
  BEGIN
    QtPixmapRaw.QPixmap_swap(selfAdr, arg2tmp);
  END QPixmap_swap;

PROCEDURE QPixmap_isNull (self: QPixmap; ): BOOLEAN =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    RETURN QtPixmapRaw.QPixmap_isNull(selfAdr);
  END QPixmap_isNull;

PROCEDURE QPixmap_devType (self: QPixmap; ): INTEGER =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    RETURN QtPixmapRaw.QPixmap_devType(selfAdr);
  END QPixmap_devType;

PROCEDURE QPixmap_width (self: QPixmap; ): INTEGER =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    RETURN QtPixmapRaw.QPixmap_width(selfAdr);
  END QPixmap_width;

PROCEDURE QPixmap_height (self: QPixmap; ): INTEGER =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    RETURN QtPixmapRaw.QPixmap_height(selfAdr);
  END QPixmap_height;

PROCEDURE QPixmap_size (self: QPixmap; ): QSize =
  VAR
    ret    : ADDRESS;
    result : QSize;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtPixmapRaw.QPixmap_size(selfAdr);

    result := NEW(QSize);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END QPixmap_size;

PROCEDURE QPixmap_rect (self: QPixmap; ): QRect =
  VAR
    ret    : ADDRESS;
    result : QRect;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtPixmapRaw.QPixmap_rect(selfAdr);

    result := NEW(QRect);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END QPixmap_rect;

PROCEDURE QPixmap_depth (self: QPixmap; ): INTEGER =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    RETURN QtPixmapRaw.QPixmap_depth(selfAdr);
  END QPixmap_depth;

PROCEDURE DefaultDepth (): INTEGER =
  BEGIN
    RETURN QtPixmapRaw.DefaultDepth();
  END DefaultDepth;

PROCEDURE QPixmap_fill (self: QPixmap; fillColor: QColor; ) =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(fillColor.cxxObj, ADDRESS);
  BEGIN
    QtPixmapRaw.QPixmap_fill(selfAdr, arg2tmp);
  END QPixmap_fill;

PROCEDURE QPixmap_fill1 (self: QPixmap; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtPixmapRaw.QPixmap_fill1(selfAdr);
  END QPixmap_fill1;

PROCEDURE QPixmap_fill2 (self: QPixmap; widget: REFANY; ofs: QPoint; ) =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg3tmp          := LOOPHOLE(ofs.cxxObj, ADDRESS);
  BEGIN
    QtPixmapRaw.QPixmap_fill2(selfAdr, widget, arg3tmp);
  END QPixmap_fill2;

PROCEDURE QPixmap_fill3
  (self: QPixmap; widget: REFANY; xofs, yofs: INTEGER; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtPixmapRaw.QPixmap_fill3(selfAdr, widget, xofs, yofs);
  END QPixmap_fill3;

PROCEDURE QPixmap_setMask (self: QPixmap; arg2: REFANY; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtPixmapRaw.QPixmap_setMask(selfAdr, arg2);
  END QPixmap_setMask;

PROCEDURE QPixmap_hasAlpha (self: QPixmap; ): BOOLEAN =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    RETURN QtPixmapRaw.QPixmap_hasAlpha(selfAdr);
  END QPixmap_hasAlpha;

PROCEDURE QPixmap_hasAlphaChannel (self: QPixmap; ): BOOLEAN =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    RETURN QtPixmapRaw.QPixmap_hasAlphaChannel(selfAdr);
  END QPixmap_hasAlphaChannel;

PROCEDURE GrabWindow (arg1, x, y, w, h: INTEGER; ): QPixmap =
  VAR
    ret   : ADDRESS;
    result: QPixmap;
  BEGIN
    ret := QtPixmapRaw.GrabWindow(arg1, x, y, w, h);

    (*IF ISTYPE(result,QPixmap) AND ret = selfAdr THEN result :=
       LOOPHOLE(self,QPixmap); ELSE*)
    result := NEW(QPixmap);
    result.cxxObj := ret;
    result.destroyCxx();
    (*END;*)

    RETURN result;
  END GrabWindow;

PROCEDURE GrabWindow1 (arg1, x, y, w: INTEGER; ): QPixmap =
  VAR
    ret   : ADDRESS;
    result: QPixmap;
  BEGIN
    ret := QtPixmapRaw.GrabWindow1(arg1, x, y, w);

    (*IF ISTYPE(result,QPixmap) AND ret = selfAdr THEN result :=
       LOOPHOLE(self,QPixmap); ELSE*)
    result := NEW(QPixmap);
    result.cxxObj := ret;
    result.destroyCxx();
    (*END;*)

    RETURN result;
  END GrabWindow1;

PROCEDURE GrabWindow2 (arg1, x, y: INTEGER; ): QPixmap =
  VAR
    ret   : ADDRESS;
    result: QPixmap;
  BEGIN
    ret := QtPixmapRaw.GrabWindow2(arg1, x, y);

    (*IF ISTYPE(result,QPixmap) AND ret = selfAdr THEN result :=
       LOOPHOLE(self,QPixmap); ELSE*)
    result := NEW(QPixmap);
    result.cxxObj := ret;
    result.destroyCxx();
    (*END;*)

    RETURN result;
  END GrabWindow2;

PROCEDURE GrabWindow3 (arg1, x: INTEGER; ): QPixmap =
  VAR
    ret   : ADDRESS;
    result: QPixmap;
  BEGIN
    ret := QtPixmapRaw.GrabWindow3(arg1, x);

    (*IF ISTYPE(result,QPixmap) AND ret = selfAdr THEN result :=
       LOOPHOLE(self,QPixmap); ELSE*)
    result := NEW(QPixmap);
    result.cxxObj := ret;
    result.destroyCxx();
    (*END;*)

    RETURN result;
  END GrabWindow3;

PROCEDURE GrabWindow4 (arg1: INTEGER; ): QPixmap =
  VAR
    ret   : ADDRESS;
    result: QPixmap;
  BEGIN
    ret := QtPixmapRaw.GrabWindow4(arg1);

    (*IF ISTYPE(result,QPixmap) AND ret = selfAdr THEN result :=
       LOOPHOLE(self,QPixmap); ELSE*)
    result := NEW(QPixmap);
    result.cxxObj := ret;
    result.destroyCxx();
    (*END;*)

    RETURN result;
  END GrabWindow4;

PROCEDURE GrabWidget (widget: REFANY; rect: QRect; ): QPixmap =
  VAR
    ret    : ADDRESS;
    result : QPixmap;
    arg2tmp          := LOOPHOLE(rect.cxxObj, ADDRESS);
  BEGIN
    ret := QtPixmapRaw.GrabWidget(widget, arg2tmp);

    (*IF ISTYPE(result,QPixmap) AND ret = selfAdr THEN result :=
       LOOPHOLE(self,QPixmap); ELSE*)
    result := NEW(QPixmap);
    result.cxxObj := ret;
    result.destroyCxx();
    (*END;*)

    RETURN result;
  END GrabWidget;

PROCEDURE GrabWidget1 (widget: REFANY; x, y, w, h: INTEGER; ): QPixmap =
  VAR
    ret   : ADDRESS;
    result: QPixmap;
  BEGIN
    ret := QtPixmapRaw.GrabWidget1(widget, x, y, w, h);

    (*IF ISTYPE(result,QPixmap) AND ret = selfAdr THEN result :=
       LOOPHOLE(self,QPixmap); ELSE*)
    result := NEW(QPixmap);
    result.cxxObj := ret;
    result.destroyCxx();
    (*END;*)

    RETURN result;
  END GrabWidget1;

PROCEDURE GrabWidget2 (widget: REFANY; x, y, w: INTEGER; ): QPixmap =
  VAR
    ret   : ADDRESS;
    result: QPixmap;
  BEGIN
    ret := QtPixmapRaw.GrabWidget2(widget, x, y, w);

    (*IF ISTYPE(result,QPixmap) AND ret = selfAdr THEN result :=
       LOOPHOLE(self,QPixmap); ELSE*)
    result := NEW(QPixmap);
    result.cxxObj := ret;
    result.destroyCxx();
    (*END;*)

    RETURN result;
  END GrabWidget2;

PROCEDURE GrabWidget3 (widget: REFANY; x, y: INTEGER; ): QPixmap =
  VAR
    ret   : ADDRESS;
    result: QPixmap;
  BEGIN
    ret := QtPixmapRaw.GrabWidget3(widget, x, y);

    (*IF ISTYPE(result,QPixmap) AND ret = selfAdr THEN result :=
       LOOPHOLE(self,QPixmap); ELSE*)
    result := NEW(QPixmap);
    result.cxxObj := ret;
    result.destroyCxx();
    (*END;*)

    RETURN result;
  END GrabWidget3;

PROCEDURE GrabWidget4 (widget: REFANY; x: INTEGER; ): QPixmap =
  VAR
    ret   : ADDRESS;
    result: QPixmap;
  BEGIN
    ret := QtPixmapRaw.GrabWidget4(widget, x);

    (*IF ISTYPE(result,QPixmap) AND ret = selfAdr THEN result :=
       LOOPHOLE(self,QPixmap); ELSE*)
    result := NEW(QPixmap);
    result.cxxObj := ret;
    result.destroyCxx();
    (*END;*)

    RETURN result;
  END GrabWidget4;

PROCEDURE GrabWidget5 (widget: REFANY; ): QPixmap =
  VAR
    ret   : ADDRESS;
    result: QPixmap;
  BEGIN
    ret := QtPixmapRaw.GrabWidget5(widget);

    (*IF ISTYPE(result,QPixmap) AND ret = selfAdr THEN result :=
       LOOPHOLE(self,QPixmap); ELSE*)
    result := NEW(QPixmap);
    result.cxxObj := ret;
    result.destroyCxx();
    (*END;*)

    RETURN result;
  END GrabWidget5;

PROCEDURE QPixmap_scaled (self      : QPixmap;
                          w, h      : INTEGER;
                          aspectMode: AspectRatioMode;
                          mode      : TransformationMode; ): QPixmap =
  VAR
    ret    : ADDRESS;
    result : QPixmap;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtPixmapRaw.QPixmap_scaled(
             selfAdr, w, h, ORD(aspectMode), ORD(mode));

    IF ISTYPE(result, QPixmap) AND ret = selfAdr THEN
      result := LOOPHOLE(self, QPixmap);
    ELSE
      result := NEW(QPixmap);
      result.cxxObj := ret;
      result.destroyCxx();
    END;

    RETURN result;
  END QPixmap_scaled;

PROCEDURE QPixmap_scaled1
  (self: QPixmap; w, h: INTEGER; aspectMode: AspectRatioMode; ): QPixmap =
  VAR
    ret    : ADDRESS;
    result : QPixmap;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtPixmapRaw.QPixmap_scaled1(selfAdr, w, h, ORD(aspectMode));

    IF ISTYPE(result, QPixmap) AND ret = selfAdr THEN
      result := LOOPHOLE(self, QPixmap);
    ELSE
      result := NEW(QPixmap);
      result.cxxObj := ret;
      result.destroyCxx();
    END;

    RETURN result;
  END QPixmap_scaled1;

PROCEDURE QPixmap_scaled2 (self: QPixmap; w, h: INTEGER; ): QPixmap =
  VAR
    ret    : ADDRESS;
    result : QPixmap;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtPixmapRaw.QPixmap_scaled2(selfAdr, w, h);

    IF ISTYPE(result, QPixmap) AND ret = selfAdr THEN
      result := LOOPHOLE(self, QPixmap);
    ELSE
      result := NEW(QPixmap);
      result.cxxObj := ret;
      result.destroyCxx();
    END;

    RETURN result;
  END QPixmap_scaled2;

PROCEDURE QPixmap_scaled3 (self      : QPixmap;
                           s         : QSize;
                           aspectMode: AspectRatioMode;
                           mode      : TransformationMode; ): QPixmap =
  VAR
    ret    : ADDRESS;
    result : QPixmap;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(s.cxxObj, ADDRESS);
  BEGIN
    ret := QtPixmapRaw.QPixmap_scaled3(
             selfAdr, arg2tmp, ORD(aspectMode), ORD(mode));

    IF ISTYPE(result, QPixmap) AND ret = selfAdr THEN
      result := LOOPHOLE(self, QPixmap);
    ELSE
      result := NEW(QPixmap);
      result.cxxObj := ret;
      result.destroyCxx();
    END;

    RETURN result;
  END QPixmap_scaled3;

PROCEDURE QPixmap_scaled4
  (self: QPixmap; s: QSize; aspectMode: AspectRatioMode; ): QPixmap =
  VAR
    ret    : ADDRESS;
    result : QPixmap;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(s.cxxObj, ADDRESS);
  BEGIN
    ret := QtPixmapRaw.QPixmap_scaled4(selfAdr, arg2tmp, ORD(aspectMode));

    IF ISTYPE(result, QPixmap) AND ret = selfAdr THEN
      result := LOOPHOLE(self, QPixmap);
    ELSE
      result := NEW(QPixmap);
      result.cxxObj := ret;
      result.destroyCxx();
    END;

    RETURN result;
  END QPixmap_scaled4;

PROCEDURE QPixmap_scaled5 (self: QPixmap; s: QSize; ): QPixmap =
  VAR
    ret    : ADDRESS;
    result : QPixmap;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(s.cxxObj, ADDRESS);
  BEGIN
    ret := QtPixmapRaw.QPixmap_scaled5(selfAdr, arg2tmp);

    IF ISTYPE(result, QPixmap) AND ret = selfAdr THEN
      result := LOOPHOLE(self, QPixmap);
    ELSE
      result := NEW(QPixmap);
      result.cxxObj := ret;
      result.destroyCxx();
    END;

    RETURN result;
  END QPixmap_scaled5;

PROCEDURE QPixmap_scaledToWidth
  (self: QPixmap; w: INTEGER; mode: TransformationMode; ): QPixmap =
  VAR
    ret    : ADDRESS;
    result : QPixmap;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtPixmapRaw.QPixmap_scaledToWidth(selfAdr, w, ORD(mode));

    IF ISTYPE(result, QPixmap) AND ret = selfAdr THEN
      result := LOOPHOLE(self, QPixmap);
    ELSE
      result := NEW(QPixmap);
      result.cxxObj := ret;
      result.destroyCxx();
    END;

    RETURN result;
  END QPixmap_scaledToWidth;

PROCEDURE QPixmap_scaledToWidth1 (self: QPixmap; w: INTEGER; ): QPixmap =
  VAR
    ret    : ADDRESS;
    result : QPixmap;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtPixmapRaw.QPixmap_scaledToWidth1(selfAdr, w);

    IF ISTYPE(result, QPixmap) AND ret = selfAdr THEN
      result := LOOPHOLE(self, QPixmap);
    ELSE
      result := NEW(QPixmap);
      result.cxxObj := ret;
      result.destroyCxx();
    END;

    RETURN result;
  END QPixmap_scaledToWidth1;

PROCEDURE QPixmap_scaledToHeight
  (self: QPixmap; h: INTEGER; mode: TransformationMode; ): QPixmap =
  VAR
    ret    : ADDRESS;
    result : QPixmap;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtPixmapRaw.QPixmap_scaledToHeight(selfAdr, h, ORD(mode));

    IF ISTYPE(result, QPixmap) AND ret = selfAdr THEN
      result := LOOPHOLE(self, QPixmap);
    ELSE
      result := NEW(QPixmap);
      result.cxxObj := ret;
      result.destroyCxx();
    END;

    RETURN result;
  END QPixmap_scaledToHeight;

PROCEDURE QPixmap_scaledToHeight1 (self: QPixmap; h: INTEGER; ): QPixmap =
  VAR
    ret    : ADDRESS;
    result : QPixmap;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtPixmapRaw.QPixmap_scaledToHeight1(selfAdr, h);

    IF ISTYPE(result, QPixmap) AND ret = selfAdr THEN
      result := LOOPHOLE(self, QPixmap);
    ELSE
      result := NEW(QPixmap);
      result.cxxObj := ret;
      result.destroyCxx();
    END;

    RETURN result;
  END QPixmap_scaledToHeight1;

PROCEDURE QPixmap_transformed
  (self: QPixmap; arg2: QMatrix; mode: TransformationMode; ): QPixmap =
  VAR
    ret    : ADDRESS;
    result : QPixmap;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(arg2.cxxObj, ADDRESS);
  BEGIN
    ret := QtPixmapRaw.QPixmap_transformed(selfAdr, arg2tmp, ORD(mode));

    IF ISTYPE(result, QPixmap) AND ret = selfAdr THEN
      result := LOOPHOLE(self, QPixmap);
    ELSE
      result := NEW(QPixmap);
      result.cxxObj := ret;
      result.destroyCxx();
    END;

    RETURN result;
  END QPixmap_transformed;

PROCEDURE QPixmap_transformed1 (self: QPixmap; arg2: QMatrix; ): QPixmap =
  VAR
    ret    : ADDRESS;
    result : QPixmap;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(arg2.cxxObj, ADDRESS);
  BEGIN
    ret := QtPixmapRaw.QPixmap_transformed1(selfAdr, arg2tmp);

    IF ISTYPE(result, QPixmap) AND ret = selfAdr THEN
      result := LOOPHOLE(self, QPixmap);
    ELSE
      result := NEW(QPixmap);
      result.cxxObj := ret;
      result.destroyCxx();
    END;

    RETURN result;
  END QPixmap_transformed1;

PROCEDURE TrueMatrix (m: QMatrix; w, h: INTEGER; ): QMatrix =
  VAR
    ret    : ADDRESS;
    result : QMatrix;
    arg1tmp          := LOOPHOLE(m.cxxObj, ADDRESS);
  BEGIN
    ret := QtPixmapRaw.TrueMatrix(arg1tmp, w, h);

    result := NEW(QMatrix);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END TrueMatrix;

PROCEDURE QPixmap_transformed2
  (self: QPixmap; arg2: QTransform; mode: TransformationMode; ): QPixmap =
  VAR
    ret    : ADDRESS;
    result : QPixmap;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(arg2.cxxObj, ADDRESS);
  BEGIN
    ret := QtPixmapRaw.QPixmap_transformed2(selfAdr, arg2tmp, ORD(mode));

    IF ISTYPE(result, QPixmap) AND ret = selfAdr THEN
      result := LOOPHOLE(self, QPixmap);
    ELSE
      result := NEW(QPixmap);
      result.cxxObj := ret;
      result.destroyCxx();
    END;

    RETURN result;
  END QPixmap_transformed2;

PROCEDURE QPixmap_transformed3 (self: QPixmap; arg2: QTransform; ):
  QPixmap =
  VAR
    ret    : ADDRESS;
    result : QPixmap;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(arg2.cxxObj, ADDRESS);
  BEGIN
    ret := QtPixmapRaw.QPixmap_transformed3(selfAdr, arg2tmp);

    IF ISTYPE(result, QPixmap) AND ret = selfAdr THEN
      result := LOOPHOLE(self, QPixmap);
    ELSE
      result := NEW(QPixmap);
      result.cxxObj := ret;
      result.destroyCxx();
    END;

    RETURN result;
  END QPixmap_transformed3;

PROCEDURE TrueMatrix1 (m: QTransform; w, h: INTEGER; ): QTransform =
  VAR
    ret    : ADDRESS;
    result : QTransform;
    arg1tmp             := LOOPHOLE(m.cxxObj, ADDRESS);
  BEGIN
    ret := QtPixmapRaw.TrueMatrix1(arg1tmp, w, h);

    result := NEW(QTransform);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END TrueMatrix1;

PROCEDURE QPixmap_toImage (self: QPixmap; ): QImage =
  VAR
    ret    : ADDRESS;
    result : QImage;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtPixmapRaw.QPixmap_toImage(selfAdr);

    result := NEW(QImage);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END QPixmap_toImage;

PROCEDURE FromImage (image: QImage; flags: ImageConversionFlags; ):
  QPixmap =
  VAR
    ret    : ADDRESS;
    result : QPixmap;
    arg1tmp          := LOOPHOLE(image.cxxObj, ADDRESS);
  BEGIN
    ret := QtPixmapRaw.FromImage(arg1tmp, ORD(flags));

    (*IF ISTYPE(result,QPixmap) AND ret = selfAdr THEN result :=
       LOOPHOLE(self,QPixmap); ELSE*)
    result := NEW(QPixmap);
    result.cxxObj := ret;
    result.destroyCxx();
    (*END;*)

    RETURN result;
  END FromImage;

PROCEDURE FromImage1 (image: QImage; ): QPixmap =
  VAR
    ret    : ADDRESS;
    result : QPixmap;
    arg1tmp          := LOOPHOLE(image.cxxObj, ADDRESS);
  BEGIN
    ret := QtPixmapRaw.FromImage1(arg1tmp);

    (*IF ISTYPE(result,QPixmap) AND ret = selfAdr THEN result :=
       LOOPHOLE(self,QPixmap); ELSE*)
    result := NEW(QPixmap);
    result.cxxObj := ret;
    result.destroyCxx();
    (*END;*)

    RETURN result;
  END FromImage1;

PROCEDURE QPixmap_load
  (self: QPixmap; fileName, format: TEXT; flags: ImageConversionFlags; ):
  BOOLEAN =
  VAR
    selfAdr      : ADDRESS     := LOOPHOLE(self.cxxObj, ADDRESS);
    qstr_fileName              := NEW(QString).initQString(fileName);
    arg2tmp                    := LOOPHOLE(qstr_fileName.cxxObj, ADDRESS);
    arg3tmp      : C.char_star;
    result       : BOOLEAN;
  BEGIN
    arg3tmp := M3toC.CopyTtoS(format);
    result :=
      QtPixmapRaw.QPixmap_load(selfAdr, arg2tmp, arg3tmp, ORD(flags));


    RETURN result;
  END QPixmap_load;

PROCEDURE QPixmap_load1 (self: QPixmap; fileName, format: TEXT; ):
  BOOLEAN =
  VAR
    selfAdr      : ADDRESS     := LOOPHOLE(self.cxxObj, ADDRESS);
    qstr_fileName              := NEW(QString).initQString(fileName);
    arg2tmp                    := LOOPHOLE(qstr_fileName.cxxObj, ADDRESS);
    arg3tmp      : C.char_star;
    result       : BOOLEAN;
  BEGIN
    arg3tmp := M3toC.CopyTtoS(format);
    result := QtPixmapRaw.QPixmap_load1(selfAdr, arg2tmp, arg3tmp);


    RETURN result;
  END QPixmap_load1;

PROCEDURE QPixmap_load2 (self: QPixmap; fileName: TEXT; ): BOOLEAN =
  VAR
    selfAdr      : ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    qstr_fileName          := NEW(QString).initQString(fileName);
    arg2tmp                := LOOPHOLE(qstr_fileName.cxxObj, ADDRESS);
  BEGIN
    RETURN QtPixmapRaw.QPixmap_load2(selfAdr, arg2tmp);
  END QPixmap_load2;

PROCEDURE QPixmap_loadFromData (self  : QPixmap;
                                buf   : ADDRESS;
                                len   : CARDINAL;
                                format: TEXT;
                                flags : ImageConversionFlags; ): BOOLEAN =
  VAR
    selfAdr: ADDRESS     := LOOPHOLE(self.cxxObj, ADDRESS);
    arg4tmp: C.char_star;
    result : BOOLEAN;
  BEGIN
    arg4tmp := M3toC.CopyTtoS(format);
    result := QtPixmapRaw.QPixmap_loadFromData(
                selfAdr, buf, len, arg4tmp, ORD(flags));


    RETURN result;
  END QPixmap_loadFromData;

PROCEDURE QPixmap_loadFromData1
  (self: QPixmap; buf: ADDRESS; len: CARDINAL; format: TEXT; ): BOOLEAN =
  VAR
    selfAdr: ADDRESS     := LOOPHOLE(self.cxxObj, ADDRESS);
    arg4tmp: C.char_star;
    result : BOOLEAN;
  BEGIN
    arg4tmp := M3toC.CopyTtoS(format);
    result :=
      QtPixmapRaw.QPixmap_loadFromData1(selfAdr, buf, len, arg4tmp);


    RETURN result;
  END QPixmap_loadFromData1;

PROCEDURE QPixmap_loadFromData2
  (self: QPixmap; buf: ADDRESS; len: CARDINAL; ): BOOLEAN =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    RETURN QtPixmapRaw.QPixmap_loadFromData2(selfAdr, buf, len);
  END QPixmap_loadFromData2;

PROCEDURE QPixmap_loadFromData3 (self  : QPixmap;
                                 data  : QByteArray;
                                 format: TEXT;
                                 flags : ImageConversionFlags; ): BOOLEAN =
  VAR
    selfAdr: ADDRESS     := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp              := LOOPHOLE(data.cxxObj, ADDRESS);
    arg3tmp: C.char_star;
    result : BOOLEAN;
  BEGIN
    arg3tmp := M3toC.CopyTtoS(format);
    result := QtPixmapRaw.QPixmap_loadFromData3(
                selfAdr, arg2tmp, arg3tmp, ORD(flags));


    RETURN result;
  END QPixmap_loadFromData3;

PROCEDURE QPixmap_loadFromData4
  (self: QPixmap; data: QByteArray; format: TEXT; ): BOOLEAN =
  VAR
    selfAdr: ADDRESS     := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp              := LOOPHOLE(data.cxxObj, ADDRESS);
    arg3tmp: C.char_star;
    result : BOOLEAN;
  BEGIN
    arg3tmp := M3toC.CopyTtoS(format);
    result := QtPixmapRaw.QPixmap_loadFromData4(selfAdr, arg2tmp, arg3tmp);


    RETURN result;
  END QPixmap_loadFromData4;

PROCEDURE QPixmap_loadFromData5 (self: QPixmap; data: QByteArray; ):
  BOOLEAN =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(data.cxxObj, ADDRESS);
  BEGIN
    RETURN QtPixmapRaw.QPixmap_loadFromData5(selfAdr, arg2tmp);
  END QPixmap_loadFromData5;

PROCEDURE QPixmap_save
  (self: QPixmap; fileName, format: TEXT; quality: INTEGER; ): BOOLEAN =
  VAR
    selfAdr      : ADDRESS     := LOOPHOLE(self.cxxObj, ADDRESS);
    qstr_fileName              := NEW(QString).initQString(fileName);
    arg2tmp                    := LOOPHOLE(qstr_fileName.cxxObj, ADDRESS);
    arg3tmp      : C.char_star;
    result       : BOOLEAN;
  BEGIN
    arg3tmp := M3toC.CopyTtoS(format);
    result := QtPixmapRaw.QPixmap_save(selfAdr, arg2tmp, arg3tmp, quality);


    RETURN result;
  END QPixmap_save;

PROCEDURE QPixmap_save1 (self: QPixmap; fileName, format: TEXT; ):
  BOOLEAN =
  VAR
    selfAdr      : ADDRESS     := LOOPHOLE(self.cxxObj, ADDRESS);
    qstr_fileName              := NEW(QString).initQString(fileName);
    arg2tmp                    := LOOPHOLE(qstr_fileName.cxxObj, ADDRESS);
    arg3tmp      : C.char_star;
    result       : BOOLEAN;
  BEGIN
    arg3tmp := M3toC.CopyTtoS(format);
    result := QtPixmapRaw.QPixmap_save1(selfAdr, arg2tmp, arg3tmp);


    RETURN result;
  END QPixmap_save1;

PROCEDURE QPixmap_save2 (self: QPixmap; fileName: TEXT; ): BOOLEAN =
  VAR
    selfAdr      : ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    qstr_fileName          := NEW(QString).initQString(fileName);
    arg2tmp                := LOOPHOLE(qstr_fileName.cxxObj, ADDRESS);
  BEGIN
    RETURN QtPixmapRaw.QPixmap_save2(selfAdr, arg2tmp);
  END QPixmap_save2;

PROCEDURE QPixmap_save3
  (self: QPixmap; device: QIODevice; format: TEXT; quality: INTEGER; ):
  BOOLEAN =
  VAR
    selfAdr: ADDRESS     := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp              := LOOPHOLE(device.cxxObj, ADDRESS);
    arg3tmp: C.char_star;
    result : BOOLEAN;
  BEGIN
    arg3tmp := M3toC.CopyTtoS(format);
    result :=
      QtPixmapRaw.QPixmap_save3(selfAdr, arg2tmp, arg3tmp, quality);


    RETURN result;
  END QPixmap_save3;

PROCEDURE QPixmap_save4 (self: QPixmap; device: QIODevice; format: TEXT; ):
  BOOLEAN =
  VAR
    selfAdr: ADDRESS     := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp              := LOOPHOLE(device.cxxObj, ADDRESS);
    arg3tmp: C.char_star;
    result : BOOLEAN;
  BEGIN
    arg3tmp := M3toC.CopyTtoS(format);
    result := QtPixmapRaw.QPixmap_save4(selfAdr, arg2tmp, arg3tmp);


    RETURN result;
  END QPixmap_save4;

PROCEDURE QPixmap_save5 (self: QPixmap; device: QIODevice; ): BOOLEAN =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(device.cxxObj, ADDRESS);
  BEGIN
    RETURN QtPixmapRaw.QPixmap_save5(selfAdr, arg2tmp);
  END QPixmap_save5;

PROCEDURE QPixmap_convertFromImage
  (self: QPixmap; img: QImage; flags: ImageConversionFlags; ): BOOLEAN =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(img.cxxObj, ADDRESS);
  BEGIN
    RETURN
      QtPixmapRaw.QPixmap_convertFromImage(selfAdr, arg2tmp, ORD(flags));
  END QPixmap_convertFromImage;

PROCEDURE QPixmap_convertFromImage1 (self: QPixmap; img: QImage; ):
  BOOLEAN =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(img.cxxObj, ADDRESS);
  BEGIN
    RETURN QtPixmapRaw.QPixmap_convertFromImage1(selfAdr, arg2tmp);
  END QPixmap_convertFromImage1;

PROCEDURE QPixmap_copy (self: QPixmap; x, y, width, height: INTEGER; ):
  QPixmap =
  VAR
    ret    : ADDRESS;
    result : QPixmap;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtPixmapRaw.QPixmap_copy(selfAdr, x, y, width, height);

    IF ISTYPE(result, QPixmap) AND ret = selfAdr THEN
      result := LOOPHOLE(self, QPixmap);
    ELSE
      result := NEW(QPixmap);
      result.cxxObj := ret;
      result.destroyCxx();
    END;

    RETURN result;
  END QPixmap_copy;

PROCEDURE QPixmap_copy1 (self: QPixmap; rect: QRect; ): QPixmap =
  VAR
    ret    : ADDRESS;
    result : QPixmap;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(rect.cxxObj, ADDRESS);
  BEGIN
    ret := QtPixmapRaw.QPixmap_copy1(selfAdr, arg2tmp);

    IF ISTYPE(result, QPixmap) AND ret = selfAdr THEN
      result := LOOPHOLE(self, QPixmap);
    ELSE
      result := NEW(QPixmap);
      result.cxxObj := ret;
      result.destroyCxx();
    END;

    RETURN result;
  END QPixmap_copy1;

PROCEDURE QPixmap_copy2 (self: QPixmap; ): QPixmap =
  VAR
    ret    : ADDRESS;
    result : QPixmap;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtPixmapRaw.QPixmap_copy2(selfAdr);

    IF ISTYPE(result, QPixmap) AND ret = selfAdr THEN
      result := LOOPHOLE(self, QPixmap);
    ELSE
      result := NEW(QPixmap);
      result.cxxObj := ret;
      result.destroyCxx();
    END;

    RETURN result;
  END QPixmap_copy2;

PROCEDURE QPixmap_scroll (self                       : QPixmap;
                          dx, dy, x, y, width, height: INTEGER;
                          exposed                    : QRegion; ) =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg8tmp          := LOOPHOLE(exposed.cxxObj, ADDRESS);
  BEGIN
    QtPixmapRaw.QPixmap_scroll(
      selfAdr, dx, dy, x, y, width, height, arg8tmp);
  END QPixmap_scroll;

PROCEDURE QPixmap_scroll1
  (self: QPixmap; dx, dy, x, y, width, height: INTEGER; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtPixmapRaw.QPixmap_scroll1(selfAdr, dx, dy, x, y, width, height);
  END QPixmap_scroll1;

PROCEDURE QPixmap_scroll2
  (self: QPixmap; dx, dy: INTEGER; rect: QRect; exposed: QRegion; ) =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg4tmp          := LOOPHOLE(rect.cxxObj, ADDRESS);
    arg5tmp          := LOOPHOLE(exposed.cxxObj, ADDRESS);
  BEGIN
    QtPixmapRaw.QPixmap_scroll2(selfAdr, dx, dy, arg4tmp, arg5tmp);
  END QPixmap_scroll2;

PROCEDURE QPixmap_scroll3 (self: QPixmap; dx, dy: INTEGER; rect: QRect; ) =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg4tmp          := LOOPHOLE(rect.cxxObj, ADDRESS);
  BEGIN
    QtPixmapRaw.QPixmap_scroll3(selfAdr, dx, dy, arg4tmp);
  END QPixmap_scroll3;

PROCEDURE QPixmap_cacheKey (self: QPixmap; ): CARDINAL =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    RETURN QtPixmapRaw.QPixmap_cacheKey(selfAdr);
  END QPixmap_cacheKey;

PROCEDURE QPixmap_isDetached (self: QPixmap; ): BOOLEAN =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    RETURN QtPixmapRaw.QPixmap_isDetached(selfAdr);
  END QPixmap_isDetached;

PROCEDURE QPixmap_detach (self: QPixmap; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtPixmapRaw.QPixmap_detach(selfAdr);
  END QPixmap_detach;

PROCEDURE QPixmap_isQBitmap (self: QPixmap; ): BOOLEAN =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    RETURN QtPixmapRaw.QPixmap_isQBitmap(selfAdr);
  END QPixmap_isQBitmap;

PROCEDURE QPixmap_paintEngine (self: QPixmap; ): QPaintEngine =
  VAR
    ret    : ADDRESS;
    result : QPaintEngine;
    selfAdr: ADDRESS      := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtPixmapRaw.QPixmap_paintEngine(selfAdr);

    result := NEW(QPaintEngine);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END QPixmap_paintEngine;

PROCEDURE QPixmap_data_ptr (self: QPixmap; ): UNTRACED REF CHAR =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    RETURN QtPixmapRaw.QPixmap_data_ptr(selfAdr);
  END QPixmap_data_ptr;

PROCEDURE Cleanup_QPixmap
  (<* UNUSED *> READONLY self: WeakRef.T; ref: REFANY) =
  VAR obj: QPixmap := ref;
  BEGIN
    Delete_QPixmap(obj);
  END Cleanup_QPixmap;

PROCEDURE Destroy_QPixmap (self: QPixmap) =
  BEGIN
    EVAL WeakRef.FromRef(self, Cleanup_QPixmap);
  END Destroy_QPixmap;

REVEAL
  QPixmap = QPixmapPublic BRANDED OBJECT
            OVERRIDES
              init_0            := New_QPixmap0;
              init_1            := New_QPixmap1;
              init_2            := New_QPixmap2;
              init_3            := New_QPixmap3;
              init_4            := New_QPixmap4;
              init_5            := New_QPixmap5;
              init_6            := New_QPixmap6;
              swap              := QPixmap_swap;
              isNull            := QPixmap_isNull;
              devType           := QPixmap_devType;
              width             := QPixmap_width;
              height            := QPixmap_height;
              size              := QPixmap_size;
              rect              := QPixmap_rect;
              depth             := QPixmap_depth;
              fill              := QPixmap_fill;
              fill1             := QPixmap_fill1;
              fill2             := QPixmap_fill2;
              fill3             := QPixmap_fill3;
              setMask           := QPixmap_setMask;
              hasAlpha          := QPixmap_hasAlpha;
              hasAlphaChannel   := QPixmap_hasAlphaChannel;
              scaled            := QPixmap_scaled;
              scaled1           := QPixmap_scaled1;
              scaled2           := QPixmap_scaled2;
              scaled3           := QPixmap_scaled3;
              scaled4           := QPixmap_scaled4;
              scaled5           := QPixmap_scaled5;
              scaledToWidth     := QPixmap_scaledToWidth;
              scaledToWidth1    := QPixmap_scaledToWidth1;
              scaledToHeight    := QPixmap_scaledToHeight;
              scaledToHeight1   := QPixmap_scaledToHeight1;
              transformed       := QPixmap_transformed;
              transformed1      := QPixmap_transformed1;
              transformed2      := QPixmap_transformed2;
              transformed3      := QPixmap_transformed3;
              toImage           := QPixmap_toImage;
              load              := QPixmap_load;
              load1             := QPixmap_load1;
              load2             := QPixmap_load2;
              loadFromData      := QPixmap_loadFromData;
              loadFromData1     := QPixmap_loadFromData1;
              loadFromData2     := QPixmap_loadFromData2;
              loadFromData3     := QPixmap_loadFromData3;
              loadFromData4     := QPixmap_loadFromData4;
              loadFromData5     := QPixmap_loadFromData5;
              save              := QPixmap_save;
              save1             := QPixmap_save1;
              save2             := QPixmap_save2;
              save3             := QPixmap_save3;
              save4             := QPixmap_save4;
              save5             := QPixmap_save5;
              convertFromImage  := QPixmap_convertFromImage;
              convertFromImage1 := QPixmap_convertFromImage1;
              copy              := QPixmap_copy;
              copy1             := QPixmap_copy1;
              copy2             := QPixmap_copy2;
              scroll            := QPixmap_scroll;
              scroll1           := QPixmap_scroll1;
              scroll2           := QPixmap_scroll2;
              scroll3           := QPixmap_scroll3;
              cacheKey          := QPixmap_cacheKey;
              isDetached        := QPixmap_isDetached;
              detach            := QPixmap_detach;
              isQBitmap         := QPixmap_isQBitmap;
              paintEngine       := QPixmap_paintEngine;
              data_ptr          := QPixmap_data_ptr;
              destroyCxx        := Destroy_QPixmap;
            END;


BEGIN
END QtPixmap.
