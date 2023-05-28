local null_ls = require("null-ls")
local lsp_format = require("lsp-format")

null_ls.setup({
    on_attach = function(client)
        lsp_format.on_attach(client)
    end,
    debug = true,
    sources = {
        -- git
        null_ls.builtins.diagnostics.commitlint.with({
            command = "@git.commitlint@/bin/commitlint",
            filetypes = { "gitcommit", "NeogitCommitMessage" },
        }),

        -- lua
        null_ls.builtins.diagnostics.luacheck.with({
            command = "@lua.luacheck@/bin/luacheck",
        }),
        null_ls.builtins.formatting.stylua.with({
            command = "@lua.stylua@/bin/stylua",
        }),

        -- markdown
        null_ls.builtins.diagnostics.markdownlint.with({
            command = "@markdown.markdownlint@/bin/markdownlint",
        }),
        null_ls.builtins.formatting.mdformat.with({
            command = "@markdown.mdformat@/bin/mdformat",
        }),

        -- nix
        null_ls.builtins.diagnostics.deadnix.with({
            command = "@nix.deadnix@/bin/deadnix",
        }),
        null_ls.builtins.diagnostics.statix.with({
            command = "@nix.statix@/bin/statix",
        }),
        null_ls.builtins.formatting.alejandra.with({
            command = "@nix.alejandra@/bin/alejandra",
        }),

        -- python
        null_ls.builtins.diagnostics.ruff.with({
            command = "@python.ruff@/bin/ruff",
        }),
        null_ls.builtins.formatting.black.with({
            command = "@python.black@/bin/black",
        }),
        --null_ls.builtins.diagnostics.mypy,

        -- rust
        null_ls.builtins.formatting.dprint.with({
            command = "@rust.dprint@/bin/dprint",
        }),

        -- yaml
        null_ls.builtins.diagnostics.yamllint.with({
            command = "@yaml.yamllint@/bin/yamllint",
        }),
        null_ls.builtins.formatting.yamlfix.with({
            command = "@yaml.yamlfix@/bin/yamlfix",
        }),

        --null_ls.builtins.formatting.asmfmt,
        --null_ls.builtins.formatting.shfmt,

        --null_ls.builtins.diagnostics.cppcheck,
        --null_ls.builtins.diagnostics.markdownlint,
        --null_ls.builtins.diagnostics.shellcheck,

        --null_ls.builtins.code_actions.shellcheck,
    },
})
