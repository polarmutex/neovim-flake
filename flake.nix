{
  description = "Tutorial Flake accompanying vimconf talk.";

  nixConfig = {
    extra-substituters = "https://polarmutex.cachix.org";
    extra-trusted-public-keys = "polarmutex.cachix.org-1:kUFH4ftZAlTrKlfFaKfdhKElKnvynBMOg77XRL2pc08=";
  };

  outputs = {
    self,
    nixpkgs,
    neovim-flake,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;}
    {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];

      imports = [
        ./checks
      ];

      flake = {
        overlays.default = _final: _prev: {
        };
      };
      perSystem = {
        config,
        pkgs,
        inputs',
        self',
        system,
        ...
      }: let
        overlays = [
          (_final: _prev: {
            inherit (self'.packages) neovim-git;
            inherit (self'.packages) nvim-treesitter-master;
            inherit (self'.packages) neovim-lua-config-polar;
            inherit (self'.packages) docgen;
            nil-git = inputs'.nil.packages.default;
          })
          (_final: _prev: {
            mdformat-with-plugins =
              pkgs.python311Packages.mdformat.withPlugins
              (with pkgs.python311Packages; [
                mdformat-gfm
                mdformat-frontmatter
                mdformat-toc
              ]);
          })
          (final: prev: let
            mkNvimPlugin = src: pname:
              prev.pkgs.vimUtils.buildVimPluginFrom2Nix {
                inherit pname src;
                version = src.lastModifiedDate;
              };
          in {
            neovimPlugins = {
              beancount-nvim = mkNvimPlugin inputs.beancount-nvim "beancount.nvim";
              cmp-buffer = mkNvimPlugin inputs.cmp-buffer "cmp-buffer";
              cmp-calc = mkNvimPlugin inputs.cmp-calc "cmp-calc";
              cmp-cmdline = mkNvimPlugin inputs.cmp-cmdline "cmp-cmdline";
              cmp-dap = mkNvimPlugin inputs.cmp-dap "cmp-dap";
              cmp-emoji = mkNvimPlugin inputs.cmp-emoji "cmp-emoji";
              cmp-nvim-lsp = mkNvimPlugin inputs.cmp-nvim-lsp "cmp-nvim-lsp";
              cmp-nvim-lsp-signature-help = mkNvimPlugin inputs.cmp-nvim-lsp-signature-help "cmp-nvim-lsp-signature-help";
              cmp-omni = mkNvimPlugin inputs.cmp-omni "cmp-omni";
              cmp-path = mkNvimPlugin inputs.cmp-path "cmp-path";
              crates-nvim = mkNvimPlugin inputs.crates-nvim "crates.nvim";
              diffview-nvim = mkNvimPlugin inputs.diffview-nvim "diffview.nvim";
              dressing-nvim = mkNvimPlugin inputs.dressing-nvim "dressing.nvim";
              git-worktree-nvim = mkNvimPlugin inputs.git-worktree-nvim "git-worktree.nvim";
              gitsigns-nvim = mkNvimPlugin inputs.gitsigns-nvim "gitsigns.nvim";
              harpoon = mkNvimPlugin inputs.harpoon "harpoon";
              lazy-nvim = mkNvimPlugin inputs.lazy-nvim "lazy.nvim";
              lsp-inlayhints-nvim = mkNvimPlugin inputs.lsp-inlayhints-nvim "lsp-inlayhints.nvim";
              lsp-kind-nvim = mkNvimPlugin inputs.lsp-kind-nvim "lspkind.nvim";
              lualine-nvim = mkNvimPlugin inputs.lualine-nvim "lualine.nvim";
              kanagawa-nvim = mkNvimPlugin inputs.kanagawa-nvim "kanagawa.nvim";
              neodev-nvim = mkNvimPlugin inputs.neodev-nvim "neodev.nvim";
              neogit = mkNvimPlugin inputs.neogit "neogit";
              noice-nvim = mkNvimPlugin inputs.noice-nvim "noice.nvim";
              nui-nvim = mkNvimPlugin inputs.nui-nvim "nui.nvim";
              null-ls-nvim = mkNvimPlugin inputs.null-ls-nvim "null-ls.nvim";
              nvim-cmp = mkNvimPlugin inputs.nvim-cmp "nvim-cmp";
              nvim-colorizer = mkNvimPlugin inputs.nvim-colorizer "nvim-colorizer.lua";
              nvim-dap = mkNvimPlugin inputs.nvim-dap "nvim-dap";
              nvim-dap-python = mkNvimPlugin inputs.nvim-dap-python "nvim-dap-python";
              nvim-dap-ui = mkNvimPlugin inputs.nvim-dap-ui "nvim-dap-ui";
              nvim-dap-virtual-text = mkNvimPlugin inputs.nvim-dap-virtual-text "nvim-dap-virtual-text";
              nvim-jdtls = mkNvimPlugin inputs.nvim-jdtls "nvim-jdtls";
              nvim-lspconfig = mkNvimPlugin inputs.nvim-lspconfig "nvim-lspconfig";
              nvim-treesitter = mkNvimPlugin inputs.nvim-treesitter "nvim-treesitter";
              nvim-treesitter-playground = mkNvimPlugin inputs.nvim-treesitter-playground "playground";
              nvim-web-devicons = mkNvimPlugin inputs.nvim-web-devicons "nvim-web-devicons";
              one-small-step-for-vimkind = mkNvimPlugin inputs.one-small-step-for-vimkind "one-small-step-for-vimkind";
              overseer-nvim = mkNvimPlugin inputs.overseer-nvim "overseer-nvim";
              plenary-nvim = mkNvimPlugin inputs.plenary-nvim "plenary.nvim";
              rust-tools-nvim = mkNvimPlugin inputs.rust-tools-nvim "rust-tools.nvim";
              telescope-nvim = mkNvimPlugin inputs.telescope-nvim "telescope.nvim";
              tokyonight-nvim = mkNvimPlugin inputs.tokyonight-nvim "tokyonight.nvim";
              vim-be-good = mkNvimPlugin inputs.vim-be-good "vim-be-good";
              which-key-nvim = mkNvimPlugin inputs.which-key-nvim "whick-key.nvim";
            };
          })
          self.overlays.default
          # Keeping this out of the exposed overlay, I don't want to
          # expose nvfetcher-generated stuff, that's annoying.
          #(_final: _prev: {
          #  neovimPlugins = import ./plugins;
          #})
          (_final: _prev: {
            treesitterGrammars = import ./tree-sitter-grammars;
          })
        ];
      in {
        _module.args = {
          pkgs = import nixpkgs {
            inherit system overlays;
          };
        };

        packages = {
          default = config.packages.neovim-git;
          # from https://github.com/nix-community/neovim-nightly-overlay
          neovim-git = inputs'.neovim-flake.packages.neovim.overrideAttrs (o: {
            patches = builtins.filter (p:
              (
                if builtins.typeOf p == "set"
                then baseNameOf p.name
                else baseNameOf
              )
              != "use-the-correct-replacement-args-for-gsub-directive.patch")
            o.patches;
          });
          neovim-lua-config-polar = pkgs.callPackage ./pkgs/lua-config.nix {};
          docgen = pkgs.callPackage ./pkgs/docgen.nix {};
          neovim-polar = pkgs.callPackage ./pkgs/neovim-polar.nix {inherit neovim-flake;};
          nvim-treesitter-master = pkgs.callPackage ./pkgs/nvim-treesitter.nix {
            inherit nixpkgs;
            nvim-treesitter-git = pkgs.neovimPlugins.nvim-treesitter;
            inherit (pkgs) treesitterGrammars;
          };
        };

        apps = {
          defaultApp = {
            type = "app";
            program = "${pkgs.neovim-polar}/bin/nvim";
          };
          update-neovim-plugins = {
            type = "app";
            program = pkgs.writeShellApplication {
              name = "update-plugins.sh";
              runtimeInputs = [pkgs.npins];
              text = ''
                ${pkgs.npins}/bin/npins -d plugins update
              '';
            };
          };
          update-treesitter-parsers = {
            type = "app";
            program = pkgs.nvim-treesitter-master.update-grammars;
          };
        };

        devShells = {
          default = pkgs.mkShell {
            packages = builtins.attrValues {
              inherit (pkgs) lemmy-help npins;
            };
            inherit (self.checks.${system}.pre-commit-check) shellHook;
          };
        };
      };
    };

  # Input source for our derivation
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    flake-parts.url = "github:hercules-ci/flake-parts";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #neovim = { url = "github:neovim/neovim?dir=contrib&rev=47e60da7210209330767615c234ce181b6b67a08"; };
    neovim-flake = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Lsp
    nil = {
      url = "github:oxalica/nil";
    };

    # plugins
    beancount-nvim = {
      url = "github:polarmutex/beancount.nvim";
      flake = false;
    };
    cmp-buffer = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };
    cmp-dap = {
      url = "github:rcarriga/cmp-dap";
      flake = false;
    };
    cmp-emoji = {
      url = "github:hrsh7th/cmp-emoji";
      flake = false;
    };
    cmp-nvim-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };
    cmp-path = {
      url = "github:hrsh7th/cmp-path";
      flake = false;
    };
    crates-nvim = {
      url = "github:Saecki/crates.nvim";
      flake = false;
    };
    diffview-nvim = {
      url = "github:sindrets/diffview.nvim";
      flake = false;
    };
    dressing-nvim = {
      url = "github:stevearc/dressing.nvim";
      flake = false;
    };
    git-worktree-nvim = {
      url = "github:ThePrimeagen/git-worktree.nvim";
      flake = false;
    };
    gitsigns-nvim = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };
    harpoon = {
      url = "github:ThePrimeagen/harpoon";
      flake = false;
    };
    lazy-nvim = {
      url = "github:folke/lazy.nvim";
      flake = false;
    };
    lualine-nvim = {
      url = "github:nvim-lualine/lualine.nvim";
      flake = false;
    };
    kanagawa-nvim = {
      url = "github:rebelot/kanagawa.nvim";
      flake = false;
    };
    neodev-nvim = {
      url = "github:folke/neodev.nvim";
      flake = false;
    };
    neogit = {
      url = "github:NeogitOrg/neogit";
      flake = false;
    };
    noice-nvim = {
      url = "github:folke/noice.nvim";
      flake = false;
    };
    nui-nvim = {
      url = "github:MunifTanjim/nui.nvim";
      flake = false;
    };
    null-ls-nvim = {
      url = "github:jose-elias-alvarez/null-ls.nvim";
      flake = false;
    };
    nvim-cmp = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };
    nvim-colorizer = {
      url = "github:norcalli/nvim-colorizer.lua";
      flake = false;
    };
    nvim-dap = {
      url = "github:mfussenegger/nvim-dap";
      flake = false;
    };
    nvim-dap-python = {
      url = "github:mfussenegger/nvim-dap-python";
      flake = false;
    };
    nvim-dap-ui = {
      url = "github:rcarriga/nvim-dap-ui";
      flake = false;
    };
    nvim-dap-virtual-text = {
      url = "github:theHamsta/nvim-dap-virtual-text";
      flake = false;
    };
    nvim-jdtls = {
      url = "github:mfussenegger/nvim-jdtls";
      flake = false;
    };
    nvim-lspconfig = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };
    nvim-treesitter = {
      url = "github:nvim-treesitter/nvim-treesitter";
      flake = false;
    };
    nvim-treesitter-playground = {
      url = "github:nvim-treesitter/playground";
      flake = false;
    };
    nvim-web-devicons = {
      url = "github:nvim-tree/nvim-web-devicons";
      flake = false;
    };
    one-small-step-for-vimkind = {
      url = "github:jbyuki/one-small-step-for-vimkind";
      flake = false;
    };
    overseer-nvim = {
      url = "github:stevearc/overseer.nvim";
      flake = false;
    };
    plenary-nvim = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };
    rust-tools-nvim = {
      url = "github:simrat39/rust-tools.nvim";
      flake = false;
    };
    telescope-nvim = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };
    tokyonight-nvim = {
      url = "github:folke/tokyonight.nvim";
      flake = false;
    };
    vim-be-good = {
      url = "github:ThePrimeagen/vim-be-good";
      flake = false;
    };
    which-key-nvim = {
      url = "github:folke/which-key.nvim";
      flake = false;
    };
  };
}
