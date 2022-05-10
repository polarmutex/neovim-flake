with builtins;
rec {
  defaultSystems = [
    "aarch64-linux"
    "aarch64-darwin"
    "i686-linux"
    "x86_64-darwin"
    "x86_64-linux"
  ];

  mkPkgs = { nixpkgs, systems ? defaultSystems, cfg ? { }, overlays ? [ ] }: withSystems systems (sys:
    import nixpkgs {
      system = sys;
      config = cfg;
      overlays = overlays;
    });

  withSystems = systems: f: foldl'
    (cur: nxt:
      let
        ret = {
          "${nxt}" = f nxt;
        };
      in
      cur // ret)
    { }
    systems;
  withDefaultSystems = withSystems defaultSystems;

  neovimBuilder = { pkgs, startPlugins, optPlugins, ... }:
    let
      neovimPlugins = pkgs.neovimPlugins;
      #vimOptions = pkgs.lib.evalModules {
      #  modules = [
      #    { imports = [ ../modules ]; }
      #    config
      #  ];

      #  specialArgs = {
      #    inherit pkgs;
      #  };
      #};

      #vim = vimOptions.config.vim;
    in
    pkgs.wrapNeovim pkgs.neovim-nightly {
      viAlias = true;
      vimAlias = true;
      configure = {
        customRC = ''
set runtimepath^=~/.config/nvim
lua << EOF
require('polarmutex')
EOF
'';

        packages.myVimPackage = with pkgs.vimPlugins; {
          start = startPlugins; #vim.startPlugins;
          opt = optPlugins; #vim.optPlugins;
        };
      };
    };
}
