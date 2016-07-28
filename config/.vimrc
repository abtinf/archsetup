" break compatability with vi
set nocompatible

" dont visually wrap long lines
set nowrap

" allow switching buffers without saving them first
set hidden

" always show line numbers
set number
" Show row and column info
set ruler

" expand the command and search pattern history
set history=1000

" set terminal title
set title

" start scrolling three lines before the end of screen
set scrolloff=3

" normal backspacing
set backspace=indent,eol,start

" use simple indenting based on previous line indent
set autoindent

" syntax highlighting and file-type specific support
syntax on
filetype on
filetype plugin on
filetype indent on

" Set tab width to 2, ensure that tabs are never autoconverted to spaces
" and indents are 2 columns
set tabstop=2
set softtabstop=2
set shiftwidth=2
set noexpandtab

" hightlight search terms
set hlsearch
" highlight as the search term is typed
set incsearch
" do case-sensitive search only if a capital letter is used
set ignorecase
set smartcase

" wrap at 79 columns
set textwidth=79
set colorcolumn=+1

" Highlight matching brace
set showmatch

" Set color scheme
colorscheme darkblue

" show trailing whitespace
" map W to w
" better open/closing brace/parens/quote support
" map caps to ctrl
" examine vimtutor
" figure out auto-completion 
