local dap = require("dap")
local dapui = require("dapui")

dapui.setup({
    --icons = { expanded = "▾", collapsed = "▸" },
    --mappings = {
    --    expand = { "<CR>", "<2-LeftMouse>" },
    --    open = "o",
    --    remove = "d",
    --    edit = "e",
    --    repl = "r",
    --    toggle = "t",
    --},
    layouts = {
        {
            elements = {
                "scopes",
                "breakpoints",
                "stacks",
                "watches",
            },
            size = 40,
            position = "left",
        },
        {
            elements = {
                "repl",
                "console",
            },
            size = 10,
            position = "bottom",
        },
    },
    --floating = {
    --    max_height = 0.8,
    --    max_width = 0.8,
    --    border = "single",
    --    mappings = {
    --        close = { "q", "<Esc>" },
    --    },
    --},
    --windows = { indent = 1 },
})

dap.listeners.after.event_initialized["dapui_config"] = dapui.open
dap.listeners.before.event_terminated["dapui_config"] = dapui.close
dap.listeners.before.event_exited["dapui_config"] = dapui.close
