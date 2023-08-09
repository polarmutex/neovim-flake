local M = {}

M.setup = function()
    vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
    local cmp = require("cmp")
    local defaults = require("cmp.config.default")()

    cmp.setup({
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end,
        },
        completion = {
            completeopt = "menu,menuone,noinsert",
        },
        mapping = cmp.mapping.preset.insert({
            ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
            ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            ["<S-CR>"] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "buffer" },
            { name = "path" },
        }),
        formatting = {
            format = function(_, item)
                local icons = require("polarmutex.icons").kinds
                if icons[item.kind] then
                    item.kind = icons[item.kind] .. item.kind
                end
                return item
            end,
        },
        experimental = {
            ghost_text = {
                hl_group = "CmpGhostText",
            },
        },
        sorting = defaults.sorting,
    })

    --cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
    --    sources = {
    --        { name = "dap" },
    --    },
    --})

    --cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

    --require("luasnip.loaders.from_vscode").lazy_load()

    --local ok, latex_snippets = pcall(require, "lua-latex-snippets")
    --if ok then
    --    latex_snippets.setup()
    --end
end

return M
