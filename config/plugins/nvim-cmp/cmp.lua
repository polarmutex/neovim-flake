vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Don't show the dumb matching stuff.
vim.opt.shortmess:append("c")

local ok, lspkind = pcall(require, "lspkind")
if not ok then
    return
end

lspkind.init()

local cmp = require("cmp")

cmp.setup({
    mapping = {
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<c-y>"] = cmp.mapping(
            cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Insert,
                select = true,
            }),
            { "i", "c" }
        ),

        ["<c-space>"] = cmp.mapping({
            i = cmp.mapping.complete(),
            c = function(--[[fallback]])
                if cmp.visible() then
                    if not cmp.confirm({ select = true }) then
                        return
                    end
                else
                    cmp.complete()
                end
            end,
        }),

        -- ["<tab>"] = false,
        ["<tab>"] = cmp.config.disable,
    },

    sources = {
        { name = "gh_issues" },

        -- Could enable this only for lua, but nvim_lua handles that already.
        { name = "nvim_lua" },

        { name = "nvim_lsp" },
        { name = "path" },
        --TODO{ name = "luasnip" },
        { name = "buffer", keyword_length = 5 },
    },

    sorting = {
        -- TODO: Would be cool to add stuff like "See variable names before method names" in rust, or something like that.
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,

            -- copied from cmp-under, but I don't think I need the plugin for this.
            -- I might add some more of my own.
            function(entry1, entry2)
                local _, entry1_under = entry1.completion_item.label:find("^_+")
                local _, entry2_under = entry2.completion_item.label:find("^_+")
                entry1_under = entry1_under or 0
                entry2_under = entry2_under or 0
                if entry1_under > entry2_under then
                    return false
                elseif entry1_under < entry2_under then
                    return true
                end
            end,

            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },

    --TODO
    --snippet = {
    --    expand = function(args)
    --        require("luasnip").lsp_expand(args.body)
    --    end,
    --},

    formatting = {
        -- Youtube: How to set up nice formatting for your sources.
        format = lspkind.cmp_format({
            with_text = true,
            menu = {
                buffer = "[buf]",
                nvim_lsp = "[LSP]",
                nvim_lua = "[api]",
                path = "[path]",
                --luasnip = "[snip]",
                gh_issues = "[issues]",
            },
        }),
    },
})
