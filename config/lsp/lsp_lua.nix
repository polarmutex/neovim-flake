{ pkgs
, dsl
, ...
}:
with dsl;
{
  lua = ''
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")
  '';

  use.lspconfig.sumneko_lua.setup = callWith
    {
      cmd = [ "${pkgs.sumneko-lua-language-server}/bin/lua-language-server" ];
      capabilities = rawLua
        "require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())";
      on_attach = rawLua "on_attach";
      settings =
        {
          telemetry = {
            enable = false;
          };
          format = {
            enable = false;
          };
          #diagnostics = {
          # globals = { 'vim' };
          #}
          Lua = {
            runtime = {
              # Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = "LuaJIT";
              # Setup your lua path
              path = rawLua "runtime_path";
            };
            diagnostics = {
              # Get the language server to recognize the `vim` global
              globals = rawLua "{ 'vim'  }";
            };
            workspace = {
              # Make the server aware of Neovim runtime files
              library = [
                "[vim.api.nvim_get_runtime_file ("
                ", true)"
                "${pkgs.awesome-git}/share/awesome/lib"
              ];
            };
            # Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
              enable = false;
            };
          };
        };
    };
}
