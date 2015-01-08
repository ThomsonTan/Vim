" Vim color file
" Maintainer: Marco Peereboom <slash@peereboom.us>
" Last Change: August 19, 2004
" Licence: Public Domain
" Try to emulate standard colors so that gvim == vim

hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "tan"

" Seems VirtSplit doesn't work?
hi VirtSplit guibg=#404040

hi link IncSearch Visual
hi link String Constant
hi link Character Constant
hi link Number Constant
hi link Boolean Constant
hi link Float Number
hi link Function Identifier
hi link Conditional Statement
hi link Repeat Statement
hi link Label Statement
hi link Operator Statement
hi link Keyword Statement
hi link Exception Statement
hi link Include PreProc
hi link Define PreProc
hi link Macro PreProc
hi link PreCondit PreProc
hi link StorageClass Type
hi link Structure Type
hi link Typedef Type
hi link Tag Special
hi link SpecialChar Special
hi link Delimiter Special
hi link SpecialComment Special
hi link Debug Special

hi Normal guifg=Grey guibg=Black
hi ErrorMsg guibg=Red guifg=Grey
hi IncSearch gui=reverse
hi StatusLine gui=reverse
hi StatusLineNC gui=reverse
hi VertSplit gui=reverse
hi Visual gui=reverse guifg=Grey guibg=Black
hi VisualNOS gui=underline
hi DiffText guibg=Red
hi Cursor guibg=#004080 guifg=white
hi lCursor guibg=Cyan guifg=NONE
hi Directory guifg=Orange
hi LineNr guifg=Grey
hi MoreMsg guifg=Green
hi NonText guifg=Orange guibg=Black
hi Question guifg=Green
hi Search guibg=#999900 guifg=Black
hi SpecialKey guifg=Orange
hi Title guifg=Magenta
hi WarningMsg guifg=Red
hi WildMenu guibg=Cyan guifg=Black
" below one takes effect actually, overwrite previous one?
hi Folded guibg=#184018 guifg=DarkBlue
hi FoldColumn guibg=Grey guifg=DarkBlue
hi DiffAdd guibg=LightBlue
hi DiffChange guibg=LightMagenta
hi DiffDelete guifg=Orange guibg=LightCyan
hi Comment guifg=DarkGreen guibg=Black
hi Constant guifg=Magenta guibg=Black
hi PreProc guifg=Orange guibg=Black
hi Statement gui=NONE guifg=Yellow guibg=Black
hi Special guifg=Red guibg=Black
hi Ignore guifg=Grey
hi Identifier guifg=Yellow guibg=Black
hi Type gui=NONE guifg=Cyan guibg=Black

hi Pmenu    ctermfg=white ctermbg=black gui=NONE guifg=white guibg=#303030
hi Pmenusel ctermfg=white ctermbg=blue gui=bold guifg=White guibg=Purple

