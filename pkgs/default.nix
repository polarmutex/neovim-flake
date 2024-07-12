{inputs, ...}: let
in {
  perSystem = {
    inputs',
    system,
    config,
    lib,
    pkgs,
    #self,
    ...
  }: let
    plugin-overlay = import ./plugins-overlay.nix {inherit inputs;};

    npins = import ./npins;

    mkNeovim = pkgs.callPackage ./mkNeovim.nix {
      inherit inputs;
      neovim-unwrapped = config.packages.neovim;
    };

    all-plugins = with pkgs.nvimPlugins; [
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
      hardtime-nvim
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
      precognition-nvim
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

    extraPackages = with pkgs; [
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
      nil
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
      basedpyright-nixpkgs.basedpyright

      # rust
      rust-analyzer

      # yaml
      nodePackages_latest.yaml-language-server

      # java
      jdt-language-server

      # arduino
      arduino-cli
    ];
  in {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = false;
      overlays = [
        plugin-overlay
        inputs.gen-luarc.overlays.default
        (_final: prev: {
          # nil-git = inputs'.nil.packages.default;
          basedpyright-nixpkgs = import inputs.nixpkgs-basedpyright {
            inherit (prev) system;
          };
        })
      ];
    };

    packages = {
      default = config.packages.neovim;

      neovim = import ./neovim.nix {
        neovim-src = npins.neovim;
        inherit lib pkgs;
      };

      neovim-debug = import ./neovim-debug.nix {
        inherit (config.packages) neovim;
        inherit pkgs;
      };

      neovim-developer = import ./neovim-developer.nix {
        inherit (config.packages) neovim-debug;
        neovim-src = npins.neovim;
        inherit lib pkgs;
      };

      polar-lua-config = pkgs.callPackage ./polar-lua-config.nix {
        inherit (config) packages;
      };

      neovim-polar-dev = mkNeovim {
        vimAlias = true;
        appName = "nvim";
        plugins =
          all-plugins
          ++ [
            config.packages.polar-lua-config
          ];
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
        vimAlias = true;
        appName = "nvim";
        plugins =
          all-plugins
          ++ (with pkgs.nvimPlugins; [
            config.packages.polar-lua-config
            git-worktree-nvim
          ]);
        inherit extraPackages;
      };

      nvim-luarc-json = pkgs.mk-luarc-json {
        nvim = config.packages.neovim-polar;
        plugins = all-plugins;
      };

      # inherit (pkgs) fd;
      # inherit (pkgs) jq;
      inherit (pkgs) npins;

      # # from https://github.com/nix-community/neovim-nightly-overlay
      # neovim-git = inputs'.neovim-nightly-overlay.packages.neovim;
      # inherit (pkgs) neovim-polar-dev;
      # inherit (pkgs) neovim-polar;
      # inherit (pkgs) nvim-luarc-json;
      # inherit polar-lua-config;

      nvimPlugins-nvim-treesitter = pkgs.nvimPlugins.nvim-treesitter;

      # # scripts
      flake-commit-and-format-patch = pkgs.callPackage ./script-flake-commit-and-format-patch.nix {};
      npins-commit-and-format-patch = pkgs.callPackage ./script-npins-commit-and-format-patch.nix {};
      configure-git-user = pkgs.callPackage ./script-configure-git-user.nix {};
      generate-npins-matrix = pkgs.callPackage ./script-generate-npins-matrix.nix {};
      npins-version-matrix = pkgs.callPackage ./script-npins-version-matrix.nix {};
      update-nvim-plugin = pkgs.callPackage ./script-update-nvim-plugin.nix {};
      update-tree-sitter-grammars = pkgs.callPackage ./script-update-tree-sitter-grammars.nix {};
    };
  };
}
