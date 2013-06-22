(*******************************************************************************
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 2.0.11
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
*******************************************************************************)

UNSAFE MODULE QtTabWidget;


FROM QtIcon IMPORT QIcon;
FROM QtSize IMPORT QSize;
IMPORT QtTabWidgetRaw;
FROM QtWidget IMPORT QWidget;
FROM QtString IMPORT QString;
FROM QtNamespace IMPORT Corner, TextElideMode;


IMPORT WeakRef;
FROM QtByteArray IMPORT QByteArray;

PROCEDURE New_QTabWidget0 (self: QTabWidget; parent: QWidget; ):
  QTabWidget =
  VAR
    result : ADDRESS;
    arg1tmp          := LOOPHOLE(parent.cxxObj, ADDRESS);
  BEGIN
    result := QtTabWidgetRaw.New_QTabWidget0(arg1tmp);

    self.cxxObj := result;
    EVAL WeakRef.FromRef(self, Cleanup_QTabWidget);

    RETURN self;
  END New_QTabWidget0;

PROCEDURE New_QTabWidget1 (self: QTabWidget; ): QTabWidget =
  VAR result: ADDRESS;
  BEGIN
    result := QtTabWidgetRaw.New_QTabWidget1();

    self.cxxObj := result;
    EVAL WeakRef.FromRef(self, Cleanup_QTabWidget);

    RETURN self;
  END New_QTabWidget1;

