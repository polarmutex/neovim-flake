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
        language = removePrefix "tree-sitter-" n;
        # version = grammar-sources."${n}".revision;
        version = v.revision;
        # src = grammar-sources."${n}";
        src = v;
        name = "${n}-grammar";
        location =
          if n == "tree-sitter-markdown_inline"
          then "tree-sitter-markdown-inline"
          else if n == "tree-sitter-markdown"
          then "tree-sitter-markdown"
          else if n == "tree-sitter-typescript"
          then "typescript"
          else null;

        #passthru.parserName = "${lib.strings.replaceStrings ["-"] ["_"] (lib.strings.removePrefix "tree-sitter-" n)}";
        # passthru.parserName = n;
        passthru.parserName = removePrefix "tree-sitter-" n;
      })
    grammar-sources;
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
