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

  cfg = config.polar.programs.neovim.lsp;
in
{
  options = {

    polar.programs.neovim.lsp = {

      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable neovim lsp support";
      };

      beancount = mkOption {
        type = types.bool;
        default = false;
        description = "Enable lsp beancount";
      };
      lua = mkOption {
        type = types.bool;
        default = false;
        description = "Enable lsp lua";
      };
      java = mkOption {
        type = types.bool;
        default = false;
        description = "Enable lsp java";
      };
      nix = mkOption {
        type = types.bool;
        default = true;
        description = "Enable lsp nix";
      };
      python = mkOption {
        type = types.bool;
        default = false;
        description = "Enable lsp python";
      };
      rust = mkOption {
        type = types.bool;
        default = false;
        description = "Enable lsp rust";
      };
      svelte = mkOption {
        type = types.bool;
        default = false;
        description = "Enable lsp svelte";
      };
      typescript = mkOption {
        type = types.bool;
        default = false;
        description = "Enable lsp typescript";
      };
    };
  };

  config = mkIf cfg.enable
    {

      home.packages = with pkgs; [
      ]
      ++ (if cfg.nix then [ rnix-lsp ] else [ ])
      ++ (if cfg.rust then [ rust-analyzer ] else [ ])
      ++ (if cfg.lua then [ sumneko-lua-language-server stylua ] else [ ])
      ++ (if cfg.python then [ nodePackages.pyright ] else [ ])
      ++ (if cfg.typescript then [ nodePackages.typescript-language-server ] else [ ])
      ++ (if cfg.svelte then [ nodePackages.svelte-language-server ] else [ ])
      ++ (if cfg.java then [ jdtls ] else [ ])
      ++ (if cfg.beancount then [ beancount-language-server ] else [ ])
      ;

      xdg.configFile."nvim/lua/polarmutex/lsp.lua".text =
        let
          lua_config = pkgs.luaConfigBuilder {
            imports = [ ./lsp.nix ]
              ++ (if cfg.nix then [ ./lsp_nix.nix ] else [ ])
              ++ (if cfg.rust then [ ./lsp_rust.nix ] else [ ])
              ++ (if cfg.lua then [ ./lsp_lua.nix ] else [ ])
            ;
          };
        in
        lua_config.lua;

      # null-ls-nvim
      xdg.configFile."nvim/lua/polarmutex/lsp_formatting.lua".source = link "config/lsp/lsp_formatting.lua";
    };
}
