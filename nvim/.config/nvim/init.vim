"
" tsoporan's (n)vim configuration
"

" vim-plug start
call plug#begin('~/.config/nvim/plugged')

Plug 'RRethy/vim-illuminate' " Hilite matching words
Plug 'machakann/vim-highlightedyank' " Highlight yanks
"Plug 'morhetz/gruvbox' "Colors
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'pantharshit00/vim-prisma'
Plug 'hoob3rt/lualine.nvim' "Status line

" Tags
Plug 'liuchengxu/vista.vim'

" Indents
Plug 'lukas-reineke/indent-blankline.nvim'

" Langs
Plug 'sheerun/vim-polyglot' "Lang pack
let g:polyglot_disabled = ["markdown"]

" Text
Plug 'tpope/vim-surround' " '' => \"\"
Plug 'godlygeek/tabular' " Alignment

" VCS
Plug 'tpope/vim-fugitive'

" File explorer
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}

" LSP + Completion
"Plug 'neovim/nvim-lspconfig'
"Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
"Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'github/copilot.vim'
Plug 'Exafunction/codeium.vim'

Plug 'MunifTanjim/nui.nvim'
Plug 'jackMort/ChatGPT.nvim'

" Buffers
Plug 'kyazdani42/nvim-web-devicons' " Recommended (for coloured icons)
Plug 'akinsho/bufferline.nvim'

" Build syntax tree / highlight - experimental
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Find
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }

" Movement
Plug 'phaazon/hop.nvim'

" Misc
Plug 'andymass/vim-matchup' " More powerful %
Plug 'tpope/vim-commentary' "Comment stuff out

" File formatting
Plug 'sbdchd/neoformat'

call plug#end()

syntax on
filetype plugin indent on

" Colors
set termguicolors
set background=dark
"let g:gruvbox_italic=1
"colorscheme gruvbox
colorscheme tokyonight

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

" set textwidth=88
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

"quick esc
imap jk <ESC>

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal g'\"" | endif

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

" Use System Clipboard
set clipboard+=unnamedplus

let g:rainbow_active = 1

" Highlight instead of underline
" hi link illuminatedWord Visual

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

" Show pesky trailing chars
set listchars=nbsp:¬,extends:»,precedes:«,trail:•

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
set signcolumn=number

" Indents
" let g:indentLine_char_list = ['|', '¦', '┆', '┊']
" map <leader>it :IndentLinesToggle<CR>

" Use ripgrep for autocompletion
if executable('rg')
  set grepprg=rg\ --no-heading\ --vimgrep
  set grepformat=%f:%l:%c:%m
endif

" Vista
let g:vista#renderer#enable_icon = 1
let g:vista#renderer#icons = {
\   "function": "\uf794",
\   "variable": "\uf71b",
\  }
let g:vista_icon_indent = ["▸ ", ""]
"g:vista_echo_cursor_strategy = 'both'
nnoremap <leader>vt :Vista finder<CR>

" Useful keybinds
inoremap jk <esc>
inoremap jj :update<CR>


au BufNewFile,BufRead *.prisma setfiletype graphql

" Ripgrep
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --hidden --ignore-case --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
  \           : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
  \   <bang>0)

set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ --follow
let g:rg_derive_root='true'

" See https://github.com/jonhoo/proximity-sort
" Uses proximity-sort for FZF :Files
function! s:list_cmd()
  let base = fnamemodify(expand('%'), ':h:.:S')
  return base == '.' ? 'fd -t f' : printf('fd -t f | proximity-sort %s', expand('%'))
endfunction

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, {'source': s:list_cmd(),
  \                               'options': '--tiebreak=index'}, <bang>0)


let g:coq_settings = { 'auto_start': 'shut-up',  }

" LSP

lua <<EOF
require("bufferline").setup{
  options = {
    diagnostics = "coc",
    show_close_icon = false
  }
}
require'hop'.setup()

vim.opt.list = true
vim.opt.listchars:append("eol:↴")
require('indent_blankline').setup {
    show_current_context = true,
    show_current_context_start = true,
    show_end_of_line = true,
}

-- ChatGPT
require("chatgpt").setup()
EOF


" Keybinds
nnoremap <leader>e <cmd>CHADopen<cr>
nnoremap <leader>cc <cmd>:close<cr>

" Bufferline
nnoremap <silent><S-L> :BufferLineCycleNext<CR>
nnoremap <silent><S-H> :BufferLineCyclePrev<CR>
nnoremap <leader>bb :BufferLinePick<CR>
nnoremap <leader>bc :BufferLinePickClose<CR>

" Telescope
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fr <cmd>Telescope oldfiles<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fw <cmd>Telescope grep_string<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fs <cmd>Telescope treesitter<cr>


" Reload config
nnoremap <leader>rc :source $MYVIMRC<CR>

let g:python3_host_prog = '/usr/bin/python'

" Enable trimmming of trailing whitespace
let g:neoformat_basic_format_trim = 1

let g:neoformat_enabled_sql = []

" Format on save
augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END

let g:neoformat_enabled_python = ['black']
let g:neoformat_basic_format_trim = 1

" CoC config
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif



" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)


" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction


" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>sr <Plug>(coc-rename)

" Creates a session per CWD, re-loads on open
function! MakeSession()
  let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
  if (filewritable(b:sessiondir) != 2)
    exe 'silent !mkdir -p ' b:sessiondir
    redraw!
  endif
  let b:filename = b:sessiondir . '/session.vim'
  exe "mksession! " . b:filename
endfunction

function! LoadSession()
  let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
  let b:sessionfile = b:sessiondir . "/session.vim"
  if (filereadable(b:sessionfile))
    exe 'source ' b:sessionfile
  else
    echo "No session loaded."
  endif
endfunction

" Adding automatons for when entering or leaving Vim
"if(argc() == 0)
"  au VimEnter * nested :call LoadSession()
"endif
"au VimLeave * :call MakeSession()

" Sessions stuff
set ssop-=options    " do not store global and local values in a session
set ssop-=folds      " do not store folds


" Explicit Coc extensions
let g:coc_global_extensions = [
      \ '@yaegassy/coc-ruff',
      \ 'coc-json',
      \ 'coc-git',
      \ 'coc-pairs',
      \ 'coc-pyright',
      \ 'coc-html',
      \ 'coc-tsserver',
      \ 'coc-prettier',
      \ 'coc-css',
      \ 'coc-diagnostic',
      \ 'coc-eslint',
      \ 'coc-go',
      \ 'coc-graphql',
      \ 'coc-highlight',
      \ 'coc-json',
      \ 'coc-vetur',
      \ 'coc-prisma',
      \ 'coc-typos']

" Tags/Vista
let g:vista#renderer#enable_icon = 1
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista_default_executive = 'coc'
let g:vista_fzf_preview = ['right:40%']

nmap <leader>t :Vista<CR>

"Hop keybinds
nmap <leader>s :HopChar2<CR>
nmap <leader>sp :HopPattern<CR>

" Copilot keys
imap <silent> <C-j> <Plug>(copilot-next)
imap <silent> <C-k> <Plug>(copilot-previous)
imap <silent> <C-\> <Plug>(copilot-dismiss)

" Pyright project root
autocmd FileType python let b:coc_root_patterns = ['.git', '.env', 'venv', '.venv', 'setup.cfg', 'setup.py', 'pyproject.toml', 'pyrightconfig.json']

" Auto sort imports in python with ruff / isort
" autocmd BufWrite *.py :silent call CocAction('runCommand', 'ruff.executeOrganizeImports')
