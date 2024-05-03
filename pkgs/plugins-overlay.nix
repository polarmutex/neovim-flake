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

  plugins-pins = import ./npins;

  mkNvimPlugin = src: pname:
    prev.pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version =
        if (src ? version)
        then src.version
        else src.revision;
    };

  mkNvimTreesitterPlugin = src: pname: let
    buildGrammar = prev.callPackage "${inputs.nixpkgs}/pkgs/development/tools/parsing/tree-sitter/grammar.nix" {};

    grammar-sources = import ./grammars;

    generatedGrammars = with prev.lib;
      mapAttrsToList
      (n: v:
        buildGrammar {
          language = removePrefix "tree-sitter-" n;
          # version = grammar-sources."${n}".revision;
          version = v.revision;
          # src = grammar-sources."${n}";
          src = v;
          name = "${n}-grammar";
          location =
            if n == "tree-sitter-markdown_inline"
            then "tree-sitter-markdown-inline"
            else if n == "tree-sitter-markdown"
            then "tree-sitter-markdown"
            else if n == "tree-sitter-typescript"
            then "typescript"
            else null;

          #passthru.parserName = "${lib.strings.replaceStrings ["-"] ["_"] (lib.strings.removePrefix "tree-sitter-" n)}";
          # passthru.parserName = n;
          passthru.parserName = removePrefix "tree-sitter-" n;
        })
      grammar-sources;
  in
    prev.pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version =
        if (src ? version)
        then src.version
        else src.revision;
      patches = [
        #./disable_ensure_installed.patch # may need in the future
      ];

      postInstall = prev.lib.concatStringsSep "\n" (map
        (drv: ''
          ls ${drv}
          cp ${drv}/parser $out/parser/${(prev.lib.removePrefix "tree-sitter-" drv.parserName)}.so
        '')
        generatedGrammars);
    };
in {
  nvimPlugins = {
    beancount-nvim = mkNvimPlugin plugins-pins."beancount.nvim" "beancount.nvim";
    cmp-dap = mkNvimPlugin plugins-pins."cmp-dap" "cmp-dap";
    cmp-emoji = mkNvimPlugin plugins-pins."cmp-emoji" "cmp-emoji";
    cmp-nvim-lsp = mkNvimPlugin plugins-pins."cmp-nvim-lsp" "cmp-nvim-lsp";
    cmp-path = mkNvimPlugin plugins-pins."cmp-path" "cmp-path";
    conform-nvim = mkNvimPlugin plugins-pins."conform.nvim" "conform-nvim";
    crates-nvim = mkNvimPlugin plugins-pins."crates.nvim" "crates-nvim";
    diffview-nvim = mkNvimPlugin plugins-pins."diffview.nvim" "diffview-nvim";
    dressing-nvim = mkNvimPlugin plugins-pins."dressing.nvim" "dressing-nvim";
    edgy-nvim = mkNvimPlugin plugins-pins."edgy.nvim" "edgy-nvim";
    flash-nvim = mkNvimPlugin plugins-pins."flash.nvim" "flash.nvim";
    friendly-snippets = mkNvimPlugin plugins-pins."friendly-snippets" "friendly-snippets";
    git-worktree-nvim = mkNvimPlugin plugins-pins."git-worktree.nvim" "git-worktree-nvim";
    gitsigns-nvim = mkNvimPlugin plugins-pins."gitsigns.nvim" "gitsigns-nvim";
    harpoon = mkNvimPlugin plugins-pins."harpoon" "harpoon";
    inc-rename-nvim = mkNvimPlugin plugins-pins."inc-rename.nvim" "inc-rename-nvim";
    lualine-nvim = mkNvimPlugin plugins-pins."lualine.nvim" "lualine-nvim";
    luasnip = mkNvimPlugin plugins-pins."LuaSnip" "luaSnip";
    kanagawa-nvim = mkNvimPlugin plugins-pins."kanagawa.nvim" "kanagawa-nvim";
    mini-indentscope = mkNvimPlugin plugins-pins."mini.indentscope" "mine-indentscope";
    neodev-nvim = mkNvimPlugin plugins-pins."neodev.nvim" "neodev-nvim";
    neogit = mkNvimPlugin plugins-pins."neogit" "neogit";
    noice-nvim = mkNvimPlugin plugins-pins."noice.nvim" "noice-nvim";
    nui-nvim = mkNvimPlugin plugins-pins."nui.nvim" "nui-nvim";
    nvim-cmp = mkNvimPlugin plugins-pins."nvim-cmp" "nvim-cmp";
    nvim-colorizer = mkNvimPlugin plugins-pins."nvim-colorizer.lua" "nvim-colorizer-lua";
    nvim-dap = mkNvimPlugin plugins-pins."nvim-dap" "nvim-dap";
    nvim-dap-python = mkNvimPlugin plugins-pins."nvim-dap-python" "nvim-dap-python";
    nvim-dap-ui = mkNvimPlugin plugins-pins."nvim-dap-ui" "nvim-dap-ui";
    nvim-dap-virtual-text = mkNvimPlugin plugins-pins."nvim-dap-virtual-text" "nvim-dap-virtual-text";
    nvim-jdtls = mkNvimPlugin plugins-pins."nvim-jdtls" "nvim-jdtls";
    nvim-lint = mkNvimPlugin plugins-pins."nvim-lint" "nvim-lint";
    nvim-navic = mkNvimPlugin plugins-pins."nvim-navic" "nvim-navic";
    nvim-nio = mkNvimPlugin plugins-pins."nvim-nio" "nvim-nio";
    nvim-treesitter = mkNvimTreesitterPlugin plugins-pins."nvim-treesitter" "nvim-treesitter";
    # nvim-treesitter = w prev.callPackage ./plugins/nvim-treesitter {
    #   inherit (inputs) nixpkgs;
    # };
    nvim-treesitter-playground = mkNvimPlugin plugins-pins."playground" "nvim-treesitter-playground";
    nvim-web-devicons = mkNvimPlugin plugins-pins."nvim-web-devicons" "nvim-web-devicons";
    obsidian-nvim = mkNvimPlugin plugins-pins."obsidian.nvim" "obsidian-nvim";
    one-small-step-for-vimkind = mkNvimPlugin plugins-pins."one-small-step-for-vimkind" "one-small-step-for-vimkind";
    overseer-nvim = mkNvimPlugin plugins-pins."overseer.nvim" "overseer-nvim";
    plenary-nvim = mkNvimPlugin plugins-pins."plenary.nvim" "plenary-nvim";
    rustaceanvim = mkNvimPlugin plugins-pins."rustaceanvim" "rustaceanvim";
    schemastore-nvim = mkNvimPlugin plugins-pins."SchemaStore.nvim" "schemaStore-nvim";
    sqlite-lua = mkNvimPlugin plugins-pins."sqlite.lua" "sqlite.lua";
    telescope-nvim = mkNvimPlugin plugins-pins."telescope.nvim" "telescope-nvim";
    tokyonight-nvim = mkNvimPlugin plugins-pins."tokyonight.nvim" "tokyonight-nvim";
    trouble-nvim = mkNvimPlugin plugins-pins."trouble.nvim" "trouble-nvim";
    vim-be-good = mkNvimPlugin plugins-pins."vim-be-good" "vim-be-good";
    vim-illuminate = mkNvimPlugin plugins-pins."vim-illuminate" "vim-illuminate";
    which-key-nvim = mkNvimPlugin plugins-pins."which-key.nvim" "which-key-nvim";
    yanky-nvim = mkNvimPlugin plugins-pins."yanky.nvim" "yanky-nvim";
  };
}
