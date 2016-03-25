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
colors tan
syntax on

let g:MySyntaxOn = 1
function! ToggleSyntax()
  if g:MySyntaxOn == 1
    syntax off
    let g:MySyntaxOn = 0
  else
    syntax on
    let g:MySyntaxOn = 1
  endif
endfunction

" nnoremap <silent> <A-s> :call ToggleSyntax()<cr>
nnoremap <silent> <A-s> :w<cr>
inoremap <silent> <A-s> <C-o>:w<cr>

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
" https://superuser.com/questions/339593/vim-toggle-number-with-relativenumber/339595#339595
se nu
" nnoremap <A-r> :exec ":se rnu!"<CR>
" inoremap <A-r> :exec "<C-o>:se rnu!"<CR>

nnoremap <A-e> :q<CR>

" Set font for specific file type, autocmd BufEnter *.txt set guifont=Arial\ 12

" try/catch/finally doesn't work, cannot catch the error of `set guifont=`
" specify comma seperated fonts works great here, and gVim will use the 
" first available fonts, which is what I want.
" http://stackoverflow.com/questions/23191969/how-to-determine-whether-a-set-command-failed-to-run-in-vimrc/23195939?noredirect=1#23195939
:set guifont=Envy_Code_R:h13:cANSI,Consolas:h13:cANSI

:set cindent
" could also say set ai! ?
:set autoindent

" Hide the menu and toolbar completely
:set guioptions-=m
:set guioptions-=T
:set guioptions-=r
:set guioptions-=L

