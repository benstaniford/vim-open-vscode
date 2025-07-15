" vim-open-vscode.vim - Open VS Code from Vim
" Maintainer: Ben Staniford
" Version: 1.0
" License: MIT

" Prevent loading twice
if exists('g:loaded_vim_open_vscode')
  finish
endif
let g:loaded_vim_open_vscode = 1

" Default VS Code executable path
" Users can override this in their vimrc with:
" let g:vscode_path = '/path/to/your/code'
if !exists('g:vscode_path')
  if has('win32') || has('win64')
    let g:vscode_path = 'code'
  elseif has('mac')
    let g:vscode_path = 'code'
  else
    let g:vscode_path = 'code'
  endif
endif

" Enable/disable opening files at current line position
" Set to 0 to disable line positioning
if !exists('g:vscode_goto_line')
  let g:vscode_goto_line = 1
endif


if has('win32') || has('win64')
  function! s:ToWindowsPath(target) abort
    let l:cygpath_cmd = 'cygpath -wa ' . a:target
    let l:cygpath = system(l:cygpath_cmd)
    if v:shell_error
      let l:cygpath_cmd = '"C:/Program Files/Git/usr/bin/cygpath.exe" -wa ' . a:target
      let l:cygpath = system(l:cygpath_cmd)
    endif
    return substitute(l:cygpath, '\%x0a', '', 'g')
  endfunction
endif

function! s:OpenInVSCode(target, goto_line)
  let l:target = a:target
  let l:goto_line = a:goto_line
  let l:cmd = ''
  let l:line = line('.')
  let l:col = col('.')

  if has('win32') || has('win64')
    let l:target_win = exists('*s:ToWindowsPath') ? s:ToWindowsPath(l:target) : l:target
    if isdirectory(l:target_win)
      let l:cmd = 'cmd /c ' . g:vscode_path . ' ' . shellescape(l:target_win)
    elseif filereadable(l:target_win)
      if l:goto_line
        let l:cmd = 'cmd /c ' . g:vscode_path . ' --goto ' . shellescape(l:target_win) . ':' . l:line . ':' . l:col
      else
        let l:cmd = 'cmd /c ' . g:vscode_path . ' ' . shellescape(l:target_win)
      endif
    else
      echohl ErrorMsg | echo 'Target does not exist: ' . l:target_win | echohl None | return
    endif
  elseif has('mac')
    if isdirectory(l:target)
      let l:cmd = 'open -a "' . g:vscode_path . '" ' . shellescape(l:target)
    elseif filereadable(l:target)
      if l:goto_line
        let l:cmd = 'open -a "' . g:vscode_path . '" --args --goto ' . shellescape(l:target) . ':' . l:line . ':' . l:col
      else
        let l:cmd = 'open -a "' . g:vscode_path . '" ' . shellescape(l:target)
      endif
    else
      echohl ErrorMsg | echo 'Target does not exist: ' . l:target | echohl None | return
    endif
  else
    if isdirectory(l:target)
      let l:cmd = g:vscode_path . ' ' . shellescape(l:target) . ' &'
    elseif filereadable(l:target)
      if l:goto_line
        let l:cmd = g:vscode_path . ' --goto ' . shellescape(l:target) . ':' . l:line . ':' . l:col . ' &'
      else
        let l:cmd = g:vscode_path . ' ' . shellescape(l:target) . ' &'
      endif
    else
      echohl ErrorMsg | echo 'Target does not exist: ' . l:target | echohl None | return
    endif
  endif
  call system(l:cmd)
  if isdirectory(l:target) || (has('win32') || has('win64') && isdirectory(l:target_win))
    echo 'Opened directory ' . l:target . ' in VS Code'
  else
    if l:goto_line
      echo 'Opened ' . l:target . ' at line ' . l:line . ':' . l:col . ' in VS Code'
    else
      echo 'Opened ' . l:target . ' in VS Code'
    endif
  endif
endfunction

" Function to handle the Code command with arguments

function! s:HandleCodeCommand(...)
  if a:0 == 0
    let l:current_file = expand('%:p')
    if empty(l:current_file)
      echohl WarningMsg | echo 'No file is currently open' | echohl None | return
    endif
    call s:OpenInVSCode(l:current_file, g:vscode_goto_line)
  elseif a:0 == 1
    let l:arg = a:1
    if l:arg == '.'
      let l:dir = getcwd()
      call s:OpenInVSCode(l:dir, 0)
    else
      let l:target = fnamemodify(l:arg, ':p')
      if isdirectory(l:target)
        call s:OpenInVSCode(l:target, 0)
      elseif filereadable(l:target)
        call s:OpenInVSCode(l:target, g:vscode_goto_line)
      else
        echohl ErrorMsg | echo 'Target does not exist: ' . l:target | echohl None | return
      endif
    endif
  else
    echohl ErrorMsg
    echo 'Usage: :Code [.] [file|folder] - Use :Code to open current file, :Code . to open current directory, :Code <folder> to open folder'
    echohl None
  endif
endfunction

" Create the :Code command

function! s:CodeComplete(A, L, P) abort
  let l:pat = a:A
  if stridx(l:pat, '~') == 0
    let l:pat = expand(l:pat)
  endif
  let l:globres = glob(l:pat.'*', 0, 1)
  if type(l:globres) != type([])
    let l:globres = []
  endif
  if empty(l:globres)
    return []
  endif
  return map(l:globres, 'isdirectory(v:val) ? v:val."/" : v:val')
endfunction

command! -nargs=? -complete=customlist,s:CodeComplete Code call s:HandleCodeCommand(<f-args>)

" Optional: Create mappings (users can add these to their vimrc if desired)
" nnoremap <leader>c :Code<CR>
" nnoremap <leader>C :Code .<CR>
