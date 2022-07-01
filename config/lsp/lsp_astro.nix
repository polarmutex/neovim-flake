{ pkgs
, dsl
, ...
}:
with dsl;
{
  use.lspconfig.astro.setup = callWith {
    # assumed to be provided by the project's nix-shell
    cmd = [ "astro-ls" "--stdio" ];
    capabilities = rawLua
      "require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())";
    init_options = {
      configuration = {
        format = {
          newLineAfterFrontmatter = false;
        };
      };
    };
    on_attach = rawLua "on_attach";
  };
}
