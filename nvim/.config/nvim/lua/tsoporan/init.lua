-- tsoporan nvim config

vim.cmd [[colorscheme dracula-soft]]

vim.opt.guicursor = "" -- thic cursor

vim.opt.nu = true      --  line nums
vim.opt.relativenumber = true

-- 4 space indents
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- no line wrapping
vim.opt.wrap = false

-- will manage with undotree
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir'
vim.opt.undofile = true

-- search
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.signcolumn = "yes"

vim.opt.updatetime = 50

vim.opt.colorcolumn = "90"

vim.g.mapleader = ","
