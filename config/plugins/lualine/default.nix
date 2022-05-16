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

  cfg = config.polar.programs.neovim.plugins.lualine;
in
{

  options = {

    polar.programs.neovim.plugins.lualine = {

      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable lualine";
      };
    };
  };

  config = mkIf cfg.enable {

    xdg.configFile."nvim/plugin/lualine.lua".source = link "config/plugins/lualine/lualine.lua";

  };

}
