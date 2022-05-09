{
  description = "Tutorial Flake accompanying vimconf talk.";

  # Input source for our derivation
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    neovim = {
      url = "github:neovim/neovim?dir=contrib&tag=master";
    };

    blamer-nvim = {
      url = "github:APZelos/blamer.nvim";
      flake = false;
    };
    nvim-cmp = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };
    cmp-nvim-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };
    cmp-buffer = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };
    colorizer = {
      url = "github:powerman/vim-plugin-AnsiEsc";
      flake = false;
    };
    comment-nvim = {
      url = "github:numToStr/Comment.nvim";
      flake = false;
    };
    conceal = {
      url = "github:ticki/rust-cute-vim";
      flake = false;
    };
    nvim-dap = {
      url = "github:mfussenegger/nvim-dap";
      flake = false;
    };
    nvim-dap-virtual-text = {
      url = "github:theHamsta/nvim-dap-virtual-text";
      flake = false;
    };
    fidget = {
      url = "github:j-hui/fidget.nvim";
      flake = false;
    };
    nvim-lspconfig = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };
    plenary-nvim = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };
    popup-nvim = {
      url = "github:nvim-lua/popup.nvim";
      flake = false;
    };
    rnix-lsp = {
      url = "github:Ma27/rnix-lsp";
    };
    rust-tools-nvim = {
      url = "github:simrat39/rust-tools.nvim";
      flake = false;
    };
    telescope-nvim = {
      url =
        "github:nvim-telescope/telescope.nvim";
      flake = false;
    };
    telescope-dap-nvim = {
      url = "github:nvim-telescope/telescope-dap.nvim";
      flake = false;
    };
    telescope-ui-select = {
      url = "github:nvim-telescope/telescope-ui-select.nvim";
      flake = false;
    };
    nvim-treesitter = {
      url = "github:nvim-treesitter/nvim-treesitter";
      flake = false;
    };
    nvim-treesitter-context = {
      url = "github:romgrk/nvim-treesitter-context";
      flake = false;
    };
    which-key-nvim = {
      url = "github:folke/which-key.nvim";
      flake = false;
    };
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , neovim
    , rnix-lsp
    , ...
    }:
    let
      plugins = [
        "blamer-nvim"
        "nvim-cmp"
        "cmp-nvim-lsp"
        "cmp-buffer"
        "colorizer"
        "comment-nvim"
        "conceal"
        "nvim-dap"
        "nvim-dap-virtual-text"
        "fidget"
        "lspconfig"
        "plenary-nvim"
        "popup-nvim"
        "rnix-lsp"
        "rust-tools-nvim"
        "telescope-nvim"
        "telescope-dap-nvim"
        "telescope-ui-select"
        "nvim-treesitter"
        "nvim-treesitter-context"
        "which-key-nvim"
      ];

      lib = import ./lib;

      dsl = import ./lib/dsl.nix { inherit (nixpkgs) lib; };

      # Function to override the source of a package
      withSrc = pkg: src: pkg.overrideAttrs (_: { inherit src; });

    externalBitsOverlay = top: last: {
      rnix-lsp = rnix-lsp.defaultPackage.${top.system};
      neovim-nightly = neovim.defaultPackage.${top.system};
    };

      pluginOverlay = top: last:
        let
          buildPlug = name: top.vimUtils.buildVimPluginFrom2Nix {
            pname = name;
            version = "master";
            src = builtins.getAttr name inputs;
          };
        in
        {
          neovimPlugins = builtins.listToAttrs (map
            (name: {
              inherit name;
              value = buildPlug name;
            })
            plugins);
        };

      allPkgs = lib.mkPkgs {
        inherit nixpkgs;
        cfg = { };
        overlays = [
          pluginOverlay
          externalBitsOverlay
          (self: last: {
          luaConfigBuilder = import ./lib/lua-config-builder.nix {
            pkgs = last;
            lib = last.lib;
          };
        })
        ];
      };

      mkNeovimPackage = pkgs: lib.neovimBuilder {
        inherit pkgs;
        startPlugins = with pkgs.neovimPlugins; [
          nvim-treesitter
        ];
        optPlugins = [ ];
      };


    in
    {
      # The packages: our custom neovim and the config text file
      packages = lib.withDefaultSystems (sys: {
        neovim-polar = mkNeovimPackage allPkgs."${sys}";
        luaConfigBuilder = import ./lib/lua-config-builder.nix {
            pkgs = allPkgs;
            lib = nixpkgs.lib;
          };
      });

      # The package built by `nix build .`
      defaultPackage = lib.withDefaultSystems (sys:
        self.packages."${sys}".neovim-polar
      );

      apps = lib.withDefaultSystems (sys: {
        nvim = {
          type = "app";
          program = "${self.defaultPackage."${sys}"}/bin/nvim";
        };
      });

      # The app run by `nix run .`
      defaultApp = lib.withDefaultSystems (sys: {
        type = "app";
        program = "${self.defaultPackage."${sys}"}/bin/nvim";
      });

      home-managerModule =
        { config
        , lib
        , pkgs
        , ...
        }:
        import ./home-manager.nix {
          inherit config lib pkgs dsl;
        };
    };
}
