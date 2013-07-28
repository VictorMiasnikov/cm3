(*******************************************************************************
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 2.0.4
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
*******************************************************************************)

UNSAFE MODULE QtStyle;


FROM QtFontMetrics IMPORT QFontMetrics;
FROM QtIcon IMPORT QIcon;
FROM QtSize IMPORT QSize;
IMPORT QtStyleRaw;
FROM QtPixmap IMPORT QPixmap;
FROM QGuiStubs IMPORT QStyleOption, QPainter;
FROM QtPalette IMPORT ColorRole, QPalette;
FROM QtSizePolicy IMPORT ControlType, ControlTypes;
FROM QtPoint IMPORT QPoint;
FROM QtRect IMPORT QRect;
FROM QtNamespace IMPORT Orientation, AlignmentFlag, LayoutDirection;


IMPORT WeakRef;
FROM QtString IMPORT QString;
FROM QtWidget IMPORT QWidget;
FROM QtApplication IMPORT QApplication;

PROCEDURE Delete_QStyle (self: QStyle; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtStyleRaw.Delete_QStyle(selfAdr);
  END Delete_QStyle;

PROCEDURE QStyle_polish (self: QStyle; arg2: REFANY (*QWidget*); ) =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(NARROW(arg2, QWidget).cxxObj, ADDRESS);
  BEGIN
    QtStyleRaw.QStyle_polish(selfAdr, arg2tmp);
  END QStyle_polish;

PROCEDURE QStyle_unpolish (self: QStyle; arg2: REFANY (*QWidget*); ) =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(NARROW(arg2, QWidget).cxxObj, ADDRESS);
  BEGIN
    QtStyleRaw.QStyle_unpolish(selfAdr, arg2tmp);
  END QStyle_unpolish;

PROCEDURE QStyle_polish1
  (self: QStyle; arg2: REFANY (* QApplication *); ) =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp := LOOPHOLE(NARROW(arg2, QApplication).cxxObj, ADDRESS);
  BEGIN
    QtStyleRaw.QStyle_polish1(selfAdr, arg2tmp);
  END QStyle_polish1;

PROCEDURE QStyle_unpolish1
  (self: QStyle; arg2: REFANY (* QApplication *); ) =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp := LOOPHOLE(NARROW(arg2, QApplication).cxxObj, ADDRESS);
  BEGIN
    QtStyleRaw.QStyle_unpolish1(selfAdr, arg2tmp);
  END QStyle_unpolish1;

PROCEDURE QStyle_polish2 (self: QStyle; arg2: QPalette; ) =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(arg2.cxxObj, ADDRESS);
  BEGIN
    QtStyleRaw.QStyle_polish2(selfAdr, arg2tmp);
  END QStyle_polish2;

PROCEDURE QStyle_itemTextRect (self   : QStyle;
                               fm     : QFontMetrics;
                               r      : QRect;
                               flags  : INTEGER;
                               enabled: BOOLEAN;
                               text   : TEXT;         ): QRect =
  VAR
    ret      : ADDRESS;
    result   : QRect;
    selfAdr  : ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp            := LOOPHOLE(fm.cxxObj, ADDRESS);
    arg3tmp            := LOOPHOLE(r.cxxObj, ADDRESS);
    qstr_text          := NEW(QString).initQString(text);
    arg6tmp            := LOOPHOLE(qstr_text.cxxObj, ADDRESS);
  BEGIN
    ret := QtStyleRaw.QStyle_itemTextRect(
             selfAdr, arg2tmp, arg3tmp, flags, enabled, arg6tmp);

    result := NEW(QRect);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END QStyle_itemTextRect;

PROCEDURE QStyle_itemPixmapRect
  (self: QStyle; r: QRect; flags: INTEGER; pixmap: QPixmap; ): QRect =
  VAR
    ret    : ADDRESS;
    result : QRect;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(r.cxxObj, ADDRESS);
    arg4tmp          := LOOPHOLE(pixmap.cxxObj, ADDRESS);
  BEGIN
    ret :=
      QtStyleRaw.QStyle_itemPixmapRect(selfAdr, arg2tmp, flags, arg4tmp);

    result := NEW(QRect);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END QStyle_itemPixmapRect;

PROCEDURE QStyle_drawItemText (self    : QStyle;
                               painter : QPainter;
                               rect    : QRect;
                               flags   : INTEGER;
                               pal     : QPalette;
                               enabled : BOOLEAN;
                               text    : TEXT;
                               textRole: ColorRole; ) =
  VAR
    selfAdr  : ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp            := LOOPHOLE(painter.cxxObj, ADDRESS);
    arg3tmp            := LOOPHOLE(rect.cxxObj, ADDRESS);
    arg5tmp            := LOOPHOLE(pal.cxxObj, ADDRESS);
    qstr_text          := NEW(QString).initQString(text);
    arg7tmp            := LOOPHOLE(qstr_text.cxxObj, ADDRESS);
  BEGIN
    QtStyleRaw.QStyle_drawItemText(
      selfAdr, arg2tmp, arg3tmp, flags, arg5tmp, enabled, arg7tmp,
      ORD(textRole));
  END QStyle_drawItemText;

PROCEDURE QStyle_drawItemText1 (self   : QStyle;
                                painter: QPainter;
                                rect   : QRect;
                                flags  : INTEGER;
                                pal    : QPalette;
                                enabled: BOOLEAN;
                                text   : TEXT;     ) =
  VAR
    selfAdr  : ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp            := LOOPHOLE(painter.cxxObj, ADDRESS);
    arg3tmp            := LOOPHOLE(rect.cxxObj, ADDRESS);
    arg5tmp            := LOOPHOLE(pal.cxxObj, ADDRESS);
    qstr_text          := NEW(QString).initQString(text);
    arg7tmp            := LOOPHOLE(qstr_text.cxxObj, ADDRESS);
  BEGIN
    QtStyleRaw.QStyle_drawItemText1(
      selfAdr, arg2tmp, arg3tmp, flags, arg5tmp, enabled, arg7tmp);
  END QStyle_drawItemText1;

PROCEDURE QStyle_drawItemPixmap (self     : QStyle;
                                 painter  : QPainter;
                                 rect     : QRect;
                                 alignment: INTEGER;
                                 pixmap   : QPixmap;  ) =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(painter.cxxObj, ADDRESS);
    arg3tmp          := LOOPHOLE(rect.cxxObj, ADDRESS);
    arg5tmp          := LOOPHOLE(pixmap.cxxObj, ADDRESS);
  BEGIN
    QtStyleRaw.QStyle_drawItemPixmap(
      selfAdr, arg2tmp, arg3tmp, alignment, arg5tmp);
  END QStyle_drawItemPixmap;

PROCEDURE QStyle_standardPalette (self: QStyle; ): QPalette =
  VAR
    ret    : ADDRESS;
    result : QPalette;
    selfAdr: ADDRESS  := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtStyleRaw.QStyle_standardPalette(selfAdr);

    result := NEW(QPalette);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END QStyle_standardPalette;

PROCEDURE QStyle_standardIcon (self        : QStyle;
                               standardIcon: StandardPixmap;
                               option      : QStyleOption;
                               widget      : REFANY (*QWidget*); ): QIcon =
  VAR
    ret    : ADDRESS;
    result : QIcon;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg3tmp          := LOOPHOLE(option.cxxObj, ADDRESS);
    arg4tmp          := LOOPHOLE(NARROW(widget, QWidget).cxxObj, ADDRESS);
  BEGIN
    ret := QtStyleRaw.QStyle_standardIcon(
             selfAdr, ORD(standardIcon), arg3tmp, arg4tmp);

    result := NEW(QIcon);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END QStyle_standardIcon;

PROCEDURE QStyle_standardIcon1
  (self: QStyle; standardIcon: StandardPixmap; option: QStyleOption; ):
  QIcon =
  VAR
    ret    : ADDRESS;
    result : QIcon;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg3tmp          := LOOPHOLE(option.cxxObj, ADDRESS);
  BEGIN
    ret :=
      QtStyleRaw.QStyle_standardIcon1(selfAdr, ORD(standardIcon), arg3tmp);

    result := NEW(QIcon);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END QStyle_standardIcon1;

PROCEDURE QStyle_standardIcon2
  (self: QStyle; standardIcon: StandardPixmap; ): QIcon =
  VAR
    ret    : ADDRESS;
    result : QIcon;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtStyleRaw.QStyle_standardIcon2(selfAdr, ORD(standardIcon));

    result := NEW(QIcon);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END QStyle_standardIcon2;

PROCEDURE VisualRect
  (direction: LayoutDirection; boundingRect, logicalRect: QRect; ): QRect =
  VAR
    ret    : ADDRESS;
    result : QRect;
    arg2tmp          := LOOPHOLE(boundingRect.cxxObj, ADDRESS);
    arg3tmp          := LOOPHOLE(logicalRect.cxxObj, ADDRESS);
  BEGIN
    ret := QtStyleRaw.VisualRect(ORD(direction), arg2tmp, arg3tmp);

    result := NEW(QRect);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END VisualRect;

PROCEDURE VisualPos
  (direction: LayoutDirection; boundingRect: QRect; logicalPos: QPoint; ):
  QPoint =
  VAR
    ret    : ADDRESS;
    result : QPoint;
    arg2tmp          := LOOPHOLE(boundingRect.cxxObj, ADDRESS);
    arg3tmp          := LOOPHOLE(logicalPos.cxxObj, ADDRESS);
  BEGIN
    ret := QtStyleRaw.VisualPos(ORD(direction), arg2tmp, arg3tmp);

    result := NEW(QPoint);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END VisualPos;

PROCEDURE SliderPositionFromValue
  (min, max, val, space: INTEGER; upsideDown: BOOLEAN; ): INTEGER =
  BEGIN
    RETURN
      QtStyleRaw.SliderPositionFromValue(min, max, val, space, upsideDown);
  END SliderPositionFromValue;

PROCEDURE SliderPositionFromValue1 (min, max, val, space: INTEGER; ):
  INTEGER =
  BEGIN
    RETURN QtStyleRaw.SliderPositionFromValue1(min, max, val, space);
  END SliderPositionFromValue1;

PROCEDURE SliderValueFromPosition
  (min, max, pos, space: INTEGER; upsideDown: BOOLEAN; ): INTEGER =
  BEGIN
    RETURN
      QtStyleRaw.SliderValueFromPosition(min, max, pos, space, upsideDown);
  END SliderValueFromPosition;

PROCEDURE SliderValueFromPosition1 (min, max, pos, space: INTEGER; ):
  INTEGER =
  BEGIN
    RETURN QtStyleRaw.SliderValueFromPosition1(min, max, pos, space);
  END SliderValueFromPosition1;

PROCEDURE VisualAlignment
  (direction: LayoutDirection; alignment: AlignmentFlag; ): AlignmentFlag =
  VAR
    ret   : INTEGER;
    result: AlignmentFlag;
  BEGIN
    ret := QtStyleRaw.VisualAlignment(ORD(direction), ORD(alignment));
    result := VAL(ret, AlignmentFlag);
    RETURN result;
  END VisualAlignment;

PROCEDURE AlignedRect (direction: LayoutDirection;
                       alignment: AlignmentFlag;
                       size     : QSize;
                       rectangle: QRect;           ): QRect =
  VAR
    ret    : ADDRESS;
    result : QRect;
    arg3tmp          := LOOPHOLE(size.cxxObj, ADDRESS);
    arg4tmp          := LOOPHOLE(rectangle.cxxObj, ADDRESS);
  BEGIN
    ret := QtStyleRaw.AlignedRect(
             ORD(direction), ORD(alignment), arg3tmp, arg4tmp);

    result := NEW(QRect);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END AlignedRect;

PROCEDURE QStyle_layoutSpacing (self              : QStyle;
                                control1, control2: ControlType;
                                orientation       : Orientation;
                                option            : QStyleOption;
                                widget            : REFANY (*QWidget*); ):
  INTEGER =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg5tmp          := LOOPHOLE(option.cxxObj, ADDRESS);
    arg6tmp          := LOOPHOLE(NARROW(widget, QWidget).cxxObj, ADDRESS);
  BEGIN
    RETURN QtStyleRaw.QStyle_layoutSpacing(
             selfAdr, ORD(control1), ORD(control2), ORD(orientation),
             arg5tmp, arg6tmp);
  END QStyle_layoutSpacing;

PROCEDURE QStyle_layoutSpacing1 (self              : QStyle;
                                 control1, control2: ControlType;
                                 orientation       : Orientation;
                                 option            : QStyleOption; ):
  INTEGER =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg5tmp          := LOOPHOLE(option.cxxObj, ADDRESS);
  BEGIN
    RETURN
      QtStyleRaw.QStyle_layoutSpacing1(
        selfAdr, ORD(control1), ORD(control2), ORD(orientation), arg5tmp);
  END QStyle_layoutSpacing1;

PROCEDURE QStyle_layoutSpacing2 (self              : QStyle;
                                 control1, control2: ControlType;
                                 orientation       : Orientation; ):
  INTEGER =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    RETURN QtStyleRaw.QStyle_layoutSpacing2(
             selfAdr, ORD(control1), ORD(control2), ORD(orientation));
  END QStyle_layoutSpacing2;

PROCEDURE QStyle_combinedLayoutSpacing
  (self                : QStyle;
   controls1, controls2: ControlTypes;
   orientation         : Orientation;
   option              : QStyleOption;
   widget              : REFANY (*QWidget*); ): INTEGER =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg5tmp          := LOOPHOLE(option.cxxObj, ADDRESS);
    arg6tmp          := LOOPHOLE(NARROW(widget, QWidget).cxxObj, ADDRESS);
  BEGIN
    RETURN QtStyleRaw.QStyle_combinedLayoutSpacing(
             selfAdr, ORD(controls1), ORD(controls2), ORD(orientation),
             arg5tmp, arg6tmp);
  END QStyle_combinedLayoutSpacing;

PROCEDURE QStyle_combinedLayoutSpacing1
  (self                : QStyle;
   controls1, controls2: ControlTypes;
   orientation         : Orientation;
   option              : QStyleOption; ): INTEGER =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg5tmp          := LOOPHOLE(option.cxxObj, ADDRESS);
  BEGIN
    RETURN QtStyleRaw.QStyle_combinedLayoutSpacing1(
             selfAdr, ORD(controls1), ORD(controls2), ORD(orientation),
             arg5tmp);
  END QStyle_combinedLayoutSpacing1;

PROCEDURE QStyle_combinedLayoutSpacing2
  (self                : QStyle;
   controls1, controls2: ControlTypes;
   orientation         : Orientation;  ): INTEGER =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    RETURN QtStyleRaw.QStyle_combinedLayoutSpacing2(
             selfAdr, ORD(controls1), ORD(controls2), ORD(orientation));
  END QStyle_combinedLayoutSpacing2;

PROCEDURE QStyle_proxy (self: QStyle; ): QStyle =
  VAR
    result : ADDRESS;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    result := QtStyleRaw.QStyle_proxy(selfAdr);

    self.cxxObj := result;
    EVAL WeakRef.FromRef(self, Cleanup_QStyle);

    RETURN self;
  END QStyle_proxy;

PROCEDURE Cleanup_QStyle
  (<* UNUSED *> READONLY self: WeakRef.T; ref: REFANY) =
  VAR obj: QStyle := ref;
  BEGIN
    Delete_QStyle(obj);
  END Cleanup_QStyle;

PROCEDURE Destroy_QStyle (self: QStyle) =
  BEGIN
    EVAL WeakRef.FromRef(self, Cleanup_QStyle);
  END Destroy_QStyle;

REVEAL
  QStyle = QStylePublic BRANDED OBJECT
           OVERRIDES
             polish                 := QStyle_polish;
             unpolish               := QStyle_unpolish;
             polish1                := QStyle_polish1;
             unpolish1              := QStyle_unpolish1;
             polish2                := QStyle_polish2;
             itemTextRect           := QStyle_itemTextRect;
             itemPixmapRect         := QStyle_itemPixmapRect;
             drawItemText           := QStyle_drawItemText;
             drawItemText1          := QStyle_drawItemText1;
             drawItemPixmap         := QStyle_drawItemPixmap;
             standardPalette        := QStyle_standardPalette;
             standardIcon           := QStyle_standardIcon;
             standardIcon1          := QStyle_standardIcon1;
             standardIcon2          := QStyle_standardIcon2;
             layoutSpacing          := QStyle_layoutSpacing;
             layoutSpacing1         := QStyle_layoutSpacing1;
             layoutSpacing2         := QStyle_layoutSpacing2;
             combinedLayoutSpacing  := QStyle_combinedLayoutSpacing;
             combinedLayoutSpacing1 := QStyle_combinedLayoutSpacing1;
             combinedLayoutSpacing2 := QStyle_combinedLayoutSpacing2;
             proxy                  := QStyle_proxy;
             destroyCxx             := Destroy_QStyle;
           END;


BEGIN
END QtStyle.
