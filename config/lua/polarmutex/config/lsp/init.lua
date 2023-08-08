local M = {}

M.setup = function(opts)
    --print(vim.inspect(opts))
    local Util = require("polarmutex.utils")

    -- setup autoformat
    require("polarmutex.config.lsp.format").setup(opts)

    -- setup formatting and keymaps
    Util.on_attach(function(client, buffer)
        require("polarmutex.config.lsp.keymaps").on_attach(client, buffer)
    end)

    -- diagnostics
    for name, icon in pairs(require("polarmutex.icons").diagnostics) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
    end

    local inlay_hint = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint

    if opts.inlay_hints.enabled and inlay_hint then
        Util.on_attach(function(client, buffer)
            if client.supports_method("textDocument/inlayHint") then
                inlay_hint(buffer, true)
            end
        end)
    end

    if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
        opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
            or function(diagnostic)
                local icons = require("lazyvim.config").icons.diagnostics
                for d, icon in pairs(icons) do
                    if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                        return icon
                    end
                end
            end
    end

    vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

    local servers = opts.servers

    local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {}
    )

    local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
            capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        if opts.setup[server] then
            if opts.setup[server](server, server_opts) then
                return
            end
        elseif opts.setup["*"] then
            if opts.setup["*"](server, server_opts) then
                return
            end
        end
        require("lspconfig")[server].setup(server_opts)
    end

    for server, _ in pairs(servers) do
        setup(server)
    end
end

return M
