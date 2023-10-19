local M = {}
---Gets a 'ClientCapabilities' object, describing the LSP client capabilities
---Extends the object with capabilities provided by plugins.
---@return lsp.ClientCapabilities
function M.make_client_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- Add com_nvim_lsp capabilities
    local cmp_lsp = require("cmp_nvim_lsp")
    local cmp_lsp_capabilities = cmp_lsp.default_capabilities()
    capabilities = vim.tbl_deep_extend("keep", capabilities, cmp_lsp_capabilities)
    -- Add any additional plugin capabilities here.
    -- Make sure to follow the instructions provided in the plugin's docs.
    return capabilities
end

local function prefix_diagnostic(prefix, diagnostic)
    return string.format(prefix .. " %s", diagnostic.message)
end

local sign = function(opts)
    vim.fn.sign_define(opts.name, {
        texthl = opts.name,
        text = opts.text,
        numhl = "",
    })
end

M.setup = function()
    sign({ name = "DiagnosticSignError", text = "󰅚" })
    sign({ name = "DiagnosticSignWarn", text = "⚠" })
    sign({ name = "DiagnosticSignInfo", text = "ⓘ" })
    sign({ name = "DiagnosticSignHint", text = "󰌶" })

    vim.diagnostic.config({
        virtual_text = {
            prefix = "",
            format = function(diagnostic)
                local severity = diagnostic.severity
                if severity == vim.diagnostic.severity.ERROR then
                    return prefix_diagnostic("󰅚", diagnostic)
                end
                if severity == vim.diagnostic.severity.WARN then
                    return prefix_diagnostic("⚠", diagnostic)
                end
                if severity == vim.diagnostic.severity.INFO then
                    return prefix_diagnostic("ⓘ", diagnostic)
                end
                if severity == vim.diagnostic.severity.HINT then
                    return prefix_diagnostic("󰌶", diagnostic)
                end
                return prefix_diagnostic("●", diagnostic)
            end,
        },
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    })
    -- setup autoformat
    require("polarmutex.lsp.format").setup({
        autoformat = true,
    })
end

return M
