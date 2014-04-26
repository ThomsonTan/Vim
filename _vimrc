:set ic
:set smartcase
:set incsearch
:set scrolloff=5
:set tabstop=4 shiftwidth=4 expandtab
:syntax on

"http://unix.stackexchange.com/questions/3073/what-is-a-vi-equivalent-of-vims-set-ruler-command
:set ruler
" Using relative numbers for navigation
" switch between normal and relative is not considered, since the column width changes 
" in this case. Please use C-g to get the absolute line information
" ref: http://jeffkreeftmeijer.com/2012/relative-line-numbers-in-vim-for-super-fast-movement/
:set rnu

" try/catch/finally doesn't work, cannot catch the error of `set guifont=`
" specify comma seperated fonts works great here, and gVim will use the 
" first available fonts, which is what I want.
" http://stackoverflow.com/questions/23191969/how-to-determine-whether-a-set-command-failed-to-run-in-vimrc/23195939?noredirect=1#23195939
:set guifont=Envy_Code_R:h12:cANSI,Consolas:h12:cANSI

:set cindent
:set autoindent

:set guioptions -=m
:set guioptions -=T

" http://stackoverflow.com/questions/7622564/vim-auto-indent-private-keyword
:set cino+=g0
" http://stackoverflow.com/questions/2549019/how-to-avoid-namespace-content-indentation-in-vim
" this actually need to relative higher version of vim73, at least it works for vim74
:set cino+=N-s
:set cino+=(s


" Vim color file
" Maintainer: Marco Peereboom <slash@peereboom.us>
" Last Change: August 19, 2004
" Licence: Public Domain
" Try to emulate standard colors so that gvim == vim
:set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let colors_name = "putty2"

hi Normal guifg=White guibg=Black
hi ErrorMsg guibg=Red guifg=White
hi IncSearch gui=reverse
"hi ModeMsg
hi StatusLine gui=reverse
hi StatusLineNC gui=reverse
hi VertSplit gui=reverse
"hi Visual gui=reverse guifg=Red guibg=fg
hi Visual gui=reverse guifg=White guibg=Black
hi VisualNOS gui=underline
hi DiffText guibg=Red
hi Cursor guibg=#004080 guifg=NONE
hi lCursor guibg=Cyan guifg=NONE
hi Directory guifg=Orange
hi LineNr guifg=#BBBB00
hi MoreMsg guifg=SeaGreen
hi NonText guifg=Orange guibg=Black
hi Question guifg=SeaGreen
"hi Search guibg=#BBBB00 guifg=NONE
hi Search guibg=LightYellow guifg=NONE
hi SpecialKey guifg=Orange
hi Title guifg=Magenta
hi WarningMsg guifg=Red
hi WildMenu guibg=Cyan guifg=Black
hi Folded guibg=White guifg=DarkBlue
hi FoldColumn guibg=Grey guifg=DarkBlue
hi DiffAdd guibg=LightBlue
hi DiffChange guibg=LightMagenta
hi DiffDelete guifg=Orange guibg=LightCyan
hi Comment guifg=Orange guibg=Black
hi Constant guifg=#BB0000 guibg=Black
hi PreProc guifg=#BB00BB guibg=Black
hi Statement gui=NONE guifg=#BBBB00 guibg=Black
hi Special guifg=#BB00BB guibg=Black
hi Ignore guifg=Grey
hi Identifier guifg=#00BBBB guibg=Black
hi Type guifg=#00BB00 guibg=Black

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
hi Cursor guibg=#004080 guifg=NONE
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
hi Folded guibg=DarkGrey guifg=DarkBlue
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


let g:highlighting = 0
function! Highlighting()
  if g:highlighting == 1 && @/ =~ '^\\<'.expand('<cword>').'\\>$'
    let g:highlighting = 0
    return ":silent nohlsearch\<CR>"
  endif
  let @/ = '\<'.expand('<cword>').'\>'
  let g:highlighting = 1
  return ":silent set hlsearch\<CR>"
endfunction
nnoremap <silent> <expr> <space> Highlighting()

nnoremap <silent> <leader>zj :call NextClosedFold('j')<cr>
nnoremap <silent> <leader>zk :call NextClosedFold('k')<cr>
function! NextClosedFold(dir)
    let cmd = 'norm!z' . a:dir
    let view = winsaveview()
    let [l0, l, open] = [0, view.lnum, 1]
    while l != l0 && open
        exe cmd
        let [l0, l] = [l, line('.')]
        let open = foldclosed(l) < 0
    endwhile
    if open
        call winrestview(view)
    endif
endfunction

" Vim plugin -- last-position-jump improved (esp. for Easy Vim)
" File:         lastpos.vim
" Created:      2010 Apr 08     (new approach!)
" Last Change:  2010 Apr 09
" Rev Days:     1
" Author:       Andy Wokula <anwoku@yahoo.de>
" Version:      0.6

if exists("loaded_lastpos")
    finish
endif
let loaded_lastpos = 1

if v:version < 700 || &cp
    echomsg "lastpos: you need at least Vim 7.0 and 'nocp' set"
    finish
endif

let s:cpo_save = &cpo
set cpo&vim

augroup LastPos
    au!
    au BufWinEnter * call s:LastPos()
augroup End

func! s:LastPos()
    let lastpos_want = getpos("'\"")
    if lastpos_want != [0,1,1,0] && lastpos_want[1] <= line("$")
        \ && getpos(".") == [0,1,1,0] && &buftype == ""
        normal! g`"
        if lastpos_want != getpos(".")
            exec printf("au! LastPos InsertEnter * call s:AdjustPos(%s, %d)",
                \ string(getpos(".")), bufnr(""))
            au! LastPos CursorMoved * au! LastPos InsertEnter,CursorMoved
        endif
    endif
endfunc

func! s:AdjustPos(badpos, bufnr)
    if getpos(".") == a:badpos && bufnr("") == a:bufnr
        call feedkeys("\<Right>")
    endif
    au! LastPos InsertEnter
endfunc

let &cpo = s:cpo_save
unlet s:cpo_save

" vim:et tw=72 sts=4 sw=4:

:set fdm=syntax
:autocmd VimEnter * normal! zR

" support Ccrtl+c/ctrl+v
" from http://stackoverflow.com/questions/2861627/paste-in-insert-mode
" 2013/11/18 by tstan
:set pastetoggle=<F10>
inoremap <C-v> <F10><C-r>+<F10>
vnoremap <C-c> "+y

" provide short cuts for insert mode
" http://stackoverflow.com/questions/1737163/traversing-text-in-insert-mode
:set winaltkeys=no
inoremap <A-h> <C-o>h
inoremap <A-j> <C-o>j
inoremap <A-k> <C-o>k
" FIXME: the issue here is A-l cannot move to the last column in edit mode
" Use a to see whether this can be fixed
inoremap <A-l> <C-o>a
inoremap <A-f> <C-o>w
inoremap <A-b> <C-o>b
inoremap <A-e> <C-o>e<C-o>l
inoremap <A-d> <C-o>4j
inoremap <A-u> <C-o>4k

" provide hjkl moves in CommandLine modes,
" from the same link as above
cnoremap <A-h> <Left>
cnoremap <A-j> <C-Right>
cnoremap <A-k> <C-Left>
cnoremap <A-l> <Right>


nnoremap <C-k> :call search('\%' . virtcol('.') . 'v\S', 'bW') <CR>
nnoremap <C-j> :call search('\%' . virtcol('.') . 'v\S', 'W') <CR>

