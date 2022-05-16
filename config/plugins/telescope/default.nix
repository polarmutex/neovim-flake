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

  cfg = config.polar.programs.neovim.plugins.telescope;
in
{

  options = {

    polar.programs.neovim.plugins.telescope = {

      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable telescope";
      };
    };
  };

  config = mkIf cfg.enable {

    xdg.configFile."nvim/plugin/telescope.lua".source = link "config/plugins/telescope/telescope.lua";

  };

}
