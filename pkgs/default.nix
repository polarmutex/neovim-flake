{inputs, ...}: let
in {
  perSystem = {
    config,
    inputs',
    pkgs,
    system,
    self,
    ...
  }: let
    polar-lua-config = pkgs.callPackage ./polar-lua-config.nix {inherit (config) packages;};
    plugin-overlay = import ./plugins-overlay.nix {inherit inputs;};
    neovim-overlay = import ./neovim-overlay.nix {
      inherit inputs;
      inherit polar-lua-config;
    };
  in {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        plugin-overlay
        neovim-overlay
        inputs.gen-luarc.overlays.default
        (_final: prev: {
          basedpyright-nixpkgs = import inputs.nixpkgs-basedpyright {
            inherit (prev) system;
          };
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
      inherit (pkgs) npins;

      # from https://github.com/nix-community/neovim-nightly-overlay
      neovim-git = inputs'.neovim-nightly-overlay.packages.neovim;
      inherit (pkgs) neovim-polar-dev;
      inherit (pkgs) neovim-polar;
      inherit polar-lua-config;

      nvimPlugins-nvim-treesitter = pkgs.nvimPlugins.nvim-treesitter;

      # scripts
      flake-commit-and-format-patch = pkgs.writeShellApplication {
        name = "flake-commit-and-format-patch";
        runtimeInputs = with pkgs; [
          coreutils
          git
        ];

        text = ''
          #!/bin/bash

          usage() {
            printf "%s\n\n" "usage: $(basename "$0") <patch-file> "
            printf "%s\n\n" "Commits all current changes with <commit-message> as the commit message and writes a patch to <output-file>."
            exit 1
          }

          if [ $# -ne 1 ]; then
            usage
          else
            git commit -am "chore(update/flake): update nix flake" && git format-patch -1 HEAD --output "$1"
          fi
        '';
      };

      npins-commit-and-format-patch = pkgs.writeShellApplication {
        name = "npins-commit-and-format-patch";
        runtimeInputs = with pkgs; [
          coreutils
          git
        ];

        text = ''
          #!/bin/bash

          usage() {
            printf "%s\n\n" "usage: $(basename "$0") <patch-file> <pin-name> <old-version> <new-version>"
            printf "%s\n\n" "Commits all current changes with <commit-message> as the commit message and writes a patch to <output-file>."
            exit 1
          }

          if [ $# -ne 4 ]; then
            usage
          else
            git commit -am "chore(plugin/update): $2: $3 -> $4" && git format-patch -1 HEAD --output "$1"
          fi
        '';
      };

      configure-git-user = pkgs.writeShellApplication {
        name = "configure-git-user";
        runtimeInputs = with pkgs; [
          coreutils
          git
        ];

        text = ''
          #!/bin/bash

          usage() {
            printf "%s\n\n" "usage: $(basename "$0") <user.name> <user.email>"
            printf "%s\n\n" "Configures the \`git\` user name and email."
            exit 1
          }

          if [ $# -ne 2 ]; then
            usage
          else
            git config user.name "$1"
            git config user.email "$2"
          fi
        '';
      };

      generate-npins-matrix = pkgs.writeShellApplication {
        name = "generate-npins-matrix";
        runtimeInputs = with pkgs; [
          coreutils
          jq
        ];

        text = ''
          #!/bin/bash

          usage() {
            printf "%s\n\n" "usage: $(basename "$0") <source-files...>"
            printf "%s\n\n" "Prints a JSON array of objects that each correspond to an \`npins\` source."
            printf "%s\n\n" "Each value in <source-files...> should be a path to an \`npins\` \`sources.json\` file."
            printf "%s\n" "Each object in the output contains the following keys:"
            printf "  %s\n" "\"name\": the name of the pin as per its entry in its \`sources.json\`"
            printf "  %s\n" "\"sources-file\": the path to the \`sources.json\` file that contains the pin"
            exit 1
          }

          if [ $# -eq 0 ]; then
            usage
          else
            # https://stackoverflow.com/questions/51217020/jq-convert-array-to-object-indexed-by-filename
            # jq -cn '[ inputs | .pins | keys_unsorted | { name: .[], "sources-file": input_filename } ]' "$@"
            jq -cn '[ inputs | .pins | map(.) | .[] | { name: .repository.repo, version: (if .version != null then .version else .revision[0:8] end), "sources-file": input_filename } ]' "$@"
          fi
        '';
      };

      npins-version-matrix = pkgs.writeShellApplication {
        name = "npins-version-matrix";
        runtimeInputs = with pkgs; [
          coreutils
          jq
        ];

        text = ''
          #!/bin/bash

          usage() {
            printf "%s\n\n" "usage: $(basename "$0") <source-file> <package-name>"
            printf "%s\n\n" "Prints a JSON array of objects that each correspond to an \`npins\` source."
            printf "%s\n\n" "Each value in <source-files...> should be a path to an \`npins\` \`sources.json\` file."
            printf "%s\n" "Each object in the output contains the following keys:"
            printf "  %s\n" "\"name\": the name of the pin as per its entry in its \`sources.json\`"
            printf "  %s\n" "\"sources-file\": the path to the \`sources.json\` file that contains the pin"
            exit 1
          }

          if [ $# -eq 0 ]; then
            usage
          else
            # https://stackoverflow.com/questions/51217020/jq-convert-array-to-object-indexed-by-filename
            jq -rcn "inputs | .pins | .[] |select(.repository.repo == \"$2\") |  if .version != null then .version else .revision[0:8] end " "$1"
          fi
        '';
      };

      update-nvim-plugin = pkgs.writeShellApplication {
        name = "update-nvim-plugin";
        runtimeInputs = with pkgs; [
          git
          mktemp
          npins
        ];

        text = ''
          OLD_VERSION=$(jq -rcn "inputs | .pins | .[] |select(.repository.repo == \"$1\") |  if .version != null then .version else .revision[0:8] end " "pkgs/npins/sources.json")
          ${pkgs.npins}/bin/npins -d pkgs/npins update "$1"
          NEW_VERSION=$(jq -rcn "inputs | .pins | .[] |select(.repository.repo == \"$1\") |  if .version != null then .version else .revision[0:8] end " "pkgs/npins/sources.json")
          git commit -am "chore(plugin/update): $1: $OLD_VERSION -> $NEW_VERSION"
        '';
      };

      update-tree-sitter-grammars = let
        data = builtins.fromJSON (builtins.readFile ./grammars/sources.json);
        inherit (data) pins;

        grammar-sources = import ./npins;
        lockfile = pkgs.lib.importJSON "${grammar-sources."nvim-treesitter"}/lockfile.json";

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
            cd "$(git rev-parse --show-toplevel)/pkgs" || exit 1
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
          '';
        };
    };
  };
}
