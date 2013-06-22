(*******************************************************************************
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 2.0.11
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
*******************************************************************************)

INTERFACE QtProgressDialogRaw;


IMPORT Ctypes AS C;




<* EXTERNAL New_QProgressDialog0 *>
PROCEDURE New_QProgressDialog0 (parent: ADDRESS; flags: C.int; ):
  QProgressDialog;

<* EXTERNAL New_QProgressDialog1 *>
PROCEDURE New_QProgressDialog1 (parent: ADDRESS; ): QProgressDialog;

<* EXTERNAL New_QProgressDialog2 *>
PROCEDURE New_QProgressDialog2 (): QProgressDialog;

<* EXTERNAL New_QProgressDialog3 *>
PROCEDURE New_QProgressDialog3 (labelText, cancelButtonText: ADDRESS;
                                minimum, maximum           : C.int;
                                parent                     : ADDRESS;
                                flags                      : C.int;   ):
  QProgressDialog;

<* EXTERNAL New_QProgressDialog4 *>
PROCEDURE New_QProgressDialog4 (labelText, cancelButtonText: ADDRESS;
                                minimum, maximum           : C.int;
                                parent                     : ADDRESS; ):
  QProgressDialog;

<* EXTERNAL New_QProgressDialog5 *>
PROCEDURE New_QProgressDialog5
  (labelText, cancelButtonText: ADDRESS; minimum, maximum: C.int; ):
  QProgressDialog;

<* EXTERNAL Delete_QProgressDialog *>
PROCEDURE Delete_QProgressDialog (self: QProgressDialog; );

<* EXTERNAL QProgressDialog_setLabel *>
PROCEDURE QProgressDialog_setLabel
  (self: QProgressDialog; label: ADDRESS; );

<* EXTERNAL QProgressDialog_setCancelButton *>
PROCEDURE QProgressDialog_setCancelButton
  (self: QProgressDialog; button: ADDRESS; );

<* EXTERNAL QProgressDialog_setBar *>
PROCEDURE QProgressDialog_setBar (self: QProgressDialog; bar: ADDRESS; );

<* EXTERNAL QProgressDialog_wasCanceled *>
PROCEDURE QProgressDialog_wasCanceled (self: QProgressDialog; ): BOOLEAN;

<* EXTERNAL QProgressDialog_minimum *>
PROCEDURE QProgressDialog_minimum (self: QProgressDialog; ): C.int;

<* EXTERNAL QProgressDialog_maximum *>
PROCEDURE QProgressDialog_maximum (self: QProgressDialog; ): C.int;

<* EXTERNAL QProgressDialog_value *>
PROCEDURE QProgressDialog_value (self: QProgressDialog; ): C.int;

<* EXTERNAL QProgressDialog_sizeHint *>
PROCEDURE QProgressDialog_sizeHint (self: QProgressDialog; ): ADDRESS;

<* EXTERNAL QProgressDialog_labelText *>
PROCEDURE QProgressDialog_labelText (self: QProgressDialog; ): ADDRESS;

<* EXTERNAL QProgressDialog_minimumDuration *>
PROCEDURE QProgressDialog_minimumDuration (self: QProgressDialog; ): C.int;

<* EXTERNAL QProgressDialog_setAutoReset *>
PROCEDURE QProgressDialog_setAutoReset
  (self: QProgressDialog; reset: BOOLEAN; );

<* EXTERNAL QProgressDialog_autoReset *>
PROCEDURE QProgressDialog_autoReset (self: QProgressDialog; ): BOOLEAN;

<* EXTERNAL QProgressDialog_setAutoClose *>
PROCEDURE QProgressDialog_setAutoClose
  (self: QProgressDialog; close: BOOLEAN; );

<* EXTERNAL QProgressDialog_autoClose *>
PROCEDURE QProgressDialog_autoClose (self: QProgressDialog; ): BOOLEAN;

<* EXTERNAL QProgressDialog_open0_0 *>
PROCEDURE QProgressDialog_open0_0 (self: QProgressDialog; );

<* EXTERNAL QProgressDialog_open1 *>
PROCEDURE QProgressDialog_open1
  (self: QProgressDialog; receiver: ADDRESS; member: C.char_star; );

<* EXTERNAL QProgressDialog_cancel *>
PROCEDURE QProgressDialog_cancel (self: QProgressDialog; );

<* EXTERNAL QProgressDialog_reset *>
PROCEDURE QProgressDialog_reset (self: QProgressDialog; );

<* EXTERNAL QProgressDialog_setMaximum *>
PROCEDURE QProgressDialog_setMaximum
  (self: QProgressDialog; maximum: C.int; );

<* EXTERNAL QProgressDialog_setMinimum *>
PROCEDURE QProgressDialog_setMinimum
  (self: QProgressDialog; minimum: C.int; );

<* EXTERNAL QProgressDialog_setRange *>
PROCEDURE QProgressDialog_setRange
  (self: QProgressDialog; minimum, maximum: C.int; );

<* EXTERNAL QProgressDialog_setValue *>
PROCEDURE QProgressDialog_setValue
  (self: QProgressDialog; progress: C.int; );

<* EXTERNAL QProgressDialog_setLabelText *>
PROCEDURE QProgressDialog_setLabelText
  (self: QProgressDialog; text: ADDRESS; );

<* EXTERNAL QProgressDialog_setCancelButtonText *>
PROCEDURE QProgressDialog_setCancelButtonText
  (self: QProgressDialog; text: ADDRESS; );

<* EXTERNAL QProgressDialog_setMinimumDuration *>
PROCEDURE QProgressDialog_setMinimumDuration
  (self: QProgressDialog; ms: C.int; );

TYPE QProgressDialog = ADDRESS;

END QtProgressDialogRaw.
