-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

vim.g.mapleader = " "
vim.g.completeopt = "menu,menuone,noselect"

vim.opt.hidden = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.list = true
vim.opt.listchars = "tab:→→,trail:●,nbsp:○"
vim.opt.matchpairs = "(:),{:},[:],<:>"
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 15
vim.opt.showmatch = true
vim.opt.sidescrolloff = 15
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true
vim.opt.errorbells = false
vim.opt.clipboard = "unnamedplus" -- sync with system clipboard
--vim.opt.title = true; # Visual artifacts
vim.opt.undofile = true
vim.opt.updatetime = 100
vim.opt.wildignore = "*/tmp/*,*.so,*.swp,*.pyc,*.db,*.sqlite,*.class,*/node_modules/*,*/.git/*"
vim.opt.wildmode = "list:longest,list:full"
vim.opt.wrap = false

vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4

vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current

vim.opt.cursorline = true

vim.opt.laststatus = 3

vim.opt.cmdheight = 0
vim.opt.splitkeep = "screen"
