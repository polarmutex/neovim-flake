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
