vim.fn.sign_define("DiagnosticError", { text = "", texthl = "DiagnostinError" })
vim.fn.sign_define("DiagnosticWarn", { text = "", texthl = "DiagnosticWarn" })
vim.fn.sign_define("DiagnosticInfo", { text = "", texthl = "DiagnosticInfo" })
vim.fn.sign_define("DiagnosticHint", { text = "", texthl = "DiagnosticHint" })

vim.diagnostic.config({
    float = { source = "always" }, --TODO borders ?
    virtual_text = true, -- , source = 'always'},
    underline = true,
    signs = true,
    update_in_insert = true,
    severity_sort = true,
})
