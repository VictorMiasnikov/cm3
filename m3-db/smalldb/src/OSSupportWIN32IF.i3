INTERFACE OSSupportWIN32IF;

IMPORT WinNT;
FROM WinBaseTypes IMPORT BOOL;

<*EXTERNAL SetEndOfFile:WINAPI*>
PROCEDURE SetEndOfFile(handle: WinNT.HANDLE): INTEGER;

<*EXTERNAL FlushFileBuffers:WINAPI*>
PROCEDURE FlushFileBuffers(handle: WinNT.HANDLE): BOOL;

END OSSupportWIN32IF.