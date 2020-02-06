" this plug-in depends on a private gvim.exe to work properly for
" --remote-tab-silent
if has('gui_running')
    nnoremap <A-r> :call SwitchTab()<CR>
    inoremap <A-r> <Esc>:call SwitchTab()<CR>
    nnoremap <A-e> :call CloseCurrentTab()<CR>

    noremap <A-a> :call SearchInActiveTabs('')<Left><Left>
    " nnoremap <A-a> :call CloseDupTabs()<CR>
    inoremap <A-a> :call CloseDupTabs()<CR>

    autocmd TabEnter * call EnterTab()
    autocmd TabLeave * call LeaveTab()
endif

function! SearchInActiveTabs(sPat)
  let iTab = 1
  let tabDescs = []
  for i in range(tabpagenr('$'))
      let tabDesc = TabId2FullPath(iTab)
      let tabDescs += [tabDesc]
      let iTab = iTab + 1
  endfor

  let sortedTabDescs = []
  if (g:cTabPages == len(tabDescs))
      for i in range(g:cTabPages)
          let curTabLine = tabDescs[g:TabStack[i]-1]
          if curTabLine != ''
              let sortedTabDescs += [curTabLine]
          endif
      endfor
  else
      throw "Inconsistent tab page counting " . g:cTabPages . ":" . len(tabDescs)
  endif

  if len(sortedTabDescs) > 0
      let sSearchFiles = ''
      for i in range(len(sortedTabDescs))
        let sSearchFiles = sSearchFiles . sortedTabDescs[i] . ' '
      endfor
      exec ":silent vim /" . a:sPat . "/j" . sSearchFiles . "|22cw|set syn=cpp"
  endif

endfunction

" tab index starts at 1
function! CloseGivenTab(tabIndex)
    let closeTabId = g:TabStack[a:tabIndex]
    if tabpagewinnr(closeTabId, '$') > 1
        " cannot close target tab since it has more than one window
        return 0
    endif
    let buflist = tabpagebuflist(closeTabId)
    for i in buflist
        if getbufvar(i, "&mod") == 1
            " at least one buffer in target tab is closed, don't close it
            return 0
        endif
    endfor

    exec ":tabclose".closeTabId
    " tabclose doesn't fire TabEnter/TabLeave events?
    call remove(g:TabStack, a:tabIndex)
    let g:cTabPages -= 1
    for i in range(g:cTabPages)
        if (g:TabStack[i] > closeTabId)
            let g:TabStack[i] -= 1
        endif
    endfor
    return 1
endfunction

function! CloseDupTabs()
    " remove duplicated tabs
    let lastTabIndex = len(g:TabStack) - 1
    while lastTabIndex > 0
        let curTabName = TabLabel(g:TabStack[lastTabIndex])
        if curTabName == ''
            let lastTabIndex -= 1
            continue
        endif
        let curTabName = fnamemodify(curTabName, ':p')

        let curDup = 0
        for i in range(lastTabIndex)
            let name = TabLabel(g:TabStack[i])
            if name == ''
                continue
            else
                let name = fnamemodify(name, ':p')
            endif
            if name == curTabName
                let curDup = 1
                break
            endif
        endfor

        let tabclosed = 0;
        if curDup == 1
            let tabclosed = CloseGivenTab(lastTabIndex)
        endif
        let lastTabIndex -= tabclosed
    endwhile
endfunction

function! CloseCurrentTab()
    let iCurTab = tabpagenr()
    if (iCurTab != g:TabStack[0])
        echom iCurTab
        echom g:TabStack
        throw "iCurTab != g:TabStack[0]"
    endif
    if (tabpagewinnr(iCurTab, '$') == 1 && len(g:TabStack) > 1)
        " This is the last window in the current tab

        let buflist = tabpagebuflist(iCurTab)
        for i in buflist
            if getbufvar(i, "&mod") == 1
                " at least one buffer in target tab is closed, don't close it
                echom "Current tab has been modified, save it or exit it by :q!"
                return
            endif
        endfor

        let toTab = g:TabStack[1]
        exec ":tabnext".toTab
        " tricky here, TabLeave/TabEnter happened
        if (g:TabStack[0] != toTab)
            throw ":tabnext doesn't trigger TabLeave/TabEnter?"
        endif
        let tabclosed = CloseGivenTab(1)
        if tabclosed == 0
            throw "why tab " . tabclosed . "is not closed which should success?"
        endif

        " close extra tabs
        let lastTabIndex = len(g:TabStack) - 1
        while lastTabIndex > 25
            let tabclosed = CloseGivenTab(lastTabIndex)
            " Breakout the loop for any reason cannot close given tab!
            if tabclosed == 0
                " Switch to the tab which cannot be closed
                exec ":tabnext".g:TabStack[lastTabIndex]
                let tabDesc = TabId2Str(g:TabStack[lastTabIndex]) . ' : ' . lastTabIndex
                throw "Tried to switch to last tab which cannot be closed: " . tabDesc
            endif
            let lastTabIndex -= tabclosed
        endwhile
    else
        exec ":q"
    endif
