{
  description = "Tutorial Flake accompanying vimconf talk.";

  # Input source for our derivation
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    flake-parts.url = "github:hercules-ci/flake-parts";

    #neovim = { url = "github:neovim/neovim?dir=contrib&rev=47e60da7210209330767615c234ce181b6b67a08"; };
    neovim = { url = "github:neovim/neovim?dir=contrib"; };
  };

  outputs =
    { self
    , nixpkgs
    , neovim
    , flake-parts
    , ...
    } @ inputs:
    flake-parts.lib.mkFlake { inherit inputs; }
      {
        systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];

        imports = [
          ./checks
        ];

        flake = {
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

              #sources = prev.callPackage ./_sources/generated.nix { };

              #buildPlugin = source:
              #  # TODO build neovim plugin
              #  prev.vimUtils.buildVimPluginFrom2Nix {
              #    inherit (source) pname version src;
              #  };
              buildPlugin = pname: src:
                # TODO build neovim plugin
                prev.vimUtils.buildVimPluginFrom2Nix {
                  inherit pname src;
                  version = src.revision;
                };

              #generatedPluginSources = with prev.lib;
              #  mapAttrs'
              #    (n:
              #      nameValuePair
              #        (removePrefix "'plugin-" (removeSuffix "'" n)))
              #    (filterAttrs (n: _: hasPrefix "'plugin-" n)
              #      sources);

              #generatedPlugins = with prev.lib;
              #  mapAttrs (_: buildPlugin) generatedPluginSources;

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

              treesitter-all = (withSrc prev.vimPlugins.nvim-treesitter final.neovimPlugins.nvim-treesitter).withAllGrammars.overrideAttrs (_:
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

                  (buildPlugin "beancount-nvim" final.neovimPlugins.beancount-nvim)
                  (buildPlugin "cmp-nvim-lsp" final.neovimPlugins.cmp-nvim-lsp)
                  (buildPlugin "cmp-path" final.neovimPlugins.cmp-path)
                  (buildPlugin "cmp-omni" final.neovimPlugins.cmp-omni)
                  (buildPlugin "cmp-calc" final.neovimPlugins.cmp-calc)
                  (buildPlugin "cmp-buffer" final.neovimPlugins.cmp-buffer)
                  (buildPlugin "cmp-cmdine" final.neovimPlugins.cmp-cmdline)
                  (buildPlugin "cmp-dap" final.neovimPlugins.cmp-dap)
                  (buildPlugin "crates-nvim" final.neovimPlugins.crates-nvim)
                  (buildPlugin "diffview-nvim" final.neovimPlugins.diffview-nvim)
                  (buildPlugin "gitsigns-nvim" final.neovimPlugins.gitsigns-nvim)
                  (buildPlugin "git-worktree-nvim" final.neovimPlugins.git-worktree-nvim)
                  (buildPlugin "harpoon" final.neovimPlugins.harpoon)
                  (buildPlugin "heirline-nvim" final.neovimPlugins.heirline-nvim)
                  (buildPlugin "lazy-nvim" final.neovimPlugins.lazy-nvim)
                  (buildPlugin "lspkind-nvim" final.neovimPlugins.lspkind-nvim)
                  (buildPlugin "lsp-format-nvim" final.neovimPlugins.lsp-format-nvim)
                  (buildPlugin "neodev-nvim" final.neovimPlugins.neodev-nvim)
                  (buildPlugin "neogit" final.neovimPlugins.neogit)
                  (buildPlugin "noice-nvim" final.neovimPlugins.noice-nvim)
                  (buildPlugin "nui-nvim" final.neovimPlugins.nui-nvim)
                  (buildPlugin "null-ls" final.neovimPlugins.null-ls-nvim)
                  (buildPlugin "nvim-cmp" final.neovimPlugins.nvim-cmp)
                  (buildPlugin "nvim-colorizer" final.neovimPlugins.nvim-colorizer)
                  (buildPlugin "nvim-dap" final.neovimPlugins.nvim-dap)
                  (buildPlugin "nvim-dap-python" final.neovimPlugins.nvim-dap-python)
                  (buildPlugin "nvim-dap-ui" final.neovimPlugins.nvim-dap-ui)
                  (buildPlugin "nvim-dap-virtual-text" final.neovimPlugins.nvim-dap-virtual-text)
                  (buildPlugin "nvim-lspconfig" final.neovimPlugins.nvim-lspconfig)
                  treesitter
                  (buildPlugin "nvim-treesitter-playground" final.neovimPlugins.nvim-treesitter-playground)
                  (buildPlugin "one-small-step-for-vimkind" final.neovimPlugins.one-small-step-for-vimkind)
                  (buildPlugin "plenary-nvim" final.neovimPlugins.plenary-nvim)
                  (buildPlugin "rust-tools-nvim" final.neovimPlugins.rust-tools-nvim)
                  (buildPlugin "telescope-nvim" final.neovimPlugins.telescope-nvim)
                  (buildPlugin "tokyonight-nvim" final.neovimPlugins.tokyonight-nvim)
                  (buildPlugin "vim-be-good" final.neovimPlugins.vim-be-good)
                  (buildPlugin "nvim-web-devicons" final.neovimPlugins.nvim-web-devicons)
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
        };
        perSystem =
          { config
          , pkgs
          , inputs'
          , self'
          , system
          , ...
          }:
          let
            overlays = with inputs; [
              neovim.overlay
              self.overlays.default
              # Keeping this out of the exposed overlay, I don't want to
              # expose nvfetcher-generated stuff, that's annoying.
              (_final: _prev: {
                neovimPlugins = import ./plugins;
              })
            ];
          in
          {
            _module.args = {
              pkgs = import nixpkgs {
                inherit system overlays;
              };
            };

            packages = with pkgs; {
              default = pkgs.neovim-polar;
              inherit neovim-lua-config-polar neovim-polar;
            };

            apps.defaultApp = {
              type = "app";
              program = "${pkgs.neovim-polar}/bin/nvim";
            };

            devShells = {
              default = pkgs.mkShell {
                packages = builtins.attrValues {
                  inherit (pkgs) lemmy-help npins;
                };
              };
            };
          };
      };
}
#//
#flake-utils.lib.eachDefaultSystem
# awesome fails on arch darwin
#(system: let
#  pkgs =
#    import nixpkgs
#    {
#      inherit system;
#      overlays = [
#        self.overlays.default
#      ];
#      config = {
#        permittedInsecurePackages = [
#          # jdt-language-server
#          "openjdk-headless-16+36"
#          "openjdk-headless-15.0.1-ga"
#          "openjdk-headless-14.0.2-ga"
#          "openjdk-headless-13.0.2-ga"
#          "openjdk-headless-12.0.2-ga"
#        ];
#        # jdt-language-server
#        allowUnsupportedSystem = true;
#      };
#    };
