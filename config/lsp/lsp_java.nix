{ pkgs
, dsl
, ...
}:
with dsl;
{
  lua = ''
    vim.api.nvim_exec(
        [[
        augroup jdtls
        autocmd!
        autocmd FileType java lua require('polarmutex.lsp_java').setup()
    augroup END
    ]],
        false
    )
  '';
}
