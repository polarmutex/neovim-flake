local M = {}

function M.setup()
    local cmp = require("cmp")
    cmp.setup({
        mapping = {
            ["<C-n>"] = cmp.mapping.select_next_item({ behavior = require("cmp").SelectBehavior.Insert }),
            ["<Down>"] = cmp.mapping.select_next_item({ behavior = require("cmp").SelectBehavior.Select }),
            ["<Tab>"] = cmp.mapping.select_next_item({ behavior = require("cmp").SelectBehavior.Select }),

            ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = require("cmp").SelectBehavior.Insert }),
            ["<Up>"] = cmp.mapping.select_prev_item({ behavior = require("cmp").SelectBehavior.Select }),
            ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = require("cmp").SelectBehavior.Select }),

            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.close(),
            ["<CR>"] = cmp.mapping.confirm({ behavior = require("cmp").ConfirmBehavior.Replace, select = true }),
        },
        sources = {
            { name = "nvim_lsp" },
            --{ name = "vsnip"; }
            { name = "crates" },
            { name = "path" },
            { name = "buffer", keyword_length = 5 },
        },
        formatting = {
            -- Youtube: How to set up nice formatting for your sources.
            --format = rawLua "lspkind.cmp_format({
            --      with_text = true,
            --      menu = {
            --          buffer = '[buf]',
            --          nvim_lsp = '[LSP]',
            --          nvim_lua = '[api]',
            --          path = '[path]',
            --          --luasnip = '[snip]',
            --          gh_issues = '[issues]',
            --      },
            --  })";
        },
        --snippet.expand = rawLua ''function(args) vim.fn["vsnip#anonymous"](args.body) end '';
    })
end

return M
