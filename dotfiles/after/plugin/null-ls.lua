local nls = require("null-ls")
local h = require("null-ls.helpers")

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
        --nls.builtins.formatting.prettier_d_slim.with({
        --    filetypes = {
        --        "astro",
        --        "svelte",
        --        "javascript",
        --        "typescript",
        --        "css",
        --        "html",
        --        "json",
        --        "yaml",
        --        --        "markdown",
        --    },
        --}),
        --nls.builtins.diagnostics.shellcheck,
        --nls.builtins.diagnostics.markdownlint,
        --nls.builtins.diagnostics.selene,
        --nls.builtins.formatting.black,
        --nls.builtins.formatting.isort,
        --nls.builtins.diagnostics.flake8,
        --nls.builtins.diagnostics.mypy,
    },
    on_attach = require("polarmutex.lsp.attach").on_attach,
    root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".nvim.settings.json", ".git"),
    debug = false,
})
