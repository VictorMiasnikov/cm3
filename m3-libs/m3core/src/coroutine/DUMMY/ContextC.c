/* Copyright (C) 2018-2019 Intel Corporation */
/* SPDX-License-Identifier: BSD-3-Clause */
/* see the file COPYRIGHT-INTEL for more information */

/*
 * Coroutines for Modula-3 !
 *
 * Author : Mika Nystrom <mika.nystroem@intel.com>
 * April, 2018
 *
 * Much of this code is a hybrid of the PTHREADS code by Tony Hosking
 * and the POSIX code by DEC-SRC.
 */

#ifndef INCLUDED_M3CORE_H
#include "m3core.h"
#endif

M3EXTERNC_BEGIN


// This code has only been tested on Linux/amd64.
#if !(defined(__x86_64__) && defined(__linux))

BOOLEAN
__cdecl
Coroutine__Supported(void)
{
    return FALSE;
}

#else

BOOLEAN
__cdecl
Coroutine__Supported(void)
{
    return FALSE;
}

#endif

M3EXTERNC_END
