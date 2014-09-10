" Hacker Vim 7.2 mentioned the command added to gvimrc should not have : prepended,
" but it seems it also works here

" highlight current line in insertion mode
" autocmd InsertLeave * se nocul
" autocmd InsertEnter * se cul
set nocompatible
" detect the file type
filetype on
filetype plugin on
set completeopt=longest,menu

" load indent file for specific file type
filetype indent on

:set ic
:set smartcase
:set incsearch
set hlsearch
:set scrolloff=5
:set tabstop=4 shiftwidth=4 expandtab
:syntax on

" ignore the errorbell, does this really work?
set noerrorbells

" don't generate swap file
setlocal noswapfile
set bufhidden=hide
set updatecount=0

" no backup file ?
" set nobackup

" always show last status line, but this is unexpected
" set laststatus=2

"http://unix.stackexchange.com/questions/3073/what-is-a-vi-equivalent-of-vims-set-ruler-command
:set ruler
" Using relative numbers for navigation
" switch between normal and relative is not considered, since the column width changes 
" in this case. Please use C-g to get the absolute line information
" ref: http://jeffkreeftmeijer.com/2012/relative-line-numbers-in-vim-for-super-fast-movement/
" switch back to normal line number due to easy navigation
:set nu

" Set font for specific file type, autocmd BufEnter *.txt set guifont=Arial\ 12

" try/catch/finally doesn't work, cannot catch the error of `set guifont=`
" specify comma seperated fonts works great here, and gVim will use the 
" first available fonts, which is what I want.
" http://stackoverflow.com/questions/23191969/how-to-determine-whether-a-set-command-failed-to-run-in-vimrc/23195939?noredirect=1#23195939
:set guifont=Envy_Code_R:h12:cANSI,Consolas:h12:cANSI

:set cindent
" could also say set ai! ?
:set autoindent

" Hide the menu and toolbar completely
:set guioptions-=m
:set guioptions-=T

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
hi Folded guibg=#303030 guifg=DarkBlue
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


let g:highlighting = 0
" TODO: Toggle between different highlights looks separate
function! Highlighting(inputPat)
  if g:highlighting == 1 
    if @/ =~ '^\\<'.expand('<cword>').'\\>$' 
      let g:highlighting = 0
      " clear the output after clear highlight, mainly for match lines.
      echo ""
      return ":silent nohlsearch\<CR>"
    endif
    if @/ == a:inputPat
      let g:highlighting = 0
      echo ""
      return ":silent nohlsearch\<CR>"
    endif
  endif
  if a:inputPat == ''
    let @/ = '\<'.expand('<cword>').'\>'
  else
    let @/ = a:inputPat
    " echo below echo the input string to command prompt line
    " which is very useful
    " echo a:inputPat
  endif
  let g:highlighting = 1
  exe "%s/".a:inputPat."//gn"
" use mary y to add the current position to jump list, since y is the 
" longest key to type :)
" One tricky behavior is when highlighting, the first back navigation
" back to the mark, not the one below the mark!
" Just got some tricky stuff about jump list format, see :help jumplist
" My understanding is when insert a new location to jumplist, it will 
" be inserted, at the same time point the top location to an empty loc,
" which is used to record the new loc when <C-o> is used to back to the
" loc just inserted.
" ??? I am wondering whether there is easy way to be ware that <C-o> will
"     cause current pos to be inserted to the jump list or now.
"     In the recording current pos mode, when <C-o> is used (<C-i> doesn't
"     exit such mode), the mode will be exited.
" The insertion mode of locs could be tricky, the motion command just 
" insert current pos to jump list (or fill the top empty one),
" then does the motion then create a empty
" jump loc at the bottom of jump list, the next motion. Strange model.
  return "my`y:silent set hlsearch\<CR>"
endfunction
" Stop mapping space as highlight, start to use quickhl
nnoremap <silent> <expr> <C-space> Highlighting('')

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
" Below <A-f> cannot go to the last (append) position of the line, because 
" the last postion is not a valid insert position.
" but above <A-l> can do it. Take care of this minor difference.
inoremap <A-f> <C-o>w
inoremap <A-b> <C-o>b
inoremap <A-e> <C-o>e<C-o>l
" reserve A-c for the most common Esc, and use c for down, as sit down
inoremap <A-c> <C-o>4j
inoremap <A-u> <C-o>4k

" map <A-d> for both insert and visual mode
" also add it for normal mode
inoremap <A-d> <Esc>
vnoremap <A-d> <Esc>
nnoremap <A-d> <Esc>
" below mapping comes from link, search <C-c> and command line mode
" http://vim.wikia.com/wiki/Avoid_the_escape_key
cnoremap <A-d> <C-c>

" provide hjkl moves in CommandLine modes,
" from the same link as above
cnoremap <A-h> <Left>
cnoremap <A-j> <C-Right>
cnoremap <A-k> <C-Left>
cnoremap <A-l> <Right>

" map <A-j> in normal mode to break the current line after cursor
" cancel this maaping for easy-motion
" nnoremap <A-j> a<CR><Esc>k$

nnoremap <C-k> :call search('\%' . virtcol('.') . 'v\S', 'bW') <CR>
nnoremap <C-j> :call search('\%' . virtcol('.') . 'v\S', 'W') <CR>

" map completion at local file scope to more convenient keys
inoremap <A-,> <C-x><C-p>
inoremap <A-.> <C-x><C-n>
inoremap <A-n> <C-n>
inoremap <A-p> <C-p>

