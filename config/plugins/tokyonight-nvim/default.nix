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

  cfg = config.polar.programs.neovim.plugins.tokyonight;
in
{

  options = {

    polar.programs.neovim.plugins.tokyonight = {

      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable";
      };
    };
  };

  config = mkIf cfg.enable {

    xdg.configFile."nvim/plugin/tokyonight.lua".text = ''
          -- Example config in Lua
      vim.g.tokyonight_style = "night"
      vim.g.tokyonight_italic_functions = true

      -- Change the "hint" color to the "orange" color, and make the "error" color bright red
      vim.g.tokyonight_colors = { hint = "orange", error = "#ff0000" }

      -- Load the colorscheme
      --vim.cmd[[colorscheme tokyonight]]
      require("tokyonight").colorscheme()
    '';
  };

}
