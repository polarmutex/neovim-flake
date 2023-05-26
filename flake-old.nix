{
  description = "polarmutex's NeoVim config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    nix2vim = {
      url = "github:gytis-ivaskevicius/nix2vim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    DSL = {
      url = "github:DieracDelta/nix2lua/aarch64-darwin";
      inputs.neovim.follows = "neovim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # LSP
    rnix-lsp = {
      url = "github:Ma27/rnix-lsp?ref=01b3623b49284d87a034676d3f4b298e495190dd";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Plugins
    beancount = {
      url = "github:polarmutex/beancount.nvim";
      flake = false;
    };
    blamer-nvim-src = {
      url = "github:APZelos/blamer.nvim";
      flake = false;
    };
    cmp-src = {
      url = "github:hrsh7th/nvim-cmp";
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
    colorizer-src = {
      url = "github:powerman/vim-plugin-AnsiEsc";
      flake = false;
    };
    comment-nvim-src = {
      url = "github:numToStr/Comment.nvim";
      flake = false;
    };
    fidget-src = {
      url = "github:j-hui/fidget.nvim";
      flake = false;
    };
    rust-tools-src = {
      url = "github:simrat39/rust-tools.nvim";
      flake = false;
    };
    telescope-src = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };
    telescope-ui-select-src = {
      url = "github:nvim-telescope/telescope-ui-select.nvim";
      flake = false;
    };
    which-key-src = {
      url = "github:folke/which-key.nvim?ref=bd4411a2ed4dd8bb69c125e339d837028a6eea71";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-utils,
    neovim,
    nix2vim,
    DSL,
    comment-nvim-src,
    telescope-ui-select-src,
    rust-tools-src,
    which-key-src,
    fidget-src,
    colorizer-src,
    ...
  }: let
    # Function to override the source of a package
    withSrc = pkg: src: pkg.overrideAttrs (_: {inherit src;});

    # Vim2Nix DSL
    dsl = nix2vim.lib.dsl;

    overlay = prev: final: rec {
      luaConfigBuilder = import ./lib/lua-config-builder.nix {
        pkgs = prev;
        lib = prev.lib;
      };

      comment-nvim = prev.vimUtils.buildVimPluginFrom2Nix {
        pname = "comment-nvim";
        version = "nixpkgs";
        src = comment-nvim-src;
      };

      parinfer-rust-nvim = prev.vimUtils.buildVimPluginFrom2Nix {
        pname = "parinfer-rust";
        version = "nixpkgs";
        src = prev.pkgs.parinfer-rust;
      };

      rust-tools = prev.vimUtils.buildVimPluginFrom2Nix {
        pname = "rust-tools";
        version = "nixpkgs";
        src = rust-tools-src;
      };

      fidget = prev.vimUtils.buildVimPluginFrom2Nix {
        pname = "fidget";
        version = "nixpkgs";
        src = fidget-src;
      };

      which-key = prev.vimUtils.buildVimPluginFrom2Nix {
        pname = "which-key";
        version = "nixpkgs";
        src = which-key-src;
      };

      colorizer = prev.vimUtils.buildVimPluginFrom2Nix {
        pname = "colorizer";
        version = "nixpkgs";
        src = colorizer-src;
      };

      # Generate our init.lua from neoConfig using vim2nix transpiler
      neovimConfig = let
        luaConfig = prev.luaConfigBuilder {
          config = import ./neoConfig.nix {
            inherit (nix2vim.lib) dsl;
            pkgs = prev;
          };
        };
      in
        prev.writeText "init.lua" luaConfig.lua;

      # shamelessly copied from fufexan (thanks buddy!)

      # Building neovim package with dependencies and custom config
      customNeovim =
        (DSL.DSL prev).neovimBuilderWithDeps.legacyWrapper
        neovim.defaultPackage.${prev.system}
        {
          # Dependencies to be prepended to PATH env variable at runtime. Needed by plugins at runtime.
          extraRuntimeDeps = with prev; [
            # master.clang-tools # fix headers not found
            clang # LSP and compiler
            fd # telescope file browser
            ripgrep # telescope
            nodePackages.vscode-json-languageserver # json
            pyright
            inputs.rnix-lsp.defaultPackage.${prev.system} # nix
          ];

          # Build with NodeJS
          withNodeJs = true;

          # Passing in raw lua config
          configure.customRC = ''
            colorscheme dracula
            luafile ${neovimConfig}
          '';

          configure.packages.myVimPackage.start = with nixpkgs.legacyPackages.${prev.system}.vimPlugins; [
            # Adding reference to our custom plugin
            # for themeing

            # commenting with treesiter
            comment-nvim

            # Overwriting plugin sources with different version
            # fuzzy finder
            (withSrc telescope-nvim inputs.telescope-src)
            (withSrc cmp-buffer inputs.cmp-buffer-src)
            (withSrc nvim-cmp inputs.cmp-src)
            (withSrc cmp-nvim-lsp inputs.cmp-nvim-lsp-src)

            # Plugins from nixpkgs
            lsp_signature-nvim
            lspkind-nvim
            nvim-lspconfig
            plenary-nvim
            popup-nvim
            # which method am I on
            nvim-treesitter-context
            # FIXME figure out how to configure this one
            harpoon

            which-key
            neogit
            #blamer-nvim

            parinfer-rust-nvim

            #nixpkgs.legacyPackages.${prev.system}.vimPlugins.telescope-file-browser-nvim
            # sexy dropdown
            #telescope-ui-select

            # more lsp rust functionality
            rust-tools

            # for updating rust crates
            crates-nvim

            # for showing lsp progress
            fidget

            # for showing ansi escape sequences
            colorizer

            # concealer
            # conceal # conflicts with treesitter

            # Compile syntaxes into treesitter
            (prev.vimPlugins.nvim-treesitter.withPlugins
              (plugins: with plugins; [tree-sitter-nix tree-sitter-rust tree-sitter-json tree-sitter-c tree-sitter-go]))
          ];
        };
    };
  in
    flake-utils.lib.eachDefaultSystem
    (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [nix2vim.overlay overlay];
        config = {
          allowAliases = false;
        };
      };
    in {
      # The packages: our custom neovim and the config text file
      packages = {inherit (pkgs) customNeovim neovimConfig;};

      # The package built by `nix build .`

      defaultPackage = pkgs.customNeovim;
      # The app run by `nix run .`
      defaultApp = {
        type = "app";
        program = "${pkgs.customNeovim}/bin/nvim";
      };
    });
}
