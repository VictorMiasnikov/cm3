(*******************************************************************************
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 2.0.11
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
*******************************************************************************)

INTERFACE QtMdiAreaRaw;




IMPORT Ctypes AS C;


<* EXTERNAL New_QMdiArea0 *>
PROCEDURE New_QMdiArea0 (parent: ADDRESS; ): QMdiArea;

<* EXTERNAL New_QMdiArea1 *>
PROCEDURE New_QMdiArea1 (): QMdiArea;

<* EXTERNAL Delete_QMdiArea *>
PROCEDURE Delete_QMdiArea (self: QMdiArea; );

<* EXTERNAL QMdiArea_sizeHint *>
PROCEDURE QMdiArea_sizeHint (self: QMdiArea; ): ADDRESS;

<* EXTERNAL QMdiArea_minimumSizeHint *>
PROCEDURE QMdiArea_minimumSizeHint (self: QMdiArea; ): ADDRESS;

<* EXTERNAL QMdiArea_currentSubWindow *>
PROCEDURE QMdiArea_currentSubWindow (self: QMdiArea; ): ADDRESS;

<* EXTERNAL QMdiArea_activeSubWindow *>
PROCEDURE QMdiArea_activeSubWindow (self: QMdiArea; ): ADDRESS;

<* EXTERNAL QMdiArea_addSubWindow *>
PROCEDURE QMdiArea_addSubWindow
  (self: QMdiArea; widget: ADDRESS; flags: C.int; ): ADDRESS;

<* EXTERNAL QMdiArea_addSubWindow1 *>
PROCEDURE QMdiArea_addSubWindow1 (self: QMdiArea; widget: ADDRESS; ):
  ADDRESS;

<* EXTERNAL QMdiArea_removeSubWindow *>
PROCEDURE QMdiArea_removeSubWindow (self: QMdiArea; widget: ADDRESS; );

<* EXTERNAL QMdiArea_background *>
PROCEDURE QMdiArea_background (self: QMdiArea; ): ADDRESS;

<* EXTERNAL QMdiArea_setBackground *>
PROCEDURE QMdiArea_setBackground (self: QMdiArea; background: ADDRESS; );

<* EXTERNAL QMdiArea_activationOrder *>
PROCEDURE QMdiArea_activationOrder (self: QMdiArea; ): C.int;

<* EXTERNAL QMdiArea_setActivationOrder *>
PROCEDURE QMdiArea_setActivationOrder (self: QMdiArea; order: C.int; );

<* EXTERNAL QMdiArea_setOption *>
PROCEDURE QMdiArea_setOption
  (self: QMdiArea; option: C.int; on: BOOLEAN; );

<* EXTERNAL QMdiArea_setOption1 *>
PROCEDURE QMdiArea_setOption1 (self: QMdiArea; option: C.int; );

<* EXTERNAL QMdiArea_testOption *>
PROCEDURE QMdiArea_testOption (self: QMdiArea; opton: C.int; ): BOOLEAN;

<* EXTERNAL QMdiArea_setViewMode *>
PROCEDURE QMdiArea_setViewMode (self: QMdiArea; mode: C.int; );

<* EXTERNAL QMdiArea_viewMode *>
PROCEDURE QMdiArea_viewMode (self: QMdiArea; ): C.int;

<* EXTERNAL QMdiArea_documentMode *>
PROCEDURE QMdiArea_documentMode (self: QMdiArea; ): BOOLEAN;

<* EXTERNAL QMdiArea_setDocumentMode *>
PROCEDURE QMdiArea_setDocumentMode (self: QMdiArea; enabled: BOOLEAN; );

<* EXTERNAL QMdiArea_setTabShape *>
PROCEDURE QMdiArea_setTabShape (self: QMdiArea; shape: C.int; );

<* EXTERNAL QMdiArea_tabShape *>
PROCEDURE QMdiArea_tabShape (self: QMdiArea; ): C.int;

<* EXTERNAL QMdiArea_setTabPosition *>
PROCEDURE QMdiArea_setTabPosition (self: QMdiArea; position: C.int; );

<* EXTERNAL QMdiArea_tabPosition *>
PROCEDURE QMdiArea_tabPosition (self: QMdiArea; ): C.int;

<* EXTERNAL QMdiArea_setActiveSubWindow *>
PROCEDURE QMdiArea_setActiveSubWindow (self: QMdiArea; window: ADDRESS; );

<* EXTERNAL QMdiArea_tileSubWindows *>
PROCEDURE QMdiArea_tileSubWindows (self: QMdiArea; );

<* EXTERNAL QMdiArea_cascadeSubWindows *>
PROCEDURE QMdiArea_cascadeSubWindows (self: QMdiArea; );

<* EXTERNAL QMdiArea_closeActiveSubWindow *>
PROCEDURE QMdiArea_closeActiveSubWindow (self: QMdiArea; );

<* EXTERNAL QMdiArea_closeAllSubWindows *>
PROCEDURE QMdiArea_closeAllSubWindows (self: QMdiArea; );

<* EXTERNAL QMdiArea_activateNextSubWindow *>
PROCEDURE QMdiArea_activateNextSubWindow (self: QMdiArea; );

<* EXTERNAL QMdiArea_activatePreviousSubWindow *>
PROCEDURE QMdiArea_activatePreviousSubWindow (self: QMdiArea; );

TYPE QMdiArea = ADDRESS;

END QtMdiAreaRaw.