endfunction

function! EnterTab()
    let cCurTab = tabpagenr('$')
    let iCurTab = tabpagenr()
    if (g:cTabPages == cCurTab - 1)
        " new tab created
        for i in range(g:cTabPages)
            if (g:TabStack[i] >= iCurTab)
                let g:TabStack[i] += 1
            endif
        endfor
        let g:TabStack = [iCurTab] + g:TabStack
        let g:cTabPages += 1
    elseif (g:cTabPages == cCurTab + 1)
        " previous tab closed
        let closePos = index(g:TabStack, g:lastLeftTabId)
        call remove(g:TabStack, closePos)
        let g:cTabPages -= 1
        for i in range(g:cTabPages)
            if (g:TabStack[i] > g:lastLeftTabId)
                let g:TabStack[i] -= 1
            endif
        endfor
    elseif (g:cTabPages == cCurTab)
        " tab switch
        let iCurStackPos = index(g:TabStack, iCurTab)
        call remove(g:TabStack, iCurStackPos)
        let g:TabStack = [iCurTab] + g:TabStack
    endif
endfunction

function! LeaveTab()
    let g:lastLeftTabId = tabpagenr()
endfunction

let g:cTabPages = 0
let g:lastLeftTabId = 0
let g:TabStack = []

" Handle the first tab page
call EnterTab()

let g:filenamePadLen = 26

function! ShowTabLists(tabList, prompt)

  echohl WarningMsg
  echo repeat('-', 80)
  echohl None

  let sortedTabDescs = a:tabList
  let iTab = 1
  for desc in sortedTabDescs
      if (iTab % 2 == 0)
          echohl Question
      else
          echohl None
      endif
      let idChar = nr2char(iTab + 96)
      echo idChar . ' : ' . desc . ' : ' . idChar
      let iTab = iTab + 1
  endfor
  echohl None
  echo a:prompt
endfunction

function! SwitchTab()
  let iTab = 1
  let tabDescs = []
  for i in range(tabpagenr('$'))
      let tabDesc = TabId2Str(iTab) . ' : ' . iTab
      let tabDescs += [tabDesc]
      let iTab = iTab + 1
  endfor

  let sortedTabDescs = []
  if (g:cTabPages == len(tabDescs))
      for i in range(g:cTabPages)
          let curTabMsgLine = tabDescs[g:TabStack[i]-1]
          let sortedTabDescs += [curTabMsgLine]
      endfor
  else
      throw "Inconsistent tab page counting " . g:cTabPages . ":" . len(tabDescs)
  endif

  call ShowTabLists(sortedTabDescs, "Switch to Recent: ")

  let selChar = getchar()
  let cmdId = selChar - 97

  if (cmdId == 0)
      " select 'a' to re-sort the list alphabetically
      redraw!
      let sortedTabDescs = sort(tabDescs, "StringCompare")
      call ShowTabLists(sortedTabDescs, "Switch to Alpha: ")
      let selChar = getchar()
      let cmdId = selChar - 97
  endif

  let cTab = len(sortedTabDescs)

  if cmdId >= 0
      if cmdId < cTab
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

function! StringContain(sArr, str)
    for i in range(len(a:sArr))
        if a:sArr[i] == a:str
            return 1
        endif
    endfor
    return 0
endfunction

function! TabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  return bufname(buflist[winnr - 1])
endfunction

func! TabId2FullPath(index)
  let name = TabLabel(a:index)
  if name == ''
      return ''
  else
      return fnamemodify(name, ':p')
  endif
endfunc

func! TabId2Str(index)
  let name = TabLabel(a:index)
  if name == ''
    if !exists("g:menutrans_no_file")
      let g:menutrans_no_file = "[No file]"
    endif
    let name = "[No file]" "g:menutrans_no_file
  else
    let name = fnamemodify(name, ':p')
  endif
  " detach file name and separate it out:
  let filename = fnamemodify(name, ':t')
  let path = fnamemodify(name,':h')
  let filenamePad = repeat('-', g:filenamePadLen - len(filename))
  return filename . ' ' . filenamePad . ' ' . path
endfunc
