"tsoporan's config ~ tsoporan@gmail.com
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

set nocompatible "removes compatibility with vi

set undofile "allow for persistent undo, i.e after closing file
set undodir=/tmp  "don't litter working dir with persistent undo files

cnoreabbrev Wq wq "treat Wq as wg 
cnoreabbrev W w " treat W as w

" always display the status line
set laststatus=2

"Colorz

set background=dark
let g:solarized_termtrans=1
let g:solarized_termcolors=256
let g:solarized_contrast="high"
let g:solarized_visibility="high"
colorscheme solarized

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
"set ruler
set backspace=indent,eol,start

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

filetype on
filetype plugin on
filetype plugin indent on


autocmd FileType html set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
autocmd FileType javascript set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab

"CloseTag only load for html/xml like files
autocmd FileType html,htmldjango,jinjahtml,eruby,mako let b:closetag_html_style=1
autocmd FileType html,xhtml,xml,htmldjango,jinjahtml,eruby,mako source ~/.vim/bundle/closetag/plugin/closetag.vim

"omnicomplete supertab
let g:SuperTabDefaultCompletionType = "context"


"Map nerdtree to f2
map <F2> :NERDTreeToggle<CR>
