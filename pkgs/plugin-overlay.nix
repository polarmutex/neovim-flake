{inputs}: final: prev: let
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

  w = wrapperFor prev;
in {
  nvimPlugins = {
    beancount-nvim = w prev.callPackage ./plugins/beancount-nvim {};
    cmp-dap = w prev.callPackage ./plugins/cmp-dap {};
    cmp-emoji = w prev.callPackage ./plugins/cmp-emoji {};
    cmp-nvim-lsp = w prev.callPackage ./plugins/cmp-nvim-lsp {};
    cmp-path = w prev.callPackage ./plugins/cmp-path {};
    comments-nvim = w prev.callPackage ./plugins/comments-nvim {};
    conform-nvim = w prev.callPackage ./plugins/conform-nvim {};
    crates-nvim = w prev.callPackage ./plugins/crates-nvim {};
    diffview-nvim = w prev.callPackage ./plugins/diffview-nvim {};
    dressing-nvim = w prev.callPackage ./plugins/dressing-nvim {};
    edgy-nvim = w prev.callPackage ./plugins/edgy-nvim {};
    flash-nvim = w prev.callPackage ./plugins/flash-nvim {};
    friendly-snippets = w prev.callPackage ./plugins/friendly-snippets {};
    git-worktree-nvim = w prev.callPackage ./plugins/git-worktree-nvim {};
    gitsigns-nvim = w prev.callPackage ./plugins/gitsigns-nvim {};
    harpoon = w prev.callPackage ./plugins/harpoon {};
    inc-rename-nvim = w prev.callPackage ./plugins/inc-rename {};
    lualine-nvim = w prev.callPackage ./plugins/lualine-nvim {};
    luasnip = w prev.callPackage ./plugins/luasnip {};
    kanagawa-nvim = w prev.callPackage ./plugins/kanagawa-nvim {};
    mini-indentscope = w prev.callPackage ./plugins/mini-indentscope {};
    neodev-nvim = w prev.callPackage ./plugins/neodev-nvim {};
    neogit = w prev.callPackage ./plugins/neogit {};
    noice-nvim = w prev.callPackage ./plugins/noice-nvim {};
    nui-nvim = w prev.callPackage ./plugins/nui-nvim {};
    null-ls-nvim = w prev.callPackage ./plugins/null-ls-nvim {};
    nvim-cmp = w prev.callPackage ./plugins/nvim-cmp {};
    nvim-colorizer = w prev.callPackage ./plugins/nvim-colorizer {};
    nvim-dap = w prev.callPackage ./plugins/nvim-dap {};
    nvim-dap-python = w prev.callPackage ./plugins/nvim-dap-python {};
    nvim-dap-ui = w prev.callPackage ./plugins/nvim-dap-ui {};
    nvim-dap-virtual-text = w prev.callPackage ./plugins/nvim-dap-virtual-text {};
    nvim-jdtls = w prev.callPackage ./plugins/nvim-jdtls {};
    nvim-lint = w prev.callPackage ./plugins/nvim-lint {};
    nvim-navic = w prev.callPackage ./plugins/nvim-navic {};
    nvim-treesitter = w prev.callPackage ./plugins/nvim-treesitter {
      inherit (inputs) nixpkgs;
    };
    nvim-treesitter-playground = w prev.callPackage ./plugins/nvim-treesitter-playground {};
    nvim-web-devicons = w prev.callPackage ./plugins/nvim-web-devicons {};
    one-small-step-for-vimkind = w prev.callPackage ./plugins/one-small-step-for-vimkind {};
    overseer-nvim = w prev.callPackage ./plugins/overseer-nvim {};
    plenary-nvim = w prev.callPackage ./plugins/plenary-nvim {};
    rustaceanvim = w prev.callPackage ./plugins/rustaceanvim {};
    schemastore-nvim = w prev.callPackage ./plugins/schemastore-nvim {};
    sqlite-lua = w prev.callPackage ./plugins/sqlite-lua {};
    telescope-nvim = w prev.callPackage ./plugins/telescope-nvim {};
    tokyonight-nvim = w prev.callPackage ./plugins/tokyonight-nvim {};
    trouble-nvim = w prev.callPackage ./plugins/trouble-nvim {};
    vim-be-good = w prev.callPackage ./plugins/vim-be-good {};
    vim-illuminate = w prev.callPackage ./plugins/vim-illuminate {};
    which-key-nvim = w prev.callPackage ./plugins/which-key-nvim {};
    yanky-nvim = w prev.callPackage ./plugins/yanky-nvim {};
  };
}
