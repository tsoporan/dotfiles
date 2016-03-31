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
Plugin 'tpope/vim-fugitive'
Plugin 'nanotech/jellybeans.vim'
Plugin 'scrooloose/syntastic'
Plugin 'rking/ag.vim'
Plugin 'luochen1990/rainbow'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'ervandew/supertab'
Plugin 'groenewege/vim-less'
Plugin 'pangloss/vim-javascript'
Plugin 'wting/rust.vim'
Plugin 'elixir-lang/vim-elixir'
Plugin 'kien/ctrlp.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'vim-airline/vim-airline'
Plugin 'mustache/vim-mustache-handlebars'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

let mapleader=',' "change from default \

"basics
syntax on

set showmode "show what mode we're in
set hidden " hide buffers instead of closing them
set number " show numbers
set cursorline
set autoindent
set copyindent "copies last indent
set smartindent
set cindent

set smarttab "be smart when using tabs
set tabstop=4
set softtabstop=4
set shiftwidth=4 "4 spaces
set shiftround
set expandtab "spaces instead of tabs
set textwidth=0
set foldmethod=marker
set backspace=indent,eol,start "allow backspacing in insert mode
set history=100 "keep command history
set showcmd "show partial commands
set list "show tab chars, visual whitespace
set listchars=trail:<
set ignorecase
set scs "smart search
set laststatus=2 "status line at bottom of window

set showmatch "show matching bracket
set matchtime=5 "bracket blinks

set hlsearch "highlight search
set incsearch "show search matches as you type

set wildmenu
set ruler "show current position
set nowrap

set noerrorbells
set novisualbell
set nomodeline

set encoding=utf8

"easily go into paste mode
set pastetoggle=<F2>

" enable using mouse in term
set mouse=a

"turn backups off
set nobackup
set nowritebackup
set noswapfile

"colors
colorscheme jellybeans
set t_Co=256

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

" Set tabs depending on file type
au FileType javascript setlocal shiftwidth=2 tabstop=2
au FileType css setlocal shiftwidth=2 tabstop=2
au FileType less setlocal shiftwidth=2 tabstop=2

" Remember info about open buffers on close
set viminfo^=%

" CtrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
