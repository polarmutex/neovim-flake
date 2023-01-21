local dap = require("dap")
local dapui = require("dapui")

dapui.setup({
    icons = { expanded = "▾", collapsed = "▸" },
    mappings = {
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
    },
    layouts = {
        {
            elements = {
                "breakpoints",
                "stacks",
                "scopes",
            },
            size = 0.30,
            position = "left",
        },
        {
            elements = {
                "console",
                "watches",
            },
            size = 0.25,
            position = "bottom",
        },
    },
    floating = {
        max_height = 0.8,
        max_width = 0.8,
        border = "single",
        mappings = {
            close = { "q", "<Esc>" },
        },
    },
    windows = { indent = 1 },
})

dap.listeners.after.event_initialized["dapui_config"] = dapui.open
dap.listeners.before.event_terminated["dapui_config"] = dapui.close
dap.listeners.before.event_exited["dapui_config"] = dapui.close