PROCEDURE Delete_QTabWidget (self: QTabWidget; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtTabWidgetRaw.Delete_QTabWidget(selfAdr);
  END Delete_QTabWidget;

PROCEDURE QTabWidget_addTab
  (self: QTabWidget; widget: QWidget; arg3: TEXT; ): INTEGER =
  VAR
    selfAdr  : ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp            := LOOPHOLE(widget.cxxObj, ADDRESS);
    qstr_arg3          := NEW(QString).initQString(arg3);
    arg3tmp            := LOOPHOLE(qstr_arg3.cxxObj, ADDRESS);
  BEGIN
    RETURN QtTabWidgetRaw.QTabWidget_addTab(selfAdr, arg2tmp, arg3tmp);
  END QTabWidget_addTab;

PROCEDURE QTabWidget_addTab1
  (self: QTabWidget; widget: QWidget; icon: QIcon; label: TEXT; ):
  INTEGER =
  VAR
    selfAdr   : ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp             := LOOPHOLE(widget.cxxObj, ADDRESS);
    arg3tmp             := LOOPHOLE(icon.cxxObj, ADDRESS);
    qstr_label          := NEW(QString).initQString(label);
    arg4tmp             := LOOPHOLE(qstr_label.cxxObj, ADDRESS);
  BEGIN
    RETURN QtTabWidgetRaw.QTabWidget_addTab1(
             selfAdr, arg2tmp, arg3tmp, arg4tmp);
  END QTabWidget_addTab1;

PROCEDURE QTabWidget_insertTab
  (self: QTabWidget; index: INTEGER; widget: QWidget; arg4: TEXT; ):
  INTEGER =
  VAR
    selfAdr  : ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg3tmp            := LOOPHOLE(widget.cxxObj, ADDRESS);
    qstr_arg4          := NEW(QString).initQString(arg4);
    arg4tmp            := LOOPHOLE(qstr_arg4.cxxObj, ADDRESS);
  BEGIN
    RETURN QtTabWidgetRaw.QTabWidget_insertTab(
             selfAdr, index, arg3tmp, arg4tmp);
  END QTabWidget_insertTab;

PROCEDURE QTabWidget_insertTab1 (self  : QTabWidget;
                                 index : INTEGER;
                                 widget: QWidget;
                                 icon  : QIcon;
                                 label : TEXT;       ): INTEGER =
  VAR
    selfAdr   : ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg3tmp             := LOOPHOLE(widget.cxxObj, ADDRESS);
    arg4tmp             := LOOPHOLE(icon.cxxObj, ADDRESS);
    qstr_label          := NEW(QString).initQString(label);
    arg5tmp             := LOOPHOLE(qstr_label.cxxObj, ADDRESS);
  BEGIN
    RETURN QtTabWidgetRaw.QTabWidget_insertTab1(
             selfAdr, index, arg3tmp, arg4tmp, arg5tmp);
  END QTabWidget_insertTab1;

PROCEDURE QTabWidget_removeTab (self: QTabWidget; index: INTEGER; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtTabWidgetRaw.QTabWidget_removeTab(selfAdr, index);
  END QTabWidget_removeTab;

PROCEDURE QTabWidget_isTabEnabled (self: QTabWidget; index: INTEGER; ):
  BOOLEAN =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    RETURN QtTabWidgetRaw.QTabWidget_isTabEnabled(selfAdr, index);
  END QTabWidget_isTabEnabled;

PROCEDURE QTabWidget_setTabEnabled
  (self: QTabWidget; index: INTEGER; arg3: BOOLEAN; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtTabWidgetRaw.QTabWidget_setTabEnabled(selfAdr, index, arg3);
  END QTabWidget_setTabEnabled;

PROCEDURE QTabWidget_tabText (self: QTabWidget; index: INTEGER; ): TEXT =
  VAR
    ret    : ADDRESS;
    qstr                := NEW(QString);
    ba     : QByteArray;
    result : TEXT;
    selfAdr: ADDRESS    := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtTabWidgetRaw.QTabWidget_tabText(selfAdr, index);

    qstr.cxxObj := ret;
    ba := qstr.toLocal8Bit();
    result := ba.data();

    RETURN result;
  END QTabWidget_tabText;

PROCEDURE QTabWidget_setTabText
  (self: QTabWidget; index: INTEGER; arg3: TEXT; ) =
  VAR
    selfAdr  : ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    qstr_arg3          := NEW(QString).initQString(arg3);
    arg3tmp            := LOOPHOLE(qstr_arg3.cxxObj, ADDRESS);
  BEGIN
    QtTabWidgetRaw.QTabWidget_setTabText(selfAdr, index, arg3tmp);
  END QTabWidget_setTabText;

PROCEDURE QTabWidget_tabIcon (self: QTabWidget; index: INTEGER; ): QIcon =
  VAR
    ret    : ADDRESS;
    result : QIcon;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtTabWidgetRaw.QTabWidget_tabIcon(selfAdr, index);

    result := NEW(QIcon);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END QTabWidget_tabIcon;

PROCEDURE QTabWidget_setTabIcon
  (self: QTabWidget; index: INTEGER; icon: QIcon; ) =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg3tmp          := LOOPHOLE(icon.cxxObj, ADDRESS);
  BEGIN
    QtTabWidgetRaw.QTabWidget_setTabIcon(selfAdr, index, arg3tmp);
  END QTabWidget_setTabIcon;

PROCEDURE QTabWidget_setTabToolTip
  (self: QTabWidget; index: INTEGER; tip: TEXT; ) =
  VAR
    selfAdr : ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    qstr_tip          := NEW(QString).initQString(tip);
    arg3tmp           := LOOPHOLE(qstr_tip.cxxObj, ADDRESS);
  BEGIN
    QtTabWidgetRaw.QTabWidget_setTabToolTip(selfAdr, index, arg3tmp);
  END QTabWidget_setTabToolTip;

PROCEDURE QTabWidget_tabToolTip (self: QTabWidget; index: INTEGER; ):
  TEXT =
  VAR
    ret    : ADDRESS;
    qstr                := NEW(QString);
    ba     : QByteArray;
    result : TEXT;
    selfAdr: ADDRESS    := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtTabWidgetRaw.QTabWidget_tabToolTip(selfAdr, index);

    qstr.cxxObj := ret;
    ba := qstr.toLocal8Bit();
    result := ba.data();

    RETURN result;
  END QTabWidget_tabToolTip;

PROCEDURE QTabWidget_setTabWhatsThis
  (self: QTabWidget; index: INTEGER; text: TEXT; ) =
  VAR
    selfAdr  : ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    qstr_text          := NEW(QString).initQString(text);
    arg3tmp            := LOOPHOLE(qstr_text.cxxObj, ADDRESS);
  BEGIN
    QtTabWidgetRaw.QTabWidget_setTabWhatsThis(selfAdr, index, arg3tmp);
  END QTabWidget_setTabWhatsThis;

PROCEDURE QTabWidget_tabWhatsThis (self: QTabWidget; index: INTEGER; ):
  TEXT =
  VAR
    ret    : ADDRESS;
    qstr                := NEW(QString);
    ba     : QByteArray;
    result : TEXT;
    selfAdr: ADDRESS    := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtTabWidgetRaw.QTabWidget_tabWhatsThis(selfAdr, index);

    qstr.cxxObj := ret;
    ba := qstr.toLocal8Bit();
    result := ba.data();

    RETURN result;
  END QTabWidget_tabWhatsThis;

PROCEDURE QTabWidget_currentIndex (self: QTabWidget; ): INTEGER =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    RETURN QtTabWidgetRaw.QTabWidget_currentIndex(selfAdr);
  END QTabWidget_currentIndex;

PROCEDURE QTabWidget_currentWidget (self: QTabWidget; ): QWidget =
  VAR
    ret    : ADDRESS;
    result : QWidget;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtTabWidgetRaw.QTabWidget_currentWidget(selfAdr);

    result := NEW(QWidget);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END QTabWidget_currentWidget;

PROCEDURE QTabWidget_widget (self: QTabWidget; index: INTEGER; ): QWidget =
  VAR
    ret    : ADDRESS;
    result : QWidget;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtTabWidgetRaw.QTabWidget_widget(selfAdr, index);

    result := NEW(QWidget);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END QTabWidget_widget;

PROCEDURE QTabWidget_indexOf (self: QTabWidget; widget: QWidget; ):
  INTEGER =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(widget.cxxObj, ADDRESS);
  BEGIN
    RETURN QtTabWidgetRaw.QTabWidget_indexOf(selfAdr, arg2tmp);
  END QTabWidget_indexOf;

PROCEDURE QTabWidget_count (self: QTabWidget; ): INTEGER =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    RETURN QtTabWidgetRaw.QTabWidget_count(selfAdr);
  END QTabWidget_count;

PROCEDURE QTabWidget_tabPosition (self: QTabWidget; ): TabPosition =
  VAR
    ret    : INTEGER;
    result : TabPosition;
    selfAdr: ADDRESS     := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtTabWidgetRaw.QTabWidget_tabPosition(selfAdr);
    result := VAL(ret, TabPosition);
    RETURN result;
  END QTabWidget_tabPosition;

PROCEDURE QTabWidget_setTabPosition
  (self: QTabWidget; arg2: TabPosition; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtTabWidgetRaw.QTabWidget_setTabPosition(selfAdr, ORD(arg2));
  END QTabWidget_setTabPosition;

PROCEDURE QTabWidget_tabsClosable (self: QTabWidget; ): BOOLEAN =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    RETURN QtTabWidgetRaw.QTabWidget_tabsClosable(selfAdr);
  END QTabWidget_tabsClosable;

PROCEDURE QTabWidget_setTabsClosable
  (self: QTabWidget; closeable: BOOLEAN; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtTabWidgetRaw.QTabWidget_setTabsClosable(selfAdr, closeable);
  END QTabWidget_setTabsClosable;

PROCEDURE QTabWidget_isMovable (self: QTabWidget; ): BOOLEAN =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    RETURN QtTabWidgetRaw.QTabWidget_isMovable(selfAdr);
  END QTabWidget_isMovable;

PROCEDURE QTabWidget_setMovable (self: QTabWidget; movable: BOOLEAN; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtTabWidgetRaw.QTabWidget_setMovable(selfAdr, movable);
  END QTabWidget_setMovable;

PROCEDURE QTabWidget_tabShape (self: QTabWidget; ): TabShape =
  VAR
    ret    : INTEGER;
    result : TabShape;
    selfAdr: ADDRESS  := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtTabWidgetRaw.QTabWidget_tabShape(selfAdr);
    result := VAL(ret, TabShape);
    RETURN result;
  END QTabWidget_tabShape;

PROCEDURE QTabWidget_setTabShape (self: QTabWidget; s: TabShape; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtTabWidgetRaw.QTabWidget_setTabShape(selfAdr, ORD(s));
  END QTabWidget_setTabShape;

PROCEDURE QTabWidget_sizeHint (self: QTabWidget; ): QSize =
  VAR
    ret    : ADDRESS;
    result : QSize;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtTabWidgetRaw.QTabWidget_sizeHint(selfAdr);

    result := NEW(QSize);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END QTabWidget_sizeHint;

PROCEDURE QTabWidget_minimumSizeHint (self: QTabWidget; ): QSize =
  VAR
    ret    : ADDRESS;
    result : QSize;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtTabWidgetRaw.QTabWidget_minimumSizeHint(selfAdr);

    result := NEW(QSize);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END QTabWidget_minimumSizeHint;

PROCEDURE QTabWidget_setCornerWidget
  (self: QTabWidget; w: QWidget; corner: Corner; ) =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(w.cxxObj, ADDRESS);
  BEGIN
    QtTabWidgetRaw.QTabWidget_setCornerWidget(
      selfAdr, arg2tmp, ORD(corner));
  END QTabWidget_setCornerWidget;

PROCEDURE QTabWidget_setCornerWidget1 (self: QTabWidget; w: QWidget; ) =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(w.cxxObj, ADDRESS);
  BEGIN
    QtTabWidgetRaw.QTabWidget_setCornerWidget1(selfAdr, arg2tmp);
  END QTabWidget_setCornerWidget1;

PROCEDURE QTabWidget_cornerWidget (self: QTabWidget; corner: Corner; ):
  QWidget =
  VAR
    ret    : ADDRESS;
    result : QWidget;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtTabWidgetRaw.QTabWidget_cornerWidget(selfAdr, ORD(corner));

    result := NEW(QWidget);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END QTabWidget_cornerWidget;

PROCEDURE QTabWidget_cornerWidget1 (self: QTabWidget; ): QWidget =
  VAR
    ret    : ADDRESS;
    result : QWidget;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtTabWidgetRaw.QTabWidget_cornerWidget1(selfAdr);

    result := NEW(QWidget);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END QTabWidget_cornerWidget1;

PROCEDURE QTabWidget_elideMode (self: QTabWidget; ): TextElideMode =
  VAR
    ret    : INTEGER;
    result : TextElideMode;
    selfAdr: ADDRESS       := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtTabWidgetRaw.QTabWidget_elideMode(selfAdr);
    result := VAL(ret, TextElideMode);
    RETURN result;
  END QTabWidget_elideMode;

PROCEDURE QTabWidget_setElideMode
  (self: QTabWidget; arg2: TextElideMode; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtTabWidgetRaw.QTabWidget_setElideMode(selfAdr, ORD(arg2));
  END QTabWidget_setElideMode;

PROCEDURE QTabWidget_iconSize (self: QTabWidget; ): QSize =
  VAR
    ret    : ADDRESS;
    result : QSize;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtTabWidgetRaw.QTabWidget_iconSize(selfAdr);

    result := NEW(QSize);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END QTabWidget_iconSize;

PROCEDURE QTabWidget_setIconSize (self: QTabWidget; size: QSize; ) =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(size.cxxObj, ADDRESS);
  BEGIN
    QtTabWidgetRaw.QTabWidget_setIconSize(selfAdr, arg2tmp);
  END QTabWidget_setIconSize;

PROCEDURE QTabWidget_usesScrollButtons (self: QTabWidget; ): BOOLEAN =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    RETURN QtTabWidgetRaw.QTabWidget_usesScrollButtons(selfAdr);
  END QTabWidget_usesScrollButtons;

PROCEDURE QTabWidget_setUsesScrollButtons
  (self: QTabWidget; useButtons: BOOLEAN; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtTabWidgetRaw.QTabWidget_setUsesScrollButtons(selfAdr, useButtons);
  END QTabWidget_setUsesScrollButtons;

PROCEDURE QTabWidget_documentMode (self: QTabWidget; ): BOOLEAN =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    RETURN QtTabWidgetRaw.QTabWidget_documentMode(selfAdr);
  END QTabWidget_documentMode;

PROCEDURE QTabWidget_setDocumentMode (self: QTabWidget; set: BOOLEAN; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtTabWidgetRaw.QTabWidget_setDocumentMode(selfAdr, set);
  END QTabWidget_setDocumentMode;

PROCEDURE QTabWidget_clear (self: QTabWidget; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtTabWidgetRaw.QTabWidget_clear(selfAdr);
  END QTabWidget_clear;

PROCEDURE QTabWidget_setCurrentIndex (self: QTabWidget; index: INTEGER; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtTabWidgetRaw.QTabWidget_setCurrentIndex(selfAdr, index);
  END QTabWidget_setCurrentIndex;

PROCEDURE QTabWidget_setCurrentWidget
  (self: QTabWidget; widget: QWidget; ) =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(widget.cxxObj, ADDRESS);
  BEGIN
    QtTabWidgetRaw.QTabWidget_setCurrentWidget(selfAdr, arg2tmp);
  END QTabWidget_setCurrentWidget;

PROCEDURE Cleanup_QTabWidget
  (<* UNUSED *> READONLY self: WeakRef.T; ref: REFANY) =
  VAR obj: QTabWidget := ref;
  BEGIN
    Delete_QTabWidget(obj);
  END Cleanup_QTabWidget;

PROCEDURE Destroy_QTabWidget (self: QTabWidget) =
  BEGIN
    EVAL WeakRef.FromRef(self, Cleanup_QTabWidget);
  END Destroy_QTabWidget;

REVEAL
  QTabWidget = QTabWidgetPublic BRANDED OBJECT
               OVERRIDES
                 init_0               := New_QTabWidget0;
                 init_1               := New_QTabWidget1;
                 addTab               := QTabWidget_addTab;
                 addTab1              := QTabWidget_addTab1;
                 insertTab            := QTabWidget_insertTab;
                 insertTab1           := QTabWidget_insertTab1;
                 removeTab            := QTabWidget_removeTab;
                 isTabEnabled         := QTabWidget_isTabEnabled;
                 setTabEnabled        := QTabWidget_setTabEnabled;
                 tabText              := QTabWidget_tabText;
                 setTabText           := QTabWidget_setTabText;
                 tabIcon              := QTabWidget_tabIcon;
                 setTabIcon           := QTabWidget_setTabIcon;
                 setTabToolTip        := QTabWidget_setTabToolTip;
                 tabToolTip           := QTabWidget_tabToolTip;
                 setTabWhatsThis      := QTabWidget_setTabWhatsThis;
                 tabWhatsThis         := QTabWidget_tabWhatsThis;
                 currentIndex         := QTabWidget_currentIndex;
                 currentWidget        := QTabWidget_currentWidget;
                 widget               := QTabWidget_widget;
                 indexOf              := QTabWidget_indexOf;
                 count                := QTabWidget_count;
                 tabPosition          := QTabWidget_tabPosition;
                 setTabPosition       := QTabWidget_setTabPosition;
                 tabsClosable         := QTabWidget_tabsClosable;
                 setTabsClosable      := QTabWidget_setTabsClosable;
                 isMovable            := QTabWidget_isMovable;
                 setMovable           := QTabWidget_setMovable;
                 tabShape             := QTabWidget_tabShape;
                 setTabShape          := QTabWidget_setTabShape;
                 sizeHint             := QTabWidget_sizeHint;
                 minimumSizeHint      := QTabWidget_minimumSizeHint;
                 setCornerWidget      := QTabWidget_setCornerWidget;
                 setCornerWidget1     := QTabWidget_setCornerWidget1;
                 cornerWidget         := QTabWidget_cornerWidget;
                 cornerWidget1        := QTabWidget_cornerWidget1;
                 elideMode            := QTabWidget_elideMode;
                 setElideMode         := QTabWidget_setElideMode;
                 iconSize             := QTabWidget_iconSize;
                 setIconSize          := QTabWidget_setIconSize;
                 usesScrollButtons    := QTabWidget_usesScrollButtons;
                 setUsesScrollButtons := QTabWidget_setUsesScrollButtons;
                 documentMode         := QTabWidget_documentMode;
                 setDocumentMode      := QTabWidget_setDocumentMode;
                 clear                := QTabWidget_clear;
                 setCurrentIndex      := QTabWidget_setCurrentIndex;
                 setCurrentWidget     := QTabWidget_setCurrentWidget;
                 destroyCxx           := Destroy_QTabWidget;
               END;


BEGIN
END QtTabWidget.