" http://stackoverflow.com/questions/7622564/vim-auto-indent-private-keyword
:set cino+=g0
" http://stackoverflow.com/questions/2549019/how-to-avoid-namespace-content-indentation-in-vim
" this actually need to relative higher version of vim73, at least it works for vim74
:set cino+=N-s
:set cino+=(s

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

" ==============================================================================
" Repeat functionality in insert mode
" C-x C-l can be used to match prefix for existing line
" ==============================================================================
function! RepeatInInsertMode()
    let times = input("Count:")
    let char  = input("Char:")
    exe ":norm a" . repeat(char, times)
endfunction

" TODO: C-l is windows refresh?
imap <C-l> <C-o>:call RepeatInInsertMode()<cr>

" ==============================================================================
" :h tags-option and :h file-searching for more syntax
" search tags from the current file directory to root
set tags=./tags;/

" ==============================================================================
" cscope support file
let cscope_file=fnamemodify(findfile("cscope.out", ".;"), ':p')
let cscope_pre = matchstr(cscope_file, ".*[\\/]")[:-2]
if !empty(cscope_file) && filereadable(cscope_file)
    exe "cs add" cscope_file cscope_pre
elseif $CSCOPE_DB != ""
    cs add $CSCOPE_DB
endif

let g:lastCSCmd = ''
let g:lastCSKey = ''
nmap <A-2>s :let g:lastCSCmd='s'<CR>:let g:lastCSKey=expand("<cword>")<CR>:cs find s <C-R>=g:lastCSKey<CR><CR>
nmap <A-2>g :let g:lastCSCmd='g'<CR>:let g:lastCSKey=expand("<cword>")<CR>:cs find g <C-R>=g:lastCSKey<CR><CR>
nmap <A-2>c :let g:lastCSCmd='c'<CR>:let g:lastCSKey=expand("<cword>")<CR>:cs find c <C-R>=g:lastCSKey<CR><CR>
nmap <A-2>d :let g:lastCSCmd='d'<CR>:let g:lastCSKey=expand("<cword>")<CR>:cs find d <C-R>=g:lastCSKey<CR><CR>
nmap <A-2>t :let g:lastCSCmd='t'<CR>:let g:lastCSKey=expand("<cword>")<CR>:cs find t <C-R>=g:lastCSKey<CR><CR>
nmap <A-2>e :let g:lastCSCmd='e'<CR>:let g:lastCSKey=expand("<cword>")<CR>:cs find e <C-R>=g:lastCSKey<CR><CR>
nmap <A-2>f :let g:lastCSCmd='f'<CR>:let g:lastCSKey=expand("<cword>")<CR>:cs find f <C-R>=g:lastCSKey<CR><CR>
nmap <A-2>i :let g:lastCSCmd='i'<CR>:let g:lastCSKey=expand("<cword>")<CR>:cs find i ^<C-R>=g:lastCSKey<CR>$<CR>
nmap <A-2>r :exe "cs find" g:lastCSCmd g:lastCSKey <CR>

" ==============================================================================
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

" Disable fdm to improve performance, IdentLine is also a big factor of the
" very slow performance
" set fdm=syntax
autocmd VimEnter * normal! zR

" support Ccrtl+c/ctrl+v
" from http://stackoverflow.com/questions/2861627/paste-in-insert-mode
" 2013/11/18 by tstan
:set pastetoggle=<F10>
inoremap <C-v> <F10><C-r>+<F10>
vnoremap <C-c> "+y

" provide short cuts for insert mode
" http://stackoverflow.com/questions/1737163/traversing-text-in-insert-mode
:set winaltkeys=no
inoremap <A-h> <Left>
inoremap <A-j> <C-o>j
inoremap <A-k> <C-o>k
" FIXME: the issue here is A-l cannot move to the last column in edit mode
" Use a to see whether this can be fixed
inoremap <A-l> <Right>
" Below <A-f> cannot go to the last (append) position of the line, because 
" the last postion is not a valid insert position.
" but above <A-l> can do it. Take care of this minor difference.
inoremap <A-f> <C-o>w
inoremap <A-b> <C-o>b
inoremap <A-e> <Esc>ea
" reserve A-c for the most common Esc, and use c for down, as sit down
inoremap <A-c> <C-o>4j
inoremap <A-u> <C-o>4k

" map <A-d> for both insert and visual mode
" also add it for normal mode
" mu only for exiting insert mode
inoremap <A-d> <Esc>mu
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
" Refactor functions navigation by usign column search <A-l>
nmap <C-n> <A-l>{<CR>
" nnoremap <C-p> :keepj norm []%zz<CR>
" remap C-p to jump to tag
nnoremap <C-p> mc:exe "tag ".expand("<cword>")<CR>md:call <SID>CheckForPositionChange(0)<CR>

" navigation in one line
nnoremap <A-f> /\%<C-R>=line('.')<CR>l
" navigation in current column
nnoremap <A-l> /\%<C-R>=col('.')<CR>c
nnoremap <A-S-l> ?\%<C-R>=col('.')<CR>c
nnoremap <A-n> :keepj norm nn%zz<CR>
nnoremap <A-p> :keepj norm N%zz<CR>

" make n/N behavior consistent
" nnoremap <expr> n 'Nn'[v:searchforward]
" nnoremap <expr> N 'nN'[v:searchforward]

" shortcuts for insert mode, a/u reserve a/u for in file marks
" not use u register since the existence of gi command
inoremap kk <Esc>'a

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
" Don't enable cursorline in diff mode since it makes diff region mess
if !&diff
    set cursorline
endif

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
" configuratins for sexy scroller
" from https://github.com/joeytwiddle/sexy_scroller.vim
if !has("float")
  echo "smooth_scroller requires the +float feature, which is missing"
  finish
endif

" == Options == "

if !exists("g:SexyScroller_Enabled")
  let g:SexyScroller_Enabled = 1
endif

" We can only really see the cursor moving if 'cursorline' is enabled (or my hiline plugin is running)
if !exists("g:SexyScroller_CursorTime")
  let g:SexyScroller_CursorTime = ( &cursorline || exists("g:hiline") && g:hiline ? 10 : 0 )
endif

" By default, scrolling the buffer is slower then moving the cursor, because a page of text is "heavier" than the cursor.  :)
if !exists("g:SexyScroller_ScrollTime")
  let g:SexyScroller_ScrollTime = 10
endif

if !exists("g:SexyScroller_MaxTime")
  let g:SexyScroller_MaxTime = 800
endif

if !exists("g:SexyScroller_EasingStyle")
  let g:SexyScroller_EasingStyle = 4
endif

if !exists("g:SexyScroller_DetectPendingKeys")
  let g:SexyScroller_DetectPendingKeys = 0
endif

if !exists("g:SexyScroller_Debug")
  let g:SexyScroller_Debug = 0
endif

if !exists("g:SexyScroller_DebugInterruption")
  let g:SexyScroller_DebugInterruption = 0
endif

if !exists("g:SexyScroller_StartSexy")
  let g:SexyScroller_StartSexy = 0
endif

" == Setup == "

command! SexyScrollerToggle call s:ToggleEnabled()
nnoremap <A-q> :call <SID>ToggleEnabled()<CR>

augroup Smooth_Scroller
  autocmd!
  autocmd CursorMoved * call s:CheckForPositionChange(1)
  autocmd CursorMovedI * call s:CheckForPositionChange(1)
  autocmd InsertLeave * call s:CheckForPositionChange(0)
  " Unfortunately we would like to fire on other occasions too, e.g.
  " BufferScrolled, but Vim does not offer enough events for us to hook to!
augroup END

" |CTRL-E| and |CTRL-Y| scroll the window, but do not fire any events for us to detect.
" If the user has not made a custom mapping for them, we will map them to fix this.
if maparg("<C-E>", 'n') == ''
  nnoremap <silent> <C-E> <C-E>:call <SID>CheckForPositionChange(1)<CR>
endif
if maparg("<C-Y>", 'n') == ''
  nnoremap <silent> <C-Y> <C-Y>:call <SID>CheckForPositionChange(1)<CR>
endif

" Map some of the z commands similarly.
" z* commands are not compatible with sexy scroller, it shows up the target
" cursor anyway!!!
if maparg("zt", 'n') == ''
  nnoremap zt zt:call <SID>CheckForPositionChange(0)<CR>
endif
if maparg("zz", 'n') == ''
  nnoremap zz zz:call <SID>CheckForPositionChange(0)<CR>
endif
if maparg("zb", 'n') == ''
  nnoremap zb zb:call <SID>CheckForPositionChange(0)<CR>
endif

nnoremap <silent> / :call <SID>StartSexy()<CR>/
nnoremap <silent> ? :call <SID>StartSexy()<CR>?
nnoremap <silent> <expr> n <SID>StartSexy().'Nn'[v:searchforward]
nnoremap <silent> <expr> N <SID>StartSexy().'nN'[v:searchforward]
nnoremap <silent> <A-space> :call <SID>StartSexy()<CR>*
nnoremap <silent> * :call <SID>StartSexy()<CR>*
nnoremap <silent> # :call <SID>StartSexy()<CR>#
nnoremap <silent> % :call <SID>StartSexy()<CR>%
nn <silent> gg :call <SID>StartSexy()<CR>gg
nn <silent> gd :call <SID>StartSexy()<CR>gd
nn <silent> gD :call <SID>StartSexy()<CR>gD
nn <silent> <expr> G <SID>StartSexy().'G'
nn <silent> <expr> j <SID>StartSexy().'j'
nn <silent> <expr> k <SID>StartSexy().'k'

" back to position is much useful than back to line, so map to convenient key
nnoremap <silent> ' :call <SID>StartSexy()<CR>`
nnoremap <silent>` :call <SID>StartSexy()<CR>'

" C-, is mapped by input method?
" Weird that both C-, C-. even C-; don't work, both local and TS
nnoremap <silent> <A-,> :call <SID>StartSexy()<CR>[{
nnoremap <silent> <A-.> :call <SID>StartSexy()<CR>]}

" this may have issue when navigating to different buffer?
nnoremap <silent> <C-i> :call <SID>StartSexy()<CR><C-i>
nnoremap <silent> <C-o> :call <SID>StartSexy()<CR><C-o>

" Scroll for ctags shortcuts
nnoremap <silent> <C-]> :call <SID>StartSexy()<CR><C-]>zR:call <SID>CheckForPositionChange(0)<CR>
nnoremap <silent> <C-t> :call <SID>StartSexy()<CR><C-t>:call <SID>CheckForPositionChange(0)<CR>

" just saw some code in is_symbols which has nested level more than 10
" Remap to A-m since C-m is <CR> which could be used in q/ or q: mode.
" Cannot fix annoy scroll here, [{ is delayed to load?
" Fixed finally, wrap command to :exe to its abort doesn't block following
" command to save position.
nnoremap <silent> <A-m> mk:call <SID>StartSexy()<CR>mm:exe "norm! [{[{[{[{[{[{[{[{[{[{[{[{[{[{[{[{[{[{[{[{[{"<CR>:call <SID>CheckForPositionChange(0)<CR>

if maparg("<C-d>", 'n') == ''
  nnoremap <silent> <C-d> :call <SID>StartSexy()<CR>:call <SID>ChangeSexyScrollStyle(0)<CR>mk<C-d>:call <SID>CheckForPositionChange(1)<CR>:call <SID>BackupSexyScrollStyle()<CR>
endif

if maparg("<C-U>", 'n') == ''
  nnoremap <silent> <C-u> :call <SID>StartSexy()<CR>:call <SID>ChangeSexyScrollStyle(0)<CR>mk<C-u>:call <SID>CheckForPositionChange(1)<CR>:call <SID>BackupSexyScrollStyle()<CR>
endif

if maparg("<C-f>", 'n') == ''
  nnoremap <silent> <C-f> :call <SID>StartSexy()<CR>:call <SID>ChangeSexyScrollStyle(0)<CR>mk<C-f>:call <SID>CheckForPositionChange(1)<CR>:call <SID>BackupSexyScrollStyle()<CR>
endif

if maparg("<C-b>", 'n') == ''
  nnoremap <silent> <C-b> :call <SID>StartSexy()<CR>:call <SID>ChangeSexyScrollStyle(0)<CR>mk<C-b>:call <SID>CheckForPositionChange(1)<CR>:call <SID>BackupSexyScrollStyle()<CR>
endif

" Search for current selection (from Practical Vim)
" ==============================================================================
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>

function! s:VSetSearch()
    let temp = @s
    norm! gv"sy
    let @/ = '\V'.substitute(escape(@s, '/\'), '\n', '\\n', 'g')
    let @s = temp
endfunction

" == Functions == "

" Globally exposed function, so other scripts may call us.
" Checks if the position of the cursor has changed.
" If 0 is passed, it will do nothing, but will register the new position.
" If 1 is passed and the position has changed, it will scroll smoothly to the new position.
function! g:SexyScroller_ScrollToCursor(...)
  let actIfChange = a:0 >= 1 ? a:1 : 1
  call s:CheckForPositionChange(actIfChange)
endfunction

function! s:ChangeSexyScrollStyle(alternativeStyle)
    let g:backupStyle = g:SexyScroller_EasingStyle
    let g:SexyScroller_EasingStyle = a:alternativeStyle
    let g:backupScrollTime = 15
    let g:SexyScroller_ScrollTime = g:SexyScroller_ScrollTime
endfunction

function! s:BackupSexyScrollStyle()
    let g:SexyScroller_EasingStyle = g:backupStyle
    let g:SexyScroller_ScrollTime = g:backupScrollTime
endfunction

function! s:StartSexy()
    let g:SexyScroller_StartSexy = 1
    return ''
endfunction

function! s:CheckForPositionChange(actIfChange)
  let w:newPosition = winsaveview()
  let w:newBuffer = bufname('%')
  if a:actIfChange && g:SexyScroller_Enabled && g:SexyScroller_StartSexy
        \ && exists("w:oldPosition")
        \ && exists("w:oldBuffer") && w:newBuffer==w:oldBuffer "&& mode()=='n'
    if s:differ("topline",3) || s:differ("leftcol",3) || s:differ("lnum",2) || s:differ("col",2)
        \ || exists("w:interruptedAnimationAt")
      if s:smooth_scroll(w:oldPosition, w:newPosition)
        return   " Do not save the new position if the scroll was interrupted
      endif
    endif
  endif
  let g:SexyScroller_StartSexy = 0
  let w:oldPosition = w:newPosition
  let w:oldBuffer = w:newBuffer
endfunction

function! s:differ(str,amount)
  return abs( w:newPosition[a:str] - w:oldPosition[a:str] ) > a:amount
endfunction

" This used to return 1 if the scroll was interrupted by a keypress, but now that is indicated by setting w:interruptedAnimationAt
function! s:smooth_scroll(start, end)

  let pi = acos(-1)

  "if g:SexyScroller_Debug
    "echo "Going from ".a:start["topline"]." to ".a:end["topline"]." with lnum from ".a:start["lnum"]." to ".a:end["lnum"]
    "echo "Target offset: ".(a:end["lnum"] - a:end["topline"])
  "endif

  let numLinesToTravel = abs( a:end["lnum"] - a:start["lnum"] )
  let numLinesToScroll = abs( a:end["topline"] - a:start["topline"] )
  let numColumnsToTravel = 0   " abs( a:end["col"] - a:start["col"] )   " No point animating horizontal cursor movement because I can't see the cursor during animation!
  let numColumnsToScroll = abs( a:end["leftcol"] - a:start["leftcol"] )
  let timeForCursorMove = g:SexyScroller_CursorTime * s:hypot(numLinesToTravel, numColumnsToTravel)
  let timeForScroll = g:SexyScroller_ScrollTime * s:hypot(numLinesToScroll, numColumnsToScroll)
  let totalTime = max([timeForCursorMove,timeForScroll])
  "let totalTime = timeForCursorMove + timeForScroll

  "if g:SexyScroller_Debug
    "echo "totalTime=".totalTime." cursor=".timeForCursorMove." (".numLinesToTravel.",".numColumnsToTravel.") scroll=".timeForScroll." (".numLinesToScroll.",".numColumnsToScroll.")"
  "endif

  let totalTime = 1.0 * min([g:SexyScroller_MaxTime,max([0,totalTime])])

  if totalTime < 1
    return
  endif

  let startTime = reltime()
  let current = copy(a:end)

  " Because arguments are immutable
  let start = a:start

  " If we have *just* interrupted a previous animation, then continue from where we left off.
  if exists("w:interruptedAnimationAt")
    let timeSinceInterruption = s:get_ms_since(w:interruptedAnimationAt)
    if g:SexyScroller_DebugInterruption
      echo "Checking interrupted animation, timeSince=".float2nr(timeSinceInterruption)." remaining=".float2nr(w:interruptedAnimationTimeRemaining)
    endif
    if timeSinceInterruption < 50
      let start = w:interruptedAnimationFrom
      if g:SexyScroller_DebugInterruption
        echo "Continuing interrupted animation with ".float2nr(w:interruptedAnimationTimeRemaining)." remaining, from ".start["topline"]
      endif
      " Secondary keystrokes should not make the animation finish sooner than it would have!
      if totalTime < w:interruptedAnimationTimeRemaining
        let totalTime = w:interruptedAnimationTimeRemaining
      endif
      " We could add the times together.  Not sure how I feel about this.
      "let totalTime = 1.0 * min([g:SexyScroller_MaxTime,float2nr(totalTime + w:interruptedAnimationTimeRemaining)])
    endif
    unlet w:interruptedAnimationAt
  endif

  " Although we did this check earlier, this function can be called if w:interruptedAnimationAt is set, and it may sometimes be called unneccessarily, when we are already right next to the destination!  (Without checking, this would cause motion to slow down when I am holding a direction with a very fast keyboard repeat set.  To reproduce, hold keys near a long wrapped line or some folded lines, after which interruptedAnimationAt keeps firing.)
  if numLinesToTravel<2 && numLinesToScroll<2 && numColumnsToTravel<2 && numColumnsToScroll<2
    return
  endif

  if g:SexyScroller_Debug
    echo "Travelling ".numLinesToTravel."/".numLinesToScroll." over ".float2nr(totalTime)."ms"
  endif

  while 1

    let elapsed = s:get_ms_since(startTime) + 8
    " +8 renders the position we should be in half way through the sleep 15m below.
    let thruTime = elapsed * 1.0 / totalTime
    if elapsed >= totalTime
      let thruTime = 1.0
    endif
    if elapsed >= totalTime
      break
    endif

    " Easing
    if g:SexyScroller_EasingStyle == 1
      let thru = cos( 0.5 * pi * (-1.0 + thruTime) )         " fast->slow
    elseif g:SexyScroller_EasingStyle == 2
      let c    = cos( 0.5 * pi * (-1.0 + thruTime) )
      let thru = sqrt(sqrt(c))                               " very fast -> very slow
    elseif g:SexyScroller_EasingStyle == 3
      let thru = 0.5 + 0.5 * cos( pi * (-1.0 + thruTime) )   " slow -> fast -> slow
    elseif g:SexyScroller_EasingStyle == 4
      let cpre = cos( pi * (-1.0 + thruTime) )
      let thru = 0.5 + 0.5 * sqrt(sqrt(abs(cpre))) * ( cpre > 0 ? +1 : -1 )    " very slow -> very fast -> very slow
    else
      let thru = thruTime
    endif

    let notThru = 1.0 - thru
    let current["topline"] = float2nr( notThru*start["topline"] + thru*a:end["topline"] + 0.5 )
    let current["leftcol"] = float2nr( notThru*start["leftcol"] + thru*a:end["leftcol"] + 0.5 )
    let current["lnum"] = float2nr( notThru*start["lnum"] + thru*a:end["lnum"] + 0.5 )
    let current["col"] = float2nr( notThru*start["col"] + thru*a:end["col"] + 0.5 )
    "echo "thruTime=".printf('%g',thruTime)." thru=".printf('%g',thru)." notThru=".printf('%g',notThru)." topline=".current["topline"]." leftcol=".current["leftcol"]." lnum=".current["lnum"]." col=".current["col"]

    call winrestview(current)
    redraw

    exec "sleep 15m"

    " Break out of the current animation if the user presses a new key.
    " Set some vars so that we can resume this animation from where it was interrupted, if the pending keys trigger further motion.
    " If they don't trigger another motion, the animation will simply jump to the destination.
    if g:SexyScroller_DetectPendingKeys && getchar(1)
      let w:oldPosition = a:end
      let w:interruptedAnimationAt = reltime()
      let w:interruptedAnimationFrom = current
      let w:interruptedAnimationTimeRemaining = totalTime * (1.0 - thruTime)
      if g:SexyScroller_DebugInterruption
        echo "Pending keys detected at ".reltimestr(reltime())." remaining=".float2nr(w:interruptedAnimationTimeRemaining)
      endif
      " We must now jump to a:end, to be in the right place to process the next keypress, regardless whether it is a movement or edit command.
      " If we do end up resuming this animation, this winrestview will cause flicker, unless we set lazyredraw to prevent it.
      set lazyredraw
      call winrestview(a:end)
      return 0
      " Old approach:
      "let w:oldPosition = current
      "return 1
    endif

  endwhile

  call winrestview(a:end)

  return 0

endfunction

function! s:get_ms_since(time)   " Ta Ter
  let cost = split(reltimestr(reltime(a:time)), '\.')
  return str2nr(cost[0])*1000 + str2nr(cost[1])/1000.0
endfunction

function! s:hypot(x, y)
  "return max([a:x,a:y])
  return float2nr( sqrt(a:x*a:x*1.0 + a:y*a:y*1.0) )
endfunction

function! s:ToggleEnabled()
  let g:SexyScroller_Enabled = !g:SexyScroller_Enabled
  echo "Sexy Scroller is " . ( g:SexyScroller_Enabled ? "en" : "dis" ) . "abled"
endfunction

" ==============================================================================
" config for taglist
let Tlist_Use_SingleClick = 1
let Tlist_Use_Right_Window = 1
nnoremap <silent> <F8> :TlistToggle<CR>

" ==============================================================================
" config for Source Explorer which simulate Source Insight
nnoremap <silent> <F7> :SrcExplToggle<CR>
let g:SrcExpl_gobackKey = '<F11>' " temporary mapping
let g:SrcExpl_jumpKey = "<F10>" 
let g:SrcExpl_refreshTime = 100 

" ==============================================================================
" config for easy-motion, this is the minimal bindings
set rtp+=$HOME/vimfiles/bundle/vundle/
call vundle#rc('$HOME/vimfiles/bundle')
Bundle 'ThomsonTan/vim-easymotion'

let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Bi-directional find motion
" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
" nmap s <Plug>(easymotion-s)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
nmap s <Plug>(easymotion-s2)
omap s <Plug>(easymotion-s2)
nmap T <Plug>(easymotion-bd-tl)
omap T <Plug>(easymotion-bd-tl)
nmap F <Plug>(easymotion-sl)
omap F <Plug>(easymotion-sl)

" Turn on case sensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <A-j> <Plug>(easymotion-j)
map <A-k> <Plug>(easymotion-k)

" ==============================================================================
" config for quickhl
Bundle 'ThomsonTan/vim-quickhl'

let g:quickhl_hl_keyword=1
let g:quickhl_manual_hl_priority=-1

nmap <Space> <Plug>(quickhl-manual-this)
xmap <Space> <Plug>(quickhl-manual-this)
nmap <A-u> <Plug>(quickhl-manual-reset)
xmap <A-u> <Plug>(quickhl-manual-reset)

nmap <A-i> <Plug>(quickhl-cword-toggle)
" be care to enable tag-toogle, performance degrade on large tags/files
nmap <F5> <Plug>(quickhl-tag-toggle)
map H <Plug>(operator-quickhl-manual-this-motion)

" ==============================================================================
" configuration for YCM
" since this is special build for Windows, no need to update it through
" Vundle, requires a special build
" Bundle 'ThomsonTan/YouCompleteMe'

" ==============================================================================
" configuration for identLine
" Disable it by default for performance reason
let g:indentLine_enabled=0
Bundle 'Yggdroot/indentLine'
set list lcs=tab:\|\ 
nmap <F4> :IndentLinesToggle<cr>

" ==============================================================================
" configuration for lexima
Bundle 'ThomsonTan/lexima'

" ==============================================================================
" configuration for rainbow
let g:rainbow_active = 1

