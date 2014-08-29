" Vundle start up ...

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

"  PLUGINS!
Plugin 'gmarik/Vundle.vim' " let Vundle manage Vundle, required
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-fugitive' ""
Plugin 'nanotech/jellybeans.vim'
Plugin 'jiangmiao/auto-pairs'
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdtree'
"Plugin 'sjl/gundo'
Plugin 'rking/ag.vim'
Plugin 'luochen1990/rainbow'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'ervandew/supertab'
Plugin 'bling/vim-airline'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

let mapleader=',' "change from default \

"basics
syntax on

set number
set cursorline
set autoindent
set smartindent
set cindent

set smarttab "be smart when using tabs
set tabstop=4
set softtabstop=4
set shiftwidth=4 "4 spaces
set expandtab "spaces instead of tabs
set textwidth=0
set foldmethod=marker
set backspace=indent,eol,start "allow backspacing in insert mode
set history=50 "keep command history
set showcmd "show partial commands
set list "show tab chars, visual whitespace
set listchars=trail:<
set ignorecase
set scs "smart search
set laststatus=2 "status line at bottom of window

set showmatch "show matching bracket
set matchtime=5 "bracket blinks

set hlsearch "highlight search
set wildmenu
set ruler "show current position
set incsearch
set nowrap

set noerrorbells
set novisualbell

set encoding=utf8

"turn backups off
set nobackup
set nowritebackup
set noswapfile

"colors
set background=dark
colorscheme jellybeans

"persistent undo
set undodir=~/.vim/undo
set undofile
set undolevels=1000
set undoreload=10000

"gundo
nnoremap <silent> <F5> :GundoToggle<CR>

"nerdtree
nnoremap <silent> <F2> :NERDTreeToggle<CR>

"tagbar
nnoremap <silent> <F9> :TagbarToggle<CR>

"rainbow parans
let g:rainbow_active=1

"quick esc
imap jj <ESC>

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal g'\"" | endif 

" Remember info about open buffers on close
set viminfo^=%
