local lsp_format = require("lsp-format")

local disable_format_cap = {
    "lua_ls",
    "nil_ls",
}

local on_attach = function(client, bufnr)
    --local filetype = vim.api.nvim_buf_get_option(0, "filetype")

    --set keymaps
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP: jump to definition", buffer = bufnr })
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "LSP: jump to declaration", buffer = bufnr })
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "LSP: jump to implementation", buffer = bufnr })
    vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { desc = "LSP: get type definition", buffer = bufnr })
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "LSP: rename function/variable", buffer = bufnr })
    --vim.keymap.set("n", "<leader>ca", vim.lsp.buf.codeaction, { desc = "LSP: perform code action", buffer = buf })
    vim.keymap.set(
        "n",
        "<leader>dp",
        vim.diagnostic.goto_prev,
        { desc = "LSP: goto to previous diagnostic", buffer = bufnr }
    )
    vim.keymap.set(
        "n",
        "<leader>dn",
        vim.diagnostic.goto_next,
        { desc = "LSP: goto to next diagnostic", buffer = bufnr }
    )
    vim.keymap.set(
        "n",
        "<leader>df",
        vim.diagnostic.open_float,
        { desc = "LSP: open float diagnostic", buffer = bufnr }
    )

    -- Set autocommands conditional on server_capabilities
    if client.server_capabilities.documentHighlightProvider then
        vim.cmd([[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]])
    end

    --if client.server_capabilities.codeLensProvider then
    --    if filetype ~= "elm" then
    --        vim.cmd([[
    --    augroup lsp_document_codelens
    --      au! * <buffer>
    --      autocmd BufEnter ++once         <buffer> lua require"vim.lsp.codelens".refresh()
    --      autocmd BufWritePost,CursorHold <buffer> lua require"vim.lsp.codelens".refresh()
    --    augroup END
    --  ]])
    --    end
    --end

    for _, v in pairs(disable_format_cap) do
        if v == client.name then
            client.server_capabilities.document_formatting = false
            break
        end
    end

    lsp_format.on_attach(client)
end

return on_attach
