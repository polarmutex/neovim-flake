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
      nix = mkOption {
        type = types.bool;
        default = true;
        description = "Enable lsp nix";
      };
      rust = mkOption {
        type = types.bool;
        default = false;
        description = "Enable lsp rust";
      };
    };
  };

  config = mkIf cfg.enable {
    home.sessionVariables.EDITOR = "${pkgs.neovim}/bin/nvim";

    home.packages = with pkgs; [
      neovim-polar
      clang-tools
      stylua
      nodePackages.bash-language-server
      nodePackages.dockerfile-language-server-nodejs
      nodePackages.eslint_d
      nodePackages.markdownlint-cli
      nodePackages.pyright
      nodePackages.stylelint
      nodePackages.typescript-language-server
      nodePackages.vim-language-server
      nodePackages.vscode-css-languageserver-bin
      nodePackages.vscode-html-languageserver-bin
      nodePackages.vscode-json-languageserver
      (if cfg.lsp.nix then rnix-lsp else null)
      sumneko-lua-language-server
      #jdtls
      nodePackages.svelte-language-server
      prettierd
      ripgrep
      #python39Packages.python-lsp-server
      ##python39Packages.pyls-flake8
      #python39Packages.flake8
      #TODO python39Packages.pylsp-mypy
      #TODO python39Packages.mypy
      #python39Packages.pyls-isort
      #python39Packages.python-lsp-black
      (if cfg.lsp.rust then rust-analyzer else null)
      beancount-language-server
    ];

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
