{
  description = "Tutorial Flake accompanying vimconf talk.";

  nixConfig = {
    extra-substituters = "https://polarmutex.cachix.org";
    extra-trusted-public-keys = "polarmutex.cachix.org-1:kUFH4ftZAlTrKlfFaKfdhKElKnvynBMOg77XRL2pc08=";
  };

  outputs = {
    self,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;}
    {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];

      imports = [
        ./checks
        ./pkgs
      ];

      flake = {
        overlays.default = _final: _prev: {
        };
      };
      perSystem = {
        #config,
        pkgs,
        #inputs',
        self',
        system,
        ...
      }: {
        apps = {
          # defaultApp = {
          #   type = "app";
          #   program = "${pkgs.neovim-polar}/bin/nvim";
          # };
          # update-neovim-plugins = {
          #   type = "app";
          #   program = pkgs.writeShellApplication {
          #     name = "update-plugins.sh";
          #     runtimeInputs = [pkgs.npins];
          #     text = ''
          #       ${pkgs.npins}/bin/npins -d plugins update
          #     '';
          #   };
          # };
          # update-treesitter-parsers = {
          #   type = "app";
          #   program = pkgs.update-tree-sitter-grammars;
          # };
        };

        devShells = {
          default = pkgs.mkShell {
            packages = builtins.attrValues {
              inherit (pkgs) fd;
              inherit (pkgs) jq;
              inherit (pkgs) lemmy-help;
              inherit (pkgs) npins;
              # inherit (pkgs) nvfetcher;
            };
            shellHook = ''
              ${self.checks.${system}.pre-commit-check.shellHook}
              ln -fs ${pkgs.nvim-luarc-json} .luarc.json
            '';
          };
        };
      };
    };

  # Input source for our derivation
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    # nixpkgs-mine.url = "github:polarmutex/nixpkgs/update-treesitter";
    # nixpkgs-treesitter.url = "github:r-ryantm/nixpkgs/auto-update/tree-sitter";

    # flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
    flake-parts.url = "github:hercules-ci/flake-parts";
    # flake-utils.url = "https://flakehub.com/f/numtide/flake-utils/0.1.tar.gz";

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # neovim
    gen-luarc.url = "github:mrcjkb/nix-gen-luarc-json";
    neovim-src = {
      url = "github:neovim/neovim";
      flake = false;
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        neovim-src.follows = "neovim-src";
      };
    };

    # spell
    spell-en-dictionary = {
      url = "http://ftp.vim.org/vim/runtime/spell/en.utf-8.spl";
      flake = false;
    };
    spell-en-suggestions = {
      url = "http://ftp.vim.org/vim/runtime/spell/en.utf-8.sug";
      flake = false;
    };

    # Lsp
    nil = {
      url = "github:oxalica/nil";
    };
  };
}
