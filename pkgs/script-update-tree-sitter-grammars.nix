{pkgs, ...}: let
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
  }
