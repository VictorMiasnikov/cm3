(*******************************************************************************
 * This file was automatically generated by SWIG (http://www.swig.org/).
 * Version: 1.3.22
 *
 * Do not make changes to this file unless you know what you are doing --
 * modify the SWIG interface file instead.
 *******************************************************************************)

INTERFACE LongRealFFTWRaw;

IMPORT Ctypes AS C;
IMPORT Cstdio;


IMPORT LongReal AS R;


TYPE
  Plan <: ADDRESS;
  Complex =
    RECORD re, im: R.T;  END;    (* compliant to 'arithmetic' library *)
  IODim = RECORD n, is, os: CARDINAL;  END;


<* EXTERNAL fftw_execute *>
PROCEDURE Execute (p: Plan; );

<* EXTERNAL fftw_plan_dft_1d *>
PROCEDURE PlanDFT1D (         n    : C.int;
                     READONLY in   : (* ARRAY OF *) Complex;
                     VAR      out  : (* ARRAY OF *) Complex;
                              sign : C.int;
                              flags: C.unsigned_int;         ): Plan;

<* EXTERNAL fftw_plan_dft_2d *>
PROCEDURE PlanDFT2D (         nx, ny: C.int;
                     READONLY in    : (* ARRAY OF ARRAY OF *) Complex;
                     VAR      out   : (* ARRAY OF ARRAY OF *) Complex;
                              sign  : C.int;
                              flags : C.unsigned_int;                  ):
  Plan;

<* EXTERNAL fftw_plan_dft_3d *>
PROCEDURE PlanDFT3D (nx, ny, nz: C.int;
                     READONLY in: (* ARRAY OF ARRAY OF ARRAY OF *) Complex;
                     VAR out  : (* ARRAY OF ARRAY OF ARRAY OF *) Complex;
                         sign : C.int;
                         flags: C.unsigned_int;                           ):
  Plan;

<* EXTERNAL fftw_plan_dft_r2c_1d *>
PROCEDURE PlanDFTR2C1D (         n    : C.int;
                        READONLY in   : C.double;
                        VAR      out  : (* ARRAY OF *) Complex;
                                 flags: C.unsigned_int;         ): Plan;

<* EXTERNAL fftw_plan_dft_r2c_2d *>
PROCEDURE PlanDFTR2C2D (         nx, ny: C.int;
                        READONLY in    : C.double;
                        VAR      out   : (* ARRAY OF ARRAY OF *) Complex;
                                 flags : C.unsigned_int;                  ):
  Plan;

<* EXTERNAL fftw_plan_dft_r2c_3d *>
PROCEDURE PlanDFTR2C3D (         nx, ny, nz: C.int;
                        READONLY in        : C.double;
                        VAR out: (* ARRAY OF ARRAY OF ARRAY OF *) Complex;
                        flags: C.unsigned_int; ): Plan;

<* EXTERNAL fftw_plan_dft_c2r_1d *>
PROCEDURE PlanDFTC2R1D (         n    : C.int;
                        READONLY in   : (* ARRAY OF *) Complex;
                        VAR      out  : C.double;
                                 flags: C.unsigned_int;         ): Plan;

<* EXTERNAL fftw_plan_dft_c2r_2d *>
PROCEDURE PlanDFTC2R2D (         nx, ny: C.int;
                        READONLY in    : (* ARRAY OF ARRAY OF *) Complex;
                        VAR      out   : C.double;
                                 flags : C.unsigned_int;                  ):
  Plan;

<* EXTERNAL fftw_plan_dft_c2r_3d *>
PROCEDURE PlanDFTC2R3D (nx, ny, nz: C.int;
                        READONLY in: (* ARRAY OF ARRAY OF ARRAY OF *) Complex;
                        VAR out  : C.double;
                            flags: C.unsigned_int; ): Plan;

<* EXTERNAL fftw_plan_r2r_1d *>
PROCEDURE PlanR2R1D (         n    : C.int;
                     READONLY in   : C.double;
                     VAR      out  : C.double;
                              kind : C.int (* fftw_r2r_kind *);
                              flags: C.unsigned_int;            ): Plan;

<* EXTERNAL fftw_plan_r2r_2d *>
PROCEDURE PlanR2R2D (         nx, ny      : C.int;
                     READONLY in          : C.double;
                     VAR      out         : C.double;
                              kindx, kindy: C.int (* fftw_r2r_kind *);
                              flags       : C.unsigned_int;            ):
  Plan;

<* EXTERNAL fftw_plan_r2r_3d *>
PROCEDURE PlanR2R3D (         nx, ny, nz: C.int;
                     READONLY in        : C.double;
                     VAR      out       : C.double;
                     kindx, kindy, kindz: C.int (* fftw_r2r_kind *);
                     flags              : C.unsigned_int;            ):
  Plan;

<* EXTERNAL fftw_destroy_plan *>
PROCEDURE DestroyPlan (p: Plan; );

<* EXTERNAL fftw_forget_wisdom *>
PROCEDURE ForgetWisdom ();

<* EXTERNAL fftw_cleanup *>
PROCEDURE Cleanup ();

<* EXTERNAL fftw_export_wisdom_to_file *>
PROCEDURE ExportWisdomToFile (output_file: Cstdio.FILE_star; );

<* EXTERNAL fftw_export_wisdom_to_string *>
PROCEDURE ExportWisdomToString (): C.char_star;

<* EXTERNAL fftw_export_wisdom *>
PROCEDURE ExportWisdom (VAR write_char: PROCEDURE (c: CHAR; buf: ADDRESS; );
                        data: ADDRESS; );

<* EXTERNAL fftw_import_system_wisdom *>
PROCEDURE ImportSystemWisdom (): C.int;

<* EXTERNAL fftw_import_wisdom_from_file *>
PROCEDURE ImportWisdomFromFile (input_file: Cstdio.FILE_star; ): C.int;

<* EXTERNAL fftw_import_wisdom_from_string *>
PROCEDURE ImportWisdomFromString (input_string: C.char_star; ): C.int;

<* EXTERNAL fftw_import_wisdom *>
PROCEDURE ImportWisdom (VAR read_char: PROCEDURE (buf: ADDRESS; ): CARDINAL;
                        data: ADDRESS; ): C.int;

<* EXTERNAL fftw_fprint_plan *>
PROCEDURE FPrintPlan (p: Plan; output_file: Cstdio.FILE_star; );

<* EXTERNAL fftw_print_plan *>
PROCEDURE PrintPlan (p: Plan; );

<* EXTERNAL fftw_flops *>
PROCEDURE Flops (p: Plan; VAR add, mul, fma: C.double; );

<* EXTERNAL *>
VAR
  fftw_version: C.char_star;

<* EXTERNAL *>
VAR
  fftw_cc: C.char_star;

<* EXTERNAL *>
VAR
  fftw_codelet_optim: C.char_star;

END LongRealFFTWRaw.