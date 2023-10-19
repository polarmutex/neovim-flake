return {

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
}
