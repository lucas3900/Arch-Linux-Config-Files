" fix tabs and autoindent
set tabstop=4
set shiftwidth=4
set expandtab
set ai

" syntax highlighting
syntax on

" display line numbers by default
set number

" ignorecase when searching and improve searching
set ignorecase
set incsearch

" standard encoding
set encoding=utf8 " disable unecessary redrawing
set lazyredraw

" autocomplete for commands
set wildmenu

" remove vi compatibility
set nocompatible

" show column number
set ruler

" distinguish file types
filetype plugin on

if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif

" No sounds
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=
