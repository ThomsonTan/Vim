if has('gui_running')
    noremap <A-r> :call SwitchTab()<CR>
endif

let g:filenamePadLen = 26

function! SwitchTab()
  let iTab = 1
  let tabDescs = []
  echohl Question
  echom repeat('-', 80)
  echohl None
  for i in range(tabpagenr('$'))
      let tabDesc = TabId2Str(iTab) . ' : ' . iTab
      let tabDescs += [tabDesc]
      let iTab = iTab + 1
  endfor
  let sortedTabDescs = sort(tabDescs, "StringCompare")
  let cTab = iTab
  let iTab = 1
  for desc in sortedTabDescs
      let idChar = nr2char(iTab + 96)
      echom idChar . ' : ' . desc . ' : ' . idChar
      let iTab = iTab + 1
  endfor
  echohl Question
  echom "Switch To: "
  echohl None
  let selChar = getchar()
  let cmdId = selChar - 97
  if cmdId >= 0
      if cmdId <= cTab
          exec ":tabnext".sortedTabDescs[cmdId][-2:]
      endif
  endif
  redraw!
endfunction

function! StringCompare(i1, i2)
    let s1 = tolower(a:i1)
    let s2 = tolower(a:i2)
	return s1 ==? s2 ? 0 : s1 >? s2 ? 1 : -1
endfunction

function! TabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  return bufname(buflist[winnr - 1])
endfunction

func! TabId2Str(index)
  let name = TabLabel(a:index)
  if name == ''
    if !exists("g:menutrans_no_file")
      let g:menutrans_no_file = "[No file]"
    endif
    let name = g:menutrans_no_file
  else
    let name = fnamemodify(name, ':p')
  endif
  " detach file name and separate it out:
  let filename = fnamemodify(name, ':t')
  let path = fnamemodify(name,':h')
  let filenamePad = repeat('-', g:filenamePadLen - len(filename))
  return filename . ' ' . filenamePad . ' ' . path
endfunc
