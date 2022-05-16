{ config
, pkgs
, lib
, dsl
, ...
}:
with lib;
let
  dot = path: "${config.home.homeDirectory}/repos/personal/neovim-flake/${path}";

  link = path:
    let
      fullpath = dot path;
    in
    config.lib.file.mkOutOfStoreSymlink fullpath;

  link-one = from: to: path:
    let
      paths = builtins.attrNames { "${path}" = "directory"; };
      mkPath = path:
        let
          orig = "${from}/${path}";
        in
        {
          name = "${to}/${path}";
          value = {
            source = link orig;
          };
        };
    in
    builtins.listToAttrs (
      map mkPath paths
    );

  cfg = config.polar.programs.neovim;
in
{

  imports = [
    ./config/lsp
    ./config/treesitter

    # plugins
    ./config/plugins/gitsigns
    ./config/plugins/nvim-cmp
    ./config/plugins/telescope
    ./config/plugins/tokyonight-nvim
  ];

  options = {

    polar.programs.neovim = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable neovim";
      };
    };
  };

  config = mkIf cfg.enable {
    home.sessionVariables.EDITOR = "${pkgs.neovim}/bin/nvim";

    home.packages = with pkgs; [
      neovim-polar
      ripgrep
      prettierd
    ];

    # old way
    #xdg.configFile = link-one "config" "." "nvim";

    # new way

    # INIT.lua
    #xdg.configFile."nvim/lua/polarmutex/init.lua".source = link "config/init.lua";

    xdg.configFile."nvim/lua/polarmutex/options.lua".source = link "config/options.lua";

  };

}
