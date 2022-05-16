{
  description = "Tutorial Flake accompanying vimconf talk.";

  # Input source for our derivation
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

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
    tokyonight-nvim-src = {
      url = "github:folke/tokyonight.nvim";
      flake = false;
    };
    null-ls-nvim-src = {
      url = "github:jose-elias-alvarez/null-ls.nvim";
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
    , flake-utils
    , rnix-lsp
    , ...
    }:
    let

      dsl = import ./lib/dsl.nix { inherit (nixpkgs) lib; };

      # Function to override the source of a package
      withSrc = pkg: src: pkg.overrideAttrs (_: { inherit src; });

      overlay = final: prev: rec {
        nix2luaUtils = prev.callPackage ./lib/utils.nix { inherit nixpkgs; };
        luaConfigBuilder = import ./lib/lua-config-builder.nix {
          pkgs = prev;
          lib = prev.lib;
        };
        neovimBuilder = import ./lib/neovim-builder.nix {
          pkgs = prev;
          lib = prev.lib;
        };
      };
    in
    {
      inherit overlay;
      home-managerModule =
        { config
        , lib
        , pkgs
        , ...
        }:
        import ./home-manager.nix {
          inherit config lib pkgs dsl;
        };
    } //
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          neovim.overlay
          (import ./plugins.nix inputs)
          overlay
        ];
      };
      neovim-polar = pkgs.neovimBuilder {
        package = pkgs.neovim;
        imports = [
          ./modules/init.nix
          ./modules/plugins.nix
        ];
        enableViAlias = true;
        enableVimAlias = true;
      };
    in
    {
      defaultPackage = neovim-polar;

    });
}
