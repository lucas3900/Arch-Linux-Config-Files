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
set encoding=utf8

" disable unecessary redrawing
set lazyredraw

" autocomplete for commands
set wildmenu

" paste please
set paste

" remove vi compatibility
set nocompatible

" show column number
set ruler

" distinguish file types
filetype plugin on

" Vim plugins
call plug#begin('~/.vim/plugged')
    " Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'davidhalter/jedi-vim',
call plug#end()
