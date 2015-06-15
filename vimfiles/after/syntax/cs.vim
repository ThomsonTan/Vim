" Reference
"   http://stackoverflow.com/questions/736701/class-function-names-highlighting-in-vim

" -----------------------------------------------------------------------------
"  Highlight function names.
"  [] means meta chars by default (no escape)
" -----------------------------------------------------------------------------

syn match    cCustomParen    "(" contains=cParen contains=cCppParen
syn match    cCustomFunc     "\w\+\s*(\@=" contains=cCustomParen

syn match    cCustomParen    "?=(" contains=cParen,cCppParen
syn match    cCustomFuncUse     "\w\+\s*(\@=" contains=cCustomParen
hi def link  cCustomFuncUse FunctionUse

syn match cFuncDefNoParamNoRightParen excludenl  "\zs\w\+\ze\s*($"
syn match cFuncDefNoParamWithRightParen excludenl  "\zs\w\+\ze\s*(\s*)$"
syn match cFuncDefOneParam "\zs\w\+\ze\s*(\(ref\|out\)\{0,1}\s*\w\+\(<\w*>\)\{0,1}\(\[]\)\{0,1}\s\+\w\+\s*)"
syn match cFuncDefMoreThanOneParam "\zs\w\+\ze\s*(\(ref\|out\)\{0,1}\s*\w\+\(<\w*>\)\{0,1}\(\[]\)\{0,1}\s\+\w\+\s*,"

hi def link cFuncDefOneParam Function
hi def link cFuncDefNoParamNoRightParen Function
hi def link cFuncDefNoParamWithRightParen Function
hi def link cFuncDefMoreThanOneParam Function

syn keyword cReturnStatement return
hi def link cReturnStatement ReturnStatement

