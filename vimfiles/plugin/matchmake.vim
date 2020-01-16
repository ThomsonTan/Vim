if has('gui_running')
    nnoremap <A-x> :call MoveToNextMatch(1)<CR>
    nnoremap <C-x> :call MoveToNextMatch(0)<CR>
endif

let g:NextPattern = '^!\s*\(else\|endif\)'
let g:PrevPattern = '^!\s*\(if\|else\)'

let g:NextRecur = '^!\s*if'
let g:PrevRecur = '^!\s*endif'

function MoveToLine(line_nr)
    let target_line_pos = [0, a:line_nr, 0, 0]
    call setpos('.', target_line_pos)
endfunction

function MoveToNextMatch(down)
    if a:down == 1
        let delta = 1
        let target_pat = g:NextPattern
        let recur_pat = g:NextRecur
        let recur_pat_end = g:PrevRecur
    else
        let delta = -1
        let target_pat = g:PrevPattern
        let recur_pat = g:PrevRecur
        let recur_pat_end = g:NextRecur
    endif

    let curr_nr = line('.') + delta
    let total_nr = line('$')

    while delta > 0 && curr_nr <= total_nr || delta < 0 && curr_nr > 0
        let curr_line = getline(curr_nr)
        if curr_line =~ target_pat
            call MoveToLine(curr_nr)
            break
        else
            let curr_nr = curr_nr + delta
            if curr_line =~ recur_pat
                let curr_nr = PassNextMatch(curr_nr, total_nr, delta, recur_pat, recur_pat_end)
            endif
        endif
    endwhile

endfunction

function PassNextMatch(curr_nr, total_nr, delta, recur_pat, recur_pat_end)
    let new_line_nr = a:curr_nr
    while a:delta > 0 && new_line_nr <= a:total_nr || a:delta < 0 && new_line_nr > 0
        let curr_line = getline(new_line_nr)
        let new_line_nr = new_line_nr + a:delta
        if curr_line =~ a:recur_pat_end
            return new_line_nr
        elseif curr_line =~ a:recur_pat
            let new_line_nr = PassNextMatch(new_line_nr, a:total_nr, a:delta, a:recur_pat, a:recur_pat_end)
        endif
    endwhile
    throw 'Cannot find match'
endfunction
