-- Set updatetime for CursorHold
-- 300ms of no cursor movement to trigger CursorHold
vim.opt.updatetime = 100

vim.fn.sign_define("DiagnosticError", { text = "", texthl = "DiagnostinError" })
vim.fn.sign_define("DiagnosticWarn", { text = "", texthl = "DiagnosticWarn" })
vim.fn.sign_define("DiagnosticInfo", { text = "", texthl = "DiagnosticInfo" })
vim.fn.sign_define("DiagnosticHint", { text = "", texthl = "DiagnosticHint" })

-- Show diagnostic popup on cursor hover
local diag_float_grp = vim.api.nvim_create_augroup("DiagnosticFloat", { clear = true })
vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        vim.diagnostic.open_float(nil, { focusable = false })
    end,
    group = diag_float_grp,
})

vim.diagnostic.config({
    float = { source = "always" }, --TODO borders ?
    virtual_text = true, -- , source = 'always'},
    underline = true,
    signs = true,
    update_in_insert = true,
    severity_sort = true,
})
