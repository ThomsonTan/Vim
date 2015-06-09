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
hi link Character Constant
hi link Number Constant
hi link Boolean Constant
hi link Float Number
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

hi String          guifg=#E6DB74
hi Character       guifg=#E6DB74
hi Function        guifg=#A6E22E
hi Identifier      guifg=#FD971F
hi FunctionUse     guifg=#66D9EF

hi Normal          guifg=Grey guibg=#272822
hi ErrorMsg guibg=Red guifg=Grey
hi IncSearch gui=reverse
hi StatusLine gui=reverse
hi StatusLineNC gui=reverse
hi VertSplit gui=reverse
hi Visual gui=reverse guifg=#585858 "LightGrey
hi VisualNOS gui=underline
hi Cursor          guifg=#000000 guibg=Gray
hi iCursor         guifg=#000000 guibg=Gray
hi Directory guifg=Orange
hi LineNr guifg=Grey
hi MoreMsg guifg=Green
hi NonText guifg=Orange
hi Question guifg=Green
hi Search guibg=#999900
hi SpecialKey guifg=Orange
hi Title guifg=Magenta
hi WarningMsg guifg=Red
hi WildMenu guibg=Cyan
" below one takes effect actually, overwrite previous one?
hi Folded guibg=#184018 guifg=DarkBlue
hi FoldColumn guibg=Grey guifg=DarkBlue

hi DiffAdd gui=none guibg=#585800
hi DiffDelete gui=none guibg=Black
hi DiffChange gui=none guibg=#404040
hi DiffText gui=none guibg=#585800

hi Comment guifg=#85816E
hi Constant guifg=#AE81DD " Extracted from sublime "Magenta
hi PreProc guifg=Orange
hi Statement gui=NONE guifg=#F92672 "Yellow
hi Special guifg=Red
hi Ignore guifg=Grey
hi Type gui=NONE guifg=Cyan
hi ReturnStatement guifg=DarkYellow

hi MatchParen      guifg=#000000 guibg=#FD971F gui=bold
hi Todo            guifg=#FFFFFF guibg=bg      gui=bold

hi cursorline guibg=#303030

hi Pmenu    ctermfg=white ctermbg=black gui=NONE guifg=white guibg=#303030
hi Pmenusel ctermfg=white ctermbg=blue gui=bold guifg=White guibg=Purple

" Must be at the end, because of ctermbg=234 bug.
" https://groups.google.com/forum/#!msg/vim_dev/afPqwAFNdrU/nqh6tOM87QUJ
set background=dark
