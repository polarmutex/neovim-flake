local M = {}

M.on_attach = function(client, bufnr, user_opts)
    require("polarmutex.lsp.formatting").setup(client, buf)
end

return M
