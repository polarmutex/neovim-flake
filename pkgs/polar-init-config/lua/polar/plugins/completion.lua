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
                    use_nvim_cmp_as_default = true,
                    nerd_font_variant = "mono",
                },
                -- default list of enabled providers defined so that you can extend it
                -- elsewhere in your config, without redefining it, via `opts_extend`
                sources = {
                    default = { "lsp", "path", "snippets", "buffer" },
                    -- optionally disable cmdline completions
                    -- cmdline = {},
                },
                signature = { enabled = true },
            }
            local blink_cmp = require("blink.cmp")
            blink_cmp.setup(opts)

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
        end,
    },
}
