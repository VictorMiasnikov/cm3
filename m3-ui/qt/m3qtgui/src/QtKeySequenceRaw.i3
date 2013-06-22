(*******************************************************************************
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 2.0.11
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
*******************************************************************************)

INTERFACE QtKeySequenceRaw;


IMPORT Ctypes AS C;




<* EXTERNAL New_QKeySequence0 *>
PROCEDURE New_QKeySequence0 (): QKeySequence;

<* EXTERNAL New_QKeySequence1 *>
PROCEDURE New_QKeySequence1 (key: ADDRESS; ): QKeySequence;

<* EXTERNAL New_QKeySequence2 *>
PROCEDURE New_QKeySequence2 (k1, k2, k3, k4: C.int; ): QKeySequence;

<* EXTERNAL New_QKeySequence3 *>
PROCEDURE New_QKeySequence3 (k1, k2, k3: C.int; ): QKeySequence;

<* EXTERNAL New_QKeySequence4 *>
PROCEDURE New_QKeySequence4 (k1, k2: C.int; ): QKeySequence;

<* EXTERNAL New_QKeySequence5 *>
PROCEDURE New_QKeySequence5 (k1: C.int; ): QKeySequence;

<* EXTERNAL New_QKeySequence6 *>
PROCEDURE New_QKeySequence6 (ks: ADDRESS; ): QKeySequence;

<* EXTERNAL New_QKeySequence7 *>
PROCEDURE New_QKeySequence7 (key: C.int; ): QKeySequence;

<* EXTERNAL Delete_QKeySequence *>
PROCEDURE Delete_QKeySequence (self: QKeySequence; );

<* EXTERNAL QKeySequence_count *>
PROCEDURE QKeySequence_count (self: QKeySequence; ): C.unsigned_int;

<* EXTERNAL QKeySequence_isEmpty *>
PROCEDURE QKeySequence_isEmpty (self: QKeySequence; ): BOOLEAN;

<* EXTERNAL QKeySequence_toString *>
PROCEDURE QKeySequence_toString (self: QKeySequence; format: C.int; ):
  ADDRESS;

<* EXTERNAL QKeySequence_toString1 *>
PROCEDURE QKeySequence_toString1 (self: QKeySequence; ): ADDRESS;

<* EXTERNAL FromString *>
PROCEDURE FromString (str: ADDRESS; format: C.int; ): ADDRESS;

<* EXTERNAL FromString1 *>
PROCEDURE FromString1 (str: ADDRESS; ): ADDRESS;

<* EXTERNAL QKeySequence_matches *>
PROCEDURE QKeySequence_matches (self: QKeySequence; seq: ADDRESS; ): C.int;

<* EXTERNAL Mnemonic *>
PROCEDURE Mnemonic (text: ADDRESS; ): ADDRESS;

<* EXTERNAL QKeySequence_isDetached *>
PROCEDURE QKeySequence_isDetached (self: QKeySequence; ): BOOLEAN;

TYPE QKeySequence <: ADDRESS;

END QtKeySequenceRaw.
