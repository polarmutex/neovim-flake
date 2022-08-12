{
  description = "Tutorial Flake accompanying vimconf talk.";


  # Input source for our derivation
  inputs = {
    nixpkgs.url = "github:teto/nixpkgs/vim-merge-cmds";
    flake-utils.url = "github:numtide/flake-utils";

    polar-nur = {
      url = "github:polarmutex/nur";
    };
    neovim = { url = "github:neovim/neovim?dir=contrib"; };
    nix2vim = {
      url = "github:gytis-ivaskevicius/nix2vim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
    let
      overlay = final: prev: rec {
        lua-config-builder = prev.callPackage ./lib/lua-config-builder.nix {
          pkgs = final;
          lib = prev.lib;
        };
      };
    in
    {
      #inherit overlay;
      #home-managerModule =
      #  { config
      #  , lib
      #  , pkgs
      #  , ...
      #  }:
      #  import ./home-manager.nix {
      #    inherit config lib pkgs dsl inputs;
      #  };
    } //
    #flake-utils.lib.eachDefaultSystem
    # awesome fails on arch darwin
    flake-utils.lib.eachSystem [
      "x86_64-linux"
      "aarch64-linux"
    ]
      (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            neovim.overlay
            polar-nur.overlays.default
            (import ./plugins.nix inputs)
            nix2vim.overlay
            overlay
          ];
        };
        # nix2vim
        #neovim-polar = pkgs.neovimBuilder {
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
        buildLuaConfig = { configDir, moduleName, vars ? null, replacements ? null, excludeFiles ? [ ] }:
          let
            pname = "lua-config-${moduleName}";
            luaSrc = builtins.filterSource
              (path: type:
                (pkgs.lib.hasSuffix ".lua" path) &&
                ! (pkgs.lib.lists.any (x: baseNameOf path == x) excludeFiles))
              configDir;
          in
          (pkgs.stdenv.mkDerivation {
            inherit pname;
            version = "dev";
            #srcs = [ luaSrc ];
            src = configDir;
            #unpackPhase = ''
            #  for _src in $srcs; do
            #    cp -v $_src/* .
            #  done
            #'';
            installPhase =
              let
                subs =
                  pkgs.lib.concatStringsSep " "
                    (pkgs.lib.lists.zipListsWith (f: t: "--subst-var-by ${f} ${t}") vars replacements);

                # lua-builder-from-nix2vim
                # TODO replace with above
                #lsp_config = pkgs.lua-config-builder {
                #  imports = [ ./dotfiles/lua/polarmutex/lsp/lspconfig.nix ];
                #};
                #lsp_config_file = pkgs.writeText "lspconfig.lua" lsp_config.lua;
                nullls_config = pkgs.lua-config-builder {
                  imports = [ ./dotfiles/plugin/null-ls.nix ];
                };
                nullls_config_file = pkgs.writeText "null-ls.lua" nullls_config.lua;
              in
              #''
                #  target=$out/lua/${moduleName}
                #  mkdir -p $target
                #  cp -r *.lua $target
                #''
                #+
              ''
                cp -r . $out
                rm -rf $out/plugin/null-ls.nix
                cp ${nullls_config_file} $out/plugin/null-ls.lua
              ''
              +
              pkgs.lib.optionalString (vars != null)
                ''
                  #for filename in $out/*
                  #do
                  #  substituteInPlace $filename ${subs}
                  #done
                  for filename in $(find $out -type f -print)
                  do
                    substituteInPlace $filename ${subs}
                  done
                  #find $out -type f -exec substituteInPlace {} ${subs} \;
                '';
            meta = with pkgs.lib; {
              homepage = "";
              description = "polarmutex neovim configuration";
              license = licenses.mit;
              maintainers = [ maintainers.polarmutex ];
            };
          });
        lua-config-polar = (buildLuaConfig {
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
            "nix.rnix"
            "python.pyright"
            "rust.rustup"
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
            (pkgs.lib.getExe pkgs.rnix-lsp)
            (pkgs.pyright)
            (pkgs.rustup)
            (pkgs.lib.getExe pkgs.nodePackages.svelte-language-server)
            (pkgs.lib.getExe pkgs.nodePackages.typescript-language-server)
          ];
        });
      in
      {
        packages = {
          default = self.packages."${system}".neovim-polar-current;

          #
          # Neovim Config
          #
          neovim-config-polar = lua-config-polar;

          #
          # Using legacy wrapper in nixpkgs
          # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/neovim/wrapper.nix
          #
          neovim-polar-legacy =
            pkgs.wrapNeovim pkgs.neovim {

              # will wrapRc if configure != {}

              #extraMakeWrapperArgs = "--cmd 'set runtimepath^=${self.packages."${system}".neovim-polar-config}' --cmd 'set packpath^=${self.packages."${system}".neovim-polar-config}/' -u ${self.packages."${system}".neovim-polar-config}/init.lua";
              configure = {
                customRC = ''
                  lua << EOF
                  vim.opt.runtimepath:prepend('${self.packages."${system}".neovim-config-polar}')
                  EOF
                  luafile ${self.packages."${system}".neovim-config-polar}/init.lua
                '';
                packages.myNeovimPackage = with pkgs.neovimPlugins; {
                  start = [
                    blamer-nvim
                    cmp-buffer
                    cmp-nvim-lsp
                    cmp-path
                    diffview-nvim
                    fidget-nvim
                    gitsigns-nvim
                    heirline-nvim
                    kanagawa-nvim
                    neogit
                    null-ls-nvim
                    nvim-cmp
                    nvim-dap
                    nvim-dap-ui
                    nvim-dap-virtual-text
                    nvim-jdtls
                    nvim-lspconfig
                    nvim-web-devicons
                    plenary-nvim
                    popup-nvim
                    telescope-nvim
                    telescope-dap-nvim
                    (nvim-treesitter.withPlugins
                      (plugins:
                        with plugins; [
                          tree-sitter-beancount
                          tree-sitter-c
                          tree-sitter-cpp
                          tree-sitter-go
                          tree-sitter-java
                          tree-sitter-json
                          tree-sitter-lua
                          tree-sitter-nix
                          tree-sitter-python
                          tree-sitter-rust
                        ]))
                    trouble-nvim
                  ];
                  opt = [ ];
                };
              };
            };

          #
          # Using current wrapper in nixpkgs
          # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/neovim/wrapper.nix
          #
          neovim-polar-current =
            let
              neovimConfig =
                pkgs.neovimUtils.makeNeovimConfig {
                  customRC = ''
                    lua << EOF
                    vim.opt.runtimepath:prepend('${self.packages."${system}".neovim-config-polar}')
                    EOF
                    luafile ${self.packages."${system}".neovim-config-polar}/init.lua
                  '';
                  plugins = with pkgs.neovimPlugins; [
                    { plugin = blamer-nvim; optional = false; }
                    { plugin = cmp-buffer; optional = false; }
                    { plugin = cmp-nvim-lsp; optional = false; }
                    { plugin = cmp-path; optional = false; }
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
                    { plugin = telescope-nvim; optional = false; }
                    { plugin = telescope-dap-nvim; optional = false; }
                    {
                      plugin = (nvim-treesitter.withPlugins
                        (plugins:
                          with plugins; [
                            tree-sitter-beancount
                            tree-sitter-c
                            tree-sitter-cpp
                            tree-sitter-go
                            tree-sitter-java
                            tree-sitter-json
                            tree-sitter-lua
                            tree-sitter-nix
                            tree-sitter-python
                            tree-sitter-rust
                          ]));
                      optional = false;
                    }
                    { plugin = trouble-nvim; optional = false; }
                  ];
                };
            in
            pkgs.wrapNeovimUnstable pkgs.neovim
              (neovimConfig // {
                #extraName = "-polar";
                #wrapperArgs = [
                #"--add-flags"
                #"--cmd 'set runtimepath^=${lua-config-polar}'"
                #  "--add-flags"
                #  "--cmd 'set packpath^=${self.packages."${system}".neovim-config-polar}/'"
                #"--add-flags"
                #"-u ${self.packages."${system}".neovim-config-polar}/init.lua"
                #];
                wrapRc = true;
                #configure = {
                #  customRC = ''
                #    lua << EOF
                #    vim.opt.runtimepath:prepend('${self.packages."${system}".neovim-polar-config}')
                #    EOF
                #    luafile ${self.packages."${system}".neovim-polar-config}/init.lua
                #  '';
                #  packages.myNeovimPackage = with pkgs.neovimPlugins; {
                #    start = [
                #      telescope-nvim
                #    ];
                #    opt = [ ];
                #  };
                #};
              });

          #
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

        apps.defaultApp = {
          type = "app";
          program = "${self.packages."${system}".neovim-polar-current}/bin/nvim";
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
            ${self.packages."${system}".default}/bin/nvim --headless -c "q" 2> "$out/nvim.log"

            if [ -n "$(cat "$out/nvim.log")" ]; then
              echo "output: "$(cat "$out/nvim.log")""
              exit 1
            fi
          '';
        };

        devShells.default = pkgs.mkShell
          { };

      });
}
