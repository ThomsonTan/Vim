@echo Install customized Vim stuff to system

cmd.exe /c copy /y /v _vimrc %homedrive%%homepath%\_vimrc

robocopy /S vimfiles\ %homedri%%homepath%\
