"loads bundles via pathogen
call pathogen#infect()

"basics
syntax on
filetype plugin indent on

set nocompatible "use vim settings
set number
set autoindent smartindent
set expandtab "spaces instead of tabs
set smarttab "be smart when using tabs
set tabstop=4
set softtabstop=4
set shiftwidth=4 "4 spaces
set textwidth=79
set colorcolumn=79
set foldmethod=marker
set backspace=indent,eol,start "allow backspacing in insert mode
set history=50 "keep command history
set showcmd "show partial commands
set list "show tab chars, visual whitespace
set listchars=trail:<
set ignorecase
set scs "smart search
set laststatus=2 "status line at bottom of window

set showmatch "show matching bracket
set hlsearch "highlight search
set wildmenu
set wildignore=*.o,*~,*.pyc
set ruler "show current position
set incsearch

set noerrorbells
set novisualbell

set encoding=utf8

"turn backups off
set nobackup
set nowb
set noswapfile

"colors using solarized
set background=dark
colorscheme solarized

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

"rainbow parens on!
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

"indent guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1
let g:indent_guides_auto_colors = 0
hi IndentGuidesOdd  ctermbg=236
hi IndentGuidesEven ctermbg=233

" Return to last edit position when opening files (You want this!)
 autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%
