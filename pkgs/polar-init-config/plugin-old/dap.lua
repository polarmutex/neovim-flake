local dap = require("dap")
local dapui = require("dapui")

--local signs = {
--    Breakpoint = "",
--    BreakpointCondition = "",
--    LogPoint = "",
--    Stopped = "",
--    BreakpointRejected = "",
--}

--for type, icon in pairs(signs) do
--    local hl = "Dap" .. type
--    vim.fn.sign_define(hl, { text = icon, texthl = "LspDiagnosticsSignHint" })
--end

--for _, file in ipairs({ "dap" }) do
--    require("polar.plugins.dap." .. file)
--end
local map = function(lhs, rhs, desc)
    if desc then
        desc = "[DAP] " .. desc
    end

    vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc })
end

map("<F5>", require("dap").continue, "Debug: Continue")
map("<F9>", require("dap").step_back, "Debug: Step Back")
map("<F10>", require("dap").step_over, "Debug: Step Over")
map("<F11>", require("dap").step_into, "Debug: Step Into")
map("<F12>", require("dap").step_out, "Debug: Step Out")

vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
vim.keymap.set("n", "<leader>B", function()
    dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Debug: Set Breakpoint" })

-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
vim.keymap.set("n", "<F7>", dapui.toggle, { desc = "Debug: See last session result." })

map("<leader>dr", require("dap").repl.open, "repl")

map("<leader>de", require("dapui").eval, "ui eval")
map("<leader>dE", function()
    require("dapui").eval(vim.fn.input("[DAP] Expression > "))
end, "ui eval input")

dapui.setup({
    -- Set icons to characters that are more likely to work in every terminal.
    --    Feel free to remove or use ones that you like more! :)
    --    Don't feel like these are good choices.
    icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
    controls = {
        icons = {
            pause = "⏸",
            play = "▶",
            step_into = "⏎",
            step_over = "⏭",
            step_out = "⏮",
            step_back = "b",
            run_last = "▶▶",
            terminate = "⏹",
            disconnect = "⏏",
        },
    },
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
