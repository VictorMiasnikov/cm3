(*******************************************************************************
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 2.0.4
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
*******************************************************************************)

INTERFACE QtRegionRaw;


IMPORT Ctypes AS C;




<* EXTERNAL New_QRegion0 *>
PROCEDURE New_QRegion0 (): QRegion;

<* EXTERNAL New_QRegion1 *>
PROCEDURE New_QRegion1 (x, y, w, h, t: C.int; ): QRegion;

<* EXTERNAL New_QRegion2 *>
PROCEDURE New_QRegion2 (x, y, w, h: C.int; ): QRegion;

<* EXTERNAL New_QRegion3 *>
PROCEDURE New_QRegion3 (r: ADDRESS; t: C.int; ): QRegion;

<* EXTERNAL New_QRegion4 *>
PROCEDURE New_QRegion4 (r: ADDRESS; ): QRegion;

<* EXTERNAL New_QRegion5 *>
PROCEDURE New_QRegion5 (pa: ADDRESS; fillRule: C.int; ): QRegion;

<* EXTERNAL New_QRegion6 *>
PROCEDURE New_QRegion6 (pa: ADDRESS; ): QRegion;

<* EXTERNAL New_QRegion7 *>
PROCEDURE New_QRegion7 (region: ADDRESS; ): QRegion;

<* EXTERNAL New_QRegion8 *>
PROCEDURE New_QRegion8 (READONLY bitmap: REFANY; ): QRegion;

<* EXTERNAL Delete_QRegion *>
PROCEDURE Delete_QRegion (self: QRegion; );

<* EXTERNAL QRegion_swap *>
PROCEDURE QRegion_swap (self: QRegion; other: ADDRESS; );

<* EXTERNAL QRegion_isEmpty *>
PROCEDURE QRegion_isEmpty (self: QRegion; ): BOOLEAN;

<* EXTERNAL QRegion_contains *>
PROCEDURE QRegion_contains (self: QRegion; p: ADDRESS; ): BOOLEAN;

<* EXTERNAL QRegion_contains1 *>
PROCEDURE QRegion_contains1 (self: QRegion; r: ADDRESS; ): BOOLEAN;

<* EXTERNAL QRegion_translate *>
PROCEDURE QRegion_translate (self: QRegion; dx, dy: C.int; );

<* EXTERNAL QRegion_translate1 *>
PROCEDURE QRegion_translate1 (self: QRegion; p: ADDRESS; );

<* EXTERNAL QRegion_translated *>
PROCEDURE QRegion_translated (self: QRegion; dx, dy: C.int; ): ADDRESS;

<* EXTERNAL QRegion_translated1 *>
PROCEDURE QRegion_translated1 (self: QRegion; p: ADDRESS; ): ADDRESS;

<* EXTERNAL QRegion_unite *>
PROCEDURE QRegion_unite (self: QRegion; r: ADDRESS; ): ADDRESS;

<* EXTERNAL QRegion_unite1 *>
PROCEDURE QRegion_unite1 (self: QRegion; r: ADDRESS; ): ADDRESS;

<* EXTERNAL QRegion_intersect *>
PROCEDURE QRegion_intersect (self: QRegion; r: ADDRESS; ): ADDRESS;

<* EXTERNAL QRegion_intersect1 *>
PROCEDURE QRegion_intersect1 (self: QRegion; r: ADDRESS; ): ADDRESS;

<* EXTERNAL QRegion_subtract *>
PROCEDURE QRegion_subtract (self: QRegion; r: ADDRESS; ): ADDRESS;

<* EXTERNAL QRegion_eor *>
PROCEDURE QRegion_eor (self: QRegion; r: ADDRESS; ): ADDRESS;

<* EXTERNAL QRegion_united *>
PROCEDURE QRegion_united (self: QRegion; r: ADDRESS; ): ADDRESS;

<* EXTERNAL QRegion_united1 *>
PROCEDURE QRegion_united1 (self: QRegion; r: ADDRESS; ): ADDRESS;

<* EXTERNAL QRegion_intersected *>
PROCEDURE QRegion_intersected (self: QRegion; r: ADDRESS; ): ADDRESS;

<* EXTERNAL QRegion_intersected1 *>
PROCEDURE QRegion_intersected1 (self: QRegion; r: ADDRESS; ): ADDRESS;

<* EXTERNAL QRegion_subtracted *>
PROCEDURE QRegion_subtracted (self: QRegion; r: ADDRESS; ): ADDRESS;

<* EXTERNAL QRegion_xored *>
PROCEDURE QRegion_xored (self: QRegion; r: ADDRESS; ): ADDRESS;

<* EXTERNAL QRegion_intersects *>
PROCEDURE QRegion_intersects (self: QRegion; r: ADDRESS; ): BOOLEAN;

<* EXTERNAL QRegion_intersects1 *>
PROCEDURE QRegion_intersects1 (self: QRegion; r: ADDRESS; ): BOOLEAN;

<* EXTERNAL QRegion_boundingRect *>
PROCEDURE QRegion_boundingRect (self: QRegion; ): ADDRESS;

<* EXTERNAL QRegion_setRects *>
PROCEDURE QRegion_setRects (self: QRegion; rect: ADDRESS; num: C.int; );

<* EXTERNAL QRegion_rectCount *>
PROCEDURE QRegion_rectCount (self: QRegion; ): C.int;

TYPE QRegion <: ADDRESS;

END QtRegionRaw.
