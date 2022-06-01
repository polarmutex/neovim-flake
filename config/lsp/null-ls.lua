local nls = require("null-ls")

nls.setup({
    debounce = 150,
    --save_after_format = false,
    sources = {
        nls.builtins.formatting.prettierd,
        --.with({
        --    filetypes = {
        --        "astro",
        --        "javascript",
        --        "javascriptreact",
        --        "typescript",
        --        "typescriptreact",
        --        "css",
        --        "scss",
        --        "html",
        --        "json",
        --        "yaml",
        --        "markdown",
        --    },
        --}),
        --nls.builtins.formatting.stylua.with({
        --    args = { "--config-path", vim.fn.stdpath("config") .. "lua/stylua.toml", "-" },
        --}),
        nls.builtins.formatting.stylua,
        nls.builtins.formatting.google_java_format,
        --nls.builtins.formatting.eslint_d,
        --nls.builtins.diagnostics.shellcheck,
        --nls.builtins.diagnostics.markdownlint,
        --nls.builtins.diagnostics.selene,
        --nls.builtins.formatting.black,
        --nls.builtins.formatting.isort,
        --nls.builtins.diagnostics.flake8,
        --nls.builtins.diagnostics.mypy,
    },
    on_attach = on_attach,
    root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".nvim.settings.json", ".git"),
    --debug = true,
})
