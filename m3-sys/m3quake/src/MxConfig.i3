(* Copyright 1996-2000 Critical Mass, Inc. All rights reserved.    *)
(* See file COPYRIGHT-CMASS for details. *)

INTERFACE MxConfig;

IMPORT M3xConfig; (* generated by m3makefile, the ok static part of the former M3Config *)

CONST
    Filename = "cm3.cfg";
    HOST = M3xConfig.HOST;
    HOST_OS_TYPE = M3xConfig.HOST_OS_TYPE;
    HOST_WORD_SIZE = M3xConfig.HOST_WORD_SIZE;
    HOST_PATH_SEP = M3xConfig.HOST_PATH_SEP;

PROCEDURE FindFile (): TEXT;
(* Returns a path to the current configuration file.  If no
   configuration file is found, "NIL" is returned. *)

PROCEDURE Get (param: TEXT): TEXT;
(* Returns the defined value of "param" in current configuration file.
   If no configuration file is found, "param" is not defined, or it
   cannot be converted to a text value, "NIL" is returned. *)

PROCEDURE EnableQuakeTrace();
   
END MxConfig.

(* The configuration file is located by finding the first
   readable instance of "Filename" in the following places:
   \begin{enumerate}
   \item the current directory (".")
   \item the immediate source directory ("./src")
   \item a sibling source directory ("../src")
   \item the directory specified by the M3CONFIG environment variable.
   \item the directory containing the current executable (if $argv[0]$
         contains any path elements)
   \item the directories named by the PATH environment variable.
   \end{enumerate}
*)