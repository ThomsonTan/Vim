@REM Don't rely on admin mode
@echo off
@REM reg query HKLM\Software\TestElevated-f57142fd-2586-45b8-bdb6-49e98d93789b >NUL 2>NUL && goto :TestKeyExists
@REM reg add HKLM\Software\TestElevated-f57142fd-2586-45b8-bdb6-49e98d93789b /f >NUL 2>NUL || goto :ErrorNotAdmin
@REM reg delete HKLM\Software\TestElevated-f57142fd-2586-45b8-bdb6-49e98d93789b /f >NUL 2>NUL || goto :FailedToDelete
@echo Install customized Vim stuff to system

cmd.exe /c copy /y /v %~dp0_vimrc %homedrive%%homepath%\_vimrc

robocopy /S %~dp0vimfiles\ %homedrive%%homepath%\vimfiles\

@REM if "%PROCESSOR_ARCHITECTURE%" equ "AMD64" (
@REM    cmd.exe /c copy /y /v %~dp0VimBin\ctags.exe %systemroot%\syswow64\
@REM ) else (
@REM    cmd.exe /c copy /y /v %~dp0VimBin\ctags.exe %systemroot%\system32\
@REM )

goto :Success

@REM :FailedToDelete
@REM @echo ========================================
@REM @echo How could this happen?
@REM @echo ========================================
@REM exit /b 3
@REM 
@REM :TestKeyExists
@REM @echo ========================================
@REM @echo Why do you have this key?
@REM @echo ========================================
@REM exit /b 1
@REM 
@REM :ErrorNotAdmin
@REM @echo ========================================
@REM @echo Please install in administrator mode!!!
@REM @echo ========================================
@REM exit /b 2

:Success
@echo ========================================
@echo Installed successfully :)
@echo ========================================
