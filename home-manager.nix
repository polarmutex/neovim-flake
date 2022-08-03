{ config
, pkgs
, lib
, dsl
, inputs
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

  withSrc = pkg: src: pkg.overrideAttrs (_: { inherit src; });
  plugin = pname: src: pkgs.vimUtils.buildVimPluginFrom2Nix {
    inherit pname src;
    version = "master";
  };

  cfg = config.polar.programs.neovim;
in
{

  imports = [
    ./config/lsp
    ./config/treesitter

    # plugins
    ./config/plugins/colorizer
    ./config/plugins/fidget
    ./config/plugins/gitsigns
    ./config/plugins/lualine
    ./config/plugins/neogit
    ./config/plugins/nvim-cmp
    ./config/plugins/telescope
    #./config/plugins/tokyonight-nvim
    ./config/plugins/kanagawa-nvim
  ];

  options = {

    polar.programs.neovim = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable neovim";
      };
    };
  };

  config = mkIf cfg.enable {
    home.sessionVariables.EDITOR = "${pkgs.neovim}/bin/nvim";

    home.packages = with pkgs; [
      #neovim-polar
      ripgrep
    ];

    programs.neovim = {
      enable = true;
      package = pkgs.neovim; # should be unwrapped master
      extraConfig = ''
        lua require('polarmutex.init')
      '';
      plugins = [
        (plugin "beancount-nvim" inputs.beancount-nvim-src)
        (withSrc pkgs.vimPlugins.cmp-buffer inputs.cmp-buffer-src)
        (withSrc pkgs.vimPlugins.cmp-nvim-lsp inputs.cmp-nvim-lsp-src)
        (withSrc pkgs.vimPlugins.cmp-nvim-lua inputs.cmp-nvim-lua-src)
        (withSrc pkgs.vimPlugins.cmp-path inputs.cmp-path-src)
        (plugin "colorizer" inputs.colorizer-src)
        (plugin "comment-nvim" inputs.comment-nvim-src)
        (plugin "conceal" inputs.conceal-src)
        (plugin "fidget" inputs.fidget-src)
        (plugin "gitsigns-nvim" inputs.gitsigns-nvim-src)
        (plugin "kanagawa-nvim" inputs.kanagawa-nvim-src)
        (withSrc pkgs.vimPlugins.lspkind-nvim inputs.lspkind-nvim-src)
        (withSrc pkgs.vimPlugins.lualine-nvim inputs.lualine-nvim-src)
        (plugin "neogit" inputs.neogit-src)
        (plugin "null-ls-nvim" inputs.null-ls-nvim-src)
        (withSrc pkgs.vimPlugins.nvim-cmp inputs.nvim-cmp-src)
        (withSrc pkgs.vimPlugins.nvim-dap inputs.nvim-dap-src)
        (withSrc pkgs.vimPlugins.nvim-dap-ui inputs.nvim-dap-ui-src)
        (withSrc pkgs.vimPlugins.nvim-dap-virtual-text inputs.nvim-dap-virtual-text-src)
        (plugin "nvim-jdtls" inputs.nvim-jdtls-src)
        (withSrc pkgs.vimPlugins.nvim-lspconfig inputs.nvim-lspconfig-src)
        #(withSrc pkgs.vimPlugins.nvim-treesitter inputs.nvim-treesitter-src)
        (pkgs.vimPlugins.nvim-treesitter.withPlugins (
          plugins: with plugins; [
            tree-sitter-bash
            tree-sitter-beancount
            tree-sitter-c
            tree-sitter-java
            tree-sitter-lua
            tree-sitter-json
            tree-sitter-nix
            tree-sitter-python
            tree-sitter-rust
          ]
        ))
        (withSrc pkgs.vimPlugins.playground inputs.nvim-treesitter-playground-src)
        (withSrc pkgs.vimPlugins.plenary-nvim inputs.plenary-nvim-src)
        (withSrc pkgs.vimPlugins.popup-nvim inputs.popup-nvim-src)
        (plugin "rust-tools" inputs.rust-tools-nvim-src)
        (plugin "telescope-nvim" inputs.telescope-nvim-src)
        (plugin "telescope-ui-select" inputs.telescope-ui-select-src)
        (plugin "tokyonight-nvim" inputs.tokyonight-nvim-src)
      ];
    };

    # old way
    #xdg.configFile = link-one "config" "." "nvim";

    # new way

    # INIT.lua
    xdg.configFile."nvim/lua/polarmutex/init.lua".source = link "config/init.lua";

    xdg.configFile."nvim/lua/polarmutex/profile.lua".source = link "config/profile.lua";
    xdg.configFile."nvim/lua/polarmutex/options.lua".source = link "config/options.lua";
    xdg.configFile."nvim/lua/polarmutex/mappings.lua".source = link "config/mappings.lua";
    xdg.configFile."nvim/filetype.lua".source = link "config/filetype.lua";

  };

}
