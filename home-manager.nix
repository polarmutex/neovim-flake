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

  cfg = config.polar.programs.neovim;
in
{
  options = {

    polar.programs.neovim = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable neovim";
      };
    };

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

  config = mkIf cfg.enable {
    home.sessionVariables.EDITOR = "${pkgs.neovim}/bin/nvim";

    home.packages = with pkgs; [
      neovim-polar
      ripgrep
      clang-tools
      #nodePackages.bash-language-server
      #nodePackages.dockerfile-language-server-nodejs
      #nodePackages.eslint_d
      #nodePackages.markdownlint-cli
      #nodePackages.stylelint
      #nodePackages.vim-language-server
      #nodePackages.vscode-css-languageserver-bin
      #nodePackages.vscode-html-languageserver-bin
      #nodePackages.vscode-json-languageserver
      prettierd
      beancount-language-server
    ]
    ++ (if cfg.lsp.nix then [ rnix-lsp ] else [ ])
    ++ (if cfg.lsp.rust then [ rust-analyzer ] else [ ])
    ++ (if cfg.lsp.lua then [ sumneko-lua-language-server stylua ] else [ ])
    ++ (if cfg.lsp.python then [ nodePackages.pyright ] else [ ])
    ++ (if cfg.lsp.typescript then [ nodePackages.typescript-language-server ] else [ ])
    ++ (if cfg.lsp.svelte then [ nodePackages.svelte-language-server ] else [ ])
    ++ (if cfg.lsp.java then [ jdtls ] else [ ])
    ++ (if cfg.lsp.beancount then [ beancount-language-server ] else [ ])
    ;

    # old way
    #xdg.configFile = link-one "config" "." "nvim";

    # new way

    # INIT.lua
    #xdg.configFile."nvim/lua/polarmutex/init.lua".source = link "config/init.lua";

    xdg.configFile."nvim/lua/polarmutex/options.lua".source = link "config/options.lua";

    # completion (cmp)
    xdg.configFile."nvim/plugin/cmp.lua".text =
      let
        lua_config = pkgs.luaConfigBuilder {
          imports = [
            ./config/plugins/completion.nix
          ];
        };
      in
      lua_config.lua;

    # nvim-lspconfig
    xdg.configFile."nvim/lua/polarmutex/lsp.lua".text =
      let
        lua_config = pkgs.luaConfigBuilder {
          imports = [ ./config/lsp/lsp.nix ]
            ++ (if cfg.lsp.nix then [ ./config/lsp/lsp_nix.nix ] else [ ])
            ++ (if cfg.lsp.rust then [ ./config/lsp/lsp_rust.nix ] else [ ])
            ++ (if cfg.lsp.lua then [ ./config/lsp/lsp_lua.nix ] else [ ])
          ;
        };
      in
      lua_config.lua;

    # nvim-treesitter
    xdg.configFile."nvim/plugin/fix_nix.lua".source = link "config/treesitter/fix_nix.lua";
    xdg.configFile."nvim/lua/polarmutex/treesitter.lua".text =
      let
        lua_config = pkgs.luaConfigBuilder {
          imports = [
            ./config/treesitter/treesitter.nix
          ];
        };
      in
      lua_config.lua;

    # null-ls-nvim
    xdg.configFile."nvim/lua/polarmutex/lsp_formatting.lua".source = link "config/lsp/lsp_formatting.lua";

    # tokyonight
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
