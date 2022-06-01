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

  cfg = config.polar.programs.neovim.plugins.colorizer;
in
{

  options = {

    polar.programs.neovim.plugins.colorizer = {

      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable colorizer";
      };
    };
  };

  config = mkIf cfg.enable {

    xdg.configFile."nvim/plugin/colorizer.lua".text = ''
      require'colorizer'.setup()
    '';

  };

}
