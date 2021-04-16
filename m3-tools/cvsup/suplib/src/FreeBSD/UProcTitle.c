#ifndef INCLUDED_M3CORE_H
#include "m3core.h"
#endif

#ifdef __FreeBSD__
#include <sys/types.h>
#include <libutil.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

void
__cdecl
m3_setproctitle(const char *title)
{
#ifdef __FreeBSD__
    setproctitle("%s", title);
#endif
}

#ifdef __cplusplus
} /* extern "C" */
#endif
