{
  description = "Wil Taylor's NeoVim config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    # Plugins
    alpha = { url = "github:goolord/alpha-nvim"; flake = false; };
    beancount = { url = "github:polarmutex/beancount.nvim"; flake = false; };
    cmp = { url = "github:hrsh7th/nvim-cmp"; flake = false; };
    cmp_buffer = { url = "github:hrsh7th/cmp-buffer"; flake = false; };
    cmp_emoji = { url = "github:hrsh7th/cmp-emoji"; flake = false; };
    cmp_lua = { url = "github:hrsh7th/cmp-nvim-lua"; flake = false; };
    cmp_lsp = { url = "github:hrsh7th/cmp-nvim-lsp"; flake = false; };
    cmp_luasnip = { url = "github:saadparwaiz1/cmp_luasnip"; flake = false; };
    cmp_path = { url = "github:hrsh7th/cmp-path"; flake = false; };
    colorizer = { url = "github:norcalli/nvim-colorizer.lua"; flake = false; };
    dap = { url = "github:mfussenegger/nvim-dap"; flake = false; };
    dap-python = { url = "github:mfussenegger/nvim-dap-python"; flake = false; };
    dap-virt-text = { url = "github:theHamsta/nvim-dap-virtual-text"; flake = false; };
    diffview = { url = "github:sindrets/diffview.nvim"; flake = false; };
    dial = { url = "github:monaqa/dial.nvim"; flake = false; };
    gitsigns = { url = "github:lewis6991/gitsigns.nvim"; flake = false; };
    git-linker = { url = "github:ruifm/gitlinker.nvim"; flake = false; };
    git-worktree = { url = "github:ThePrimeagen/git-worktree.nvim"; flake = false; };
    harpoon = { url = "github:ThePrimeagen/harpoon"; flake = false; };
    impatient = { url = "github:lewis6991/impatient.nvim"; flake = false; };
    jdtls = { url = "github:mfussenegger/nvim-jdtls"; flake = false; };
    lightline = { url = "github:nvim-lualine/lualine.nvim"; flake = false; };
    lightspeed = { url = "github:ggandor/lightspeed.nvim"; flake = false; }; # TODO
    lspconfig = { url = "github:neovim/nvim-lspconfig"; flake = false; };
    lspkind = { url = "github:onsails/lspkind-nvim"; flake = false; };
    lspstatus = { url = "github:nvim-lua/lsp-status.nvim"; flake = false; };
    lsp_ts_utils = { url = "github:jose-elias-alvarez/nvim-lsp-ts-utils"; flake = false; };
    luadev = { url = "github:folke/lua-dev.nvim"; flake = false; };
    luasnip = { url = "github:L3MON4D3/LuaSnip"; flake = false; };
    neogit = { url = "github:TimUntersberger/neogit"; flake = false; };
    # todo neoscroll
    nvim-which-key = { url = "github:folke/which-key.nvim"; flake = false; };
    null-ls = { url = "github:jose-elias-alvarez/null-ls.nvim"; flake = false; };
    octo = { url = "github:pwntester/octo.nvim"; flake = false; };
    plenary = { url = "github:nvim-lua/plenary.nvim"; flake = false; };
    startuptime = { url = "github:tweekmonster/startuptime.vim"; flake = false; };
    telescope = { url = "github:nvim-telescope/telescope.nvim"; flake = false; };
    telescope-dap = { url = "github:nvim-telescope/telescope-dap.nvim"; flake = false; };
    treesitter = { url = "github:nvim-treesitter/nvim-treesitter"; flake = false; };
    treesitter_playground = { url = "github:nvim-treesitter/playground"; flake = false; };
    trouble = { url = "github:folke/trouble.nvim"; flake = false; };
    todo-comments = { url = "github:folke/todo-comments.nvim"; flake = false; };
    undotree = { url = "github:mbbill/undotree"; flake = false; };
    vim-be-good = { url = "github:ThePrimeagen/vim-be-good"; flake = false; };
    vim-illuminate = { url = "github:RRethy/vim-illuminate"; flake = false; };
    web-devicons = { url = "github:kyazdani42/nvim-web-devicons"; flake = false; };
    which-key = { url = "github:folke/which-key.nvim"; flake = false; };

    # lsp
    rnix-lsp.url = github:nix-community/rnix-lsp;

  };

  outputs = { nixpkgs, flake-utils, neovim, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        plugins = [
          "nvim-which-key"
          "plenary"
          "impatient"
          "lspconfig"
          "lspstatus"
          "luadev"
          "null-ls"
          "lsp_ts_utils"
          "lspkind"
          "trouble"
          "jdtls"
          "cmp"
          "cmp_buffer"
          "cmp_path"
          "cmp_lua"
          "cmp_lsp"
          "cmp_emoji"
          "cmp_luasnip"
          "luasnip"
          "treesitter"
          "treesitter_playground"
          "telescope"
          "harpoon"
          "lightspeed"
          "gitsigns"
          "neogit"
          "diffview"
          "git-worktree"
          "git-linker"
          "octo"
          "which-key"
          "dap"
          "dap-python"
          "dap-virt-text"
          "telescope-dap"
          "lightline"
          "alpha"
          "undotree"
          "vim-illuminate"
          "web-devicons"
          "colorizer"
          "dial"
          "beancount"
          "vim-be-good"
          "todo-comments"
          "startuptime"
        ];

        pluginOverlay = lib.buildPluginOverlay;

        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
          overlays = [
            pluginOverlay
            (final: prev: {
              neovim-nightly = neovim.defaultPackage.${system};
              rnix-lsp = inputs.rnix-lsp.defaultPackage.${system};
            })
          ];
        };

        lib = import ./lib { inherit pkgs inputs plugins; };

        neovimBuilder = lib.neovimBuilder;
      in
      rec {
        inherit neovimBuilder pkgs;

        apps = {
          nvim = {
            type = "app";
            program = "${defaultPackage}/bin/nvim";
          };
        };

        defaultApp = apps.nvim;

        defaultPackage = packages.neovimPM;


        overlay = (self: super: {
          inherit neovimBuilder;
          neovimPM = packages.neovimPM;
          neovimPlugins = pkgs.neovimPlugins;
        });

        packages.neovimPM = neovimBuilder {
          config = {
            vim.viAlias = true;
            vim.vimAlias = true;
            #vim.dashboard.startify.enable = true;
            #vim.dashboard.startify.customHeader = [ "NIXOS NEOVIM CONFIG" ];
            #vim.theme.nord.enable = true;
            #vim.disableArrows = true;
            #vim.statusline.lightline.enable = true;
            #vim.lsp.enable = true;
            #vim.lsp.bash = true;
            #vim.lsp.go = true;
            #vim.lsp.nix = true;
            #vim.lsp.python = true;
            #vim.lsp.ruby = true;
            #vim.lsp.rust = true;
            #vim.lsp.terraform = true;
            #vim.lsp.typescript = true;
            #vim.lsp.vimscript = true;
            #vim.lsp.yaml = true;
            #vim.lsp.docker = true;
            #vim.lsp.tex = true;
            #vim.lsp.css = true;
            #vim.lsp.html = true;
            #vim.lsp.json = true;
            #vim.lsp.clang = true;
            #vim.lsp.cmake = false; # Currently broken
            #vim.lsp.lightbulb = true;
            #vim.lsp.variableDebugPreviews = true;
            #vim.fuzzyfind.telescope.enable = true;
            #vim.filetree.nvimTreeLua.enable = true;
            #vim.git.enable = true;
            #vim.formatting.editorConfig.enable = true;
            #vim.editor.indentGuide = true;
            #vim.editor.underlineCurrentWord = true;
            #vim.test.enable = true;

          };
        };
      });
}
