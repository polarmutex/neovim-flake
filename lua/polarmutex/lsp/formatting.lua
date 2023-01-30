local M = {}

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
        print("formatting")
        vim.lsp.buf.format()
    end
end

function M.has_formatter(ft)
    local sources = require("null-ls.sources")
    local available = sources.get_available(ft, "NULL_LS_FORMATTING")
    return #available > 0
end

function M.setup(client, buf)
    local filetype = vim.api.nvim_buf_get_option(0, "filetype")

    local augroup_format = vim.api.nvim_create_augroup("my_lsp_format", { clear = true })
    local autocmd_format = function(async, filter)
        vim.api.nvim_clear_autocmds({ buffer = 0, group = augroup_format })
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = 0,
            callback = function()
                vim.lsp.buf.format({ async = async, filter = filter })
            end,
        })
    end
    local filetype_attach = setmetatable({
        beancount = function()
            autocmd_format(false)
        end,

        java = function()
            autocmd_format(false)
        end,

        json = function()
            autocmd_format(false)
        end,

        lua = function()
            autocmd_format(false)
        end,

        nix = function()
            autocmd_format(false, function(client)
                return client.name ~= "nil_ls"
            end)
        end,

        python = function()
            autocmd_format(false)
        end,

        rust = function()
            autocmd_format(false)
        end,

        svelte = function()
            autocmd_format(false)
        end,

        typescript = function()
            autocmd_format(false, function(client)
                return client.name ~= "tsserver"
            end)
        end,
    }, {
        __index = function()
            return function() end
        end,
    })

    local enable = false
    if M.has_formatter(filetype) then
        enable = client.name == "null-ls"
    else
        enable = not (client.name == "null-ls")
    end

    client.server_capabilities.document_formatting = enable
    -- format on save
    if client.server_capabilities.document_formatting then
        filetype_attach[filetype](client)
        --vim.cmd([[
        --augroup LspFormat
        --autocmd! * <buffer>
        --autocmd BufWritePre <buffer> lua require("polarmutex.lsp.formatting").format()
        --augroup END
        --]])
    end
end

return M
