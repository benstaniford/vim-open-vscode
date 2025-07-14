# vim-open-vscode

A simple Vim plugin that allows you to open VS Code from within Vim.

## Features

- Open the current file in VS Code with `:Code`
- Open the current directory in VS Code with `:Code .`
- Configurable VS Code executable path
- Cross-platform support (Windows, macOS, Linux)

## Installation

### Using vim-plug

```vim
Plug 'benstaniford/vim-open-vscode'
```

### Using Vundle

```vim
Plugin 'benstaniford/vim-open-vscode'
```

### Using native package management (Vim 8+)

```bash
git clone https://github.com/benstaniford/vim-open-vscode.git ~/.vim/pack/plugins/start/vim-open-vscode
```

## Configuration

By default, the plugin assumes the `code` command is available in your PATH. If VS Code is installed in a different location, you can specify the full path in your vimrc:

```vim
" Examples for different platforms
let g:vscode_path = 'code'  " Default - assumes code is in PATH

" Windows
let g:vscode_path = 'C:\Program Files\Microsoft VS Code\bin\code.cmd'

" macOS
let g:vscode_path = '/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code'

" Linux
let g:vscode_path = '/usr/bin/code'
```

## Usage

### Commands

- `:Code` - Opens the current file in VS Code
- `:Code .` - Opens the current directory in VS Code

### Key Mappings (Optional)

Add these to your vimrc if you want convenient key mappings:

```vim
" Open current file in VS Code
nnoremap <leader>c :Code<CR>

" Open current directory in VS Code
nnoremap <leader>C :Code .<CR>
```

## Examples

```vim
:Code          " Open current file in VS Code
:Code .        " Open current directory in VS Code
```

## Requirements

- Vim 7.0 or later
- VS Code installed on your system
- The `code` command available in PATH (or configured via `g:vscode_path`)

## Troubleshooting

### VS Code doesn't open

Make sure:
1. VS Code is installed
2. The `code` command is available in your PATH
3. Or set `g:vscode_path` to the correct executable path

### Permission denied errors

Ensure the VS Code executable has the correct permissions and you have permission to execute it.

## License

MIT License. See LICENSE file for details.