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
      }: let
        sources = import ./npins;
        pinned-pkgs = (import sources.nixpkgs) {
          inherit system;
          config.allowUnfree = false;
          overlays = [
            # plugin-overlay
            inputs.gen-luarc.overlays.default
            (import sources.neovim-nightly-overlay)
            (_final: _prev: {
              #   # nil-git = inputs'.nil.packages.default;
              #   basedpyright-nixpkgs = import inputs.nixpkgs-basedpyright {
              #     inherit (prev) system;
              #   };
            })
          ];
        };
      in {
        _module.args.pkgs = pinned-pkgs;
        devShells = {
          default = pkgs.mkShell {
            name = "neovim-developer-shell";
            packages = with pkgs; [
              self.packages.${system}.default.devMode
              # lemmy-help
              # nix-tree
              # statix
              just
              # gitu
              inputs.mcp-hub.packages."${system}".default
              task-master-ai
            ];
            shellHook = ''
              ${self.checks.${system}.pre-commit-check.shellHook}
              # ln -fs ${self'.packages.nvim-luarc-json} .luarc.json
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
    };

    # spell
    spell-en-dictionary = {
      url = "http://ftp.nluug.nl/vim/runtime/spell/en.utf-8.spl";
      flake = false;
    };

    spell-en-suggestions = {
      url = "http://ftp.nluug.nl/vim/runtime/spell/en.utf-8.sug";
      flake = false;
    };

    mcp-hub = {url = "github:ravitemer/mcp-hub";};
  };
}
