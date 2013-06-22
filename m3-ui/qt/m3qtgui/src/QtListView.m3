(*******************************************************************************
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 2.0.11
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
*******************************************************************************)

UNSAFE MODULE QtListView;


FROM QtSize IMPORT QSize;
IMPORT QtListViewRaw;
FROM QtAbstractItemModel IMPORT QModelIndex;
FROM QtWidget IMPORT QWidget;
FROM QtRect IMPORT QRect;
FROM QtAbstractItemView IMPORT ScrollHint;


IMPORT WeakRef;

PROCEDURE New_QListView0 (self: QListView; parent: QWidget; ): QListView =
  VAR
    result : ADDRESS;
    arg1tmp          := LOOPHOLE(parent.cxxObj, ADDRESS);
  BEGIN
    result := QtListViewRaw.New_QListView0(arg1tmp);

    self.cxxObj := result;
    EVAL WeakRef.FromRef(self, Cleanup_QListView);

    RETURN self;
  END New_QListView0;

PROCEDURE New_QListView1 (self: QListView; ): QListView =
  VAR result: ADDRESS;
  BEGIN
    result := QtListViewRaw.New_QListView1();

    self.cxxObj := result;
    EVAL WeakRef.FromRef(self, Cleanup_QListView);

    RETURN self;
  END New_QListView1;

