{
  self,
  inputs,
  ...
}: {
  perSystem = {
    pkgs,
    npins,
    lib,
    self',
    ...
  }: let
  in {
    legacyPackages = {
      # neovimPluginsCompressed = byteCompilePlugins self'.legacyPackages.neovimPlugins;
      #   neovimPlugins =
      #     {
      #       polar = pkgs.callPackage ./polar {inherit self;};
      #     }
      #     // plugins
      #     // {
      #       telescope-fzf-native = plugins.telescope-fzf-native.overrideAttrs {buildPhase = "make";};
      #       treesitter = plugins.treesitter.overrideAttrs {
      #         postInstall = let
      #           buildGrammar = pkgs.callPackage "${inputs.nixpkgs}/pkgs/development/tools/parsing/tree-sitter/grammar.nix" {};
      #           grammar-sources = import ./grammars;
      #           generatedGrammars = with lib;
      #             mapAttrsToList
      #             (n: v:
      #               buildGrammar {
      #                 language = removePrefix "tree-sitter-" n;
      #                 # version = grammar-sources."${n}".revision;
      #                 version = v.revision;
      #                 # src = grammar-sources."${n}";
      #                 src = v;
      #                 name = "${n}-grammar";
      #                 location =
      #                   if n == "tree-sitter-markdown_inline"
      #                   then "tree-sitter-markdown-inline"
      #                   else if n == "tree-sitter-markdown"
      #                   then "tree-sitter-markdown"
      #                   else if n == "tree-sitter-typescript"
      #                   then "typescript"
      #                   else null;
      #
      #                 passthru.parserName = removePrefix "tree-sitter-" n;
      #               })
      #             grammar-sources;
      #         in
      #           lib.concatStringsSep "\n" (map
      #             (drv: ''
      #               ls ${drv}
      #               cp ${drv}/parser $out/parser/${(lib.removePrefix "tree-sitter-" drv.parserName)}.so
      #             '')
      #             generatedGrammars);
      #       };
      #     };
    };
  };
}
