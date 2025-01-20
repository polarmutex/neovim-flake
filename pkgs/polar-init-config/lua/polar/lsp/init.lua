local Util = require("polar.utils")

local M = {}
---Gets a 'ClientCapabilities' object, describing the LSP client capabilities
---Extends the object with capabilities provided by plugins.
---@return lsp.ClientCapabilities
function M.make_client_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    -- Add blink.cmp capabilities
    -- capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

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
    vim.lsp.enable("lua_ls")
    vim.lsp.enable("beancount")

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
    -- -- setup autoformat
    -- require("polar.lsp.format").setup({
    --     autoformat = true,
    -- })

    Util.on_attach(function(client, buffer)
        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = buffer, desc = "LSP: " .. desc })
        end

        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        --  To jump back, press <C-t>.
        map("gd", function()
            Snacks.picker.lsp_definitions()
        end, "[G]oto [D]efinition")

        -- Find references for the word under your cursor.
        map("gr", function()
            Snacks.picker.lsp_references()
        end, "[G]oto [R]eferences")

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        map("gI", function()
            Snacks.picker.lsp_implementations()
        end, "[G]oto [I]mplementation")

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map("<leader>gy", function()
            Snacks.picker.lsp_type_definitions()
        end, "Type [D]efinition")

        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        map("<leader>ss", function()
            Snacks.picker.lsp_symbols()
        end, "[D]ocument [S]ymbols")

        -- Fuzzy find all the symbols in your current workspace.
        --  Similar to document symbols, except searches over your entire project.
        -- map("<leader>sS", Snacks.picker.lsp.lsp_workspace_symbols(), "[W]orkspace [S]ymbols")

        -- Rename the variable under your cursor.
        --  Most Language Servers support renaming across files, etc.
        map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

        -- Opens a popup that displays documentation about the word under your cursor
        --  See `:help K` for why this keymap.
        map("K", vim.lsp.buf.hover, "Hover Documentation")

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header.
        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                buffer = buffer,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                buffer = buffer,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
                group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
                callback = function(event2)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
                end,
            })
        end

        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            vim.lsp.inlay_hint.enable()
            map("<leader>th", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(), { bufnr = buffer })
            end, "[T]oggle Inlay [H]ints")
        end
    end)
end

return M
