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
                    -- optionally disable cmdline completions
                    cmdline = {},
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
}
