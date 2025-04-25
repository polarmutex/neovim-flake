{
  inputs,
  self,
  ...
}: {
  perSystem = {
    inputs',
    system,
    lib,
    pkgs,
    ...
  }: let
    makePluginFromPin = name: pin:
      pkgs.vimUtils.buildVimPlugin {
        pname = "${name}";
        name = "${name}";
        version = pin.version or (builtins.substring 0 8 pin.revision);
        src = pin;
        doCheck = false;
        passthru.optional =
          if (pin ? opt)
          then pin.opt
          else false;
      };
    npins = import ../npins;
    npinPlugins = lib.pipe npins [
      # (lib.filterAttrs (name: _: lib.hasPrefix "plugin-" name))
      (lib.mapAttrs' (name: pin:
        lib.nameValuePair (
          if lib.hasSuffix "--opt" name
          then lib.removeSuffix "--opt" name
          else name
        ) (
          if (lib.hasSuffix "--opt" name)
          then pin // {opt = true;}
          else pin
        )))
      (lib.mapAttrs' (name: pin: lib.nameValuePair (name + "-src") pin))
      (lib.mapAttrs makePluginFromPin)
    ];
    npinPlugins' =
      npinPlugins
      // {
        lz-n-src = npinPlugins.lz-n-src.overrideAttrs {passthru = {opt = false;};};
      };

    buildTSGrammar = pkgs.callPackage "${inputs.nixpkgs}/pkgs/development/tools/parsing/tree-sitter/grammar.nix" {};
    treesitterGrammars = lib.pipe (import ../npins-ts-grammars) [
      (lib.mapAttrs (name: pin:
        buildTSGrammar {
          language = lib.removePrefix "tree-sitter-" name;
          version = pin.version or (builtins.substring 0 8 pin.revision);
          src = pin;
          name = "${name}-grammar";
          pname = "${name}-grammar";
          location =
            if name == "tree-sitter-markdown_inline"
            then "tree-sitter-markdown-inline"
            else if name == "tree-sitter-markdown"
            then "tree-sitter-markdown"
            else if name == "tree-sitter-typescript"
            then "typescript"
            else null;
          passthru.parserName = lib.removePrefix "tree-sitter-" name;
        }))
      (lib.mapAttrs (
        name: pin:
          pkgs.stdenv.mkDerivation {
            name = pin.name;
            pname = pin.pname;
            inherit (pin) src;
            dontBuild = true;
            passthru = {opt = false;};
            installPhase = ''
              mkdir -pv $out/parser
              cp ${pin}/parser $out/parser/${(lib.removePrefix "tree-sitter-" pin.parserName)}.so
              mkdir -pv $out/queries
              cp -r ${npins.nvim-treesitter}/queries/${lib.removePrefix "tree-sitter-" pin.parserName} $out/queries
            '';
          }
      ))
    ];
  in {
    packages = let
      byteCompileLuaHook = pkgs.makeSetupHook {name = "byte-compile-lua-hook";} (
        let
          luajit = lib.getExe' pkgs.luajit "luajit";
        in
          pkgs.writeText "byte-compile-lua-hook.sh"
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
        lib.mapAttrs' (name: pin:
          lib.nameValuePair (lib.removeSuffix "-src" name) (byteCompile (pin.overrideAttrs (old: {
            name = lib.removeSuffix "-src" old.name;
            pname = lib.removeSuffix "-src" old.pname;
          }))))
        plugins;
      npinCompressedPlugins = byteCompilePlugins npinPlugins';
    in {
      default = self.packages.${system}.neovim;
      inherit (pkgs) npins;
      inherit (pkgs) neovim-nightly;
      nvim-luarc-json = pkgs.mk-luarc-json {
        nvim = pkgs.neovim-nightly;
        plugins = builtins.attrValues npinPlugins';
      };
      neovim = inputs.mnw.lib.wrap pkgs {
        inherit (inputs.neovim-nightly.packages.${system}) neovim;

        appName = "polar";
        extraLuaPackages = p: [p.jsregexp];

        providers = {
          nodeJs.enable = true;
          perl.enable = true;
        };

        # Source lua config
        initLua = ''
          require('polar')
        '';

        # Add lua config
        devExcludedPlugins = [
          ../polar
        ];
        # Impure path to lua config for devShell
        devPluginPaths = [
          "/home/polar/repos/personal/neovim-flake/main/polar"
        ];

        desktopEntry = false;

        plugins =
          lib.flatten [
            (lib.attrValues npinCompressedPlugins)
            (lib.attrValues treesitterGrammars)
          ]
          ++ [
            pkgs.vimPlugins.blink-cmp
          ];
        extraBinPath = with pkgs; [
          fswatch # for lsp file watching
          xsel # for clipboard

          # arduino
          # arduino-cli

          # cpp
          clang
          clang-tools
          cpplint
          cppcheck

          # java
          jdt-language-server

          # lua
          lua-language-server
          luajitPackages.luacheck
          stylua

          # markdown
          prettierd
          markdownlint-cli

          #nix
          # nil
          nixd
          deadnix
          statix
          alejandra

          # python
          (python313.withPackages (ps:
            with ps; [
              black
              python-lsp-server
              python-lsp-black
              # :.overrideAttrs
              # (oldAttrs: {
              #   patches =
              #     oldAttrs.patches
              #     /*
              #     fix test failure with black>=24.3.0;
              #     remove this patch once python-lsp-black>2.0.0
              #     */
              #     ++ lib.optional
              #     (with lib; (versionOlder version "2.0.1") && (versionAtLeast black.version "24.3.0"))
              #     (fetchpatch {
              #       url = "https://patch-diff.githubusercontent.com/raw/python-lsp/python-lsp-black/pull/59.patch";
              #       hash = "sha256-4u0VIS7eidVEiKRW2wc8lJVkJwhzJD/M+uuqmTtiZ7E=";
              #     });
              # })
              python-lsp-ruff
              pydocstyle
              debugpy
            ]))
          ruff
          basedpyright

          # rust
          rust-analyzer

          # typescript
          vtsls

          # yaml
          nodePackages_latest.yaml-language-server
        ];
      };
    };
  };
}
