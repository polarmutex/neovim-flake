{inputs}: final: prev: let
  mkNvimPlugin = src: pname:
    prev.pkgs.vimUtils.buildVimPluginFrom2Nix {
      inherit pname src;
      version = src.lastModifiedDate;
    };
in {
  neovimPlugins = {
    beancount-nvim = mkNvimPlugin inputs.beancount-nvim "beancount.nvim";
    cmp-buffer = mkNvimPlugin inputs.cmp-buffer "cmp-buffer";
    cmp-calc = mkNvimPlugin inputs.cmp-calc "cmp-calc";
    cmp-cmdline = mkNvimPlugin inputs.cmp-cmdline "cmp-cmdline";
    cmp-dap = mkNvimPlugin inputs.cmp-dap "cmp-dap";
    cmp-emoji = mkNvimPlugin inputs.cmp-emoji "cmp-emoji";
    cmp-nvim-lsp = mkNvimPlugin inputs.cmp-nvim-lsp "cmp-nvim-lsp";
    cmp-nvim-lsp-signature-help = mkNvimPlugin inputs.cmp-nvim-lsp-signature-help "cmp-nvim-lsp-signature-help";
    cmp-omni = mkNvimPlugin inputs.cmp-omni "cmp-omni";
    cmp-path = mkNvimPlugin inputs.cmp-path "cmp-path";
    crates-nvim = mkNvimPlugin inputs.crates-nvim "crates.nvim";
    diffview-nvim = mkNvimPlugin inputs.diffview-nvim "diffview.nvim";
    git-worktree-nvim = mkNvimPlugin inputs.git-worktree-nvim "git-worktree.nvim";
    gitsigns-nvim = mkNvimPlugin inputs.gitsigns-nvim "gitsigns.nvim";
    harpoon = mkNvimPlugin inputs.harpoon "harpoon";
    heirline-nvim = mkNvimPlugin inputs.heirline-nvim "heirline.nvim";
    lazy-nvim = mkNvimPlugin inputs.lazy-nvim "lazy.nvim";
    lsp-format-nvim = mkNvimPlugin inputs.lsp-format-nvim "lsp-format.nvim";
    lsp-inlayhints-nvim = mkNvimPlugin inputs.lsp-inlayhints-nvim "lsp-inlayhints.nvim";
    lsp-kind-nvim = mkNvimPlugin inputs.lsp-kind-nvim "lspkind.nvim";
    kanagawa-nvim = mkNvimPlugin inputs.kanagawa-nvim "kanagawa.nvim";
    neodev-nvim = mkNvimPlugin inputs.neodev-nvim "neodev.nvim";
    neogit = mkNvimPlugin inputs.neogit "neogit";
    noice-nvim = mkNvimPlugin inputs.noice-nvim "noice.nvim";
    nui-nvim = mkNvimPlugin inputs.nui-nvim "nui.nvim";
    null-ls-nvim = mkNvimPlugin inputs.null-ls-nvim "null-ls.nvim";
    nvim-cmp = mkNvimPlugin inputs.nvim-cmp "nvim-cmp";
    nvim-colorizer = mkNvimPlugin inputs.nvim-colorizer "nvim-colorizer.lua";
    nvim-dap = mkNvimPlugin inputs.nvim-dap "nvim-dap";
    nvim-dap-python = mkNvimPlugin inputs.nvim-dap-python "nvim-dap-python";
    nvim-dap-ui = mkNvimPlugin inputs.nvim-dap-ui "nvim-dap-ui";
    nvim-dap-virtual-text = mkNvimPlugin inputs.nvim-dap-virtual-text "nvim-dap-virtual-text";
    nvim-jdtls = mkNvimPlugin inputs.nvim-jdtls "nvim-jdtls";
    nvim-lspconfig = mkNvimPlugin inputs.nvim-lspconfig "nvim-lspconfig";
    nvim-treesitter = mkNvimPlugin inputs.nvim-treesitter "nvim-treesitter";
    nvim-treesitter-playground = mkNvimPlugin inputs.nvim-treesitter-playground "playground";
    nvim-web-devicons = mkNvimPlugin inputs.nvim-web-devicons "nvim-web-devicons";
    one-small-step-for-vimkind = mkNvimPlugin inputs.one-small-step-for-vimkind "one-small-step-for-vimkind";
    plenary-nvim = mkNvimPlugin inputs.plenary-nvim "plenary.nvim";
    rust-tools-nvim = mkNvimPlugin inputs.rust-tools-nvim "rust-tools.nvim";
    tasks-nvim = inputs.tasks-nvim.packages.${final.system}.default;
    telescope-nvim = mkNvimPlugin inputs.telescope-nvim "telescope.nvim";
    tokyonight-nvim = mkNvimPlugin inputs.tokyonight-nvim "tokyonight.nvim";
    vim-be-good = mkNvimPlugin inputs.vim-be-good "vim-be-good";
  };
}
