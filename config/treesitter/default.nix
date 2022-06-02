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

  cfg = config.polar.programs.neovim.treesitter;
in
{


  options = {

    polar.programs.neovim.treesitter = {

      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable neovim treesitter";
      };
    };
  };

  config = mkIf cfg.enable {

    xdg.configFile."nvim/lua/polarmutex/treesitter.lua".text =
      let
        lua_config = pkgs.luaConfigBuilder {
          imports = [
            ./treesitter.nix
          ];
        };
      in
      lua_config.lua;
  };
}
