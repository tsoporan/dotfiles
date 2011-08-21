"tsoporan's config ~ tsoporan@gmail.com

set nocompatible "removes compatibility with vi

"256 color
set t_Co=256
colorscheme maroloccio 

"better completion
set wildmenu

"default encoding
set encoding=utf-8
set fileencoding=utf-8
scriptencoding utf-8


set history=50    " keep 50 lines of command line history
set showcmd   " display incomplete commands
set incsearch   " do incremental searching
set autoindent


"PEP8 style guides
set tabstop=8
set expandtab  "spaces not tabs
set softtabstop=4 " How many spaces to use when tab is pressed
set shiftwidth=4
set textwidth=79

set history=200
set viminfo='20,\"500
set hlsearch
set cursorline
set number
set numberwidth=2

set showmatch

set showmode
set scrolloff=3
set hidden
set wildmenu
set wildmode=list:longest

"no visualbell
set novisualbell
set noerrorbells

set ttyfast
set ruler
set backspace=indent,eol,start
set laststatus=2

"set relativenumber

set autowrite "automatically save before commands like :next and :make

set wrap
set formatoptions=qrn1

set ignorecase 
set smartcase

"Sets cursor to the last position you were in
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

syntax on

filetype plugin on
filetype plugin indent on

filetype plugin on
autocmd FileType python set complete+=k~/.vim/syntax/python3.0.vim isk+=.,(

"autocmd FileType html set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
"autocmd FileType javascript set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab

"Map nerdtree to f2
map <F2> :NERDTreeToggle<CR>
