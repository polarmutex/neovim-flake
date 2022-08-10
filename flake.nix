{
  description = "Tutorial Flake accompanying vimconf talk.";


  # Input source for our derivation
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
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
    trouble-nvim-src = {
      url = "github:folke/trouble.nvim";
      flake = false;
    };
    which-key-nvim-src = {
      url = "github:folke/which-key.nvim";
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
        neovim-polar = pkgs.neovimBuilder {
          package = pkgs.neovim-git;
          enableViAlias = true;
          enableVimAlias = true;
          withNodeJs = true;
          withPython3 = true;
          imports = [
            ./modules/aesthetics.nix
            ./modules/essentials.nix
            ./modules/git.nix
            ./modules/lsp.nix
            ./modules/treesitter.nix
            ./modules/telescope.nix
            ./modules/which-key.nix
          ];
        };
      in
      {
        packages = {
          default = self.packages."${system}".neovim-polar-legacy;

          #
          # Neovim Config DEr
          #
          neovim-polar-config =
            let
              lsp_config = pkgs.lua-config-builder {
                imports = [ ./dotfiles/lua/polarmutex/lsp/lspconfig.nix ];
              };
              lsp_config_file = pkgs.writeText "lspconfig.lua" lsp_config.lua;
              nullls_config = pkgs.lua-config-builder {
                imports = [ ./dotfiles/plugin/null-ls.nix ];
              };
              nullls_config_file = pkgs.writeText "null-ls.lua" nullls_config.lua;
            in
            pkgs.stdenv.mkDerivation rec {
              pname = "neovim-configuration";
              version = "1.0";
              src = ./dotfiles;
              buildInputs = with pkgs; [
                #lua-config-builder
              ];
              buildPhase = ''
              '';
              installPhase = ''
                cp -r . $out
                rm -rf $out/lua/polarmutex/lsp/lspconfig.nix
                rm -rf $out/plugin/null-ls.nix
                cp ${lsp_config_file} $out/lua/polarmutex/lsp/lspconfig.lua
                cp ${nullls_config_file} $out/plugin/null-ls.lua
              '';
              meta = with pkgs.lib; {
                homepage = "";
                description = "polarmutex configuration";
                license = licenses.mit;
                maintainers = [ maintainers.polarmutex ];
              };
            };

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
                  vim.opt.runtimepath:prepend('${self.packages."${system}".neovim-polar-config}')
                  EOF
                  luafile ${self.packages."${system}".neovim-polar-config}/init.lua
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
                    nvim-lspconfig
                    plenary-nvim
                    popup-nvim
                    telescope-nvim
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
                    which-key-nvim
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
            pkgs.wrapNeovimUnstable pkgs.neovim {
              wrapperArgs = [
                "--add-flags"
                "--cmd 'set runtimepath^=${self.packages."${system}".neovim-polar-config}'"
                "--add-flags"
                "--cmd 'set packpath^=${self.packages."${system}".neovim-polar-config}/'"
                "--add-flags"
                "-u ${self.packages."${system}".neovim-polar-config}/init.lua"
              ];
              wrapRc = false;
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
            };
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

        devShells.default = pkgs.mkShell { };

      });
}
