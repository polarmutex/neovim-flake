{
  sources,
  #date,
  #pname,
  #src,
  #version,
  #
  callPackage,
  lib,
  nixpkgs,
  vimUtils,
}: let
  buildGrammar = callPackage "${nixpkgs}/pkgs/development/tools/parsing/tree-sitter/grammar.nix" {};

  # Build grammars that were fetched using nvfetcher
  generatedGrammars = with lib;
    mapAttrsToList (n: v:
      buildGrammar {
        language = removePrefix "tree-sitter-" n;
        inherit (v) version src;
        passthru.parserName = n;
      }) (filterAttrs (n: _: hasPrefix "tree-sitter-" n) sources);
in
  vimUtils.buildVimPlugin {
    inherit (sources.nvim-treesitter) pname src;
    version = sources.nvim-treesitter.date;

    postInstall = lib.concatStringsSep "\n" (map
      (drv: ''
        ls ${drv}
        cp ${drv}/parser $out/parser/${(lib.removePrefix "tree-sitter-" drv.parserName)}.so
      '')
      generatedGrammars);
  }
