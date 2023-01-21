local dap = require("dap")

local signs = {
    Breakpoint = "",
    BreakpointCondition = "",
    LogPoint = "",
    Stopped = "",
    BreakpointRejected = "",
}

for type, icon in pairs(signs) do
    local hl = "Dap" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = "LspDiagnosticsSignHint" })
end
