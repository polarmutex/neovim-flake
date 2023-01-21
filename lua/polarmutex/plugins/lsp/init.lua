local lspconfig_spec = {
    name = "nvim-lspconfig",
    dir = "@neovimPlugin.nvim-lspconfig@",
    config = function()
        for _, file in ipairs({ "servers", "handlers" }) do
            require("polarmutex.plugins.lsp." .. file)
        end
    end,
    lazy = false,
}

local cmp_spec = {
    name = "nvim-cmp",
    dir = "@neovimPlugin.nvim-cmp@",
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
        require("polarmutex.plugins.lsp.cmp")
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
        { name = "lspkind.nvim", dir = "@neovimPlugin.lspkind-nvim@" },
    },
}

local lsp_format_spec = {
    name = "lspformat.nvim",
    dir = "@neovimPlugin.lspformat-nvim@",
    config = function()
        require("lsp-format").setup({})
        -- to handle :wq
        vim.cmd([[cabbrev wq execute "Format sync" <bar> wq]])
    end,
}

local null_ls_spec = {
    name = "null-ls.nvim",
    dir = "@neovimPlugin.null-ls-nvim@",
    event = "CursorHold",
    dependencies = { lsp_format_spec },
    config = function()
        require("polarmutex.plugins.lsp.null-ls")
    end,
}

local rust_tools_spec = {
    name = "rust-tools.nvim",
    dir = "@neovimPlugin.rust-tools-nvim@",
}

return {
    lspconfig_spec,
    cmp_spec,
    null_ls_spec,
    lsp_format_spec,
    rust_tools_spec,
}
