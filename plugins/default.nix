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
    makePluginFromPin = name: pin:
      pkgs.vimUtils.buildVimPlugin {
        pname = "src-${name}";
        version = pin.version or pin.revision;
        src = pin;
      };
    plugins = lib.pipe npins [
      (lib.filterAttrs (name: _: lib.hasPrefix "nvim-" name))
      (lib.mapAttrs' (name: pin: lib.nameValuePair (lib.removePrefix "nvim-" name) pin))
      (lib.mapAttrs makePluginFromPin)
    ];

    byteCompileLuaHook = pkgs.makeSetupHook {name = "byte-compile-lua-hook";} (
      let
        luajit = lib.getExe' pkgs.luajit "luajit";
      in
        pkgs.writeText "byte-compile-lua-hook.sh" # bash
        
        ''
          byteCompileLuaPostFixup() {
              while IFS= read -r -d "" file; do
                  tmp=$(mktemp -u "$file.XXXX")
                  if ${luajit} -bd -- "$file" "$tmp"; then
                      mv "$tmp" "$file"
                  fi
              done < <(find "$out" -type f,l -name "*.lua" -print0)
          }
          postFixupHooks+=(byteCompileLuaPostFixup)
        ''
    );
    # Byte compiling of normalized plugin list
    byteCompilePlugins = plugins: let
      byteCompile = p:
        p.overrideAttrs (
          prev:
            {
              pname = lib.removePrefix "src-" prev.pname;
              nativeBuildInputs = prev.nativeBuildInputs or [] ++ [byteCompileLuaHook];
            }
            // lib.optionalAttrs (prev ? buildCommand) {
              buildCommand = ''
                ${prev.buildCommand}
                runHook postFixup
              '';
            }
            // lib.optionalAttrs (prev ? dependencies) {dependencies = map byteCompile prev.dependencies;}
        );
    in
      lib.mapAttrs (_: byteCompile) plugins;
  in {
    legacyPackages = {
      neovimPluginsCompressed = byteCompilePlugins self'.legacyPackages.neovimPlugins;
      neovimPlugins =
        {
          polar = pkgs.callPackage ./polar {inherit self;};
        }
        // plugins
        // {
          telescope-fzf-native = plugins.telescope-fzf-native.overrideAttrs {buildPhase = "make";};
          treesitter = plugins.treesitter.overrideAttrs {
            postInstall = let
              buildGrammar = pkgs.callPackage "${inputs.nixpkgs}/pkgs/development/tools/parsing/tree-sitter/grammar.nix" {};
              grammar-sources = import ./grammars;
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

                    passthru.parserName = removePrefix "tree-sitter-" n;
                  })
                grammar-sources;
            in
              lib.concatStringsSep "\n" (map
                (drv: ''
                  ls ${drv}
                  cp ${drv}/parser $out/parser/${(lib.removePrefix "tree-sitter-" drv.parserName)}.so
                '')
                generatedGrammars);
          };
        };
    };
  };
}
