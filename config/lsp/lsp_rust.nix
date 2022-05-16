{ pkgs
, dsl
, ...
}:
with dsl;
{
  use.lspconfig.rust_analyzer.setup = callWith {
    # assumed to be provided by the project's nix-shell
    cmd = [ "rust-analyzer" ];
    capabilities = rawLua
      "require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())";
    settings = { "['rust-analyzer']" = { procMacro = { enable = true; }; }; };
    on_attach = rawLua "on_attach";
  };
}
