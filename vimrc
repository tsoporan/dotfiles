"
" tsoporan's vim configuration
"
"
call plug#begin()
Plug 'junegunn/vim-easy-align' " Align around = and such
Plug 'tpope/vim-fugitive' " Git
Plug 'tpope/vim-surround' " '' => \"\"
Plug 'airblade/vim-gitgutter' " Shows git changes beside line numbers
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " Fuzzy finder
Plug 'junegunn/fzf.vim'
Plug 'w0rp/ale' " Async linting engine
Plug 'ervandew/supertab' " Tab auto complete
Plug 'raimondi/delimitmate' " Parens
Plug 'Yggdroot/indentLine' "Indents
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' } "Better undo
Plug 'itchyny/lightline.vim' "Lightweight airline
Plug 'scrooloose/nerdcommenter' " Commenting
Plug 'haya14busa/incsearch.vim' "Improved incremental search
Plug 'w0ng/vim-hybrid' "Color
Plug 'junegunn/gv.vim' "Git commit browser
Plug 'sheerun/vim-polyglot' "Multiple lang support
Plug 'hashivim/vim-terraform' "Terraform

call plug#end()

let mapleader=',' "change from default \

set autochdir " Automatically change the directory
set autowrite " Write before running commands
set nu
set autoindent
set smartindent
set lazyredraw
set hlsearch

set showmode "show what mode we're in
set hidden " hide buffers instead of closing them
set number " show numbers
set numberwidth=4
set nocursorline

" Tabs/spaces
set tabstop=2
set softtabstop=2
set shiftwidth=2 "2 spaces
set shiftround
set expandtab smarttab "spaces instead of tabs

set encoding=utf-8

set textwidth=100
set colorcolumn=+1

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
set background=dark
let g:hybrid_custom_term_colors = 1
let g:hybrid_reduced_contrast = 1 " Remove this line if using the default palette.
colorscheme hybrid

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

" ALE
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['prettier', 'eslint'],
\   'vue': ['prettier', 'eslint'],
\   'python': ['isort', 'black']
\}
let g:ale_fix_on_save = 1

" Move between linting  errors
nnoremap ]r :ALENextWrap<CR>
nnoremap [r :ALEPreviousWrap<CR>

set list listchars=tab:»·,trail:·,nbsp:· " Whitespace

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
nnoremap P :FZF<CR>

"netwr
let g:netrw_liststyle = 3 "Tree view
let g:netrw_banner = 0 "No banner
let g:netrw_browse_split = 4 "Open file in prev window
let g:netrw_altv = 1
let g:netrw_winsize = 25

"Incsearch
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)


" Tmp files
set backupdir=/tmp//,.
set directory=/tmp//,.
if v:version >= 703
  set undodir=/tmp//,.
  set undofile
endif

"Commenting
let g:NERDSpaceDelims = 1 "Spaces after comments

"Terraform
let g:terraform_align=1
let g:terraform_fold_sections=1
