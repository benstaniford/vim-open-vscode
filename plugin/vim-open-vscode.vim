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

" Function to open current file in VS Code
function! s:OpenCurrentFileInVSCode()
  let l:current_file = expand('%:p')
  let l:current_dir = expand('%:p:h')
  
  if empty(l:current_file)
    echohl WarningMsg
    echo 'No file is currently open'
    echohl None
    return
  endif
  
  " Change to the current file's directory and open the file
  if has('win32') || has('win64')
    " Use start with /B flag to suppress cmd window
    let l:cmd = 'start /B /D ' . shellescape(l:current_dir) . ' ' . g:vscode_path . ' ' . shellescape(l:current_file)
  elseif has('mac')
    let l:cmd = 'open -a "' . g:vscode_path . '" ' . shellescape(l:current_file)
  else
    let l:cmd = 'cd ' . shellescape(l:current_dir) . ' && ' . g:vscode_path . ' ' . shellescape(l:current_file) . ' &'
  endif
  
  call system(l:cmd)
  echo 'Opened ' . l:current_file . ' in VS Code'
endfunction

" Function to open current directory in VS Code
function! s:OpenCurrentDirInVSCode()
  let l:current_dir = getcwd()
  
  " Open the current working directory
  if has('win32') || has('win64')
    " Use start with /B flag to suppress cmd window
    let l:cmd = 'start /B /D ' . shellescape(l:current_dir) . ' ' . g:vscode_path . ' .'
  elseif has('mac')
    let l:cmd = 'open -a "' . g:vscode_path . '" ' . shellescape(l:current_dir)
  else
    let l:cmd = g:vscode_path . ' ' . shellescape(l:current_dir) . ' &'
  endif
  
  call system(l:cmd)
  echo 'Opened ' . l:current_dir . ' in VS Code'
endfunction

" Function to handle the Code command with arguments
function! s:HandleCodeCommand(...)
  if a:0 == 0
    " No arguments - open current file
    call s:OpenCurrentFileInVSCode()
  elseif a:0 == 1 && a:1 == '.'
    " Single argument '.' - open current directory
    call s:OpenCurrentDirInVSCode()
  else
    echohl ErrorMsg
    echo 'Usage: :Code [.] - Use :Code to open current file, :Code . to open current directory'
    echohl None
  endif
endfunction

" Create the :Code command
command! -nargs=? Code call s:HandleCodeCommand(<f-args>)

" Optional: Create mappings (users can add these to their vimrc if desired)
" nnoremap <leader>c :Code<CR>
" nnoremap <leader>C :Code .<CR>
