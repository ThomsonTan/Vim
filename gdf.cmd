@echo off

SET COMMIT_ID=%1

git.exe log -1 %COMMIT_ID% > %TMP%\gtf.tmp

if %errorlevel% EQU 128 (
    git.exe pull > %TMP%\gtf.tmp
)

git.exe dt --dir-diff %COMMIT_ID%~1 %COMMIT_ID%

if %errorlevel% EQU 255 (
    @ECHO Invalid commit ID
)
