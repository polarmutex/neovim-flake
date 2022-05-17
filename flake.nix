{
  description = "Tutorial Flake accompanying vimconf talk.";

  # Input source for our derivation
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    neovim = {
      url = "github:neovim/neovim?dir=contrib&tag=master";
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
    colorizer-src = {
      url = "github:powerman/vim-plugin-AnsiEsc";
      flake = false;
    };
    comment-nvim-src = {
      url = "github:numToStr/Comment.nvim";
      flake = false;
    };
    conceal-src = {
      url = "github:ticki/rust-cute-vim";
      flake = false;
    };
    fidget-src = {
      url = "github:j-hui/fidget.nvim";
      flake = false;
    };
    gitsigns-nvim-src = {
      url = "github:lewis6991/gitsigns.nvim";
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
    nvim-cmp-src = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };
    nvim-dap-src = {
      url = "github:mfussenegger/nvim-dap";
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
    which-key-nvim-src = {
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
