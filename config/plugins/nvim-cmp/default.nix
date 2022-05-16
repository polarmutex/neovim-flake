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

  cfg = config.polar.programs.neovim.plugins.cmp;
in
{

  options = {

    polar.programs.neovim.plugins.cmp = {

      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable nvim-cmp";
      };
    };
  };

  config = mkIf cfg.enable {

    xdg.configFile."nvim/plugin/cmp.lua".source = link "config/plugins/nvim-cmp/cmp.lua";
    #xdg.configFile."nvim/plugin/cmp.lua".text =
    #  let
    #    lua_config = pkgs.luaConfigBuilder {
    #      imports = [
    #        ./completion.nix
    #      ];
    #    };
    #  in
    #  lua_config.lua;

  };

}
