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
        overlays = let
          plugin-overlay = import ./nix/plugin-overlay.nix {inherit inputs;};
        in [
          (_final: _prev: {
            inherit (self'.packages) neovim-git;
            inherit (self'.packages) nvim-treesitter-master;
            inherit (self'.packages) neovim-lua-config-polar;
            nil-git = inputs'.nil.packages.default;
          })
          (_final: _prev: {
            mdformat = import inputs.nixpkgs-mdformat {
              inherit system;
              config.allowUnfree = true;
            };
          })
          (_final: _prev: {
            mdformat-with-plugins = pkgs.mdformat.python310.withPackages (ps: [
              ps.mdformat
              ps.mdformat-gfm
              ps.mdformat-frontmatter
              ps.mdformat-toc
            ]);
          })

          plugin-overlay
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
          neovim-polar = pkgs.callPackage ./pkgs/neovim-polar.nix {inherit neovim-flake;};
          nvim-treesitter-master = pkgs.callPackage ./pkgs/nvim-treesitter.nix {
            inherit nixpkgs;
            nvim-treesitter-git = pkgs.neovimPlugins.nvim-treesitter;
            inherit (pkgs) treesitterGrammars;
          };
          inherit (pkgs) mdformat-with-plugins;
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
    nixpkgs-mdformat.url = "github:polarmutex/nixpkgs/mdformat-plugins";
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
    cmp-calc = {
      url = "github:hrsh7th/cmp-calc";
      flake = false;
    };
    cmp-cmdline = {
      url = "github:hrsh7th/cmp-cmdline";
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
    cmp-nvim-lsp-signature-help = {
      url = "github:hrsh7th/cmp-nvim-lsp-signature-help";
      flake = false;
    };
    cmp-omni = {
      url = "github:hrsh7th/cmp-omni";
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
    heirline-nvim = {
      url = "github:rebelot/heirline.nvim";
      flake = false;
    };
    lazy-nvim = {
      url = "github:folke/lazy.nvim";
      flake = false;
    };
    lsp-format-nvim = {
      url = "github:lukas-reineke/lsp-format.nvim";
      flake = false;
    };
    lspkind-nvim = {
      url = "github:onsails/lspkind.nvim";
      flake = false;
    };
    neodev-nvim = {
      url = "github:folke/neodev.nvim";
      flake = false;
    };
    neogit = {
      url = "github:TimUntersberger/neogit";
      flake = false;
    };
    neovim-tasks = {
      url = "github:Shatur/neovim-tasks";
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
  };
}
