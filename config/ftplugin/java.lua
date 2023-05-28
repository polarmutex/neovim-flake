local lspconfig = require("lspconfig")
local root_pattern = lspconfig.util.root_pattern
local on_attach = require("polarmutex.plugins.lsp.on_attach")

local function jdt_on_attach(client, bufnr)
    -- With `hotcodereplace = 'auto' the debug adapter will try to apply code changes
    -- you make during a debug session immediately.
    -- Remove the option if you do not want that.
    -- You can use the `JdtHotcodeReplace` command to trigger it manually
    require("jdtls").setup_dap({ hotcodereplace = "auto" })

    on_attach(client, bufnr)

    --local function set_keymap(...)
    --    vim.api.nvim_buf_set_keymap(bufnr, ...)
    --end
    --local opts = { noremap = true, silent = true }

    --set_keymap("n", "<leader>dc", '<cmd>lua require("jdtls").code_action()<CR>', opts)
    --set_keymap("v", "<leader>dc", '<esc><cmd>lua require("jdtls").code_action(true)<CR>', opts)
    -- set_keymap('n', '<leader>rn', '<cmd>lua require("jdtls").code_action(false, "refactor")<CR>', opts)

    --set_keymap("n", "<leader>di", '<Cmd>lua require"jdtls".organize_imports()<CR>', opts)
    --set_keymap("n", "<leader>de", '<Cmd>lua require("jdtls").extract_variable()<CR>', opts)
    --set_keymap("v", "<leader>de", '<Esc><Cmd>lua require("jdtls").extract_variable(true)<CR>', opts)
    --set_keymap("v", "<leader>dm", '<Esc><Cmd>lua require("jdtls").extract_method(true)<CR>', opts)

    -- Run test mappings
    --set_keymap("n", "cptt", '<Cmd>lua require"jdtls".test_nearest_method()<CR>', opts)
    --set_keymap("n", "cpta", '<Cmd>lua require"jdtls".test_class()<CR>', opts)

    --require("jdtls.setup").add_commands()

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

local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
local root_dir = root_pattern(".git", "gradlew", "mvnw", "pom.xml")(bufname)
local workspace_dir = "/tmp/jdtls_workspaces/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
local bundles = {
    "@java.debug.plugin@",
}

local root_markers = { "gradlew", "pom.xml" }

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
    -- The command that starts the language server
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    cmd = { "@java.jdt-language-server@/bin/jdt-language-server", "-data", workspace_dir },

    root_dir = require("jdtls.setup").find_root(root_markers), --root_dir,

    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a list of options
    settings = {
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
                        path = "@java.jdk8@",
                    },
                    {
                        name = "JavaSE-11",
                        path = "@java.jdk11@/lib/openjdk",
                        default = true,
                    },
                    {
                        name = "JavaSE-17",
                        path = "@java.jdk17@/lib/openjdk",
                    },
                },
            },
            --codeGeneration = {
            --    toString = {
            --        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            --    },
            --},
        },
    },

    -- Language server `initializationOptions`
    -- You need to extend the `bundles` with paths to jar files
    -- if you want to use additional eclipse.jdt.ls plugins.
    --
    -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
    --
    -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
    init_options = {
        bundles = bundles,
        extendedCapabilities = require("jdtls").extendedClientCapabilities,
    },

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
    on_attach = jdt_on_attach,

    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a list of options
    handlers = {},
}

require("jdtls").start_or_attach(config)
