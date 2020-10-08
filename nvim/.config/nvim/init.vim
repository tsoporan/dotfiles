"
" tsoporan's (n)vim configuration
"

" vim-plug start
call plug#begin('~/.config/nvim/plugged')

" GUI
Plug 'itchyny/lightline.vim' "Status bar
Plug 'morhetz/gruvbox' "Gruvbox colors
Plug 'RRethy/vim-illuminate' " Hilite matching words
Plug 'machakann/vim-highlightedyank' " Highlight yanks
Plug 'Yggdroot/indentLine' "Indents indication

" Langs
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'sheerun/vim-polyglot' "Lang pack

" Text
Plug 'tpope/vim-surround' " '' => \"\"
Plug 'godlygeek/tabular' " Alignment

" VCS
Plug 'tpope/vim-fugitive'

" Nav / working with code
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } "Fuzzy finder
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree' "File browse
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Intellisense
Plug 'andymass/vim-matchup' " More powerful %
Plug 'liuchengxu/vista.vim' " Tags
Plug 'easymotion/vim-easymotion' " Move around quicker
Plug 'tpope/vim-commentary' "Comment stuff out

call plug#end()

syntax on
filetype plugin indent on


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
\  'typescript': ['tsserver', 'tslint'],
\  'vue': ['eslint'],
\  'python': ['flake8', 'mypy'],
\  'svelte': ['eslint']
\}

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['prettier', 'eslint'],
\   'vue': ['prettier', 'eslint'],
\   'typescript': ['prettier'],
\   'python': ['isort', 'black'],
\   'html': ['prettier'],
\   'svelte': ['prettier', 'eslint']
\}

let g:ale_linter_aliases = {'svelte': ['css', 'javascript']}

" Speedups
let b:ale_python_flake8_executable = '/usr/bin/flake8'
let b:ale_python_flake8_use_global = 1
let b:ale_python_mypy_executable = '/usr/bin/mypy'
let b:ale_python_mypy_use_global = 1
let g:ale_virtualenv_dir_names = []

let g:ale_lint_on_save=1
let g:ale_fix_on_save=1
let g:ale_lint_on_enter=0
let g:ale_lint_on_text_changed= 'never'

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

" Show pesky trailing chars
set listchars=nbsp:¬,extends:»,precedes:«,trail:•

" Coc - completion see https://github.com/jonhoo/configs/blob/master/editor/.config/nvim/init.vim
" Python config, use host python
let g:python3_host_prog = '/usr/bin/python'

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
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gi <Plug>(coc-implementation)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" CocList
nnoremap <leader>d : <C-u>CocList diagnostics<CR>
nnoremap <leader>c : <C-u>CocList commands<CR>
nnoremap <leader>s : <C-u>CocList -I symbols<CR>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>

" Indents
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
map <leader>it :IndentLinesToggle

" Use ripgrep for autocompletion
if executable('rg')
  set grepprg=rg\ --no-heading\ --vimgrep
  set grepformat=%f:%l:%c:%m
endif

" Denite settings
"call denite#custom#option('default', {
"      \ 'prompt': '❯'
"      \ })
"
"call denite#custom#var('file/rec', 'command',
"      \ ['fd', '-H', '--full-path'])
"call denite#custom#var('grep', 'command', ['rg'])
"call denite#custom#var('grep', 'default_opts',
"      \ ['--hidden', '--vimgrep', '--smart-case'])
"call denite#custom#var('grep', 'recursive_opts', [])
"call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
"call denite#custom#var('grep', 'separator', ['--'])
"call denite#custom#var('grep', 'final_opts', [])
"call denite#custom#option('_', 'max_dynamic_update_candidates', 100000)
"call denite#custom#option('_', {
"      \ 'split': 'floating',
"      \ 'highlight_matched_char': 'Underlined',
"      \ 'highlight_matched_range': 'NormalFloat',
"      \ 'wincol': &columns / 6,
"      \ 'winwidth': &columns * 2 / 3,
"      \ 'winrow': &lines / 6,
"      \ 'winheight': &lines * 2 / 3
"      \ })
"
"autocmd FileType denite call s:denite_settings()
"
"function! s:denite_settings() abort
"  nnoremap <silent><buffer><expr> <CR>
"        \ denite#do_map('do_action')
"  nnoremap <silent><buffer><expr> <C-v>
"        \ denite#do_map('do_action', 'vsplit')
"  nnoremap <silent><buffer><expr> <C-h>
"        \ denite#do_map('do_action', 'split')
"  nnoremap <silent><buffer><expr> d
"        \ denite#do_map('do_action', 'delete')
"  nnoremap <silent><buffer><expr> p
"        \ denite#do_map('do_action', 'preview')
"  nnoremap <silent><buffer><expr> <Esc>
"        \ denite#do_map('quit')
"  nnoremap <silent><buffer><expr> q
"        \ denite#do_map('quit')
"  nnoremap <silent><buffer><expr> i
"        \ denite#do_map('open_filter_buffer')
"endfunction
"
" Kill filter buffer with esc
"function! s:denite_filter_settings() abort
"  nmap <silent><buffer> <Esc> <Plug>(denite_filter_quit)
"endfunction
"
"nnoremap <leader>. :<C-u>Denite file/rec<CR>
"nnoremap <leader>/ :<C-u>Denite -start-filter grep:::!<CR>
"nnoremap <leader>/ :<C-u>DeniteCursorWord grep:.<CR>

" Vista
"--- Vista ---
let g:vista_default_executive = 'coc'
let g:vista#renderer#enable_icon = 1
let g:vista#renderer#icons = {
\   "function": "\uf794",
\   "variable": "\uf71b",
\  }
let g:vista_icon_indent = ["▸ ", ""]
"g:vista_echo_cursor_strategy = 'both'
nnoremap <leader>ft :Vista finder<CR>

" Useful keybinds
inoremap jk <esc>

nnoremap <leader>ff :Files<CR>
nnoremap <leader>fh :History<CR>
nnoremap <leader>fs :Rg<CR>
"Find word under cursor
nnoremap <leader>fw :Rg <C-R><C-W><CR>
nnoremap <leader>fb :Buffers<CR>


"NERDTree
" Open
nnoremap <leader>op :NERDTreeToggle<CR>

" Open dir of current file
nnoremap <leader>od :NERDTreeToggle %<CR>

" Open to file loc
nnoremap <leader>of :NERDTreeFind<CR>

" Coc Command shortcuts
nnoremap <buffer> <leader>i :CocCommand python.sortImports<CR>

" Light line config with blame
let g:lightline = {
  \ 'colorscheme': 'darcula',
  \ 'active': {
  \   'left': [
  \     [ 'mode', 'paste' ],
  \     [ 'ctrlpmark', 'git', 'diagnostic', 'cocstatus', 'filename', 'method' ]
  \   ],
  \   'right':[
  \     [ 'filetype', 'fileencoding', 'lineinfo'],
  \     [ 'blame' ]
  \   ],
  \ },
  \ 'component_function': {
  \   'blame': 'LightlineGitBlame',
  \ }
\ }

function! LightlineGitBlame() abort
  let blame = get(b:, 'coc_git_blame', '')
  " return blame
  return winwidth(0) > 120 ? blame : ''
endfunction
