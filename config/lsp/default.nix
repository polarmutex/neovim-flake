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
      cpp = mkOption {
        type = types.bool;
        default = false;
        description = "Enable lsp cpp";
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

  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = with pkgs; [
      ];

      xdg.configFile."nvim/lua/polarmutex/lsp.lua".text =
        let
          lua_config = pkgs.luaConfigBuilder {
            imports = [ ./lsp.nix ]
              ++ (if cfg.nix then [ ./lsp_nix.nix ] else [ ])
              ++ (if cfg.rust then [ ./lsp_rust.nix ] else [ ])
              ++ (if cfg.lua then [ ./lsp_lua.nix ] else [ ])
              ++ (if cfg.python then [ ./lsp_python.nix ] else [ ])
              ++ (if cfg.cpp then [ ./lsp_cpp.nix ] else [ ])
              ++ (if cfg.java then [ ./lsp_java.nix ] else [ ])
              ++ (if cfg.beancount then [ ./lsp_beancount.nix ] else [ ])
              ++ (if cfg.typescript then [ ./lsp_typescript.nix ] else [ ])
            ;
          };
        in
        concatStrings [
          (builtins.readFile ./lsp_diag.lua)
          lua_config.lua
          # needs to be below lua_config for on_attach
          (builtins.readFile ./null-ls.lua)
        ];

      # null-ls-nvim
      xdg.configFile."nvim/lua/polarmutex/lsp_formatting.lua".source = link "config/lsp/lsp_formatting.lua";
    }
    # BEANCOUNT
    (mkIf cfg.beancount {
      home.packages = with pkgs; [
        beancount-language-server
      ];
    })
    # CPP
    (mkIf cfg.cpp {
      home.packages = with pkgs; [
        clang-tools
      ];
    })
    # JAVA
    (mkIf cfg.java {
      home.packages = with pkgs; [
        jdt-language-server
        google-java-format
      ];
      xdg.configFile."nvim/lua/polarmutex/lsp_java.lua".source = link "config/lsp/lsp_java.lua";
    })
    # LUA
    (mkIf cfg.lua {
      home.packages = with pkgs; [
        sumneko-lua-language-server
        stylua
      ];
    })
    # NIX
    (mkIf cfg.nix {
      home.packages = with pkgs; [
        rnix-lsp
      ];
    })
    # PYTHON
    (mkIf cfg.python {
      home.packages = with pkgs; [
        nodePackages.pyright
      ];
    })
    # RUST
    (mkIf cfg.rust {
      home.packages = with pkgs; [
        rust-analyzer
      ];
    })
    # SVELTE
    (mkIf cfg.svelte {
      home.packages = with pkgs; [
        nodePackages.svelte-language-server
      ];
    })
    # TYPESCRIPT
    (mkIf cfg.typescript {
      home.packages = with pkgs; [
        nodePackages.typescript-language-server
        nodePackages.eslint_d
        nodePackages.prettier_d_slim
      ];
    })
  ]);
}
