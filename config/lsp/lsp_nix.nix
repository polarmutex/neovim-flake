{ pkgs
, dsl
, ...
}:
with dsl;
{

  use.lspconfig.rnix.setup = callWith {
    cmd = [ "${pkgs.rnix-lsp}/bin/rnix-lsp" ];
    capabilities = rawLua
      "require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())";
    on_attach = rawLua "on_attach";
  };

}
