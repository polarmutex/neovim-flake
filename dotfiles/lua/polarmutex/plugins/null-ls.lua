local nls = require("null-ls")
local h = require("null-ls.helpers")
local cmd_resolver = require("null-ls.helpers.command_resolver")
local u = require("null-ls.utils")

local M = {}

function M.setup()
    nls.setup({
        debounce = 150,
        --save_after_format = false,
        sources = {
            nls.builtins.formatting.stylua.with({
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
            --nls.builtins.formatting.google_java_format,
            --nls.builtins.diagnostics.eslint_d,
            nls.builtins.formatting.prettier_d_slim.with({
                generator_opts = {
                    command = "@js.prettier_d_slim@/bin/prettier_d_slim",
                    args = h.range_formatting_args_factory(
                        { "--stdin", "--stdin-filepath", "$FILENAME" },
                        "--range-start",
                        "--range-end",
                        { row_offset = -1, col_offset = -1 }
                    ),
                    to_stdin = true,
                    dynamic_command = cmd_resolver.from_node_modules,
                    cwd = h.cache.by_bufnr(function(params)
                        return u.root_pattern(
                            -- https://prettier.io/docs/en/configuration.html
                            ".prettierrc",
                            ".prettierrc.json",
                            ".prettierrc.yml",
                            ".prettierrc.yaml",
                            ".prettierrc.json5",
                            ".prettierrc.js",
                            ".prettierrc.cjs",
                            ".prettier.config.js",
                            ".prettier.config.cjs",
                            ".prettierrc.toml",
                            "package.json"
                        )(params.bufname)
                    end),
                },
                filetypes = {
                    "javascript",
                    "typescript",
                    "css",
                    "html",
                    "json",
                    "yaml",
                },
            }),
            --nls.builtins.diagnostics.shellcheck,
            --nls.builtins.diagnostics.markdownlint,
            --nls.builtins.diagnostics.selene,
            nls.builtins.formatting.black,
            nls.builtins.diagnostics.flake8,
            nls.builtins.diagnostics.mypy,
            nls.builtins.diagnostics.clippy,
        },
        on_attach = require("polarmutex.lsp.attach").on_attach,
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".nvim.settings.json", ".git"),
        debug = false,
    })
end

return M
