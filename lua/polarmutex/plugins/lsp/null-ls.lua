local null_ls = require("null-ls")
local lsp_format = require("lsp-format")
local h = require("null-ls.helpers")
local cmd_resolver = require("null-ls.helpers.command_resolver")
local u = require("null-ls.utils")

null_ls.setup({
    on_attach = function(client)
        lsp_format.on_attach(client)
    end,
    debug = true,
    sources = {
        --null_ls.builtins.formatting.asmfmt,
        --null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.dprint.with({
            generator_opts = {
                command = "@rust.dprint@/bin/dprint",
                args = {
                    "fmt",
                    "--stdin",
                    "$FILENAME",
                },
                to_stdin = true,
            },
            filetypes = {
                "javascript",
                "json",
                "markdown",
                --"markdown.mdx",
                "typescript",
                "yaml",
                "toml",
            },
        }),
        null_ls.builtins.formatting.alejandra.with({
            generator_opts = {
                command = "@nix.alejandra@/bin/alejandra",
                args = { "--quiet" },
                to_stdin = true,
            },
        }),
        --null_ls.builtins.formatting.rustfmt,
        --null_ls.builtins.formatting.shfmt,
        null_ls.builtins.formatting.stylua.with({
            generator_opts = {
                command = "@lua.stylua@/bin/stylua",
                args = h.range_formatting_args_factory({
                    "--search-parent-directories",
                    "--stdin-filepath",
                    "$FILENAME",
                    "-",
                }, "--range-start", "--range-end", { row_offset = -1, col_offset = -1 }),
                to_stdin = true,
            },
            extra_args = { "--indent-type", "Spaces", "--indent-width", "4", "--column-width", "120" },
        }),

        --null_ls.builtins.diagnostics.cppcheck,
        --null_ls.builtins.diagnostics.deadnix,
        --null_ls.builtins.diagnostics.flake8,
        --null_ls.builtins.diagnostics.gitlint,
        --null_ls.builtins.diagnostics.markdownlint,
        --null_ls.builtins.diagnostics.mypy,
        --null_ls.builtins.diagnostics.shellcheck,
        --null_ls.builtins.diagnostics.statix,

        --null_ls.builtins.code_actions.shellcheck,
        --null_ls.builtins.code_actions.statix,
    },
})
