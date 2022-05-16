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

  cfg = config.polar.programs.neovim.plugins.fidget;
in
{

  options = {

    polar.programs.neovim.plugins.fidget = {

      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable fidget";
      };
    };
  };

  config = mkIf cfg.enable {

    xdg.configFile."nvim/plugin/fidget.lua".source = link "config/plugins/fidget/fidget.lua";

  };

}
