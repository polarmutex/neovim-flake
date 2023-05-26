{
  lib,
  pkgs,
  ...
}: {
  plugins = with pkgs.neovimPlugins; [
    (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.passthru.allGrammars))
    nvim-treesitter-context
    #nvim-ts-context-commentstring
    #nvim-ts-rainbow
  ];

  setup.treesitter-context.setup = {};

  setup."nvim-treesitter.configs" = {
    #ensure_installed = "all";
    #ignore_install = [ ];

    highlight = {
      enable = true;
      use_languagetree = true;
      #disable = [ ];
    };

    incremental_selection = {
      enable = true;
      keymaps = {
        init_selection = "<C-n>";
        node_incremental = "<C-n>";
        scope_incremental = "<C-s>";
        node_decremental = "<C-p>";
      };
    };
    indent.enable = true;

    textobjects = {
      select = {
        enable = true;
        lookahead = true;

        keymaps = {
          "['af']" = "@function.outer";
          "['if']" = "@function.inner";
          "['ac']" = "@class.outer";
          "['ic']" = "@class.inner";
        };
      };
    };
  };
}
