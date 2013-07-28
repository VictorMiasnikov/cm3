(*******************************************************************************
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 2.0.4
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
*******************************************************************************)

INTERFACE QtProgressBarRaw;


IMPORT Ctypes AS C;




<* EXTERNAL New_QProgressBar0 *>
PROCEDURE New_QProgressBar0 (parent: ADDRESS; ): QProgressBar;

<* EXTERNAL New_QProgressBar1 *>
PROCEDURE New_QProgressBar1 (): QProgressBar;

<* EXTERNAL QProgressBar_minimum *>
PROCEDURE QProgressBar_minimum (self: QProgressBar; ): C.int;

<* EXTERNAL QProgressBar_maximum *>
PROCEDURE QProgressBar_maximum (self: QProgressBar; ): C.int;

<* EXTERNAL QProgressBar_value *>
PROCEDURE QProgressBar_value (self: QProgressBar; ): C.int;

<* EXTERNAL QProgressBar_text *>
PROCEDURE QProgressBar_text (self: QProgressBar; ): ADDRESS;

<* EXTERNAL QProgressBar_setTextVisible *>
PROCEDURE QProgressBar_setTextVisible
  (self: QProgressBar; visible: BOOLEAN; );

<* EXTERNAL QProgressBar_isTextVisible *>
PROCEDURE QProgressBar_isTextVisible (self: QProgressBar; ): BOOLEAN;

<* EXTERNAL QProgressBar_alignment *>
PROCEDURE QProgressBar_alignment (self: QProgressBar; ): C.int;

<* EXTERNAL QProgressBar_setAlignment *>
PROCEDURE QProgressBar_setAlignment
  (self: QProgressBar; alignment: C.int; );

<* EXTERNAL QProgressBar_sizeHint *>
PROCEDURE QProgressBar_sizeHint (self: QProgressBar; ): ADDRESS;

<* EXTERNAL QProgressBar_minimumSizeHint *>
PROCEDURE QProgressBar_minimumSizeHint (self: QProgressBar; ): ADDRESS;

<* EXTERNAL QProgressBar_orientation *>
PROCEDURE QProgressBar_orientation (self: QProgressBar; ): C.int;

<* EXTERNAL QProgressBar_setInvertedAppearance *>
PROCEDURE QProgressBar_setInvertedAppearance
  (self: QProgressBar; invert: BOOLEAN; );

<* EXTERNAL QProgressBar_invertedAppearance *>
PROCEDURE QProgressBar_invertedAppearance (self: QProgressBar; ): BOOLEAN;

<* EXTERNAL QProgressBar_invertedAppearance1 *>
PROCEDURE QProgressBar_invertedAppearance1 (self: QProgressBar; ): BOOLEAN;

<* EXTERNAL QProgressBar_setTextDirection *>
PROCEDURE QProgressBar_setTextDirection
  (self: QProgressBar; textDirection: C.int; );

<* EXTERNAL QProgressBar_textDirection *>
PROCEDURE QProgressBar_textDirection (self: QProgressBar; ): C.int;

<* EXTERNAL QProgressBar_textDirection1 *>
PROCEDURE QProgressBar_textDirection1 (self: QProgressBar; ): C.int;

<* EXTERNAL QProgressBar_setFormat *>
PROCEDURE QProgressBar_setFormat (self: QProgressBar; format: ADDRESS; );

<* EXTERNAL QProgressBar_format *>
PROCEDURE QProgressBar_format (self: QProgressBar; ): ADDRESS;

<* EXTERNAL QProgressBar_reset *>
PROCEDURE QProgressBar_reset (self: QProgressBar; );

<* EXTERNAL QProgressBar_setRange *>
PROCEDURE QProgressBar_setRange
  (self: QProgressBar; minimum, maximum: C.int; );

<* EXTERNAL QProgressBar_setMinimum *>
PROCEDURE QProgressBar_setMinimum (self: QProgressBar; minimum: C.int; );

<* EXTERNAL QProgressBar_setMaximum *>
PROCEDURE QProgressBar_setMaximum (self: QProgressBar; maximum: C.int; );

<* EXTERNAL QProgressBar_setValue *>
PROCEDURE QProgressBar_setValue (self: QProgressBar; value: C.int; );

<* EXTERNAL QProgressBar_setOrientation *>
PROCEDURE QProgressBar_setOrientation (self: QProgressBar; arg2: C.int; );

<* EXTERNAL Delete_QProgressBar *>
PROCEDURE Delete_QProgressBar (self: QProgressBar; );

TYPE QProgressBar = ADDRESS;

END QtProgressBarRaw.
