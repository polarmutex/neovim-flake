local M = {}

M.setup = function()
    -- Set <space> as the leader key
    -- See `:help mapleader`
    --  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
    vim.g.mapleader = " "
    vim.g.maplocalleader = " "

    -- Set to true if you have a Nerd Font installed
    vim.g.have_nerd_font = false

    -- [[ Setting options ]]
    -- See `:help vim.opt`
    -- NOTE: You can change these options as you wish!
    --  For more options, you can see `:help option-list`

    -- Make line numbers default
    vim.opt.number = true
    -- You can also add relative line numbers, for help with jumping.
    vim.opt.relativenumber = true

    -- Enable mouse mode, can be useful for resizing splits for example!
    vim.opt.mouse = "a"

    -- Don't show the mode, since it's already in status line
    vim.opt.showmode = false

    -- Sync clipboard between OS and Neovim.
    --  Remove this option if you want your OS clipboard to remain independent.
    --  See `:help 'clipboard'`
    vim.opt.clipboard = "unnamedplus"

    -- Enable break indent
    vim.opt.breakindent = true

    -- Save undo history
    vim.opt.undofile = true

    -- Case-insensitive searching UNLESS \C or capital in search
    vim.opt.ignorecase = true
    vim.opt.smartcase = true

    -- Keep signcolumn on by default
    vim.opt.signcolumn = "yes"

    -- Decrease update time
    vim.opt.updatetime = 250

    -- Decrease mapped sequence wait time
    -- Displays which-key popup sooner
    vim.opt.timeoutlen = 300

    -- Configure how new splits should be opened
    vim.opt.splitright = true
    vim.opt.splitbelow = true

    -- Sets how neovim will display certain whitespace in the editor.
    --  See `:help 'list'`
    --  and `:help 'listchars'`
    vim.opt.list = true
    vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
    -- vim.opt.listchars = "tab:→→,trail:●,nbsp:○"

    -- Preview substitutions live, as you type!
    vim.opt.inccommand = "split"

    -- Show which line your cursor is on
    vim.opt.cursorline = true

    -- Minimal number of screen lines to keep above and below the cursor.
    vim.opt.scrolloff = 15
    vim.opt.sidescrolloff = 15

    -- Set highlight on search, but clear on pressing <Esc> in normal mode
    vim.opt.hlsearch = true

    -- tabs
    vim.opt.expandtab = true
    vim.opt.shiftwidth = 4
    vim.opt.softtabstop = 4
    vim.opt.tabstop = 4

    -- status line
    vim.opt.laststatus = 3

    -- TODO
    vim.g.completeopt = "menu,menuone,noselect"

    vim.opt.hidden = true
    --vim.opt.fillchars = {
    --    foldopen = "",
    --    foldclose = "",
    --    fold = " ",
    --    foldsep = " ",
    --    diff = "╱",
    --    eob = " ",
    --}
    vim.opt.matchpairs = "(:),{:},[:],<:>"
    vim.opt.showmatch = true
    vim.opt.termguicolors = true
    vim.opt.errorbells = false
    --vim.opt.title = true; # Visual artifacts
    vim.opt.wildignore = "*/tmp/*,*.so,*.swp,*.pyc,*.db,*.sqlite,*.class,*/node_modules/*,*/.git/*"
    vim.opt.wildmode = "list:longest,list:full"

    vim.opt.cmdheight = 0
    vim.opt.splitkeep = "screen"
    vim.opt.conceallevel = 1 -- for obsidian.nvim

    vim.opt.spell = true
    vim.opt.spelllang = "en"
end

return M
