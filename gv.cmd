@echo off
setlocal EnableDelayedExpansion
setlocal EnableExtensions

SET MYGVIMPATH=C:\Progra~2\Vim\vim80\gvim.exe
SET GVIMSINGLEINSTANCE=-p --remote-tab-silent
SET ENABLE_SCROLL_ANIMATION=1

SET paramLine=%*
SET normalizeParamLine=%paramLine:"=%

REM ONE tricky stuff for Set ENV=%%i, don't leave any spaces around =
for /F "tokens=1,2,3 delims=:? " %%i in ("!normalizeParamLine!") do (
    set GVFileName=%%i
    set GVLineNumber=%%j
    set EndMarker=%%k
)

if not "!EndMarker!" EQU "" (
REM re-split by ?, since driver latter is followed by :
    for /F "tokens=1,2,3 delims=? " %%i in ("!normalizeParamLine!") do (
        set GVFileName=%%i
        set GVLineNumber=%%j
        set EndMarker=%%k
    )
)

set /a RealLineNumber=0
set /a RealColNumber=0

if "%EndMarker%" EQU "" (
    if not "%GVLineNumber%" EQU "" (
        if not "!GVLineNumber:~0,1!" EQU "\" (
            if !GVLineNumber! GTR 1000000 (
                REM need %% to represent mod?
                set /a RealLineNumber=!GVLineNumber! %% 1000000
                set /a RealColNumber=!GVLineNumber! / 1000000
                REM location of +normal command matters, need to be immediate before source file?
                start !MYGVIMPATH! !GVIMSINGLEINSTANCE! "+cal cursor(!RealLineNumber!, !RealColNumber!)" %GVFileName% 
            ) else (
                start !MYGVIMPATH! !GVIMSINGLEINSTANCE! +%GVLineNumber% %GVFileName%
            )
            goto :EOF
        )
    )
)

if "%*" EQU "" (
start !MYGVIMPATH! %*
) else (
start !MYGVIMPATH! !GVIMSINGLEINSTANCE! %*
)
