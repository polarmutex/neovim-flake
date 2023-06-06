local M = {

    -- lsp
    {
        name = "nvim-lspconfig",
        dir = "@neovimPlugin.nvim-lspconfig@",
        lazy = false,
        config = function()
            require("polarmutex.config.lsp").config()
        end,
    },
    {
        name = "nvim-cmp",
        dir = "@neovimPlugin.nvim-cmp@",
        event = { "InsertEnter", "CmdlineEnter" },
        config = function()
            require("polarmutex.config.cmp").config()
        end,
        dependencies = {
            --{ dir = "L3MON4D3/LuaSnip" },
            { name = "cmp-nvim-lsp", dir = "@neovimPlugin.cmp-nvim-lsp@" },
            { name = "cmp-path", dir = "@neovimPlugin.cmp-path@" },
            { name = "cmp-omni", dir = "@neovimPlugin.cmp-omni@" },
            { name = "cmp-calc", dir = "@neovimPlugin.cmp-calc@" },
            { name = "cmp-buffer", dir = "@neovimPlugin.cmp-buffer@" },
            { name = "cmp-cmdline", dir = "@neovimPlugin.cmp-cmdline@" },
            { name = "cmp-dap", dir = "@neovimPlugin.cmp-dap@" },
            --{ dir = "saadparwaiz1/cmp_luasnip" },
            --{ dir = "rafamadriz/friendly-snippets" },
            { name = "lspkind.nvim", dir = "@neovimPlugin.lsp-kind-nvim@" },
        },
    },
    {
        name = "lspformat.nvim",
        dir = "@neovimPlugin.lsp-format-nvim@",
        event = "LspAttach",
        config = function()
            require("lsp-format").setup({})
            -- to handle :wq
            vim.cmd([[cabbrev wq execute "Format sync" <bar> wq]])
        end,
    },
    {
        name = "lsp-inlayhints.nvim",
        dir = "@neovimPlugin.lsp-inlayhints-nvim@",
        event = "LspAttach",
        config = function()
            require("lsp-inlayhints").setup()
            --local group = vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
            --vim.api.nvim_create_autocmd("LspAttach", {
            --    group = "LspAttach_inlayhints",
            --    callback = function(args)
            --        if not (args.data and args.data.client_id) then
            --            return
            --        end

            --        local client = vim.lsp.get_client_by_id(args.data.client_id)
            --        require("lsp-inlayhints").on_attach(client, args.buf)
            --    end,
            --})
        end,
    },
    {
        name = "null-ls.nvim",
        dir = "@neovimPlugin.null-ls-nvim@",
        event = "CursorHold",
        --dependencies = { lsp_format_spec },
        config = function()
            require("polarmutex.config.null-ls").config()
        end,
    },

    -- treesitter
    {
        name = "nvim-treesitter",
        dir = "@neovimPlugin.nvim-treesitter@",
        dependencies = {
            --{ "nvim-treesitter/nvim-treesitter-textobjects", {} },
            --{ "nvim-treesitter/nvim-treesitter-refactor", {} },
            --{ "windwp/nvim-ts-autotag", {} },
            --{ "JoosepAlviste/nvim-ts-context-commentstring", {} },
            --{ "nvim-treesitter/playground", {} },
        },
        lazy = false,
        config = function()
            require("polarmutex.config.treesitter").config()
        end,
    },
    {
        name = "nvim-treesitter-playground",
        dir = "@neovimPlugin.nvim-treesitter-playground@",
        lazy = false,
    },

    -- dap
    {
        name = "nvim-dap",
        dir = "@neovimPlugin.nvim-dap@",
        event = "CursorHold",
        config = function()
            require("polarmutex.config.dap").config()
        end,
    },
    {
        name = "nvim-dap-ui",
        dir = "@neovimPlugin.nvim-dap-ui@",
        event = "CursorHold",
        dependencies = { "nvim-dap" },
        config = function()
            require("polarmutex.config.dap-ui").config()
        end,
    },
    {
        name = "nvim-dap-virtual-text",
        dir = "@neovimPlugin.nvim-dap-virtual-text@",
        event = "CursorHold",
        dependencies = { "nvim-dap" },
        config = function()
            require("polarmutex.config.dap-virt-text").config()
        end,
    },
    {
        name = "one-small-step-for-vimkind",
        dir = "@neovimPlugin.one-small-step-for-vimkind@",
        dependencies = { "nvim-dap" },
        config = function()
            require("polarmutex.config.dap-lua").config()
        end,
        ft = "lua",
    },
    {
        name = "nvim-dap-python",
        dir = "@neovimPlugin.nvim-dap-python@",
        dependencies = { "nvim-dap" },
        config = function()
            if vim.fn.executable("python3") then
                require("dap-python").setup(vim.fn.exepath("python3"))
            end
        end,
        ft = "python",
    },

    -- git
    {
        name = "gitsigns.nvim",
        dir = "@neovimPlugin.gitsigns-nvim@",
        event = "BufRead",
        config = function()
            require("gitsigns").setup({})
        end,
    },
    {
        name = "gitworktree.nvim",
        dir = "@neovimPlugin.gitworktree-nvim@",
        --dir = "~/repos/personal/git-worktree-nvim/master",
        event = "BufRead",
        config = function()
            require("git-worktree").setup({})
            require("telescope").load_extension("git_worktree")
        end,
    },
    {
        name = "neogit",
        dir = "@neovimPlugin.neogit@",
        lazy = false,
        config = function()
            require("polarmutex.config.neogit").config()
        end,
    },
    {
        name = "diffview.nvim",
        dir = "@neovimPlugin.diffview-nvim@",
        event = "CursorHold",
        config = function()
            require("diffview").setup()
        end,
    },

    -- tasks / dev
    {
        name = "tasks.nvim",
        dir = "@neovimPlugin.tasks-nvim@",
        --dir = "/home/polar/repos/personal/tasks.nvim/main",
        dependencies = {},
        lazy = false,
        config = function()
            require("polarmutex.config.tasks-nvim").config()
        end,
    },
    {
        name = "telescope.nvim",
        dir = "@neovimPlugin.telescope-nvim@",
        event = "CursorHold",
        dependencies = {
            { name = "plenary.nvim", dir = "@neovimPlugin.plenary-nvim@" },
        },
        config = function()
            require("polarmutex.config.telescope-nvim").config()
        end,
    },

    -- ui
    {
        name = "heirline.nvim",
        dir = "@neovimPlugin.heirline-nvim@",
        lazy = false,
        config = function()
            require("polarmutex.config.heirline-nvim").config()
        end,
    },
    {
        name = "noice.nvim",
        dir = "@neovimPlugin.noice-nvim@",
        dependencies = {
            { name = "nui.nvim", dir = "@neovimPlugin.nui-nvim@" },
        },
        lazy = false,
        config = function()
            require("noice").setup()
        end,
    },
    {
        name = "nvim-web-devicons",
        dir = "@neovimPlugin.nvim-web-devicons@",
        lazy = false,
    },

    -- colorscheme
    {
        name = "tokyonight-nvim",
        dir = "@neovimPlugin.tokyonight-nvim@",
        lazy = false,
        priority = 1000,
        config = function()
            require("polarmutex.config.tokyonight-nvim").config()
        end,
    },

    -- beancount
    {
        name = "beancount.nvim",
        dir = "@neovimPlugin.beancount-nvim@",
        ft = "beancount",
        config = function()
            require("polarmutex.config.beancount-nvim").config()
        end,
    },

    -- lua
    {
        name = "neodev.nvim",
        dir = "@neovimPlugin.neodev-nvim@",
        module = "neodev",
        ft = "lua",
    },

    -- rust
    {
        name = "rust-tools",
        dir = "@neovimPlugin.rust-tools-nvim@",
        -- dependencies = { use("neovim/nvim-lspconfig") },
        ft = "rust",
        config = function() end,
    },
    {
        name = "crates.nvim",
        dir = "@neovimPlugin.crates-nvim@",
        ft = "rust",
        config = function()
            require("crates").setup()
        end,
    },

    -- java
    {
        name = "jdtls.nvim",
        dir = "@neovimPlugin.nvim-jdtls@",
    },

    -- misc
    {
        name = "harpoon",
        dir = "@neovimPlugin.harpoon@",
        event = "CursorHold",
        config = function()
            require("harpoon").setup({})
            require("telescope").load_extension("harpoon")
        end,
    },
    {
        name = "vim-be-good",
        dir = "@neovimPlugin.vim-be-good@",
        cmd = "VimBeGood",
        config = function() end,
    },
}

return M
