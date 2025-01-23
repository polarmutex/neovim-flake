return {
    {
        "conform-nvim",
        event = "DeferredUIEnter",
        after = function()
            ---@type conform.setupOpts
            local opts = {
                default_format_opts = {
                    timeout_ms = 3000,
                    async = false, -- not recommended to change
                    quiet = false, -- not recommended to change
                    lsp_format = "fallback", -- not recommended to change
                },
                formatters_by_ft = {
                    cpp = { "clang-format" },
                    lua = { "stylua" },
                    markdown = { "prettierd" },
                    nix = { "alejandra" },
                    python = { "ruff_format" },
                },
                -- The options you set here will be merged with the builtin formatters.
                -- You can also define any custom formatters here.
                ---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
                formatters = {
                    injected = { options = { ignore_errors = true } },
                    -- # Example of using dprint only when a dprint.json file is present
                    -- dprint = {
                    --   condition = function(ctx)
                    --     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
                    --   end,
                    -- },
                    --
                    -- # Example of using shfmt with extra args
                    -- shfmt = {
                    --   prepend_args = { "-i", "2", "-ci" },
                    -- },
                },
            }
            require("conform").setup(opts)

            vim.keymap.set({ "n", "v" }, "<leader>cF", function()
                require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
            end, { desc = "Format Injected Langs" })

            require("polar.utils.format").register({
                name = "conform.nvim",
                priority = 100,
                primary = true,
                format = function(buf)
                    require("conform").format({ bufnr = buf })
                end,
                sources = function(buf)
                    local ret = require("conform").list_formatters(buf)
                    ---@param v conform.FormatterInfo
                    return vim.tbl_map(function(v)
                        return v.name
                    end, ret)
                end,
            })
        end,
    },
}
