{ pkgs
, dsl
, ...
}:
with dsl;
{

  use.lspconfig.tsserver.setup = callWith {
    cmd = [ "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server" "--stdio" ];
    capabilities = rawLua
      "require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())";
    on_attach = rawLua "on_attach";
    filetypes = [
      "javascript"
      "typescript"
      "typescript.tsx"
    ];
  };

}
