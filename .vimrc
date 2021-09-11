" fix tabs and autoindent
set tabstop=4
set shiftwidth=4
set noexpandtab
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
    Plug 'davidhalter/jedi-vim'
	" Plug 'neomake/neomake'
	Plug 'vim-syntastic/syntastic'
call plug#end()

" syntastic settings
let g:syntastic_cpp_checkers=['clang_check', 'avrgcc', 'clang_tidy']
let g:syntastic_python_checkers=['python', 'bandit', 'pylint']
" set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" call neomake#configure#automake('nrwi', 500)

let g:syntastic_quiet_messages = {"regex": 'invalid-name\|trailing-whitespace\|missing-\w*-docstring'} 
