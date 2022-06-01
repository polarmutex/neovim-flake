{ pkgs, dsl, ... }:
{
  lua = ''
    local function on_attach(client, bufnr)
        vim.api.nvim_set_current_dir(client.config.root_dir)
        require('polarmutex.lsp_formatting').setup(client, bufnr)
    end
  '';
}
