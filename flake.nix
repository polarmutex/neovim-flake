{
  description = "Tutorial Flake accompanying vimconf talk.";


  # Input source for our derivation
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    polar-nur = {
      url = "github:polarmutex/nur";
    };
    neovim = { url = "github:neovim/neovim?dir=contrib"; };
    nix2vim = {
      url = "github:gytis-ivaskevicius/nix2vim";
    };

    #
    # Neovim plugins
    #
    beancount-nvim-src = {
      url = "github:polarmutex/beancount.nvim";
      flake = false;
    };
    blamer-nvim-src = {
      url = "github:APZelos/blamer.nvim";
      flake = false;
    };
    cmp-nvim-lsp-src = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };
    cmp-buffer-src = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };
    cmp-nvim-lua-src = {
      url = "github:hrsh7th/cmp-nvim-lua";
      flake = false;
    };
    cmp-path-src = {
      url = "github:hrsh7th/cmp-path";
      flake = false;
    };
    crates-nvim-src = {
      url = "github:saecki/crates.nvim";
      flake = false;
    };
    comment-nvim-src = {
      url = "github:numToStr/Comment.nvim";
      flake = false;
    };
    diffview-nvim-src = {
      url = "github:sindrets/diffview.nvim";
      flake = false;
    };
    fidget-nvim-src = {
      url = "github:j-hui/fidget.nvim";
      flake = false;
    };
    gitsigns-nvim-src = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };
    heirline-nvim-src = {
      url = "github:rebelot/heirline.nvim";
      flake = false;
    };
    kanagawa-nvim-src = {
      url = "github:rebelot/kanagawa.nvim";
      flake = false;
    };
    lspkind-nvim-src = {
      url = "github:onsails/lspkind-nvim";
      flake = false;
    };
    lualine-nvim-src = {
      url = "github:nvim-lualine/lualine.nvim";
      flake = false;
    };
    neogit-src = {
      url = "github:TimUntersberger/neogit";
      flake = false;
    };
    null-ls-nvim-src = {
      url = "github:jose-elias-alvarez/null-ls.nvim";
      flake = false;
    };
    nvim-colorizer-src = {
      url = "github:norcalli/nvim-colorizer.lua";
      flake = false;
    };
    nvim-cmp-src = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };
    nvim-dap-src = {
      url = "github:mfussenegger/nvim-dap";
      flake = false;
    };
    nvim-dap-ui-src = {
      url = "github:rcarriga/nvim-dap-ui";
      flake = false;
    };
    nvim-dap-virtual-text-src = {
      url = "github:theHamsta/nvim-dap-virtual-text";
      flake = false;
    };
    nvim-jdtls-src = {
      url = "github:mfussenegger/nvim-jdtls";
      flake = false;
    };
    nvim-lspconfig-src = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };
    nvim-treesitter-src = {
      url = "github:nvim-treesitter/nvim-treesitter";
      flake = false;
    };
    nvim-treesitter-context-src = {
      url = "github:romgrk/nvim-treesitter-context";
      flake = false;
    };
    nvim-treesitter-playground-src = {
      url = "github:nvim-treesitter/playground";
      flake = false;
    };
    nvim-web-devicons-src = {
      url = "github:kyazdani42/nvim-web-devicons";
      flake = false;
    };
    plenary-nvim-src = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };
    popup-nvim-src = {
      url = "github:nvim-lua/popup.nvim";
      flake = false;
    };
    rnix-lsp = {
      url = "github:Ma27/rnix-lsp";
    };
    rust-tools-nvim-src = {
      url = "github:simrat39/rust-tools.nvim";
      flake = false;
    };
    telescope-nvim-src = {
      url =
        "github:nvim-telescope/telescope.nvim";
      flake = false;
    };
    telescope-dap-nvim-src = {
      url = "github:nvim-telescope/telescope-dap.nvim";
      flake = false;
    };
    telescope-ui-select-src = {
      url = "github:nvim-telescope/telescope-ui-select.nvim";
      flake = false;
    };
    tokyonight-nvim-src = {
      url = "github:folke/tokyonight.nvim";
      flake = false;
    };
    tree-sitter-lua-src = {
      url = "github:tjdevries/tree-sitter-lua";
      flake = false;
    };
    trouble-nvim-src = {
      url = "github:folke/trouble.nvim";
      flake = false;
    };
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , polar-nur
    , neovim
    , flake-utils
    , rnix-lsp
    , nix2vim
    , ...
    }:
    {
      overlays.default = final: prev:
        let
          pkgs = import nixpkgs {
            system = prev.system;
            allowBroken = false;
            allowUnfree = false;
            overlays = [
              neovim.overlay
              polar-nur.overlays.default
              (import ./plugins.nix inputs)
              nix2vim.overlay
            ];
          };


          buildLuaConfigPlugin = { configDir, moduleName, vars ? null, replacements ? null, excludeFiles ? [ ] }:
            let
              pname = "${moduleName}";
              luaSrc = builtins.filterSource
                (path: type:
                  (prev.lib.hasSuffix ".lua" path) &&
                  ! (prev.lib.lists.any (x: baseNameOf path == x) excludeFiles))
                configDir;
            in
            (prev.vimUtils.buildVimPluginFrom2Nix {
              inherit pname;
              version = "dev";
              src = configDir;
              postInstall =
                let
                  subs =
                    pkgs.lib.concatStringsSep " "
                      (pkgs.lib.lists.zipListsWith (f: t: "--subst-var-by ${f} ${t}") vars replacements);
                in
                '''' +
                prev.lib.optionalString
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

        in
        rec  {

          neovim-lua-config-polar = (buildLuaConfigPlugin {
            configDir = ./dotfiles;
            moduleName = "polarmutex";
            excludeFiles = [ ]; #if builtins.isNull config then [ ] else [ "user.lua" ];
            vars = [
              "beancount.beancount-language-server"
              "cpp.clangd"
              "go.gopls"
              "json.jsonls"
              "java.debug.plugin"
              "java.jdt-language-server"
              "lua.sumneko-lua-language-server"
              "lua.stylua"
              "nix.rnix"
              "python.pyright"
              "rust.analyzer"
              "svelte.svelte-language-server"
              "typescript.typescript-language-server"
            ];
            replacements = [
              (pkgs.beancount-language-server)
              (pkgs.clang-tools)
              (pkgs.gopls)
              (pkgs.lib.getExe pkgs.nodePackages.vscode-json-languageserver)
              (pkgs.fetchMavenArtifact
                {
                  groupId = "com.microsoft.java";
                  artifactId = "com.microsoft.java.debug.plugin";
                  version = "0.34.0";
                  sha256 = "sha256-vKvTHA17KPhvxCwI6XdQX3Re2z7vyMhObM9l3QOcrAM=";
                }).jar
              (pkgs.jdt-language-server)
              (pkgs.sumneko-lua-language-server)
              (pkgs.stylua)
              (pkgs.lib.getExe pkgs.rnix-lsp)
              (pkgs.pyright)
              (pkgs.lib.getExe pkgs.rust-analyzer)
              (pkgs.lib.getExe pkgs.nodePackages.svelte-language-server)
              (pkgs.lib.getExe pkgs.nodePackages.typescript-language-server)
            ];
          });

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
              neovimConfig =
                pkgs.neovimUtils.makeNeovimConfig {
                  customRC = ''
                    lua << EOF
                    require('polarmutex.init')
                    EOF
                  '';
                  plugins = with pkgs.neovimPlugins; [
                    { plugin = self.packages."${prev.system}".neovim-lua-config-polar; optional = false; }
                    { plugin = blamer-nvim; optional = false; }
                    { plugin = beancount-nvim; optional = false; }
                    { plugin = cmp-buffer; optional = false; }
                    { plugin = cmp-nvim-lsp; optional = false; }
                    { plugin = cmp-path; optional = false; }
                    { plugin = crates-nvim; optional = false; }
                    { plugin = diffview-nvim; optional = false; }
                    { plugin = fidget-nvim; optional = false; }
                    { plugin = gitsigns-nvim; optional = false; }
                    { plugin = heirline-nvim; optional = false; }
                    { plugin = kanagawa-nvim; optional = false; }
                    { plugin = neogit; optional = false; }
                    { plugin = null-ls-nvim; optional = false; }
                    { plugin = nvim-cmp; optional = false; }
                    { plugin = nvim-dap; optional = false; }
                    { plugin = nvim-dap-ui; optional = false; }
                    { plugin = nvim-dap-virtual-text; optional = false; }
                    { plugin = nvim-jdtls; optional = false; }
                    { plugin = nvim-lspconfig; optional = false; }
                    { plugin = nvim-web-devicons; optional = false; }
                    { plugin = plenary-nvim; optional = false; }
                    { plugin = popup-nvim; optional = false; }
                    { plugin = rust-tools-nvim; optional = false; }
                    { plugin = telescope-nvim; optional = false; }
                    { plugin = telescope-dap-nvim; optional = false; }
                    {
                      plugin = (nvim-treesitter.withPlugins
                        (plugins:
                          with plugins; [
                            tree-sitter-bash
                            tree-sitter-beancount
                            tree-sitter-c
                            tree-sitter-comment
                            tree-sitter-cpp
                            tree-sitter-dockerfile
                            tree-sitter-go
                            tree-sitter-html
                            tree-sitter-java
                            tree-sitter-javascript
                            tree-sitter-json
                            tree-sitter-json5
                            tree-sitter-latex
                            tree-sitter-lua
                            tree-sitter-make
                            tree-sitter-markdown
                            tree-sitter-nix
                            tree-sitter-python
                            tree-sitter-query
                            tree-sitter-rust
                            #tree-sitter-sql #TODO broken
                            tree-sitter-svelte
                            tree-sitter-toml
                            tree-sitter-yaml
                          ]));
                      optional = false;
                    }
                    { plugin = trouble-nvim; optional = false; }
                  ];
                };
            in
            pkgs.wrapNeovimUnstable pkgs.neovim
              (neovimConfig // {
                wrapRc = true;
              });

          # Neovim instance to generate docs
          neovim-docgen =
            let
              tree-sitter-lua-grammar = pkgs.stdenv.mkDerivation rec {

                pname = "tree-sitter-lua-grammar";
                version = "master-2022-07-12";

                src = inputs.tree-sitter-lua-src;

                buildInputs = [ pkgs.tree-sitter ];

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
                fixupPhase = pkgs.lib.optionalString pkgs.stdenv.isLinux ''
                  runHook preFixup
                  $STRIP $out/parser
                  runHook postFixup
                '';
              };

              neovimConfig =
                pkgs.neovimUtils.makeNeovimConfig {
                  customRC = ''
                  '';
                  plugins = with pkgs.neovimPlugins; [
                    { plugin = plenary-nvim; optional = false; }
                    { plugin = tree-sitter-lua; optional = false; }
                    #{ plugin = tree-sitter-lua-grammar; optional = false; }
                    {
                      plugin = (nvim-treesitter.withPlugins
                        (plugins:
                          with plugins; [
                            tree-sitter-lua-grammar
                          ]));
                      optional = false;
                    }
                  ];
                };
            in
            pkgs.wrapNeovimUnstable pkgs.neovim
              (neovimConfig // {
                wrapRc = true;
              });
        };
    } //
    #flake-utils.lib.eachDefaultSystem
    # awesome fails on arch darwin
    flake-utils.lib.eachSystem [
      "x86_64-linux"
      "aarch64-linux"
    ]
      (system:
      let
        pkgs = import nixpkgs
          {
            inherit system;
            overlays = [
              self.overlays.default
            ];
          };
      in
      rec {
        packages = with pkgs; {
          default = pkgs.neovim-polar;
          inherit neovim-lua-config-polar neovim-docgen neovim-polar;
        };

        apps.defaultApp = {
          type = "app";
          program = "${pkgs.neovim-polar}/bin/nvim";
        };

        # check to see if any config errors ars displayed
        # TODO need to have version with all the config
        checks = {
          neovim-check-config = pkgs.runCommand "neovim-check-config"
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
          neovim-check-health = pkgs.runCommand "neovim-check-health"
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

        devShells.default = pkgs.mkShell
          { };

      });
}
