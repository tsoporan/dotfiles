"
" tsoporan's (n)vim configuration
"

" vim-plug start
call plug#begin('~/.config/nvim/plugged')

" Syntax
Plug 'w0rp/ale' " Async syntax linting/fixing

" GUI
Plug 'itchyny/lightline.vim' "Status bar
Plug 'morhetz/gruvbox' "Gruvbox colors
Plug 'RRethy/vim-illuminate' " Hilite matching words
Plug 'machakann/vim-highlightedyank' " Highlight yanks

" Langs
"Plug 'vim-python/python-syntax' " Python
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'cespare/vim-toml' " Toml
Plug 'stephpy/vim-yaml' " Yaml
Plug 'rust-lang/rust.vim' " Rust
Plug 'rhysd/vim-clang-format' " C
Plug 'plasticboy/vim-markdown' " markdown
Plug 'fatih/vim-go' " Go

" Intellisense for vim
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Text
Plug 'tpope/vim-surround' " '' => \"\"
Plug 'godlygeek/tabular' " Alignment

" VCS
Plug 'tpope/vim-fugitive' " Git
Plug 'mhinz/vim-signify' "VCS changes indication

" Nav
" Build the extra binary if cargo exists on your syst
Plug 'airblade/vim-rooter' " Change cwd when opening file/dir
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " Fuzzy finder
Plug 'junegunn/fzf.vim'
Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' }
"Plug 'pechorin/any-jump.vim' "Find code defs easily
Plug 'andymass/vim-matchup' " More powerful %
Plug 'liuchengxu/vista.vim' " Tagbar replacement

call plug#end()

" Colors
set background=dark
colorscheme gruvbox

let mapleader=',' "change from default \

set noshowmode

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
set expandtab
set smarttab "spaces instead of tabs

set encoding=utf-8

set textwidth=88
set colorcolumn=+1

" Searching
set ignorecase
set smartcase "smart search
set incsearch "incremen


"set foldmethod=indent
set showcmd "show partial commands
set list "show tab chars, visual whitespace
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

set noswapfile

"colors
"set background=dark
"colorscheme blazer

"persistent undo
set undodir=~/.vim/undo


"quick esc
imap jk <ESC>

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal g'\"" | endif

" ALE
let g:ale_linters = {
\  'javascript': ['eslint'],
"\  'typescript': ['tsserver', 'tslint'],
\  'vue': ['eslint'],
\  'python': ['flake8', 'mypy']
\}

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
"\   'javascript': ['prettier', 'eslint'],
"\   'vue': ['prettier', 'eslint'],
"\   'typescript': ['prettier'],
\   'python': ['isort', 'black']
"\   'python': ['add_blank_lines_for_python_control_statements', 'isort', 'black']
"\   'html': ['prettier']
\}

" Speedups
let b:ale_python_flake8_executable = '/usr/bin/flake8'
let b:ale_python_flake8_use_global = 1
let b:ale_python_mypy_executable = '/usr/bin/mypy'
let b:ale_python_mypy_use_global = 1
let g:ale_virtualenv_dir_names = []

let g:ale_linters_explicit=1
let g:ale_fix_on_save=1

" Move between linting  errors
nnoremap ]r :ALENextWrap<CR>
nnoremap [r :ALEPreviousWrap<CR>

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

" Use System Clipboard
set clipboard+=unnamedplus

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
nnoremap <leader>b :Vista<CR>


" File browser using `maple`
nnoremap <leader>f :Clap filer<CR>

" Search jumps, i.e places been
nnoremap <leader>o :Clap jumps<CR>

" Use ripgrep for autocompletion
if executable('rg')
  set grepprg=rg\ --no-heading\ --vimgrep
  set grepformat=%f:%l:%c:%m
endif

set listchars=nbsp:¬,extends:»,precedes:«,trail:•

" Coc - completion see https://github.com/jonhoo/configs/blob/master/editor/.config/nvim/init.vim
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup
" Give more space for displaying messages.
set cmdheight=2
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
