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

  cfg = config.polar.programs.neovim.plugins.kanagawa;
in
{

  options = {

    polar.programs.neovim.plugins.kanagawa = {

      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable";
      };
    };
  };

  config = mkIf cfg.enable {

    xdg.configFile."nvim/plugin/kanagawa.lua".text = ''
      -- Load the colorscheme
      local default_colors = require("kanagawa.colors").setup()
      local my_colors = {};
      local overrides = {
        diffAdded = { fg = default_colors.springGreen };
      };
      require'kanagawa'.setup({ overrides = overrides, colors = my_colors })
      vim.cmd[[colorscheme kanagawa]]
    '';
  };

}
