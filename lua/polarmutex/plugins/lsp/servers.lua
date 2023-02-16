local lspconfig = require("lspconfig")
local root_pattern = lspconfig.util.root_pattern
local on_attach = require("polarmutex.plugins.lsp.on_attach")

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
            --"/home/polar/repos/personal/beancount-language-server/develop/target/master/beancount-language-server",
            "/home/polar/repos/personal/beancount-language-server/develop/target/debug/beancount-language-server",
            "--log",
            "temp",
        },
        init_options = {
            journal_file = "/home/polar/repos/personal/beancount/main.beancount",
        },
    },
    clangd = {
        cmd = {
            "@cpp.clangd@",
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
            auto = true,

            -- Only show inlay hints for the current line
            only_current_line = false,

            -- Event which triggers a refersh of the inlay hints.
            -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
            -- not that this may cause  higher CPU usage.
            -- This option is only respected when only_current_line and
            -- autoSetHints both are true.
            only_current_line_autocmd = "CursorHold",

            -- whether to show parameter hints with the inlay hints or not
            -- default: true
            show_parameter_hints = true,

            -- prefix for parameter hints
            -- default: "<-"
            parameter_hints_prefix = "<- ",

            -- prefix for all the other hints (type, chaining)
            -- default: "=>"
            other_hints_prefix = "=> ",

            -- whether to align to the lenght of the longest line in the file
            max_len_align = false,

            -- padding from the left if max_len_align is true
            max_len_align_padding = 1,

            -- whether to align to the extreme right or not
            right_align = false,

            -- padding from the right if right_align is true
            right_align_padding = 7,

            -- The color of the hints
            highlight = "Comment",
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
                --cargo = {
                --    loadOutDirsFromCheck = true,
                --},
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

--
-- Java
--
local function jdt_on_attach(client, bufnr)
    require("jdtls").setup_dap()
    on_attach(client, bufnr)

    local function set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local opts = { noremap = true, silent = true }

    set_keymap("n", "<leader>dc", '<cmd>lua require("jdtls").code_action()<CR>', opts)
    set_keymap("v", "<leader>dc", '<esc><cmd>lua require("jdtls").code_action(true)<CR>', opts)
    -- set_keymap('n', '<leader>rn', '<cmd>lua require("jdtls").code_action(false, "refactor")<CR>', opts)

    set_keymap("n", "<leader>di", '<Cmd>lua require"jdtls".organize_imports()<CR>', opts)
    set_keymap("n", "<leader>de", '<Cmd>lua require("jdtls").extract_variable()<CR>', opts)
    set_keymap("v", "<leader>de", '<Esc><Cmd>lua require("jdtls").extract_variable(true)<CR>', opts)
    set_keymap("v", "<leader>dm", '<Esc><Cmd>lua require("jdtls").extract_method(true)<CR>', opts)

    -- Run test mappings
    set_keymap("n", "cptt", '<Cmd>lua require"jdtls".test_nearest_method()<CR>', opts)
    set_keymap("n", "cpta", '<Cmd>lua require"jdtls".test_class()<CR>', opts)

    require("jdtls.setup").add_commands()

    --vim.api.nvim_exec(
    --    [[
    --augroup FormatLspAutogroup
    --  autocmd!
    --  autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
    --augroup END
    --]],
    --     false
    -- )
end

function Start_jdtls()
    local settings = {
        java = {
            signatureHelp = { enabled = true },
            --referenceCodeLens = { enabled = true },
            --implementationsCodeLens = { enabled = true },
            --autobuild = { enabled = true },
            --trace = { server = "verbose" },
            -- contentProvider = { preferred = 'fernflower' };
            -- completion = {
            --   favoriteStaticMembers = {
            --     "org.hamcrest.MatcherAssert.assertThat",
            --     "org.hamcrest.Matchers.*",
            --     "org.hamcrest.CoreMatchers.*",
            --     "org.junit.jupiter.api.Assertions.*",
            --     "java.util.Objects.requireNonNull",
            --     "java.util.Objects.requireNonNullElse",
            --     "org.mockito.Mockito.*"
            --   }
            -- },
            sources = {
                organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999,
                },
            },
            configuration = {
                runtimes = {
                    {
                        name = "JavaSE-1.8",
                        path = "/usr/lib/jvm/java-8-openjdk-amd64/jre",
                    },
                },
            },
            --codeGeneration = {
            --    toString = {
            --        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            --    },
            --},
        },
    }
    local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
    local root_dir = root_pattern(".git", "gradlew", "mvnw", "pom.xml")(bufname)
    local workspace_dir = "/tmp/jdtls_workspaces/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
    local bundles = {
        "@java.debug.plugin@",
    }

    local root_markers = { "gradlew", "pom.xml" }

    require("jdtls").start_or_attach({
        cmd = { "@java.jdt-language-server@/bin/jdt-language-server", "-data", workspace_dir },
        on_attach = jdt_on_attach,
        root_dir = require("jdtls.setup").find_root(root_markers), --root_dir,
        capabilities = {
            workspace = {
                configuration = true,
            },
            textDocument = {
                completion = {
                    completionItem = {
                        snippetSupport = true,
                    },
                },
            },
        },
        settings = settings,
        handlers = {},
        init_options = {
            bundles = bundles,
            extendedCapabilities = require("jdtls").extendedClientCapabilities,
        },
    })
end

vim.api.nvim_exec(
    [[
augroup LspCustom
  autocmd!
  autocmd FileType java lua Start_jdtls()
augroup END
]],
    true
)
