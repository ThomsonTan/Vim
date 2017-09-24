@REM workaround to check running in admin mode or not
@echo off
reg query HKLM\Software\TestElevated-f57142fd-2586-45b8-bdb6-49e98d93789b >NUL 2>NUL && goto :TestKeyExists
reg add HKLM\Software\TestElevated-f57142fd-2586-45b8-bdb6-49e98d93789b /f >NUL 2>NUL || goto :ErrorNotAdmin
reg delete HKLM\Software\TestElevated-f57142fd-2586-45b8-bdb6-49e98d93789b /f >NUL 2>NUL || goto :FailedToDelete
@echo Install customized Vim stuff to system

cmd.exe /c copy /y /v %~dp0_vimrc %homedrive%%homepath%\_vimrc

robocopy /S %~dp0vimfiles\ %homedrive%%homepath%\vimfiles\

if "%PROCESSOR_ARCHITECTURE%" equ "AMD64" (
    cmd.exe /c copy /y /v %~dp0VimBin\ctags.exe %systemroot%\syswow64\
) else (
    cmd.exe /c copy /y /v %~dp0VimBin\ctags.exe %systemroot%\system32\
)

goto :Success

:FailedToDelete
@echo ========================================
@echo How could this happen? Ping lilotom@gmail.com
@echo ========================================
exit /b 3

:TestKeyExists
@echo ========================================
@echo Why do you have this key?
@echo ========================================
exit /b 1

:ErrorNotAdmin
@echo ========================================
@echo Please install in administrator mode!!!
@echo ========================================
exit /b 2

:Success
@echo ========================================
@echo Installed successful :)
@echo ========================================
