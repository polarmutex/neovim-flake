local dap_spec = {
    name = "nvim-dap",
    dir = "@neovimPlugin.nvim-dap@",
    event = "CursorHold",
    config = function()
        for _, file in ipairs({ "dap" }) do
            require("polarmutex.plugins.dap." .. file)
        end
    end,
}

local dapui_spec = {
    name = "nvim-dap-ui",
    dir = "@neovimPlugin.nvim-dap-ui@",
    event = "CursorHold",
    dependencies = { { dir = "mfussenegger/nvim-dap" } },
    config = function()
        require("polarmutex.plugins.dap.ui")
    end,
}

local dap_virtual_text_spec = {
    name = "nvim-dap-virtual-text",
    dir = "@neovimPlugin.nvim-dap-virtual-text@",
    event = "CursorHold",
    config = function()
        require("nvim-dap-virtual-text").setup()
    end,
}

local osv_spec = {
    name = "one-small-step-for-vimkind",
    dir = "@neovimPlugin.one-small-step-for-vimkind@",
    dependencies = { { dir = "@neovimPlugin.nvim-dap" } },
    config = function()
        require("polarmutex.plugins.dap.nlua")
    end,
    ft = "lua",
}

--local dap_go_spec = use("leoluz/nvim-dap-go", {
--    dependencies = { use("mfussenegger/nvim-dap") },
--    config = function()
--        require("dap-go").setup()
--    end,
--    ft = "go",
--})

local dap_python_spec = {
    name = "nvim-dap-python",
    dir = "@neovimPlugin.nvim-dap-python@",
    dependencies = {
        { dir = "@neovimPlugin.nvim-dap@" },
    },
    config = function()
        if vim.fn.executable("python3") then
            require("dap-python").setup(vim.fn.exepath("python3"))
        end
    end,
    ft = "python",
}

return {
    dap_spec,
    dapui_spec,
    dap_virtual_text_spec,
    osv_spec,
    --dap_go_spec,
    dap_python_spec,
}
