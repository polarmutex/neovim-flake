--local util = require("polarmutex.util")

local M = {}

-- vim.lsp.handlers["textDocument/hover"] = function(_, method, result)
--   print(vim.inspect(result))
-- end

M.autoformat = true

function M.toggle()
    M.autoformat = not M.autoformat
    if M.autoformat then
        --util.info("enabled format on save", "Formatting")
        print("enabled format on save", "Formatting")
    else
        --util.warn("disabled format on save", "Formatting")
        print("disabled format on save", "Formatting")
    end
end

function M.format()
    if M.autoformat then
        vim.lsp.buf.format()
    end
end

function M.has_formatter(ft)
    local sources = require("null-ls.sources")
    local available = sources.get_available(ft, "NULL_LS_FORMATTING")
    return #available > 0
end

function M.setup(client, buf)
    local ft = vim.api.nvim_buf_get_option(buf, "filetype")

    local enable = false
    if M.has_formatter(ft) then
        enable = client.name == "null-ls"
    else
        enable = not (client.name == "null-ls")
    end

    client.server_capabilities.document_formatting = enable
    -- format on save
    if client.server_capabilities.document_formatting then
        vim.cmd([[
      augroup LspFormat
        autocmd! * <buffer>
        autocmd BufWritePre <buffer> lua require("polarmutex.lsp_formatting").format()
      augroup END
    ]]   )
    end
end

return M
