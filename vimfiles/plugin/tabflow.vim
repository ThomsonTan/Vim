if has('gui_running')
    nnoremap <A-w> :call ReflowTabWindows()<CR>
endif

function ReflowTabWindows()
    let l:currWindow = winnr()
    let l:prevCount = l:currWindow - 1
    let l:nextCount = winnr('$') - l:currWindow

    let l:marginLines = 6

    let l:currStartLine = line('w0')
    let l:currEndLine = line('w$')

    " assumes all tabs in the same height?
    let l:tabHeight = l:currEndLine - l:currStartLine + 1

    " flow backward
    let l:lastLine = l:currStartLine - l:marginLines
    for i in range(l:currWindow - 1, 1, -1)
        exec 'wincmd W'
        exec 'norm 'l:lastLine . 'zb'
        let l:lastLine = l:lastLine - l:tabHeight
    endfor

    " restore current window
    exec  l:currWindow . 'wincmd w'
    

    " flow forward

    let l:lastLine = l:currEndLine + l:marginLines
    for i in range(l:currWindow + 1, winnr('$'))
        exec 'wincmd w'
        exec 'norm ' . l:lastLine . 'zt'
        let l:lastLine = l:lastLine + l:tabHeight
    endfor

    " restore current window
    exec  l:currWindow . 'wincmd w'
endfunction
