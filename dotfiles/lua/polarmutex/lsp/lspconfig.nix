{ pkgs, lib, dsl, ... }: with dsl;
let
  inherit (lib) getExe;
in
{
  use.lspconfig.beancount.setup = callWith {
    #cmd = [ "${pkgs.beancount-language-server}/bin/beancount-language-server" ];
    cmd = [ "/home/polar/repos/personal/beancount-language-server/develop/target/debug/beancount-language-server" ];
    init_options = {
      journal_file = "/home/polar/repos/personal/beancount/main.beancount";
    };
    capabilities = rawLua
      "require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())";
    on_attach = rawLua "require('polarmutex.lsp.attach').on_attach";
  };

  use.lspconfig.clangd.setup = callWith {
    cmd = [ "${pkgs.clang-tools}/bin/clangd" ];
    capabilities = rawLua
      "require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())";
    on_attach = rawLua "require('polarmutex.lsp.attach').on_attach";
  };

  use.lspconfig.gopls.setup = callWith {
    cmd = [ "${pkgs.gopls}/bin/gopls" ];
    capabilities = rawLua
      "require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())";
    on_attach = rawLua "require('polarmutex.lsp.attach').on_attach";
  };

  use.lspconfig.sumneko_lua.setup = callWith
    {
      cmd = [ "${pkgs.sumneko-lua-language-server}/bin/lua-language-server" ];
      capabilities = rawLua
        "require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())";
      on_attach = rawLua "require('polarmutex.lsp.attach').on_attach";
      settings =
        {
          # Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false;
          };
          #diagnostics = {
          # globals = { 'vim' };
          #}
          Lua = {
            format = {
              enable = false;
            };
            diagnostics = {
              # Get the language server to recognize the `vim` global
              globals = [
                # neovim
                "vim"
                # awesomewm
                "awesome"
                "client"
                "screen"
              ];
            };
            runtime = {
              # Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = "LuaJIT";
              # Setup your lua path
              path = rawLua "runtime_path";
            };
            workspace = {
              # Make the server aware of Neovim runtime files
              library = [
                "[vim.api.nvim_get_runtime_file ("
                ", true)"
                "${pkgs.awesome-git}/share/awesome/lib"
              ];
            };
          };
        };
    };

  use.lspconfig.jsonls.setup = callWith {
    cmd = [ (getExe pkgs.nodePackages.vscode-json-languageserver) "--stdio" ];
    capabilities = rawLua
      "require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())";
    on_attach = rawLua "require('polarmutex.lsp.attach').on_attach";
  };

  use.lspconfig.pyright.setup = callWith {
    cmd = [ "${pkgs.pyright}/bin/pyright-langserver" "--stdio" ];
    capabilities = rawLua
      "require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())";
    on_attach = rawLua "require('polarmutex.lsp.attach').on_attach";
  };

  use.lspconfig.rnix.setup = callWith {
    cmd = [ (getExe pkgs.rnix-lsp) ];
    capabilities = rawLua
      "require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())";
    on_attach = rawLua "require('polarmutex.lsp.attach').on_attach";
  };

}
