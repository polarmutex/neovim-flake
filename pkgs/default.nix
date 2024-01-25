{inputs, ...}: let
in {
  perSystem = {
    config,
    inputs',
    pkgs,
    system,
    ...
  }: let
    polar-lua-config = pkgs.callPackage ./polar-lua-config.nix {inherit (config) packages;};
    plugin-overlay = import ./plugin-overlay.nix {inherit inputs;};
    neovim-overlay = import ./neovim-overlay.nix {
      inherit inputs;
      inherit polar-lua-config;
    };
  in {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        inputs.nvfetcher.overlays.default
        plugin-overlay
        neovim-overlay
        (_final: _prev: {
          mdformat-with-plugins =
            pkgs.python311Packages.mdformat.withPlugins
            (with pkgs.python311Packages; [
              (mdformat-gfm.overridePythonAttrs (prev: {
                src = pkgs.fetchFromGitHub {
                  owner = "hukkin";
                  repo = prev.pname;
                  rev = "master";
                  hash = "sha256-dQsYL2I3bWmdgoxIHhW6e+Sz8kfjD1bR5XZmpmUYCV8=";
                };
              }))
              mdit-py-plugins
              mdformat-frontmatter
              mdformat-toc
            ]);
          nil-git = inputs'.nil.packages.default;
        })
      ];
    };

    packages = {
      default = config.packages.neovim-git;

      inherit (pkgs) nvfetcher;

      # from https://github.com/nix-community/neovim-nightly-overlay
      neovim-git = inputs'.neovim-flake.packages.neovim;
      neovim-polar-dev = pkgs.neovim-polar-dev;
      neovim-polar = pkgs.neovim-polar;

      nvimPlugins-nvim-treesitter = pkgs.nvimPlugins.nvim-treesitter;

      # update-tree-sitter-grammars = let
      #   sources = pkgs.callPackages ./plugins/nvim-treesitter/generated.nix {};
      #   lockfile = pkgs.lib.importJSON "${sources.nvim-treesitter.src}/lockfile.json";
      #
      #   allGrammars =
      #     builtins.mapAttrs
      #     (name: value: rec {
      #       inherit (value) owner;
      #       repo =
      #         if value ? "repo"
      #         then value.repo
      #         else "tree-sitter-${name}";
      #       rev =
      #         if value ? "rev"
      #         then value.rev
      #         else lockfile."${name}".revision;
      #       branch =
      #         if value ? "branch"
      #         then value.branch
      #         else "master";
      #     })
      #     grammars;
      #
      #   foreachSh = attrs: f:
      #     pkgs.lib.concatMapStringsSep "\n" f
      #     (pkgs.lib.mapAttrsToList (k: v: {name = k;} // v) attrs);
      # in
      #   pkgs.writeShellApplication {
      #     name = "update-grammars.sh";
      #     runtimeInputs = [pkgs.npins];
      #     text = ''
      #        rm -rf pkgs/plugins/nvim-treesitter/grammars/*
      #       ${pkgs.npins}/bin/npins -d pkgs/plugins/nvim-treesitter/grammars init --bare
      #        ${
      #         foreachSh allGrammars ({
      #           name,
      #           owner,
      #           repo,
      #           branch,
      #           rev,
      #           ...
      #         }: ''
      #           echo "Updating treesitter parser for ${name}"
      #           ${pkgs.npins}/bin/npins \
      #             -d pkgs/plugins/nvim-treesitter/grammars \
      #             add \
      #             --name tree-sitter-${name}\
      #             github \
      #             "${owner}" \
      #             "${repo}" \
      #             -b "${branch}" \
      #             --at "${rev}"
      #         '')
      #       }
      #     '';
      #   };
    };
  };
}
