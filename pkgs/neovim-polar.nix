{
  neovim-git,
  pkgs,
  polar-lua-config,
  ...
}: let
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
        plugin = polar-lua-config;
        optional = false;
      }
    ];
  };
in
  pkgs.wrapNeovimUnstable neovim-git
  (neovimConfig
    // {
      wrapRc = true;
    })
