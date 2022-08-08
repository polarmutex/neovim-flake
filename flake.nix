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
    tree-sitter-beancount = {
      url = "github:polarmutex/tree-sitter-beancount";
    };
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
    , tree-sitter-beancount
    , flake-utils
    , rnix-lsp
    , nix2vim
    , ...
    }:
    let
      overlay = final: prev: rec { };
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
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          neovim.overlay
          polar-nur.overlays.default
          tree-sitter-beancount.overlays.default
          (import ./plugins.nix inputs)
          nix2vim.overlay
          #overlay
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
      packages.default = neovim-polar;

      apps.defaultApp = {
        type = "app";
        program = "${neovim-polar}/bin/nvim";
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
