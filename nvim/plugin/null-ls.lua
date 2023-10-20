local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        -- docker
        --nls.builtins.diagnostics.hadolint.with({
        --    command = "$<del me>{lib.getExe pkgs.hadolint}",
        --}),
        -- git
        --nls.builtins.diagnostics.commitlint.with({
        --    command = "${lib.getExe pkgs.commitlint}",
        --    filetypes = { "gitcommit", "NeogitCommitMessage" },
        --}),

        -- lua
        --null_ls.builtins.diagnostics.luacheck,
        --null_ls.builtins.formatting.stylua,

        -- markdown
        --null_ls.builtins.diagnostics.markdownlint,
        null_ls.builtins.formatting.mdformat,

        -- nix
        --null_ls.builtins.diagnostics.deadnix,
        --null_ls.builtins.diagnostics.statix,
        null_ls.builtins.formatting.alejandra,

        -- yaml
        --nls.builtins.diagnostics.yamllint.with({
        --    command = "@yaml.yamllint@/bin/yamllint",
        --}),
    },
})
