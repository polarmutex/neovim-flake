{
  sources,
  grammars,
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

  grammar-sources = import ./grammars;

  # Build grammars that were fetched using nvfetcher
  # generatedGrammars = with lib;
  #   mapAttrsToList (n: v:
  #     buildGrammar {
  #       language = removePrefix "tree-sitter-" n;
  #       inherit (v) version src;
  #       passthru.parserName = n;
  #     }) (filterAttrs (n: _: hasPrefix "tree-sitter-" n) sources);

  generatedGrammars = with lib;
    mapAttrsToList
    (n: v:
      buildGrammar {
        #language = removePrefix "tree-sitter-" n;
        language = n;
        version = grammar-sources."tree-sitter-${n}".revision;
        src = grammar-sources."tree-sitter-${n}";
        name = "tree-sitter-${n}-grammar";
        location =
          if v ? "location"
          then v.location
          else null;

        #passthru.parserName = "${lib.strings.replaceStrings ["-"] ["_"] (lib.strings.removePrefix "tree-sitter-" n)}";
        passthru.parserName = n;
      })
    grammars;
in
  vimUtils.buildVimPlugin {
    inherit (sources.nvim-treesitter) pname src;
    version = sources.nvim-treesitter.date;

    patches = [
      ./disable_ensure_installed.patch
    ];

    postInstall = lib.concatStringsSep "\n" (map
      (drv: ''
        ls ${drv}
        cp ${drv}/parser $out/parser/${(lib.removePrefix "tree-sitter-" drv.parserName)}.so
      '')
      generatedGrammars);
  }
