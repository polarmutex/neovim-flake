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

  cfg = config.polar.programs.neovim.plugins.neogit;
in
{

  options = {

    polar.programs.neovim.plugins.neogit = {

      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable neogit";
      };
    };
  };

  config = mkIf cfg.enable {

    xdg.configFile."nvim/plugin/neogit.lua".source = link "config/plugins/neogit/neogit.lua";

  };

}
