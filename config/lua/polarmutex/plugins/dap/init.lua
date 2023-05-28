local dap_spec = {
    name = "nvim-dap",
    dir = "@neovimPlugin.nvim-dap@",
    event = "CursorHold",
    config = function()
        --for _, file in ipairs({ "dap" }) do
        --    require("polarmutex.plugins.dap." .. file)
        --end
        local map = function(lhs, rhs, desc)
            if desc then
                desc = "[DAP] " .. desc
            end

            vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc })
        end

        map("<F5>", require("dap").continue, "continue")
        map("<F9>", require("dap").step_back, "step back")
        map("<F10>", require("dap").step_over, "step over")
        map("<F11>", require("dap").step_into, "step into")
        map("<F12>", require("dap").step_out, "step out")

        map("<leader>db", require("polarmutex.utils.dap").toggle_breakpoint)
        map("<leader>dB", function()
            require("dap").set_breakpoint(vim.fn.input("[DAP] Condition > "))
        end, "conditional breakpoint")

        map("<leader>dr", require("dap").repl.open, "repl")

        map("<leader>de", require("dapui").eval, "ui eval")
        map("<leader>dE", function()
            require("dapui").eval(vim.fn.input("[DAP] Expression > "))
        end, "ui eval input")
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
        require("nvim-dap-virtual-text").setup({
            enabled = true,

            -- DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, DapVirtualTextForceRefresh
            enabled_commands = false,

            -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
            highlight_changed_variables = true,
            highlight_new_as_changed = true,

            -- prefix virtual text with comment string
            commented = false,

            show_stop_reason = true,

            -- experimental features:
            virt_text_pos = "eol", -- position of virtual text, see `:h nvim_buf_set_extmark()`
            all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
        })
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
