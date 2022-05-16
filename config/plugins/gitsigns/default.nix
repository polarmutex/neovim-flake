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

  cfg = config.polar.programs.neovim.plugins.gitsigns;
in
{

  options = {

    polar.programs.neovim.plugins.gitsigns = {

      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable gitsigns";
      };
    };
  };

  config = mkIf cfg.enable {

    xdg.configFile."nvim/plugin/gitsigns.lua".source = link "config/plugins/gitsigns/gitsigns.lua";

  };

}
