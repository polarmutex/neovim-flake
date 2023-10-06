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
        #self',
        system,
        ...
      }: {
        packages = {
          #default = config.packages.neovim-git;
          # from https://github.com/nix-community/neovim-nightly-overlay
          #neovim-git = inputs'.neovim-flake.packages.neovim.overrideAttrs (o: {
          #  patches = builtins.filter (p:
          #    (
          #      if builtins.typeOf p == "set"
          #      then baseNameOf p.name
          #      else baseNameOf
          #    )
          #    != "use-the-correct-replacement-args-for-gsub-directive.patch")
          #  o.patches;
          #});
          #neovim-lua-config-polar = pkgs.callPackage ./pkgs/lua-config.nix {};
          #docgen = pkgs.callPackage ./pkgs/docgen.nix {};
          #neovim-polar = pkgs.callPackage ./pkgs/neovim-polar.nix {inherit neovim-flake;};
          #nvim-treesitter-master = pkgs.callPackage ./pkgs/nvim-treesitter.nix {
          #  inherit nixpkgs;
          #  nvim-treesitter-git = pkgs.neovimPlugins.nvim-treesitter;
          #  inherit (pkgs) treesitterGrammars;
          #};
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
              inherit (pkgs) lemmy-help;
            };
            inherit (self.checks.${system}.pre-commit-check) shellHook;
          };
        };
      };
    };

  # Input source for our derivation
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    nvfetcher = {
      url = "github:berberman/nvfetcher/0.6.2";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
      };
    };

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
  };
}
