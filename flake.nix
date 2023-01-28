{
  description = "Tutorial Flake accompanying vimconf talk.";

  # Input source for our derivation
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";

    #neovim = { url = "github:neovim/neovim?dir=contrib&rev=47e60da7210209330767615c234ce181b6b67a08"; };
    neovim = { url = "github:neovim/neovim?dir=contrib"; };
    nix2vim = {
      url = "github:gytis-ivaskevicius/nix2vim";
    };

    rnix-lsp = {
      url = "github:Ma27/rnix-lsp";
    };
  };

  outputs =
    inputs @ { self
    , nixpkgs
    , neovim
    , flake-utils
    , rnix-lsp
    , nix2vim
    , ...
    }:
    {
      overlays.default = final: prev:
        let
          buildLuaConfigPlugin =
            { configDir
            , moduleName
            , vars ? null
            , replacements ? null
            , excludeFiles ? [ ]
            ,
            }:
            let
              pname = "${moduleName}";
              luaSrc =
                builtins.filterSource
                  (path: type:
                    (prev.lib.hasSuffix ".lua" path)
                    && ! (prev.lib.lists.any (x: baseNameOf path == x) excludeFiles))
                  configDir;
            in
            (prev.vimUtils.buildVimPluginFrom2Nix {
              inherit pname;
              version = "dev";
              src = configDir;
              postUnpack = ''
                mkdir -p $sourceRoot/lua
                mv $sourceRoot/polarmutex $sourceRoot/lua
                mkdir -p $sourceRoot/doc
                ${prev.lemmy-help}/bin/lemmy-help -fact \
                    $sourceRoot/lua/polarmutex/config/lazy.lua \
                    $sourceRoot/lua/polarmutex/config/keymaps.lua \
                    > $sourceRoot/doc/polarmutex.txt
              '';
              postInstall =
                let
                  subs =
                    prev.lib.concatStringsSep " "
                      (prev.lib.lists.zipListsWith (f: t: "--subst-var-by ${f} ${t}") vars replacements);
                in
                ''''
                + prev.lib.optionalString
                  (vars != null)
                  ''
                    for filename in $(find $out -type f -print)
                    do
                      substituteInPlace $filename ${subs}
                    done
                  '';
              meta = with prev.lib; {
                homepage = "";
                description = "polarmutex neovim configuration";
                license = licenses.mit;
                maintainers = [ maintainers.polarmutex ];
              };
            });

          sources = prev.callPackage ./_sources/generated.nix { };

          buildPlugin = source:
            # TODO build neovim plugin
            prev.vimUtils.buildVimPluginFrom2Nix {
              inherit (source) pname version src;
            };

          generatedPluginSources = with prev.lib;
            mapAttrs'
              (n:
                nameValuePair
                  (removePrefix "'plugin-" (removeSuffix "'" n)))
              (filterAttrs (n: _: hasPrefix "'plugin-" n)
                sources);

          generatedPlugins = with prev.lib;
            mapAttrs (_: buildPlugin) generatedPluginSources;

          withSrc = pkg: src: pkg.overrideAttrs (_: { inherit src; });

          # Grammar builder function
          buildGrammar = prev.callPackage "${inputs.nixpkgs}/pkgs/development/tools/parsing/tree-sitter/grammar.nix" { };

          # Build grammars that were fetched using nvfetcher
          generatedGrammars = with prev.lib;
            mapAttrs
              (n: v:
                buildGrammar {
                  language = removePrefix "tree-sitter-" n;
                  inherit (v) version;
                  src = v.src;
                })
              (filterAttrs (n: _: hasPrefix "tree-sitter-" n) sources);

          treesitter-all = (withSrc prev.vimPlugins.nvim-treesitter sources.plugin-nvim-treesitter).withAllGrammars.overrideAttrs (_:
            let
              treesitter-parser-paths = prev.symlinkJoin {
                name = "treesitter-parsers";
                paths = treesitter.dependencies;
              };
            in
            {
              postPatch = ''
                mkdir -p parser
                cp -r ${treesitter-parser-paths.outPath}/parser/*.so parser
              '';
            });

          nvim-treesitter-plugin = prev.vimPlugins.nvim-treesitter.withPlugins (
            p:
              with p; [
                astro
                bash
                #generatedGrammars.tree-sitter-beancount
                beancount
                c
                cmake
                cpp
                diff
                dockerfile
                fish
                gitcommit
                gitignore
                go
                help
                html
                java
                javascript
                json
                lua
                make
                markdown
                markdown_inline
                mermaid
                nix
                proto
                python
                tree-sitter-query
                regex
                rust
                svelte
                teal
                toml
                typescript
                vim
                yaml
              ]
          );

          treesitter =
            nvim-treesitter-plugin.overrideAttrs
              (_:
                let
                  treesitter-parser-paths = prev.symlinkJoin {
                    name = "treesitter-parsers";
                    paths = nvim-treesitter-plugin.dependencies;
                  };
                in
                {
                  postPatch = ''
                    mkdir -p parser
                    cp -r ${treesitter-parser-paths.outPath}/parser/*.so parser
                  '';
                });
        in
        rec {
          neovim-lua-config-polar = buildLuaConfigPlugin {
            configDir = ./lua;
            moduleName = "polarmutex";
            excludeFiles = [ ]; #if builtins.isNull config then [ ] else [ "user.lua" ];
            vars = [
              "beancount.beancount-language-server"
              "cpp.clangd"
              "go.gopls"
              "json.jsonls"
              "java.debug.plugin"
              "java.jdt-language-server"
              "js.prettier_d_slim"
              "lua.sumneko-lua-language-server"
              "lua.stylua"
              "nix.rnix"
              "nix.alejandra"
              "python.pyright"
              "rust.analyzer"
              "rust.clippy"
              "svelte.svelte-language-server"
              "typescript.typescript-language-server"

              "neovimPlugin.beancount-nvim"
              "neovimPlugin.cmp-nvim-lsp"
              "neovimPlugin.cmp-path"
              "neovimPlugin.cmp-omni"
              "neovimPlugin.cmp-calc"
              "neovimPlugin.cmp-buffer"
              "neovimPlugin.cmp-cmdline"
              "neovimPlugin.cmp-dap"
              "neovimPlugin.crates-nvim"
              "neovimPlugin.diffview-nvim"
              "neovimPlugin.gitsigns-nvim"
              "neovimPlugin.gitworktree-nvim"
              "neovimPlugin.harpoon"
              "neovimPlugin.heirline-nvim"
              "neovimPlugin.lazy-nvim"
              "neovimPlugin.lspkind-nvim"
              "neovimPlugin.lspformat-nvim"
              "neovimPlugin.neodev-nvim"
              "neovimPlugin.neogit"
              "neovimPlugin.noice-nvim"
              "neovimPlugin.nui-nvim"
              "neovimPlugin.null-ls-nvim"
              "neovimPlugin.nvim-cmp"
              "neovimPlugin.nvim-colorizer"
              "neovimPlugin.nvim-dap"
              "neovimPlugin.nvim-dap-python"
              "neovimPlugin.nvim-dap-ui"
              "neovimPlugin.nvim-dap-virtual-text"
              "neovimPlugin.nvim-lspconfig"
              "neovimPlugin.nvim-treesitter"
              "neovimPlugin.nvim-treesitter-playground"
              "neovimPlugin.one-small-step-for-vimkind"
              "neovimPlugin.plenary-nvim"
              "neovimPlugin.rust-tools-nvim"
              "neovimPlugin.telescope-nvim"
              "neovimPlugin.tokyonight-nvim"
              "neovimPlugin.vim-be-good"
              "neovimPlugin.nvim-web-devicons"
            ];
            replacements = [
              (final.beancount-language-server)
              (final.clang-tools)
              (final.gopls)
              (prev.lib.getExe final.nodePackages.vscode-json-languageserver)
              (final.fetchMavenArtifact
                {
                  groupId = "com.microsoft.java";
                  artifactId = "com.microsoft.java.debug.plugin";
                  version = "0.34.0";
                  sha256 = "sha256-vKvTHA17KPhvxCwI6XdQX3Re2z7vyMhObM9l3QOcrAM=";
                }).jar
              (final.jdt-language-server)
              (final.nodePackages.prettier_d_slim)
              (final.sumneko-lua-language-server)
              (final.stylua)
              (prev.lib.getExe final.rnix-lsp)
              (final.alejandra)
              (prev.pyright)
              (prev.lib.getExe final.rust-analyzer)
              (final.clippy)
              (prev.lib.getExe final.nodePackages.svelte-language-server)
              (prev.lib.getExe final.nodePackages.typescript-language-server)

              (buildPlugin sources.plugin-beancount-nvim)
              (buildPlugin sources.plugin-cmp-nvim-lsp)
              (buildPlugin sources.plugin-cmp-path)
              (buildPlugin sources.plugin-cmp-omni)
              (buildPlugin sources.plugin-cmp-calc)
              (buildPlugin sources.plugin-cmp-buffer)
              (buildPlugin sources.plugin-cmp-cmdline)
              (buildPlugin sources.plugin-cmp-dap)
              (buildPlugin sources.plugin-crates-nvim)
              (buildPlugin sources.plugin-diffview-nvim)
              (buildPlugin sources.plugin-gitsigns-nvim)
              (buildPlugin sources.plugin-gitworktree-nvim)
              (buildPlugin sources.plugin-harpoon)
              (buildPlugin sources.plugin-heirline-nvim)
              (buildPlugin sources.plugin-lazy-nvim)
              (buildPlugin sources.plugin-lspkind-nvim)
              (buildPlugin sources.plugin-lspformat-nvim)
              (buildPlugin sources.plugin-neodev-nvim)
              (buildPlugin sources.plugin-neogit)
              (buildPlugin sources.plugin-noice-nvim)
              (buildPlugin sources.plugin-nui-nvim)
              (buildPlugin sources.plugin-null-ls-nvim)
              (buildPlugin sources.plugin-nvim-cmp)
              (buildPlugin sources.plugin-nvim-colorizer)
              (buildPlugin sources.plugin-nvim-dap)
              (buildPlugin sources.plugin-nvim-dap-python)
              (buildPlugin sources.plugin-nvim-dap-ui)
              (buildPlugin sources.plugin-nvim-dap-virtual-text)
              (buildPlugin sources.plugin-nvim-lspconfig)
              treesitter
              (buildPlugin sources.plugin-nvim-treesitter-playground)
              (buildPlugin sources.plugin-one-small-step-for-vimkind)
              (buildPlugin sources.plugin-plenary-nvim)
              (buildPlugin sources.plugin-rust-tools-nvim)
              (buildPlugin sources.plugin-telescope-nvim)
              (buildPlugin sources.plugin-tokyonight-nvim)
              (buildPlugin sources.plugin-vim-be-good)
              (buildPlugin sources.plugin-nvim-web-devicons)
            ];
          };

          # neeeds updated
          #neovim-server = pkgs.neovimBuilder {
          #  package = pkgs.neovim-git;
          #  enableViAlias = true;
          #  enableVimAlias = true;
          #  withNodeJs = true;
          #  withPython3 = true;
          #  imports = [
          #    ./modules/aesthetics.nix
          #    ./modules/essentials.nix
          #    ./modules/git.nix
          #    ./modules/lsp.nix
          #    ./modules/treesitter.nix
          #    ./modules/telescope.nix
          #  ];
          #};

          neovim-polar =
            let
              neovimConfig = prev.neovimUtils.makeNeovimConfig {
                customRC = ''
                  lua << EOF
                  -- bootstrap lazy.nvim, LazyVim and your plugins
                  require('polarmutex.config.lazy').setup()
                  EOF
                '';
                plugins =
                  let
                    withSrc = pkg: src: pkg.overrideAttrs (_: { inherit src; });
                    plugin = pname: src:
                      prev.vimUtils.buildVimPluginFrom2Nix {
                        inherit pname src;
                        version = "master";
                      };
                  in
                  [
                    {
                      plugin = neovim-lua-config-polar;
                      optional = false;
                    }
                  ];
              };
            in
            prev.wrapNeovimUnstable neovim.packages.${prev.system}.default
              (neovimConfig
              // {
                wrapRc = true;
              });

          # Neovim instance to generate docs
          neovim-docgen =
            let
              tree-sitter-lua-grammar = prev.stdenv.mkDerivation rec {
                pname = "tree-sitter-lua-grammar";
                version = "master-2022-07-12";

                src = inputs.tree-sitter-lua-src;

                buildInputs = [ final.tree-sitter ];

                dontUnpack = true;
                dontConfigure = true;

                CFLAGS = [ "-I${src}/src" "-O2" ];
                CXXFLAGS = [ "-I${src}/src" "-O2" ];

                # When both scanner.{c,cc} exist, we should not link both since they may be the same but in
                # different languages. Just randomly prefer C++ if that happens.
                buildPhase = ''
                  runHook preBuild
                  if [[ -e "$src/src/scanner.cc" ]]; then
                    $CXX -c "$src/src/scanner.cc" -o scanner.o $CXXFLAGS
                  elif [[ -e "$src/src/scanner.c" ]]; then
                    $CC -c "$src/src/scanner.c" -o scanner.o $CFLAGS
                  fi
                  $CC -c "$src/src/parser.c" -o parser.o $CFLAGS
                  $CXX -shared -o parser *.o
                  runHook postBuild
                '';

                installPhase = ''
                  runHook preInstall
                  mkdir $out
                  mv parser $out/
                  runHook postInstall
                '';

                # Strip failed on darwin: strip: error: symbols referenced by indirect symbol table entries that can't be stripped
                fixupPhase = prev.lib.optionalString prev.stdenv.isLinux ''
                  runHook preFixup
                  $STRIP $out/parser
                  runHook postFixup
                '';
              };

              neovimConfig = prev.neovimUtils.makeNeovimConfig {
                customRC = ''
            '';
                plugins =
                  let
                    withSrc = pkg: src: pkg.overrideAttrs (_: { inherit src; });
                    plugin = pname: src:
                      prev.vimUtils.buildVimPluginFrom2Nix {
                        inherit pname src;
                        version = "master";
                      };
                  in
                  [
                    #{
                    #  plugin = withSrc prev.vimPlugins.plenary-nvim inputs.plenary-nvim-src;
                    #  optional = false;
                    #}
                    #{
                    #  plugin = plugin "tree-sitter-lua" inputs.tree-sitter-lua-src;
                    #  optional = false;
                    #}
                    #{ plugin = tree-sitter-lua-grammar; optional = false; }
                    #{
                    #  plugin =
                    #    (withSrc prev.vimPlugins.nvim-treesitter inputs.nvim-treesitter-src).withPlugins
                    #      (plugins:
                    #        with plugins; [
                    #          tree-sitter-lua-grammar
                    #        ]);
                    #  optional = false;
                    #}
                  ];
              };
            in
            prev.wrapNeovimUnstable final.neovim
              (neovimConfig
              // {
                wrapRc = true;
              });
        };
    }
    //
    #flake-utils.lib.eachDefaultSystem
    # awesome fails on arch darwin
    flake-utils.lib.eachSystem
      [
        "x86_64-linux"
        "aarch64-linux"
      ]
      (system:
      let
        pkgs =
          import nixpkgs
            {
              inherit system;
              overlays = [
                self.overlays.default
              ];
              config = {
                permittedInsecurePackages = [
                  # jdt-language-server
                  "openjdk-headless-16+36"
                  "openjdk-headless-15.0.1-ga"
                  "openjdk-headless-14.0.2-ga"
                  "openjdk-headless-13.0.2-ga"
                  "openjdk-headless-12.0.2-ga"
                ];
                # jdt-language-server
                allowUnsupportedSystem = true;
              };
            };
        neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
          #extraPython3Packages = [ ];
          withPython3 = true;
          withRuby = true;
          viAlias = true;
          vimAlias = true;
          withNodeJs = true;
          plugins = [ ];
          customRC = '''';
        };
      in
      rec {
        packages = with pkgs; {
          default = pkgs.neovim-polar;
          inherit neovim-lua-config-polar neovim-docgen neovim-polar;
          neovim-test =
            pkgs.wrapNeovimUnstable neovim.packages.${system}.default
              (neovimConfig
              // {
                wrapRc = false;
              });
        };

        apps.defaultApp = {
          type = "app";
          program = "${pkgs.neovim-polar}/bin/nvim";
        };

        # check to see if any config errors ars displayed
        # TODO need to have version with all the config
        checks = {
          neovim-check-config =
            pkgs.runCommand "neovim-check-config"
              {
                buildInputs = [
                  pkgs.git
                ];
              } ''
              # We *must* create some output, usually contains test logs for checks
              mkdir -p "$out"

              # Probably want to do something to ensure your config file is read, too
              # need git in path
              export HOME=$TMPDIR
              ${pkgs.neovim-polar}/bin/nvim --headless -c "q" 2> "$out/nvim-config.log"

              if [ -n "$(cat "$out/nvim-config.log")" ]; then
                  while IFS= read -r line; do
                      echo "$line"
                  done < "$out/nvim-config.log"
                  exit 1
              fi
            '';
          neovim-check-health =
            pkgs.runCommand "neovim-check-health"
              {
                buildInputs = [
                  pkgs.git
                ];
              } ''
              # We *must* create some output, usually contains test logs for checks
              mkdir -p "$out"

              # Probably want to do something to ensure your config file is read, too
              # need git in path
              export HOME=$TMPDIR
              ${pkgs.neovim-polar}/bin/nvim --headless -c "lua require('polarmutex.health').nix_check()" -c "q" 2> "$out/nvim-health.log"

              if [ -n "$(cat "$out/nvim-health.log")" ]; then
                  while IFS= read -r line; do
                      echo "$line"
                  done < "$out/nvim-health.log"
                  exit 1
              fi
            '';
        };

        devShells.default =
          pkgs.mkShell
            {
              buildInputs = [
                pkgs.lemmy-help
                pkgs.pandoc
                pkgs.nvfetcher
              ];
            };
      });
}
