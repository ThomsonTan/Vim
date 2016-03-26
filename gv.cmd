@echo off
setlocal EnableDelayedExpansion
setlocal EnableExtensions

SET MYGVIMPATH=C:\Progra~2\Vim\vim74\gvim.exe
SET GVIMSINGLEINSTANCE=-p --remote-tab-silent

REM ONE tricky stuff for Set ENV=%%i, don't leave any spaces around =
for /F "tokens=1,2,3 delims=: " %%i in ("%*") do (
set GVFileName=%%i
set GVLineNumber=%%j
set EndMarker=%%k
)

if "%EndMarker%" EQU "" (
    if not "%GVLineNumber%" EQU "" (
        if not "!GVLineNumber:~0,1!" EQU "\" (
            start !MYGVIMPATH! !GVIMSINGLEINSTANCE! +%GVLineNumber% %GVFileName%
            goto :EOF
        )
    )
)

if "%*" EQU "" (
start !MYGVIMPATH! %*
) else (
start !MYGVIMPATH! !GVIMSINGLEINSTANCE! %*
)
