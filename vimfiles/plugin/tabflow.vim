" For multiple windows opened in one tab, show the file lines in sequential in
" all the windows, based on current window

if has('gui_running')
    nnoremap <A-z> :call ReflowTabWindows()<CR>
endif

function ReflowTabWindows()
    let l:currWindow = winnr()
    let l:currStartLine = line('w0')
    let l:currEndLine = line('w$')

    let l:savedScrollOff = &scrolloff

    set scrolloff=0

    " assumes all tabs in the same height?
    let l:tabHeight = l:currEndLine - l:currStartLine + 1

    " flow backward
    let l:lastLine = l:currStartLine - 1
    for i in range(l:currWindow - 1, 1, -1)
        exec 'wincmd W'
        exec 'norm ' . l:lastLine . 'zb'
        exec 'norm ' . (l:savedScrollOff + 1) . 'k'
        let l:lastLine = line('w0') - 1
    endfor

    " restore current window
    exec  l:currWindow . 'wincmd w'

    " flow forward

    let l:firstLine = l:currEndLine + 1
    for i in range(l:currWindow + 1, winnr('$'))
        exec 'wincmd w'
        exec 'norm ' . l:firstLine . 'zt'
        exec 'norm ' . (l:savedScrollOff + 1) . 'j'
        let l:firstLine = line('w$') + 1
    endfor

    " restore current window
    exec  l:currWindow . 'wincmd w'

    let &scrolloff=l:savedScrollOff

endfunction
