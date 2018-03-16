"
" tsoporan's vim configuration
"

call plug#begin()
Plug 'junegunn/vim-easy-align' " Align around = and such
Plug 'tpope/vim-fugitive' " Git
Plug 'tpope/vim-surround' " '' => \"\"
Plug 'slashmili/alchemist.vim' " Elixir
Plug 'airblade/vim-gitgutter' " Shows git changes beside line numbers
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'junegunn/goyo.vim'
Plug 'myusuf3/numbers.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " Fuzzy finder
Plug 'junegunn/fzf.vim'
Plug 'posva/vim-vue' " VueJS
Plug 'fatih/vim-go' "Golang
Plug 'w0rp/ale' " Async linting engine
Plug 'ervandew/supertab' " Tab auto complete
Plug 'raimondi/delimitmate' " Parens
Plug 'elmcast/elm-vim' " Elm lang
Plug 'pangloss/vim-javascript' " JS Syntax
Plug 'mxw/vim-jsx' "JSX
Plug 'leshill/vim-json' " JSON highlighting
Plug 'justinmk/vim-sneak' "Motion 
Plug 'Yggdroot/indentLine' "Indents
Plug 'vimwiki/vimwiki' "Easy note taking
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' } "Better undo
Plug 'itchyny/lightline.vim' "Lightweight airline
Plug 'scrooloose/nerdcommenter' " Commenting

call plug#end()

let mapleader=',' "change from default \

set autochdir " Automatically change the directory
set nu
set autoindent
set smartindent
set lazyredraw

set showmode "show what mode we're in
set hidden " hide buffers instead of closing them
set number " show numbers
set nocursorline

set tabstop=2
set softtabstop=2
set shiftwidth=2 "2 spaces
set shiftround
set expandtab smarttab "spaces instead of tabs
set encoding=utf-8

set textwidth=0
set foldmethod=indent
set backspace=indent,eol,start "allow backspacing in insert mode
set showcmd "show partial commands
set list "show tab chars, visual whitespace
set ignorecase
set scs "smart search
set laststatus=2 "status line at bottom of window

set showmatch "show matching bracket
set matchtime=5 "bracket blinks

set wildmenu
set wildmode=full
set ruler "show current position
set nowrap

set noerrorbells
set novisualbell
set nomodeline

"easily go into paste mode
set pastetoggle=<F2>

"turn backups off
set nobackup
set nowritebackup
set noswapfile

"colors
"let base16colorspace=256  " Access colors present in 256 colorspace
"colorscheme base16-tomorrow-night
set background=dark
colorscheme default

"persistent undo
set undodir=~/.vim/undo

"gundo
nnoremap <silent> <F5> :GundoToggle<CR>

"tagbar
nnoremap <silent> <F9> :TagbarToggle<CR>

"rainbow parans
let g:rainbow_active=1

"quick esc
imap jk <ESC>

" Set tabs depending on file type
" JS, HTML, CSS
autocmd Filetype html setlocal ts=2 sts=2 sw=2
autocmd Filetype css setlocal ts=2 sts=2 sw=2
autocmd Filetype scss setlocal ts=2 sts=2 sw=2
autocmd Filetype javascript setlocal ts=2 sts=2 sw=2
autocmd Filetype vue setlocal ts=2 sts=2 sw=2

" PEP 8 Python
autocmd BufNewFile,BufRead *.py:
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set textwidth=79
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal g'\"" | endif

" Easy align
" Start interactive EasyAlign in visual mode (e.g. vipga)
nmap ga <Plug>(EasyAlign)

" Vim-javascript
let g:javascript_plugin_flow = 1

" JSX 
let g:jsx_ext_required = 0 " Not required to have jsx extension

" ALE
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 1
let g:ale_lint_on_enter = 1 " Disable linting on opening file
let g:ale_linters = {'javascript': ['eslint']}

" Check Python files with flake8 and pylint.
let b:ale_linters = ['flake8', 'pylint']
" Fix Python files with autopep8 and yapf.
let b:ale_fixers = ['autopep8', 'yapf']

set listchars=tab:>-

"Indents
hi Folded ctermbg=black
hi Visual ctermbg=darkgrey

"Vim easy motion
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"Undo
let g:undotree_WindowLayout = 2
nnoremap U :UndotreeToggle<CR>

"FZF
nnoremap F :FZF<CR>

"netwr
let g:netrw_liststyle = 3 "Tree view
let g:netrw_banner = 0 "No banner
let g:netrw_browse_split = 4 "Open file in prev window
let g:netrw_altv = 1 
let g:netrw_winsize = 25
