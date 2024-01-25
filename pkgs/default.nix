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

      inherit (pkgs) fd;
      inherit (pkgs) jq;
      inherit (pkgs) nvfetcher;

      # from https://github.com/nix-community/neovim-nightly-overlay
      neovim-git = inputs'.neovim-flake.packages.neovim;
      inherit (pkgs) neovim-polar-dev;
      inherit (pkgs) neovim-polar;
      inherit polar-lua-config;

      nvimPlugins-nvim-treesitter = pkgs.nvimPlugins.nvim-treesitter;

      update-nvim-plugin = pkgs.writeShellApplication {
        name = "update-nvim-plugin";
        runtimeInputs = with pkgs; [
          git
          mktemp
          nvfetcher
        ];

        text = ''
          #!/bin/sh
          set -eu

          TMPDIR="$(mktemp -d -t nvfetcher-XXXXXX)"

          cd "$(git rev-parse --show-toplevel)/pkgs/plugins/''${1}" || exit 1
          nvfetcher -l "$TMPDIR/changelog" --build-dir .

          echo "chore(plugin-update): " > "$TMPDIR/commit-summary"
          cat "$TMPDIR/changelog"

          if [ -s "$TMPDIR/changelog" ]; then
           git config user.name "polarmutex"
           git config user.email "polarmutex@users.noreply.github.com"
           cat "$TMPDIR/commit-summary" "$TMPDIR/changelog" | tr '\n' ' ' > "$TMPDIR/commit-message"
           git add .
           git commit . -F "$TMPDIR/commit-message"
          else
           git restore .
          fi
          rm -r "$TMPDIR"
        '';
      };

      update-tree-sitter-grammars = let
        data = builtins.fromJSON (builtins.readFile ./plugins/nvim-treesitter/grammars/sources.json);
        inherit (data) pins;

        grammar-sources = pkgs.callPackages ./plugins/nvim-treesitter/generated.nix {};
        lockfile = pkgs.lib.importJSON "${grammar-sources.nvim-treesitter.src}/lockfile.json";

        allGrammars = with pkgs.lib;
          mapAttrs (
            name: value: {
              inherit (value.repository) owner;
              inherit (value.repository) repo;
              rev = lockfile."${removePrefix "tree-sitter-" name}".revision;
              inherit (value) branch;
            }
          )
          pins;

        foreachSh = attrs: f:
          pkgs.lib.concatMapStringsSep "\n" f
          (pkgs.lib.mapAttrsToList (k: v: {name = k;} // v) attrs);
      in
        pkgs.writeShellApplication {
          name = "update-grammars.sh";
          runtimeInputs = with pkgs; [
            alejandra
            git
            npins
          ];
          text = ''
            cd "$(git rev-parse --show-toplevel)/pkgs/plugins/nvim-treesitter" || exit 1
            rm -rf ./grammars/*
            ${pkgs.npins}/bin/npins -d ./grammars init --bare
             ${
              foreachSh allGrammars ({
                name,
                owner,
                repo,
                branch,
                rev,
                ...
              }: ''
                echo "Updating treesitter parser for ${name}"
                ${pkgs.npins}/bin/npins \
                  -d ./grammars \
                  add \
                  --name ${name}\
                  github \
                  "${owner}" \
                  "${repo}" \
                  -b "${branch}" \
                  --at "${rev}"
              '')
            }
            ${pkgs.alejandra}/bin/alejandra -q .
            git add .
            git commit --amend --no-edit
          '';
        };
    };
  };
}
