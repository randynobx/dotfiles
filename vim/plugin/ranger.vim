" Copyright (c) 2015 François Cabrol
"
" MIT License
"
" Permission is hereby granted, free of charge, to any person obtaining
" a copy of this software and associated documentation files (the
" "Software"), to deal in the Software without restriction, including
" without limitation the rights to use, copy, modify, merge, publish,
" distribute, sublicense, and/or sell copies of the Software, and to
" permit persons to whom the Software is furnished to do so, subject to
" the following conditions:
"
" The above copyright notice and this permission notice shall be
" included in all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
" EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
" MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
" NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
" LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
" OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
" WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


" ================ Ranger =======================
if has('nvim')
  function! OpenRangerIn(path, edit_cmd)
    let currentPath = expand(a:path)
    let rangerCallback = { 'name': 'ranger', 'edit_cmd': a:edit_cmd }
    function! rangerCallback.on_exit(id, code, _event)
      silent! Bclose!
      try
        if filereadable('/tmp/chosenfile')
          exec system('sed -ie "s/ /\\\ /g" /tmp/chosenfile')
          exec 'argadd ' . system('cat /tmp/chosenfile | tr "\\n" " "')
          exec self.edit_cmd . system('head -n1 /tmp/chosenfile')
          call system('rm /tmp/chosenfile')
        endif
      endtry
    endfunction
    enew
    call termopen('ranger --choosefiles=/tmp/chosenfile ' . currentPath, rangerCallback)
    startinsert
  endfunction
else
  function! OpenRangerIn(path, edit_cmd)
    let currentPath = expand(a:path)
    exec "silent !ranger --choosefiles=/tmp/chosenfile " . currentPath
    if filereadable('/tmp/chosenfile')
      exec system('sed -ie "s/ /\\\ /g" /tmp/chosenfile')
      exec 'argadd ' . system('cat /tmp/chosenfile | tr "\\n" " "')
      exec a:edit_cmd . system('head -n1 /tmp/chosenfile')
      call system('rm /tmp/chosenfile')
    endif
    redraw!
  endfun
endif

" For backwards-compatibility (deprecated)
if exists('g:ranger_open_new_tab') && g:ranger_open_new_tab
  let s:default_edit_cmd='tabedit '
else
  let s:default_edit_cmd='edit '
endif

command! RangerCurrentDirectory call OpenRangerIn("%:p:h", s:default_edit_cmd)
command! RangerWorkingDirectory call OpenRangerIn("", s:default_edit_cmd)
command! Ranger RangerCurrentDirectory

" To open the selected file in a new tab
command! RangerCurrentDirectoryNewTab call OpenRangerIn("%:p:h", 'tabedit ')
command! RangerWorkingDirectoryNewTab call OpenRangerIn("", 'tabedit ')
command! RangerNewTab RangerCurrentDirectoryNewTab

" For retro-compatibility
function! OpenRanger()
  Ranger
endfunction

if !exists('g:ranger_map_keys') || g:ranger_map_keys
  map <leader>f :Ranger<CR>
endif

