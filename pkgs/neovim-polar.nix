{pkgs, ...}: let
  neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
    viAlias = true;
    vimAlias = true;

    withPython3 = true;
    withRuby = true;
    withNodeJs = true;

    customRC = ''
      lua << EOF
      -- bootstrap lazy.nvim, LazyVim and your plugins
      require('polarmutex.config.lazy').setup()
      EOF
    '';
    plugins = [
      {
        plugin = pkgs.neovim-lua-config-polar;
        optional = false;
      }
    ];
  };
in
  pkgs.wrapNeovimUnstable pkgs.neovim-git
  (neovimConfig
    // {
      wrapRc = true;
    })