" functions navivation, still not perfect
" The first function cannot be handed for forward navigation, also cannot handle C++ class
" and namespaces indentation
nnoremap <C-n> :keepj norm ][w][%zz<CR>
nnoremap <C-p> :keepj norm []%zz<CR>
nnoremap <C-m> 10[{zz
" C-, is mapped by input method?
" Weird that both C-, C-. even C-; don't work, both local and TS
nnoremap <A-,> [{
nnoremap <A-.> ]}

" navigation in one line
nnoremap <A-f> /\%<C-R>=line('.')<CR>l

" make n/N behavior consistent
nnoremap <expr> n 'Nn'[v:searchforward]
nnoremap <expr> N 'nN'[v:searchforward]

" below techical of maximize gvim Window on Windows comems from below link:
" http://wenku.baidu.com/link?url=1yPMaL-9SsDE5PULKNZ61eeV0cjUp0qYEIiX7_u27siVqN89cleuFCpTLqaj8P8SVH3JtrsNxR8WmKRbLrHfqSS_e4aXlFoZDwOEU-_1dOS
if (has("win32") || has("win64"))
    au GUIEnter * simalt ~x
    " share clipboard with Windows
    set clipboard+=unnamed
elseif has("unix")
    set clipboard+=linux
endif

" The techinical of maximize Windows on Linux comes from below link:
" http://blog.163.com/lgh_2002/blog/static/4401752620115604617575/
function! MaximizeWindow()
    silent !wmctrl -r :ACTIVE: -b
add,maximized_vert,maximized_horz
endfunction

" allow backspace cross cursor and line border, is this really necessary?
" set whichwrap+=<,>,h,l

" put below hi at the begining of the file doesn't take any effect, so put it
" here seems Ok.
" Btw which plug-in split/end comment for me???
set cursorline
hi cursorline guibg=#282828

" http://vim.wikia.com/wiki/Search_in_current_function
" 7/22/2014
" Search within a scope (a {...} program block).
" Version 2010-02-28 from http://vim.wikia.com/wiki/VimTip1530
" Original solution in above link use / to search? which has the issue of 
" advancing past the current one when selected, which is the typical 
" behavior of search, but weird for highlight.
" Anyway, I like highlight instead of search here, so switch the implementation
" to use @/ and set hlsearch as toggle, which makes it consistent with space 
" highlight
" One random thing looks strange is there is no file type hint when creating new
" lines now, file type identify is closed???

" Search within top-level block for word at cursor, or selected text.
nnoremap <silent> <C-S-space>       :exe 'silent norm '.<SID>ScopeSearch('][%', 1)<CR>
vnoremap <silent> <C-S-space> <Esc> :exe 'silent norm '.<SID>ScopeSearch('][%', 2)<CR>gV
" Search within current block for word at cursor, or selected text.
" ugly workaround of appending h here, it may not work in some edge scenarios
" Why this command moves cursor one char later?
" Strange again, the extra move just disppeared, is it because I insered an extra
" space after <CR>, must be type accurate keys for mapping!!! Perfect solution.
" 9/10/2014 scope search is less useful than highlighting. Move this shortcut
" to highlight since single space is used to highlight multiple words
" nnoremap <silent> <C-space>       :exe 'silent norm '.<SID>ScopeSearch('[{', 1)<CR>
vnoremap <silent> <C-space> <Esc> :exe 'silent norm '.<SID>ScopeSearch('[{', 2)<CR>gV
" Search within current top-level block for user-entered text.
" No need of below 2 right now
" nnoremap <Leader>/ /<C-R>=<SID>ScopeSearch('[[', 0)<CR>
" vnoremap <Leader>/ <Esc>/<C-R>=<SID>ScopeSearch('[[', 2)<CR><CR>

" Return a pattern to search within a specified scope, or
" return a backslash to cancel search if scope not found.
" navigator: a command to jump to the beginning of the desired scope
" mode: 0=scope only; 1=scope+current word; 2=scope+visual selection
function! s:ScopeSearch(navigator, mode)
  let retStr = ''
  if a:mode == 0
    let pattern = ''
  elseif a:mode == 1
    let pattern = '\<' . expand('<cword>') . '\>'
  else
    let old_reg = getreg('@')
    let old_regtype = getregtype('@')
    normal! gvy
    let pattern = escape(@@, '/\.*$^~[')
    call setreg('@', old_reg, old_regtype)
  endif
  let saveview = winsaveview()
  execute 'normal! ' . a:navigator
  let first = line('.')
  normal %
  let last = line('.')
  normal %
  if first < last
    " return printf('\%%>%dl\%%<%dl%s', first-1, last+1, pattern)
    let retStr = Highlighting(printf('\%%>%dl\%%<%dl%s', first-1, last+1, pattern))
  else
    let retStr = ':echo no highlight in scope'
    echo 'No highlight in scope'
  endif
  " restore vew after highligh is necessary, since highlighting has motion (search)
  " which affects the real view
  call winrestview(saveview)
  return retStr
endfunction

" ==============================================================================
" config for easy-motion, this is the minimal bindings
set rtp+=$HOME/vimfiles/bundle/vundle/
call vundle#rc('$HOME/vimfiles/bundle')
Bundle 'Lokaltog/vim-easymotion'

let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Bi-directional find motion
" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
nmap s <Plug>(easymotion-s)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
nmap s <Plug>(easymotion-s2)

" Turn on case sensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <A-j> <Plug>(easymotion-j)
map <A-k> <Plug>(easymotion-k)

" ==============================================================================
" config for quickhl
Bundle 't9md/vim-quickhl'

nmap <Space> <Plug>(quickhl-manual-this)
xmap <Space> <Plug>(quickhl-manual-this)
nmap <A-u> <Plug>(quickhl-manual-reset)
xmap <A-u> <Plug>(quickhl-manual-reset)

nmap <A-i> <Plug>(quickhl-cword-toggle)
" nmap <Space>] <Plug>(quickhl-tag-toggle)
map H <Plug>(operator-quickhl-manual-this-motion)
