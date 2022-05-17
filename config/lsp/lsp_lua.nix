{ pkgs
, dsl
, ...
}:
with dsl;
{

  use.lspconfig.sumneko_lua.setup = callWith
    {
      cmd = [ "${pkgs.sumneko-lua-language-server}/bin/lua-language-server" ];
      capabilities = rawLua
        "require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())";
      on_attach = rawLua "on_attach";
      settings =
        {
          telemetry =
            {
              enable = false;
            };
          format = {
            enable = false;
          };
          #diagnostics = {
          # globals = { 'vim' };
          #}
        };
    };
}
