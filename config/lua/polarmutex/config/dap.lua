local M = {}

M.config = function()
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
end

return M
