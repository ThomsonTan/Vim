@echo Install customized Vim stuff to system

cmd.exe /c copy /y /v _vimrc %homedrive%%homepath%\_vimrc

if not exist %homedrive%%homepath%\vimfiles\colors (
mkdir %homedrive%%homepath%\vimfiles\colors
)
copy colors\tan.vim %homedrive%%homepath%\vimfiles\colors\tan.vim

if not exist %homedrive%%homepath%\vimfiles\plugin (
mkdir %homedrive%%homepath%\vimfiles\plugin
)
copy plugin\srcexpl.vim %homedrive%%homepath%\vimfiles\plugin\
copy plugin\taglist.vim %homedrive%%homepath%\vimfiles\plugin\

if not exist %homedrive%%homepath%\vimfiles\after\syntax (
mkdir %homedrive%%homepath%\vimfiles\after\syntax
)

copy after\syntax\c.vim %homedrive%%homepath%\vimfiles\after\syntax\
