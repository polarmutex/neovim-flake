{inputs, ...}: {
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
        passthru.opt =
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
        blink-cmp-src = let
          inherit (pkgs.stdenv) hostPlatform;
          libExt =
            if hostPlatform.isDarwin
            then "dylib"
            else if hostPlatform.isWindows
            then "dll"
            else "so";
          lib_name =
            if hostPlatform.isDarwin
            then "aarch64-apple-darwin.${libExt}"
            else "x86_64-unknown-linux-gnu.${libExt}";
          blink-cmp = npinPlugins.blink-cmp-src;
          blink-fuzzy-lib = builtins.fetchurl {
            url = "https://github.com/Saghen/blink.cmp/releases/download/${blink-cmp.version}/${lib_name}";
            sha256 = "sha256:1bbhr9173z6f1dlwbfa13nxqlamxpy44hrwnpwfasgh7vq5963p6";
          };
        in
          npinPlugins.blink-cmp-src.overrideAttrs {
            preInstall = ''
              mkdir -p target/release
              ln -s ${blink-fuzzy-lib} target/release/libblink_cmp_fuzzy.${libExt}
            '';
          };
        telescope-fzf-native-nvim-src = npinPlugins.telescope-fzf-native-nvim-src.overrideAttrs {buildPhase = "make";};
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

    extraPackages = with pkgs; [
      fswatch # for lsp file watching
      xclip # for clipboard

      # cpp
      clang
      clang-tools

      # lua
      lua-language-server
      luajitPackages.luacheck
      stylua

      # markdown
      prettierd
      markdownlint-cli
      # (pkgs.mdformat.withPlugins (p: [
      #   p.mdformat-frontmatter
      #   p.mdformat-gfm
      #   p.mdformat-toc
      # ]))

      #nix
      # nil
      nixd
      deadnix
      statix
      alejandra

      # python
      (python311.withPackages (ps:
        with ps; [
          black
          python-lsp-server
          python-lsp-black.overrideAttrs
          (oldAttrs: {
            patches =
              oldAttrs.patches
              /*
              fix test failure with black>=24.3.0;
              remove this patch once python-lsp-black>2.0.0
              */
              ++ lib.optional
              (with lib; (versionOlder version "2.0.1") && (versionAtLeast black.version "24.3.0"))
              (fetchpatch {
                url = "https://patch-diff.githubusercontent.com/raw/python-lsp/python-lsp-black/pull/59.patch";
                hash = "sha256-4u0VIS7eidVEiKRW2wc8lJVkJwhzJD/M+uuqmTtiZ7E=";
              });
          })
          python-lsp-ruff
          pydocstyle
          debugpy
        ]))
      ruff
      basedpyright

      # rust
      rust-analyzer

      # yaml((
      nodePackages_latest.yaml-language-server

      # java
      jdt-language-server

      # arduino
      arduino-cli
    ];
  in {
    packages = let
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
        lib.mapAttrs' (name: pin:
          lib.nameValuePair (lib.removeSuffix "-src" name) (byteCompile (pin.overrideAttrs (old: {
            name = lib.removeSuffix "-src" old.name;
            pname = lib.removeSuffix "-src" old.pname;
          }))))
        plugins;
      npinCompressedPlugins = byteCompilePlugins npinPlugins';
    in
      lib.fix (_: let
        # packages in $FLAKE/pkgs, callPackage'd automatically
        stage1 = lib.fix (
          self': let
            callPackage = lib.callPackageWith (pkgs // self');
            auto = lib.pipe (builtins.readDir ./.) [
              (lib.filterAttrs (_: value: value == "directory"))
              (builtins.mapAttrs (name: _: callPackage ./${name} {}))
            ];
          in
            auto
            // {
              inherit (pkgs) neovim-nightly;
              inherit (pkgs) npins;
              nvim-luarc-json = pkgs.mk-luarc-json {
                nvim = pkgs.neovim-nightly;
                plugins = builtins.attrValues npinPlugins';
              };
            }
        );

        # wrapper-manager packages
        stage2 =
          stage1
          // {
            blink-cmp = npinCompressedPlugins.blink-cmp;
            pack-dir = let
              packName = "polar";
              allPlugins = lib.flatten [
                (lib.attrValues npinCompressedPlugins)
                (lib.attrValues treesitterGrammars)
              ];
            in
              pkgs.runCommandLocal "pack-dir" {}
              # bash
              ''
                mkdir -pv $out/pack/${packName}/{start,opt}

                ${lib.concatMapStringsSep "\n" (p: ''
                    ln -vsfT ${p} $out/pack/${packName}/${
                      if p ? passthru.opt && p.passthru.opt
                      then "opt"
                      else "start"
                    }/${p.pname}
                  '')
                  allPlugins}
              '';
          }
          // (inputs.wrapper-manager.lib {
            pkgs = pkgs // stage1;
            modules = lib.pipe (builtins.readDir ../wrapper-manager) [
              (lib.filterAttrs (_: value: value == "directory"))
              builtins.attrNames
              (map (n: ../wrapper-manager/${n}))
            ];
            specialArgs = {
              inherit inputs' npinCompressedPlugins treesitterGrammars;
            };
          })
          .config
          .build
          .packages;
      in
        stage2);
  };
}
