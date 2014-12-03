@echo off
setlocal EnableDelayedExpansion
setlocal EnableExtensions

SET MYGVIMPATH=d:\tmp\vim73\gvim.exe

REM ONE tricky stuff for Set ENV=%%i, don't leave any spaces around =
for /F "tokens=1,2,3 delims=: " %%i in ("%*") do (
set GVFileName=%%i
set GVLineNumber=%%j
set EndMarker=%%k
)

if "%EndMarker%" EQU "" (
    if not "%GVLineNumber%" EQU "" (
        start !MYGVIMPATH! +%GVLineNumber% %GVFileName%
        goto :EOF
    )
)

start !MYGVIMPATH! %*
