{
  description = "Tutorial Flake accompanying vimconf talk.";

  nixConfig = {
    extra-substituters = [
      "https://polarmutex.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "polarmutex.cachix.org-1:kUFH4ftZAlTrKlfFaKfdhKElKnvynBMOg77XRL2pc08="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs = {
    self,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake
    {inherit inputs;}
    {
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      imports = [
        ./checks
        ./pkgs
      ];

      perSystem = {
        self',
        pkgs,
        system,
        ...
      }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = false;
          overlays = [
            # plugin-overlay
            inputs.gen-luarc.overlays.default
            (_final: _prev: {
              neovim-nightly = inputs.neovim-nightly-overlay.packages.${system}.default;
              #   # nil-git = inputs'.nil.packages.default;
              #   basedpyright-nixpkgs = import inputs.nixpkgs-basedpyright {
              #     inherit (prev) system;
              #   };
            })
          ];
        };
        devShells = {
          default = pkgs.mkShell {
            name = "neovim-developer-shell";
            packages = with pkgs; [
              lemmy-help
              # npins
              nix-tree
              statix
              just
              gitu
            ];
            shellHook = ''
              ${self.checks.${system}.pre-commit-check.shellHook}
              ln -fs ${self'.packages.nvim-luarc-json} .luarc.json
              #export NVIM_PYTHON_LOG_LEVEL=DEBUG
              #export NVIM_LOG_FILE=/tmp/nvim.log
              #export VIMRUNTIME=

              # ASAN_OPTIONS=detect_leaks=1
              #export ASAN_OPTIONS="log_path=./test.log:abort_on_error=1"

              # for treesitter functionaltests
              #mkdir -p runtime/parser
              #cp -f {pkgs.vimPlugins.nvim-treesitter.builtGrammars.c}/parser runtime/parser/c.so
            '';
          };
        };
      };
    };

  # Input source for our derivation
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    gen-luarc.url = "github:mrcjkb/nix-gen-luarc-json";

    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixpkgs.url = "github:nixos/nixpkgs/master";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    # nixpkgs-mine.url = "github:polarmutex/nixpkgs/update-treesitter";

    # spell
    spell-en-dictionary = {
      url = "http://ftp.nluug.nl/vim/runtime/spell/en.utf-8.spl";
      flake = false;
    };

    spell-en-suggestions = {
      url = "http://ftp.nluug.nl/vim/runtime/spell/en.utf-8.sug";
      flake = false;
    }; # Add the wrapper-manager flake

    wrapper-manager = {
      url = "github:viperML/wrapper-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
