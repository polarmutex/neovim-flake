local lspconfig = require("lspconfig")
local on_attach = require("polarmutex.config.lsp.on_attach")

local custom_init = function(client)
    client.config.flags = client.config.flags or {}
    client.config.flags.allow_incremental_sync = true
end

local updated_capabilities = vim.lsp.protocol.make_client_capabilities()
--if nvim_status then
--    updated_capabilities = vim.tbl_deep_extend("keep", updated_capabilities, nvim_status.capabilities)
--end
updated_capabilities.textDocument.codeLens = { dynamicRegistration = false }
updated_capabilities = require("cmp_nvim_lsp").default_capabilities(updated_capabilities)

-- TODO: check if this is the problem.
updated_capabilities.textDocument.completion.completionItem.insertReplaceSupport = false

local servers = {
    astro = {
        cmd = { "@astro.language-server@", "--stdio" },
    },
    beancount = {
        cmd = {
            --"@beancount.beancount-language-server@/bin/beancount-language-server"
            --"/home/polar/repos/personal/beancount-language-server/master/target/distrib/beancount-language-server-v1.3.0-x86_64-unknown-linux-gnu/beancount-language-server",
            --"/home/polar/repos/personal/beancount-language-server/develop/target/debug/beancount-language-server",
            "/home/polar/repos/personal/beancount-language-server/master/target/release/beancount-language-server",
            --"--log",
            --"temp",
        },
        init_options = {
            journal_file = "/home/polar/repos/personal/beancount/main/main.beancount",
        },
    },
    clangd = {
        cmd = {
            "@cpp.clangd@/bin/clangd",
            "--background-index",
            "--suggest-missing-includes",
            "--clang-tidy",
            "--header-insertion=iwyu",
        },
        -- Required for lsp-status
        init_options = {
            clangdFileStatus = true,
        },
        --handlers = nvim_status and nvim_status.extensions.clangd.setup() or nil,
    },
    gopls = {
        cmd = { "@go.gopls@/bin/gopls" },
    },
    jsonls = {
        cmd = { "@json.jsonls@", "--stdio" },
    },
    pyright = {
        cmd = { "@python.pyright@/bin/pyright-langserver", "--stdio" },
        settings = {
            python = {
                analysis = {
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    diagnosticMode = "openFilesOnly",
                },
            },
        },
    },
    nil_ls = {
        cmd = { "@nix.nil@" },
    },
    -- handled by rust-tools
    --rust_analyzer = {
    --    cmd = { "@rust.analyzer@" },
    --},
    svelte = {
        cmd = { "@svelte.svelte-language-server@", "--stdio" },
        settings = {
            svelte = {
                plugin = {
                    html = { completions = { enable = true, emmet = false } },
                    svelte = { completions = { enable = true, emmet = false } },
                    css = { completions = { enable = true, emmet = false } },
                },
            },
        },
    },
    lua_ls = {
        cmd = { "@lua.sumneko-lua-language-server@/bin/lua-language-server" },
        settings = {
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
            --diagnostics = {
            -- globals = { 'vim' };
            --}
            Lua = {
                format = {
                    enable = false,
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = {
                        -- neovim
                        "vim",
                        -- awesomewm
                        "awesome",
                        "client",
                        "screen",
                    },
                },
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = "LuaJIT",
                    -- Setup your lua path
                    --path = runtime_path,
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = {
                        "[vim.api.nvim_get_runtime_file (",
                        ", true)",
                        "${pkgs.awesome-git}/share/awesome/lib",
                    },
                },
            },
        },
    },
    tsserver = {
        --init_options = ts_util.init_options,
        cmd = { "@typescript.typescript-language-server@", "--stdio" },
        filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
        },

        on_attach = function(client)
            on_attach(client)

            --ts_util.setup({ auto_inlay_hints = false })
            --ts_util.setup_client(client)
        end,
    },
    ltex = {
        cmd = { "@markdown.ltex@/bin/ltex-ls" },
        filetypes = { "markdown" },
        settings = {
            enabled = { "markdown" },
            checkFrequency = "save",
            language = "en-US",
            diagnosticSeverity = "information",
            setenceCacheSize = 5000,
            additionalRules = {
                enablePickyRules = true,
            },
        },
    },
}

