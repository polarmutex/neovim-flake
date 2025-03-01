return {
    {
        "blink-cmp",
        event = "InsertEnter",
        dependencies = "friendly-snippets",
        after = function()
            ---@module 'blink.cmp'
            ---@type blink.cmp.Config
            local opts = {
                -- 'default' for mappings similar to built-in completion
                keymap = { preset = "default" },
                appearance = {
                    use_nvim_cmp_as_default = false,
                    nerd_font_variant = "mono",
                },
                completion = {
                    accept = {
                        -- experimental auto-brackets support
                        auto_brackets = {
                            enabled = true,
                        },
                    },
                    menu = {
                        draw = {
                            treesitter = { "lsp" },
                        },
                    },
                    documentation = {
                        auto_show = true,
                        auto_show_delay_ms = 200,
                    },
                    ghost_text = {
                        enabled = vim.g.ai_cmp,
                    },
                },
                -- default list of enabled providers defined so that you can extend it
                -- elsewhere in your config, without redefining it, via `opts_extend`
                sources = {
                    default = { "lsp", "path", "snippets", "buffer" },
                },
                -- optionally disable cmdline completions
                cmdline = {
                    enabled = false,
                },
                signature = { enabled = true },
            }
            local blink_cmp = require("blink.cmp")
            blink_cmp.setup(opts)
        end,
    },
    {
        "yanky-nvim",
        event = "DeferredUIEnter",
        after = function()
            local opts = {
                highlight = { timer = 200 },
            }
            require("yanky").setup(opts)
        end,
    },
    {
        "cmake-tools-nvim",
        lazy = true,
        ft = "cpp",
    },
    {
        "rustaceanvim",
        ft = { "rust" },
        after = function()
            ---@type rustaceanvim.Opts
            local opts = {

                tools = {
                    -- executor = "toggleterm",
                },
                server = {
                    on_attach = function(_, bufnr)
                        vim.keymap.set("n", "<leader>cR", function()
                            vim.cmd.RustLsp("codeAction")
                        end, { desc = "Code Action", buffer = bufnr })
                        vim.keymap.set("n", "<leader>dr", function()
                            vim.cmd.RustLsp("debuggables")
                        end, { desc = "Rust Debuggables", buffer = bufnr })
                    end,
                    default_settings = {
                        -- rust-analyzer language server configuration
                        ["rust-analyzer"] = {
                            cargo = {
                                allFeatures = true,
                                loadOutDirsFromCheck = true,
                                buildScripts = {
                                    enable = true,
                                },
                            },
                            -- Add clippy lints for Rust if using rust-analyzer
                            checkOnSave = true,
                            -- Enable diagnostics if using rust-analyzer
                            diagnostics = {
                                enable = true,
                            },
                            procMacro = {
                                enable = true,
                                ignored = {
                                    ["async-trait"] = { "async_trait" },
                                    ["napi-derive"] = { "napi" },
                                    ["async-recursion"] = { "async_recursion" },
                                },
                            },
                            files = {
                                excludeDirs = {
                                    ".direnv",
                                    ".git",
                                    ".github",
                                    ".gitlab",
                                    "bin",
                                    "node_modules",
                                    "target",
                                    "venv",
                                    ".venv",
                                },
                            },
                            inlayHints = {
                                lifetimeElisionHints = {
                                    enable = true,
                                    useParameterNames = true,
                                },
                            },
                        },
                    },
                },
            }
            vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
        end,
    },
    {
        "crates-nvim",
        event = { "BufRead Cargo.toml" },
        after = function()
            ---@type crates.UserConfig
            local opts = {
                completion = {
                    crates = {
                        enabled = true,
                    },
                },
                lsp = {
                    enabled = true,
                    actions = true,
                    completion = true,
                    hover = true,
                },
            }
            require("crates").setup(opts)
        end,
    },
}
