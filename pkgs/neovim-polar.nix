{ pkgs
, lib
, neovim
, ...
}:
let
  neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
    customRC = ''
      lua << EOF
      -- bootstrap lazy.nvim, LazyVim and your plugins
      require('polarmutex.config.lazy').setup()
      EOF
    '';
    plugins =
      let
        withSrc = pkg: src: pkg.overrideAttrs (_: { inherit src; });
        plugin = pname: src:
          pkgs.vimUtils.buildVimPluginFrom2Nix {
            inherit pname src;
            version = "master";
          };
      in
      [
        {
          plugin = pkgs.neovim-lua-config-polar;
          optional = false;
        }
      ];
  };
in
pkgs.wrapNeovimUnstable neovim.packages.${pkgs.system}.default
  (neovimConfig
    // {
    wrapRc = true;
  })