PROCEDURE Delete_QListView (self: QListView; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtListViewRaw.Delete_QListView(selfAdr);
  END Delete_QListView;

PROCEDURE QListView_setMovement (self: QListView; movement: Movement; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtListViewRaw.QListView_setMovement(selfAdr, ORD(movement));
  END QListView_setMovement;

PROCEDURE QListView_movement (self: QListView; ): Movement =
  VAR
    ret    : INTEGER;
    result : Movement;
    selfAdr: ADDRESS  := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtListViewRaw.QListView_movement(selfAdr);
    result := VAL(ret, Movement);
    RETURN result;
  END QListView_movement;

PROCEDURE QListView_setFlow (self: QListView; flow: Flow; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtListViewRaw.QListView_setFlow(selfAdr, ORD(flow));
  END QListView_setFlow;

PROCEDURE QListView_flow (self: QListView; ): Flow =
  VAR
    ret    : INTEGER;
    result : Flow;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtListViewRaw.QListView_flow(selfAdr);
    result := VAL(ret, Flow);
    RETURN result;
  END QListView_flow;

PROCEDURE QListView_setWrapping (self: QListView; enable: BOOLEAN; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtListViewRaw.QListView_setWrapping(selfAdr, enable);
  END QListView_setWrapping;

PROCEDURE QListView_isWrapping (self: QListView; ): BOOLEAN =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    RETURN QtListViewRaw.QListView_isWrapping(selfAdr);
  END QListView_isWrapping;

PROCEDURE QListView_setResizeMode (self: QListView; mode: ResizeMode; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtListViewRaw.QListView_setResizeMode(selfAdr, ORD(mode));
  END QListView_setResizeMode;

PROCEDURE QListView_resizeMode (self: QListView; ): ResizeMode =
  VAR
    ret    : INTEGER;
    result : ResizeMode;
    selfAdr: ADDRESS    := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtListViewRaw.QListView_resizeMode(selfAdr);
    result := VAL(ret, ResizeMode);
    RETURN result;
  END QListView_resizeMode;

PROCEDURE QListView_setLayoutMode (self: QListView; mode: LayoutMode; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtListViewRaw.QListView_setLayoutMode(selfAdr, ORD(mode));
  END QListView_setLayoutMode;

PROCEDURE QListView_layoutMode (self: QListView; ): LayoutMode =
  VAR
    ret    : INTEGER;
    result : LayoutMode;
    selfAdr: ADDRESS    := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtListViewRaw.QListView_layoutMode(selfAdr);
    result := VAL(ret, LayoutMode);
    RETURN result;
  END QListView_layoutMode;

PROCEDURE QListView_setSpacing (self: QListView; space: INTEGER; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtListViewRaw.QListView_setSpacing(selfAdr, space);
  END QListView_setSpacing;

PROCEDURE QListView_spacing (self: QListView; ): INTEGER =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    RETURN QtListViewRaw.QListView_spacing(selfAdr);
  END QListView_spacing;

PROCEDURE QListView_setBatchSize (self: QListView; batchSize: INTEGER; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtListViewRaw.QListView_setBatchSize(selfAdr, batchSize);
  END QListView_setBatchSize;

PROCEDURE QListView_batchSize (self: QListView; ): INTEGER =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    RETURN QtListViewRaw.QListView_batchSize(selfAdr);
  END QListView_batchSize;

PROCEDURE QListView_setGridSize (self: QListView; size: QSize; ) =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(size.cxxObj, ADDRESS);
  BEGIN
    QtListViewRaw.QListView_setGridSize(selfAdr, arg2tmp);
  END QListView_setGridSize;

PROCEDURE QListView_gridSize (self: QListView; ): QSize =
  VAR
    ret    : ADDRESS;
    result : QSize;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtListViewRaw.QListView_gridSize(selfAdr);

    result := NEW(QSize);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END QListView_gridSize;

PROCEDURE QListView_setViewMode (self: QListView; mode: ViewMode; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtListViewRaw.QListView_setViewMode(selfAdr, ORD(mode));
  END QListView_setViewMode;

PROCEDURE QListView_viewMode (self: QListView; ): ViewMode =
  VAR
    ret    : INTEGER;
    result : ViewMode;
    selfAdr: ADDRESS  := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtListViewRaw.QListView_viewMode(selfAdr);
    result := VAL(ret, ViewMode);
    RETURN result;
  END QListView_viewMode;

PROCEDURE QListView_clearPropertyFlags (self: QListView; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtListViewRaw.QListView_clearPropertyFlags(selfAdr);
  END QListView_clearPropertyFlags;

PROCEDURE QListView_isRowHidden (self: QListView; row: INTEGER; ):
  BOOLEAN =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    RETURN QtListViewRaw.QListView_isRowHidden(selfAdr, row);
  END QListView_isRowHidden;

PROCEDURE QListView_setRowHidden
  (self: QListView; row: INTEGER; hide: BOOLEAN; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtListViewRaw.QListView_setRowHidden(selfAdr, row, hide);
  END QListView_setRowHidden;

PROCEDURE QListView_setModelColumn (self: QListView; column: INTEGER; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtListViewRaw.QListView_setModelColumn(selfAdr, column);
  END QListView_setModelColumn;

PROCEDURE QListView_modelColumn (self: QListView; ): INTEGER =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    RETURN QtListViewRaw.QListView_modelColumn(selfAdr);
  END QListView_modelColumn;

PROCEDURE QListView_setUniformItemSizes
  (self: QListView; enable: BOOLEAN; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtListViewRaw.QListView_setUniformItemSizes(selfAdr, enable);
  END QListView_setUniformItemSizes;

PROCEDURE QListView_uniformItemSizes (self: QListView; ): BOOLEAN =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    RETURN QtListViewRaw.QListView_uniformItemSizes(selfAdr);
  END QListView_uniformItemSizes;

PROCEDURE QListView_setWordWrap (self: QListView; on: BOOLEAN; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtListViewRaw.QListView_setWordWrap(selfAdr, on);
  END QListView_setWordWrap;

PROCEDURE QListView_wordWrap (self: QListView; ): BOOLEAN =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    RETURN QtListViewRaw.QListView_wordWrap(selfAdr);
  END QListView_wordWrap;

PROCEDURE QListView_setSelectionRectVisible
  (self: QListView; show: BOOLEAN; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtListViewRaw.QListView_setSelectionRectVisible(selfAdr, show);
  END QListView_setSelectionRectVisible;

PROCEDURE QListView_isSelectionRectVisible (self: QListView; ): BOOLEAN =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    RETURN QtListViewRaw.QListView_isSelectionRectVisible(selfAdr);
  END QListView_isSelectionRectVisible;

PROCEDURE QListView_visualRect (self: QListView; index: QModelIndex; ):
  QRect =
  VAR
    ret    : ADDRESS;
    result : QRect;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(index.cxxObj, ADDRESS);
  BEGIN
    ret := QtListViewRaw.QListView_visualRect(selfAdr, arg2tmp);

    result := NEW(QRect);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END QListView_visualRect;

PROCEDURE QListView_scrollTo
  (self: QListView; index: QModelIndex; hint: ScrollHint; ) =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(index.cxxObj, ADDRESS);
  BEGIN
    QtListViewRaw.QListView_scrollTo(selfAdr, arg2tmp, ORD(hint));
  END QListView_scrollTo;

PROCEDURE QListView_scrollTo1 (self: QListView; index: QModelIndex; ) =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(index.cxxObj, ADDRESS);
  BEGIN
    QtListViewRaw.QListView_scrollTo1(selfAdr, arg2tmp);
  END QListView_scrollTo1;

PROCEDURE QListView_doItemsLayout (self: QListView; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtListViewRaw.QListView_doItemsLayout(selfAdr);
  END QListView_doItemsLayout;

PROCEDURE QListView_reset (self: QListView; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtListViewRaw.QListView_reset(selfAdr);
  END QListView_reset;

PROCEDURE QListView_setRootIndex (self: QListView; index: QModelIndex; ) =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(index.cxxObj, ADDRESS);
  BEGIN
    QtListViewRaw.QListView_setRootIndex(selfAdr, arg2tmp);
  END QListView_setRootIndex;

PROCEDURE Cleanup_QListView
  (<* UNUSED *> READONLY self: WeakRef.T; ref: REFANY) =
  VAR obj: QListView := ref;
  BEGIN
    Delete_QListView(obj);
  END Cleanup_QListView;

PROCEDURE Destroy_QListView (self: QListView) =
  BEGIN
    EVAL WeakRef.FromRef(self, Cleanup_QListView);
  END Destroy_QListView;

REVEAL
  QListView =
    QListViewPublic BRANDED OBJECT
    OVERRIDES
      init_0                  := New_QListView0;
      init_1                  := New_QListView1;
      setMovement             := QListView_setMovement;
      movement                := QListView_movement;
      setFlow                 := QListView_setFlow;
      flow                    := QListView_flow;
      setWrapping             := QListView_setWrapping;
      isWrapping              := QListView_isWrapping;
      setResizeMode           := QListView_setResizeMode;
      resizeMode              := QListView_resizeMode;
      setLayoutMode           := QListView_setLayoutMode;
      layoutMode              := QListView_layoutMode;
      setSpacing              := QListView_setSpacing;
      spacing                 := QListView_spacing;
      setBatchSize            := QListView_setBatchSize;
      batchSize               := QListView_batchSize;
      setGridSize             := QListView_setGridSize;
      gridSize                := QListView_gridSize;
      setViewMode             := QListView_setViewMode;
      viewMode                := QListView_viewMode;
      clearPropertyFlags      := QListView_clearPropertyFlags;
      isRowHidden             := QListView_isRowHidden;
      setRowHidden            := QListView_setRowHidden;
      setModelColumn          := QListView_setModelColumn;
      modelColumn             := QListView_modelColumn;
      setUniformItemSizes     := QListView_setUniformItemSizes;
      uniformItemSizes        := QListView_uniformItemSizes;
      setWordWrap             := QListView_setWordWrap;
      wordWrap                := QListView_wordWrap;
      setSelectionRectVisible := QListView_setSelectionRectVisible;
      isSelectionRectVisible  := QListView_isSelectionRectVisible;
      visualRect              := QListView_visualRect;
      scrollTo                := QListView_scrollTo;
      scrollTo1               := QListView_scrollTo1;
      doItemsLayout           := QListView_doItemsLayout;
      reset                   := QListView_reset;
      setRootIndex            := QListView_setRootIndex;
      destroyCxx              := Destroy_QListView;
    END;


BEGIN
END QtListView.
