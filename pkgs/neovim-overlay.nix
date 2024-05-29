{
  inputs,
  polar-lua-config,
}: final: prev:
with final.lib; let
  mkNeovim = final.callPackage ./mkNeovim.nix {
    inherit inputs;
  };

  all-plugins = with final.nvimPlugins; [
    polar-lua-config
    beancount-nvim
    cmp-dap
    cmp-emoji
    cmp-nvim-lsp
    cmp-path
    conform-nvim
    crates-nvim
    diffview-nvim
    dressing-nvim
    edgy-nvim
    flash-nvim
    friendly-snippets
    gitsigns-nvim
    harpoon
    inc-rename-nvim
    lualine-nvim
    luasnip
    kanagawa-nvim
    mini-indentscope
    neodev-nvim
    neogit
    noice-nvim
    nui-nvim
    nvim-cmp
    nvim-colorizer
    nvim-dap
    nvim-dap-python
    nvim-dap-ui
    nvim-dap-virtual-text
    nvim-jdtls
    nvim-lint
    nvim-navic
    nvim-nio
    nvim-treesitter
    nvim-treesitter-playground
    nvim-web-devicons
    obsidian-nvim
    one-small-step-for-vimkind
    overseer-nvim
    rustaceanvim
    plenary-nvim
    schemastore-nvim
    sqlite-lua
    telescope-nvim
    telescope-fzf-native
    tokyonight-nvim
    trouble-nvim
    vim-arduino
    vim-be-good
    vim-illuminate
    which-key-nvim
    yanky-nvim
  ];

  extraPackages = with final; [
    fswatch

    # lua
    lua-language-server
    luajitPackages.luacheck
    stylua

    # markdown
    prettierd
    markdownlint-cli
    # (pkgs.mdformat.withPlugins (p: [
    #   p.mdformat-frontmatter
    #   p.mdformat-gfm
    #   p.mdformat-toc
    # ]))

    #nix
    nil-git
    deadnix
    statix
    alejandra

    # python
    (python311.withPackages (ps:
      with ps; [
        black
        python-lsp-server
        python-lsp-black.overrideAttrs
        (oldAttrs: rec {
          patches =
            oldAttrs.patches
            /*
            fix test failure with black>=24.3.0;
            remove this patch once python-lsp-black>2.0.0
            */
            ++ lib.optional
            (with lib; (versionOlder version "2.0.1") && (versionAtLeast black.version "24.3.0"))
            (fetchpatch {
              url = "https://patch-diff.githubusercontent.com/raw/python-lsp/python-lsp-black/pull/59.patch";
              hash = "sha256-4u0VIS7eidVEiKRW2wc8lJVkJwhzJD/M+uuqmTtiZ7E=";
            });
        })
        python-lsp-ruff
        pydocstyle
        debugpy
      ]))
    ruff
    basedpyright

    # rust
    rust-analyzer

    # yaml
    nodePackages_latest.yaml-language-server

    # java
    jdt-language-server

    # arduino
    arduino-cli
  ];

  neovim-polar-dev = mkNeovim {
    plugins = all-plugins;
    devPlugins = [
      {
        name = "git-worktree.nvim";
        path = "~/repos/personal/git-worktree-nvim/v2 ";
      }
      {
        name = "beancount.nvim";
        path = "~/repos/personal/beancount-nvim/master ";
      }
    ];
    inherit extraPackages;
  };

  neovim-polar = mkNeovim {
    plugins =
      all-plugins
      ++ (with final.nvimPlugins; [
        git-worktree-nvim
      ]);
    inherit extraPackages;
  };
in {
  inherit
    neovim-polar-dev
    neovim-polar
    ;

  # This can be symlinked in the devShell's shellHook.
  nvim-luarc-json = final.mk-luarc-json {
    nvim = neovim-polar;
    plugins = all-plugins;
    neodev-types = "nightly";
  };
}
