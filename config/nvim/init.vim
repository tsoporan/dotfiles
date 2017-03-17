" nVIM Configuration
call plug#begin()
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'slashmili/alchemist.vim'
Plug 'airblade/vim-gitgutter'
Plug 'luochen1990/rainbow'
Plug 'myusuf3/numbers.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " Fuzzy finder
Plug 'junegunn/fzf.vim'
Plug 'posva/vim-vue' " VueJS
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx' " React JSX
Plug 'leshill/vim-json'
Plug 'fatih/vim-go' "Golang
Plug 'w0rp/ale' " Async linting engine
Plug 'ervandew/supertab' " Tab auto complete
Plug 'raimondi/delimitmate' " Parens
Plug 'chriskempson/base16-vim'  " Base 16 color scheme
call plug#end()

let mapleader=',' "change from default \

set showmode "show what mode we're in
set hidden " hide buffers instead of closing them
set number " show numbers
set cursorline
set copyindent "copies last indent
set smartindent
set cindent

set tabstop=4
set softtabstop=4
set shiftwidth=4 "4 spaces
set shiftround
set expandtab "spaces instead of tabs
set textwidth=0
set foldmethod=marker
set backspace=indent,eol,start "allow backspacing in insert mode
set showcmd "show partial commands
set list "show tab chars, visual whitespace
set ignorecase
set scs "smart search
set laststatus=2 "status line at bottom of window

set showmatch "show matching bracket
set matchtime=5 "bracket blinks

set wildmenu
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
set t_Co=256
colorscheme base16-default-dark
let base16colorspace=256  " Access colors present in 256 colorspace

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

" CtrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

" Easy align
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Vim-javascript
let g:javascript_plugin_flow = 1

" JSX
let g:jsx_ext_required = 0

" ALE
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_enter = 0 " Disable linting on opening file
let g:ale_linters = {'javascript': ['eslint']}

