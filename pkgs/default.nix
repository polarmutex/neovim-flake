{inputs, ...}: let
  /*
  wrapperFor returns a wrapper w for a set of pkgs

  wrapper incudes automatic overrides for a callPackage definition
  */
  wrapperFor = _pkgs: _callPackage: path: extraOverrides: let
    # args :: set
    args = builtins.functionArgs (import path);

    usesNvfetcher = builtins.hasAttr "src" args || builtins.hasAttr "sources" args;

    sources = _pkgs.callPackages (path + "/generated.nix") {};

    firstSource = builtins.head (builtins.attrValues sources);

    nvfetcherOverrides =
      if ! usesNvfetcher
      then {}
      else if builtins.hasAttr "sources" args
      then {inherit sources;}
      else builtins.intersectAttrs args firstSource;
  in
    _callPackage path (nvfetcherOverrides // extraOverrides);
in {
  perSystem = {
    config,
    inputs',
    pkgs,
    system,
    ...
  }: let
    w = wrapperFor pkgs;
  in {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        inputs.nvfetcher.overlays.default
        (_final: _prev: {
          mdformat-with-plugins =
            pkgs.python311Packages.mdformat.withPlugins
            (with pkgs.python311Packages; [
              mdformat-gfm
              mdformat-frontmatter
              mdformat-toc
            ]);
          nil-git = inputs'.nil.packages.default;
        })
      ];
    };

    legacyPackages = pkgs;

    packages = {
      default = config.packages.neovim-git;
      # from https://github.com/nix-community/neovim-nightly-overlay
      neovim-git = inputs'.neovim-flake.packages.neovim;

      polar-lua-config = pkgs.callPackage ./polar-lua-config.nix {inherit (config) packages;};
      neovim-polar = pkgs.callPackage ./neovim-polar.nix {
        inherit (inputs) neovim-flake;
        inherit (config) packages;
      };

      neovim-plugin-beancount-nvim = w pkgs.callPackage ./plugins/beancount-nvim {};
      neovim-plugin-cmp-dap = w pkgs.callPackage ./plugins/cmp-dap {};
      neovim-plugin-cmp-emoji = w pkgs.callPackage ./plugins/cmp-emoji {};
      neovim-plugin-cmp-nvim-lsp = w pkgs.callPackage ./plugins/cmp-nvim-lsp {};
      neovim-plugin-cmp-path = w pkgs.callPackage ./plugins/cmp-path {};
      neovim-plugin-crates-nvim = w pkgs.callPackage ./plugins/crates-nvim {};
      neovim-plugin-diffview-nvim = w pkgs.callPackage ./plugins/diffview-nvim {};
      neovim-plugin-dressing-nvim = w pkgs.callPackage ./plugins/dressing-nvim {};
      neovim-plugin-edgy-nvim = w pkgs.callPackage ./plugins/edgy-nvim {};
      neovim-plugin-flash-nvim = w pkgs.callPackage ./plugins/flash-nvim {};
      neovim-plugin-friendly-snippets = w pkgs.callPackage ./plugins/friendly-snippets {};
      neovim-plugin-git-worktree-nvim = w pkgs.callPackage ./plugins/git-worktree-nvim {};
      neovim-plugin-gitsigns-nvim = w pkgs.callPackage ./plugins/gitsigns-nvim {};
      neovim-plugin-harpoon = w pkgs.callPackage ./plugins/harpoon {};
      neovim-plugin-lualine-nvim = w pkgs.callPackage ./plugins/lualine-nvim {};
      neovim-plugin-luasnip = w pkgs.callPackage ./plugins/luasnip {};
      neovim-plugin-kanagawa-nvim = w pkgs.callPackage ./plugins/kanagawa-nvim {};
      neovim-plugin-mini-indentscope = w pkgs.callPackage ./plugins/mini-indentscope {};
      neovim-plugin-neodev-nvim = w pkgs.callPackage ./plugins/neodev-nvim {};
      neovim-plugin-neogit = w pkgs.callPackage ./plugins/neogit {};
      neovim-plugin-noice-nvim = w pkgs.callPackage ./plugins/noice-nvim {};
      neovim-plugin-nui-nvim = w pkgs.callPackage ./plugins/nui-nvim {};
      neovim-plugin-null-ls-nvim = w pkgs.callPackage ./plugins/null-ls-nvim {};
      neovim-plugin-nvim-cmp = w pkgs.callPackage ./plugins/nvim-cmp {};
      neovim-plugin-nvim-colorizer = w pkgs.callPackage ./plugins/nvim-colorizer {};
      neovim-plugin-nvim-dap = w pkgs.callPackage ./plugins/nvim-dap {};
      neovim-plugin-nvim-dap-python = w pkgs.callPackage ./plugins/nvim-dap-python {};
      neovim-plugin-nvim-dap-ui = w pkgs.callPackage ./plugins/nvim-dap-ui {};
      neovim-plugin-nvim-dap-virtual-text = w pkgs.callPackage ./plugins/nvim-dap-virtual-text {};
      neovim-plugin-nvim-jdtls = w pkgs.callPackage ./plugins/nvim-jdtls {};
      neovim-plugin-nvim-lspconfig = w pkgs.callPackage ./plugins/nvim-lspconfig {};
      neovim-plugin-nvim-navic = w pkgs.callPackage ./plugins/nvim-navic {};
      neovim-plugin-nvim-treesitter = w pkgs.callPackage ./plugins/nvim-treesitter {inherit (inputs) nixpkgs;};
      neovim-plugin-nvim-treesitter-playground = w pkgs.callPackage ./plugins/nvim-treesitter-playground {};
      neovim-plugin-nvim-web-devicons = w pkgs.callPackage ./plugins/nvim-web-devicons {};
      neovim-plugin-one-small-step-for-vimkind = w pkgs.callPackage ./plugins/one-small-step-for-vimkind {};
      neovim-plugin-overseer-nvim = w pkgs.callPackage ./plugins/overseer-nvim {};
      neovim-plugin-plenary-nvim = w pkgs.callPackage ./plugins/plenary-nvim {};
      neovim-plugin-schemastore-nvim = w pkgs.callPackage ./plugins/schemastore-nvim {};
      neovim-plugin-sqlite-lua = w pkgs.callPackage ./plugins/sqlite-lua {};
      neovim-plugin-telescope-nvim = w pkgs.callPackage ./plugins/telescope-nvim {};
      neovim-plugin-tokyonight-nvim = w pkgs.callPackage ./plugins/tokyonight-nvim {};
      neovim-plugin-trouble-nvim = w pkgs.callPackage ./plugins/trouble-nvim {};
      neovim-plugin-vim-be-good = w pkgs.callPackage ./plugins/vim-be-good {};
      neovim-plugin-vim-illuminate = w pkgs.callPackage ./plugins/vim-illuminate {};
      neovim-plugin-which-key-nvim = w pkgs.callPackage ./plugins/which-key-nvim {};
      neovim-plugin-yanky-nvim = w pkgs.callPackage ./plugins/yanky-nvim {};
    };
  };
}
