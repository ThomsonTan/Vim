" Reference
"   http://stackoverflow.com/questions/736701/class-function-names-highlighting-in-vim

" -----------------------------------------------------------------------------
"  Highlight function names.
" -----------------------------------------------------------------------------

syn match    cCustomParen    "(" contains=cParen contains=cCppParen
syn match    cCustomFunc     "\w\+\s*(\@=" contains=cCustomParen

syn match    cCustomParen    "?=(" contains=cParen,cCppParen
syn match    cCustomFuncUse     "\w\+\s*(\@=" contains=cCustomParen
hi def link  cCustomFuncUse FunctionUse

" syn match cFuncDefNoParamNoRightParen excludenl  "\zs\w\+\ze\s*($"
syn match cFuncDefNoParamNoRightParen excludenl  "${FuncDefName}"
" syn match cFuncDefNoParamWithRightParen excludenl  "\zs\w\+\ze\s*(\s*)$"
" syn match cFuncDefOneParam "\zs\w\+\ze\s*(\w\+\**&\{0,2}\s\+"
hi def link cFuncDefOneParam Function
hi def link cFuncDefNoParamNoRightParen Function
hi def link cFuncDefNoParamWithRightParen Function

syn keyword cReturnStatement return
hi def link cReturnStatement ReturnStatement

