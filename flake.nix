{
  description = "Tutorial Flake accompanying vimconf talk.";

  outputs = {
    self,
    nixpkgs,
    neovim,
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
        overlays.default = final: prev: {
          neovim-lua-config-polar = final.callPackage ./pkgs/lua-config.nix {};
          neovim-polar = final.callPackage ./pkgs/neovim-polar.nix {inherit neovim;};
          nvim-treesitter-master = final.callPackage ./pkgs/nvim-treesitter.nix {
            inherit nixpkgs;
            nvim-treesitter-git = prev.neovimPlugins.nvim-treesitter;
            treesitterGrammars = final.treesitterGrammars;
          };
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
          neovim.overlay
          self.overlays.default
          # Keeping this out of the exposed overlay, I don't want to
          # expose nvfetcher-generated stuff, that's annoying.
          (_final: _prev: {
            neovimPlugins = import ./plugins;
          })
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

        packages = with pkgs; {
          default = pkgs.neovim-polar;
          inherit neovim-lua-config-polar neovim-polar nvim-treesitter-master;
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
          };
        };
      };
    };

  # Input source for our derivation
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    flake-parts.url = "github:hercules-ci/flake-parts";

    #neovim = { url = "github:neovim/neovim?dir=contrib&rev=47e60da7210209330767615c234ce181b6b67a08"; };
    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      #inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
