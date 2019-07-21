"
" tsoporan's vim configuration
"

call plug#begin()
Plug 'junegunn/vim-easy-align' " Align around = and such
Plug 'tpope/vim-fugitive' " Git
Plug 'tpope/vim-surround' " '' => \"\"
Plug 'luochen1990/rainbow' " Rainbow parens
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " Fuzzy finder
Plug 'junegunn/fzf.vim'
Plug 'w0rp/ale' " Async linting engine
Plug 'ervandew/supertab' " Tab auto complete
Plug 'raimondi/delimitmate' " Parens
Plug 'Yggdroot/indentLine' "Indent indicator
Plug 'itchyny/lightline.vim' "Status bar
Plug 'sheerun/vim-polyglot' "Multiple lang support
Plug 'ludovicchabant/vim-gutentags' " (c)tag management
Plug 'flazz/vim-colorschemes' " Bunch of colors
Plug 'RRethy/vim-illuminate' " Hilite matching words
Plug 'mhinz/vim-signify' "VCS changes indication

call plug#end()

let mapleader=',' "change from default \

set noshowmode

"set autochdir " Automatically change the directory
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

set textwidth=120
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

" Search down into subfolders + tab complete for files
set path+=**

"easily go into paste mode
set pastetoggle=<F2>

"turn backups off
set nobackup
set nowritebackup
set noswapfile

"colors
set background=dark
colorscheme 256-jungle

"persistent undo
set undodir=~/.vim/undo

"tagbar
nnoremap <silent> <F9> :TagbarToggle<CR>

"quick esc
imap jk <ESC>

" Set tabs depending on file type
" JS, HTML, CSS
autocmd Filetype html setlocal ts=2 sts=2 sw=2
autocmd Filetype css setlocal ts=2 sts=2 sw=2
autocmd Filetype scss setlocal ts=2 sts=2 sw=2
autocmd Filetype javascript setlocal ts=2 sts=2 sw=2
autocmd Filetype vue setlocal ts=2 sts=2 sw=2
autocmd FileType vue syntax sync fromstart " Otherwise syntax highlighting tends to break

" PEP8 Python
autocmd BufNewFile,BufRead *.py:
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set textwidth=90
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal g'\"" | endif

" Easy align
" Start interactive EasyAlign in visual mode (e.g. vipga)
nmap ga <Plug>(EasyAlign)

" ALE
let g:ale_linters = {
\  'javascript': ['eslint'],
"\  'typescript': ['tsserver', 'tslint'],
\  'vue': ['eslint'],
\  'python': ['flake8', 'mypy']
\}

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['prettier', 'eslint'],
\   'vue': ['prettier', 'eslint'],
"\   'typescript': ['prettier'],
\   'python': ['black', 'isort', 'add_blank_lines_for_python_control_statements'],
\   'html': ['prettier']
\}
let g:ale_linters_explicit = 1
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
nnoremap <leader>, :FZF<CR>
nnoremap <leader>. :Rg<CR>
nnoremap <leader>l :BLines<CR>

"netwr
let g:netrw_liststyle = 3 "Tree view
let g:netrw_banner = 0 "No banner
let g:netrw_browse_split = 4 "Open file in prev window
let g:netrw_altv = 1
let g:netrw_winsize = 25

" Tmp files
set backupdir=/tmp//,.
set directory=/tmp//,.
if v:version >= 703
  set undodir=/tmp//,.
  set undofile
endif

" Markdown
let g:vim_markdown_conceal = 0

" Lightline
let g:lightline = {
  \ 'colorscheme': 'wombat',
  \ }

" System Clipboard
set clipboard=unnamedplus

" Tags lookup, traverse up
set tags=./tags;/

let g:rainbow_active = 1

" Highlight instead of underline
hi link illuminatedWord Visual

" Here is my writting notes mode, on and off
map <leader>w :set tw=120<CR>:set linebreak<CR>:set spell spelllang=en_us<CR>
map <leader>W :set tw=0<CR>:set nolinebreak<CR>:set nospell<CR>

" Signify
let g:signify_vcs_list = ['git']
hi SignColumn ctermbg=none
highlight DiffAdd     cterm=bold ctermbg=none ctermfg=119
highlight DiffDelete  cterm=bold ctermbg=none ctermfg=167
highlight DiffChange  cterm=bold ctermbg=none ctermfg=227
highlight SignifySignAdd    cterm=bold ctermbg=237  ctermfg=119
highlight SignifySignDelete cterm=bold ctermbg=237  ctermfg=167
highlight SignifySignChange cterm=bold ctermbg=237  ctermfg=227
