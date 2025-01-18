return {
    -- {
    --     "mini-nvim",
    --     -- event = "InsertEnter",
    --     event = "DeferredUIEnter",
    --     after = function()
    --         local opts = {
    --             lsp_completion = {
    --                 -- source_func = "omnifunc",
    --                 auto_setup = false,
    --                 source_func = "completefunc",
    --                 -- auto_setup = true,
    --                 process_items = require("mini.fuzzy").process_lsp_items,
    --                 -- process_items = function(items, base)
    --                 --     print(items)
    --                 --     return items
    --                 -- end,
    --             },
    --         }
    --         print("get here")
    --         require("mini.completion").setup(opts)
    --     end,
    -- },
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
                    default = { "lsp", "path", "snippets" },
                    -- optionally disable cmdline completions
                    cmdline = {},
                    -- providers = {
                    --     lsp = {
                    --         -- Filter text items from the LSP provider, since we have the buffer provider for that
                    --         transform_items = function(_, items)
                    --             print(vim.inspect(items))
                    --             print("done items")
                    --             for _, item in ipairs(items) do
                    --                 if item.kind == require("blink.cmp.types").CompletionItemKind.Snippet then
                    --                     item.score_offset = item.score_offset - 3
                    --                 end
                    --             end
                    --
                    --             local ret = vim.tbl_filter(function(item)
                    --                 return item.kind ~= require("blink.cmp.types").CompletionItemKind.Text
                    --             end, items)
                    --             print(vim.inspect(ret))
                    --             print("done ret")
                    --             return ret
                    --         end,
                    --     },
                    -- },
                },
                signature = { enabled = true },
            }
            local blink_cmp = require("blink.cmp")
            blink_cmp.setup(opts)
        end,
    },
    -- {
    --     "nvim-cmp",
    --     event = "InsertEnter",
    --     after = function()
    --         vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
    --         local cmp = require("cmp")
    --         local defaults = require("cmp.config.default")()
    --
    --         cmp.setup({
    --             snippet = {
    --                 expand = function(args)
    --                     require("luasnip").lsp_expand(args.body)
    --                 end,
    --             },
    --             completion = {
    --                 completeopt = "menu,menuone,noinsert",
    --             },
    --
    --             -- For an understanding of why these mappings were
    --             -- chosen, you will need to read `:help ins-completion`
    --             --
    --             -- No, but seriously. Please read `:help ins-completion`, it is really good!
    --             mapping = cmp.mapping.preset.insert({
    --                 -- Select the [n]ext item
    --                 ["<C-n>"] = cmp.mapping.select_next_item(),
    --                 -- ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    --
    --                 -- Select the [p]revious item
    --                 ["<C-p>"] = cmp.mapping.select_prev_item(),
    --                 -- ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    --
    --                 -- Scroll the documentation window [b]ack / [f]orward
    --                 ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    --                 ["<C-f>"] = cmp.mapping.scroll_docs(4),
    --
    --                 -- Accept ([y]es) the completion.
    --                 --  This will auto-import if your LSP supports it.
    --                 --  This will expand snippets if the LSP sent a snippet.
    --                 ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    --
    --                 -- If you prefer more traditional completion keymaps,
    --                 -- you can uncomment the following lines
    --                 --['<CR>'] = cmp.mapping.confirm { select = true },
    --                 --['<Tab>'] = cmp.mapping.select_next_item(),
    --                 --['<S-Tab>'] = cmp.mapping.select_prev_item(),
    --
    --                 -- Manually trigger a completion from nvim-cmp.
    --                 --  Generally you don't need this, because nvim-cmp will display
    --                 --  completions whenever it has completion options available.
    --                 ["<C-Space>"] = cmp.mapping.complete({}),
    --
    --                 -- Think of <c-l> as moving to the right of your snippet expansion.
    --                 --  So if you have a snippet that's like:
    --                 --  function $name($args)
    --                 --    $body
    --                 --  end
    --                 --
    --                 -- <c-l> will move you to the right of each of the expansion locations.
    --                 -- <c-h> is similar, except moving you backwards.
    --                 -- ["<C-l>"] = cmp.mapping(function()
    --                 --     if luasnip.expand_or_locally_jumpable() then
    --                 --         luasnip.expand_or_jump()
    --                 --     end
    --                 -- end, { "i", "s" }),
    --                 -- ["<C-h>"] = cmp.mapping(function()
    --                 --     if luasnip.locally_jumpable(-1) then
    --                 --         luasnip.jump(-1)
    --                 --     end
    --                 -- end, { "i", "s" }),
    --
    --                 -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
    --                 --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
    --             }),
    --             sources = cmp.config.sources({
    --                 { name = "nvim_lsp" },
    --                 { name = "luasnip" },
    --                 { name = "path" },
    --             }),
    --             formatting = {
    --                 format = function(_, item)
    --                     local icons = require("polar.icons").kinds
    --                     if icons[item.kind] then
    --                         item.kind = icons[item.kind] .. item.kind
    --                     end
    --                     return item
    --                 end,
    --             },
    --             experimental = {
    --                 ghost_text = {
    --                     hl_group = "CmpGhostText",
    --                 },
    --             },
    --             sorting = defaults.sorting,
    --         })
    --     end,
    -- },
}