local setup_server = function(server, config)
    if not config then
        return
    end

    if type(config) ~= "table" then
        return --we need at least cmd defined for nixos
    end

    config = vim.tbl_deep_extend("force", {
        on_init = custom_init,
        on_attach = on_attach,
        capabilities = updated_capabilities,
        flags = {
            debounce_text_changes = nil,
        },
    }, config)

    lspconfig[server].setup(config)
end

for server, config in pairs(servers) do
    setup_server(server, config)
end

--
-- Rust
--
local rt = require("rust-tools")
rt.setup({
    -- rust-tools options
    tools = {
        -- Automatically set inlay hints (type hints)
        autoSetHints = true,

        -- Whether to show hover actions inside the hover window
        -- This overrides the default hover handler
        -- TODO hover_with_actions is deprecated, please setup a keybind to :RustHoverActions in on_attach instead
        --hover_with_actions = true,

        runnables = {
            -- whether to use telescope for selection menu or not
            use_telescope = true,

            -- rest of the opts are forwarded to telescope
        },

        debuggables = {
            -- whether to use telescope for selection menu or not
            use_telescope = true,

            -- rest of the opts are forwarded to telescope
        },

        -- These apply to the default RustSetInlayHints command
        inlay_hints = {
            -- automatically set inlay hints (type hints)
            -- default: true
            auto = false,

            -- Only show inlay hints for the current line
            --only_current_line = false,

            -- Event which triggers a refersh of the inlay hints.
            -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
            -- not that this may cause  higher CPU usage.
            -- This option is only respected when only_current_line and
            -- autoSetHints both are true.
            --only_current_line_autocmd = "CursorHold",

            -- whether to show parameter hints with the inlay hints or not
            -- default: true
            --show_parameter_hints = true,

            -- prefix for parameter hints
            -- default: "<-"
            --parameter_hints_prefix = "<- ",

            -- prefix for all the other hints (type, chaining)
            -- default: "=>"
            --other_hints_prefix = "=> ",

            -- whether to align to the lenght of the longest line in the file
            --max_len_align = false,

            -- padding from the left if max_len_align is true
            --max_len_align_padding = 1,

            -- whether to align to the extreme right or not
            --right_align = false,

            -- padding from the right if right_align is true
            --right_align_padding = 7,

            -- The color of the hints
            --highlight = "Comment",
        },

        hover_actions = {
            -- the border that is used for the hover window
            -- see vim.api.nvim_open_win()
            border = {
                { "╭", "FloatBorder" },
                { "─", "FloatBorder" },
                { "╮", "FloatBorder" },
                { "│", "FloatBorder" },
                { "╯", "FloatBorder" },
                { "─", "FloatBorder" },
                { "╰", "FloatBorder" },
                { "│", "FloatBorder" },
            },

            -- whether the hover action window gets automatically focused
            auto_focus = false,
        },

        -- debugging stuff
        dap = {
            adapter = {
                type = "executable",
                command = "lldb-vscode",
                name = "rt_lldb",
            },
        },
    },
    server = {
        cmd = { "@rust.analyzer@" },
        on_init = custom_init,
        on_attach = on_attach,
        capabilities = updated_capabilities,
        flags = {
            debounce_text_changes = false,
        },
        settings = {
            ["rust-analyzer"] = {
                --assist = {
                --    importGranularity = "module",
                --    importPrefix = "by_self",
                --},
                cargo = {
                    --features = { "ssr" },
                    --    loadOutDirsFromCheck = true,
                },
                checkOnSave = {
                    command = "clippy",
                },
                --procMacro = {
                --    enable = true,
                --},
            },
        },
    },
})
