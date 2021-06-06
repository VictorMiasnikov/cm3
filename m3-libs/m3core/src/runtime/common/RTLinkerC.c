#ifndef INCLUDED_M3CORE_H
#include "m3core.h"
#endif

#ifdef __cplusplus
extern "C" {
#endif

/*
EnvFromMain is either char** from main, or char* GetEnvironmentStringsA from WinMain.
Rather than make a coordinated compiler/runtime change, we just ignore
the compiler-provided data and make the runtime always work.
One additional copy of the environment variables is leaked per .exe/.dll.

RTLinker__GetEnvironmentStrings here matches M3C output (subject to change).
That is why "ADDRESS" and not e.g. "void*".
*/
ADDRESS
__cdecl
RTLinker__GetEnvironmentStrings (ADDRESS EnvFromMain)
{
#ifdef _WIN32
    return (ADDRESS)GetEnvironmentStringsA ();
#else
    return EnvFromMain;
#endif
}

#ifndef _WIN32 /* Do not accidentally export printf. */

#if 1 /* debugging code */

#include <stdio.h>

#if 0
STRUCT_TYPEDEF(RT0__TypeLink)
struct Text_t
{
    void* Functions;
    ptrdiff_t Length;
    char Chars[1];
};

enum Trace_t
{
    Trace_None,
    Trace_M3,
    Trace_C,
};
size_t RTLinker__traceInit /* = Trace_C */;

void
__cdecl
RTIO__PutString(const char* a);

void
__cdecl
RTIO__PutText(Text_t* a);

void
__cdecl
RTIO__PutInt(int a);

void
__cdecl
RTIO__Flush(void);

static
void
RTLinker__PrintFlush(void)
{
    if (RTLinker__traceInit == Trace_M3)
        RTIO__Flush();
}

static
void
RTLinker__PrintString(const char* a)
{
    if (a == NULL || a[0] == 0)
        return;
    switch (RTLinker__traceInit)
    {
    case Trace_None:
        break;
    case Trace_M3:
        RTIO__PutString(a);
        break;
    case Trace_C:
        printf("%s", a);
        break;
    }
}

static
void
RTLinker__PrintText(Text_t* a)
{
    if (a == NULL || a->Length < 1)
        return;
    switch (RTLinker__traceInit)
    {
    case Trace_None:
        break;
    case Trace_M3:
        RTIO__PutText(a);
        break;
    case Trace_C:
        printf("%.*s", ((int)a->Length), a->Chars);
        break;
    }
}

static
void
RTLinker__PrintInt(int a)
{
    switch (RTLinker__traceInit)
    {
    case Trace_None:
        break;
    case Trace_M3:
        RTIO__PutInt(a);
        break;
    case Trace_C:
        printf("%X", a);
        break;
    }
}

#endif

void
__cdecl
RTLinker__PrintModule(RT0__Module* module)
{
    RT0__Import* imports = { 0 };

    if (module == NULL)
        return;

    imports = module->imports;
    while (imports)
    {
        printf("module %p %s imports %p{import %p, binder %p, next %p}",
               (void*)module,
               module->file,
               (void*)imports,
               (void*)(imports ? imports->import : NULL),
               (void*)(imports ? *(void**)&imports->binder : NULL),
               (void*)(imports ? imports->next : NULL));
        fflush(0);
        printf(" %p ", imports && imports->import ? imports->import->file : "");
        fflush(0);
        printf(" %s\n", imports && imports->import ? imports->import->file : "");
        imports = imports->next;
    }
    printf("\n");
}

#endif

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif
