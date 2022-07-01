{ pkgs
, dsl
, ...
}:
with dsl;
{
  use.lspconfig.svelte.setup = callWith {
    # assumed to be provided by the project's nix-shell
    cmd = [ "svelteserver" "--stdio" ];
    capabilities = rawLua
      "require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())";
    on_attach = rawLua "on_attach";
  };
}
