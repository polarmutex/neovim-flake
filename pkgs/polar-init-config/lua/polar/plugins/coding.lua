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
        "mini-nvim",
        event = "DeferredUIEnter",
        after = function()
            local pairs = require("mini.pairs")
            local pair_opts = {
                modes = { insert = true, command = true, terminal = false },
                -- skip autopair when next character is one of these
                skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
                -- skip autopair when the cursor is inside these treesitter nodes
                skip_ts = { "string" },
                -- skip autopair when next character is closing pair
                -- and there are more closing pairs than opening pairs
                skip_unbalanced = true,
                -- better deal with markdown code blocks
                markdown = true,
            }
            pairs.setup(pair_opts)

            local ai = require("mini.ai")
            local ai_opts = {
                n_lines = 500,
                custom_textobjects = {
                    o = ai.gen_spec.treesitter({ -- code block
                        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                    }),
                    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
                    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
                    t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
                    d = { "%f[%d]%d+" }, -- digits
                    e = { -- Word with case
                        {
                            "%u[%l%d]+%f[^%l%d]",
                            "%f[%S][%l%d]+%f[^%l%d]",
                            "%f[%P][%l%d]+%f[^%l%d]",
                            "^[%l%d]+%f[^%l%d]",
                        },
                        "^().*()$",
                    },
                    -- g = LazyVim.mini.ai_buffer, -- buffer
                    u = ai.gen_spec.function_call(), -- u for "Usage"
                    U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
                },
            }
            ai.setup(ai_opts)
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
