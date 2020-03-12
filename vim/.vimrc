"
" tsoporan's vim configuration
"

call plug#begin()
Plug 'junegunn/vim-easy-align' " Align around = and such
Plug 'tpope/vim-fugitive' " Git
Plug 'tpope/vim-surround' " '' => \"\"
Plug 'tpope/vim-sensible' " sensible defaults for Vim
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
"Plug 'majutsushi/tagbar' "Tagbar
Plug 'liuchengxu/vista.vim' " Tagbar replacement
" Build the extra binary if cargo exists on your system.
Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' }
Plug 'pechorin/any-jump.vim'

let &t_ut=''

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

set textwidth=88
set colorcolumn=+1

set foldmethod=indent
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
"colorscheme 256-jungle
colorscheme blazer

"persistent undo
set undodir=~/.vim/undo

"tagbar
nnoremap <leader>b :TagbarToggle<CR>

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
"\   'python': ['add_blank_lines_for_python_control_statements', 'isort', 'black']
\   'python': ['add_blank_lines_for_python_control_statements', 'isort', 'black']
"\   'html': ['prettier']
\}
let g:ale_linters_explicit=1
let g:ale_fix_on_save=1

" Move between linting  errors
nnoremap ]r :ALENextWrap<CR>
nnoremap [r :ALEPreviousWrap<CR>

"Indents
hi Folded ctermbg=black
hi Visual ctermbg=darkgrey

"Vim easy motion
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"Undo
let g:undotree_WindowLayout = 2
nnoremap U :UndotreeToggle<CR>

" FZF auto bind history ctrl-p/ctrl-n
let g:fzf_history_dir = '~/.local/share/fzf-history'

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
"set tags=./tags;/

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


"Rename file + remove old file simultatenously
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>

" Vim clap config

let g:clap_theme = 'material_design_dark'

" Working with files, i.e handy vim-clap bindings
" Search files
nnoremap <leader>, :Clap files<CR>

" Search text
nnoremap <leader>. :Clap grep<CR>

" Bring up tags, uses vista.vim
nnoremap <leader>t :Clap tags<CR>

" File browser using `maple`
nnoremap <leader>f :Clap filer<CR>

" Search jumps, i.e places been
nnoremap <leader>o :Clap jumps<CR>
