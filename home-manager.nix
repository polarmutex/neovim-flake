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
      #clang-tools
      stylua
      #nodePackages.bash-language-server
      #nodePackages.dockerfile-language-server-nodejs
      #nodePackages.eslint_d
      nodePackages.markdownlint-cli
      nodePackages.pyright
      #nodePackages.stylelint
      #nodePackages.typescript-language-server
      #nodePackages.vim-language-server
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
      #rust-analyzer
      beancount-language-server
    ];

    #xdg.configFile = link-one "config" "." "nvim";

    #xdg.configFile."nvim/init.lua".source = ./config/init.lua;
    xdg.configFile."nvim/lua/polarmutex/init.lua".source = link "config/init.lua";

    xdg.configFile."nvim/lua/polarmutex/treesitter.lua".text =
    let
        lua_config = pkgs.luaConfigBuilder {
            imports = [
	    ./config/treesitter.nix
	    ];
        };
    in lua_config.lua;

    xdg.configFile."nvim/lua/polarmutex/lsp.lua".text =
    let
        lua_config = pkgs.luaConfigBuilder {
            imports = (if cfg.lsp.nix then [ ./config/lsp_nix.nix ] else [])
            ++ (if cfg.lsp.rust then [ ./config/lsp_rust.nix ] else [])
	    ;
        };
    in lua_config.lua;

    #xdg.dataFile."nvim/site/pack/packer/start/nvim-treesitter/parser/python.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-python}/parser";
    #xdg.dataFile."nvim/site/pack/packer/start/nvim-treesitter/parser/lua.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-lua}/parser";
    #xdg.dataFile."nvim/site/pack/packer/start/nvim-treesitter/parser/rust.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-rust}/parser";
    #xdg.dataFile."nvim/site/pack/packer/start/nvim-treesitter/parser/java.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-java}/parser";
    #xdg.dataFile."nvim/site/pack/packer/start/nvim-treesitter/parser/c.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-c}/parser";
    #xdg.dataFile."nvim/site/pack/packer/start/nvim-treesitter/parser/cpp.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-cpp}/parser";
    #xdg.dataFile."nvim/site/pack/packer/start/nvim-treesitter/parser/typescript.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-typescript}/parser";
    #xdg.dataFile."nvim/site/pack/packer/start/nvim-treesitter/parser/html.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-html}/parser";
    #xdg.dataFile."nvim/site/pack/packer/start/nvim-treesitter/parser/markdown.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-markdown}/parser";
    #xdg.dataFile."nvim/site/pack/packer/start/nvim-treesitter/parser/nix.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-nix}/parser";
    ##xdg.dataFile."nvim/site/pack/packer/start/nvim-treesitter/parser/svelte.so".source = "${pkgs.my.tree-sitter-svelte}/parser";
    #xdg.dataFile."nvim/site/pack/packer/start/nvim-treesitter/parser/svelte.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-svelte}/parser";
    ##xdg.dataFile."nvim/site/pack/packer/start/nvim-treesitter/parser/beancount.so".source = "${pkgs.my.tree-sitter-beancount}/parser";
    #xdg.dataFile."nvim/site/pack/packer/start/nvim-treesitter/parser/beancount.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-beancount}/parser";
  };

}
