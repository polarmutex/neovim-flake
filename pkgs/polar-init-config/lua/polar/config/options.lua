local set = vim.opt

-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`
-- Set <space> as the leader key

-- Make line numbers default
set.number = true
-- You can also add relative line numbers, for help with jumping.
set.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
set.mouse = "a"

-- Don't show the mode, since it's already in status line
set.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
set.clipboard = { "unnamed", "unnamedplus" }

-- Enable break indent
set.breakindent = true

-- Save undo history
set.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
set.ignorecase = true
set.smartcase = true

-- Keep signcolumn on by default
set.signcolumn = "yes"

-- Decrease update time
set.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
set.timeoutlen = 300

-- Configure how new splits should be opened
set.splitright = true
set.splitbelow = true

-- Sets how neovim will display certain whitespace in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
set.list = true
set.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
-- vim.opt.listchars = "tab:→→,trail:●,nbsp:○"

-- Preview substitutions live, as you type!
set.inccommand = "split"

-- Show which line your cursor is on
set.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
set.scrolloff = 15
set.sidescrolloff = 15

-- Set highlight on search, but clear on pressing <Esc> in normal mode
set.hlsearch = true

-- tabs
set.expandtab = true
set.shiftwidth = 4
set.softtabstop = 4
set.tabstop = 4

-- status line
set.laststatus = 3

-- TODO
set.completeopt = "menu,menuone,noselect"

set.hidden = true
--vim.opt.fillchars = {
--    foldopen = "",
--    foldclose = "",
--    fold = " ",
--    foldsep = " ",
--    diff = "╱",
--    eob = " ",
--}
set.matchpairs = "(:),{:},[:],<:>"
set.showmatch = true
set.termguicolors = true
set.errorbells = false
--vim.opt.title = true; # Visual artifacts
set.wildignore = "*/tmp/*,*.so,*.swp,*.pyc,*.db,*.sqlite,*.class,*/node_modules/*,*/.git/*"
set.wildmode = "list:longest,list:full"

set.cmdheight = 0
set.splitkeep = "screen"
set.conceallevel = 1 -- for obsidian.nvim

set.spell = true
set.spelllang = "en"
