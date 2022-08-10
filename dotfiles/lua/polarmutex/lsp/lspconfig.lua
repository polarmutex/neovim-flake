local lspconfig = require("lspconfig")
local root_pattern = lspconfig.util.root_pattern

local custom_init = function(client)
    client.config.flags = client.config.flags or {}
    client.config.flags.allow_incremental_sync = true
end

local updated_capabilities = vim.lsp.protocol.make_client_capabilities()
--if nvim_status then
--    updated_capabilities = vim.tbl_deep_extend("keep", updated_capabilities, nvim_status.capabilities)
--end
updated_capabilities.textDocument.codeLens = { dynamicRegistration = false }
updated_capabilities = require("cmp_nvim_lsp").update_capabilities(updated_capabilities)

-- TODO: check if this is the problem.
updated_capabilities.textDocument.completion.completionItem.insertReplaceSupport = false

local custom_attach = function(client, buf)
    local filetype = vim.api.nvim_buf_get_option(0, "filetype")
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

    if client.server_capabilities.codeLensProvider then
        if filetype ~= "elm" then
            vim.cmd([[
        augroup lsp_document_codelens
          au! * <buffer>
          autocmd BufEnter ++once         <buffer> lua require"vim.lsp.codelens".refresh()
          autocmd BufWritePost,CursorHold <buffer> lua require"vim.lsp.codelens".refresh()
        augroup END
      ]])
        end
    end

    require("polarmutex.lsp.formatting").setup(client, buf)
end

local servers = {
    beancount = {
        cmd = {
            --"@beancount.beancount-language-server@/bin/beancount-language-server"
            "/home/polar/repos/personal/beancount-language-server/develop/target/debug/beancount-language-server",
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
        cmd = { "@json.jsonls@" },
    },
    pyright = {
        cmd = { "@python.pyright@/bin/pyright-langserver", "--stdio" },
    },
    rnix = {
        cmd = { "@nix.rnix@" },
    },
    rust_analyzer = {
        cmd = { "@rust.rustup@", "run", "nightly", "rust-analyzer" },
    },
    svelte = {
        cmd = { "@svelte.svelte-language-server@" },
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
    sumneko_lua = {
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
            custom_attach(client)

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
        on_attach = custom_attach,
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
-- Java
--
local function progress_report(_, result, ctx)
    local lsp = vim.lsp
    local info = {
        client_id = ctx.client_id,
    }

    local kind = "report"
    if result.complete then
        kind = "end"
    elseif result.workDone == 0 then
        kind = "begin"
    elseif result.workDone > 0 and result.workDone < result.totalWork then
        kind = "report"
    else
        kind = "end"
    end

    local percentage = 0
    if result.totalWork > 0 and result.workDone >= 0 then
        percentage = result.workDone / result.totalWork * 100
    end

    local msg = {
        token = result.id,
        value = {
            kind = kind,
            percentage = percentage,
            title = result.subTask,
            message = result.subTask,
        },
    }
    -- print(vim.inspect(result))

    lsp.handlers["$/progress"](nil, msg, info)
end

local function jdt_on_attach(client, bufnr)
    require("jdtls").setup_dap()
    custom_attach(client, bufnr)

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
        handlers = {
            --["language/progressReport"] = progress_report,
        },
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
