{ pkgs, dsl, ... }:
{
  lua = ''
    local function on_attach(client, bufnr)
        require('polarmutex.lsp_formatting').setup(client, bufnr)
    end
  '';
}
