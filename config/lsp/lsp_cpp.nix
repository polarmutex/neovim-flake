{ pkgs
, dsl
, ...
}:
with dsl;
{
  use.lspconfig.clangd.setup = callWith {
    # assumed to be provided by the project's nix-shell
    cmd = [
      "clangd"
      "--background-index"
      "--suggest-missing-includes"
      "--clang-tidy"
      "--header-insertion=iwyu"
    ];
    capabilities = rawLua
      "require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())";
    init_options = {
      clangdFileStatus = true;
    };
    on_attach = rawLua "on_attach";
  };
}
