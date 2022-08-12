inputs: final: prev:
let
  #TODO can we override version to master?
  withSrc = pkg: src: pkg.overrideAttrs (_: { inherit src; });
  plugin = pname: src: prev.vimUtils.buildVimPluginFrom2Nix {
    inherit pname src;
    version = "master";
  };
in
with inputs; {

  rnix-lsp = inputs.rnix-lsp.packages.${prev.system}.rnix-lsp;

  neovimPlugins = {
    beancount-nvim = plugin "beancount-nvim" beancount-nvim-src;
    blamer-nvim = plugin "blamer-nvim" blamer-nvim-src;
    cmp-buffer = (withSrc prev.vimPlugins.cmp-buffer cmp-buffer-src);
    cmp-nvim-lsp = withSrc prev.vimPlugins.cmp-nvim-lsp cmp-nvim-lsp-src;
    cmp-nvim-lua = withSrc prev.vimPlugins.cmp-nvim-lua cmp-nvim-lua-src;
    cmp-path = (withSrc prev.vimPlugins.cmp-path cmp-path-src);
    crates-nvim = plugin "crates-nvim" crates-nvim-src;
    comment-nvim = plugin "comment-nvim" comment-nvim-src;
    conceal = plugin "conceal" conceal-src;
    diffview-nvim = plugin "diffview-nvim" diffview-nvim-src;
    fidget-nvim = plugin "fidget-nvim" fidget-nvim-src;
    gitsigns-nvim = plugin "gitsigns-nvim" gitsigns-nvim-src;
    heirline-nvim = plugin "heirline-nvim" heirline-nvim-src;
    kanagawa-nvim = plugin "kanagawa-nvim" kanagawa-nvim-src;
    lspkind-nvim = (withSrc prev.vimPlugins.lspkind-nvim lspkind-nvim-src);
    lualine-nvim = (withSrc prev.vimPlugins.lualine-nvim lualine-nvim-src);
    neogit = plugin "neogit" neogit-src;
    null-ls-nvim = plugin "null-ls-nvim" null-ls-nvim-src;
    nvim-cmp = (withSrc prev.vimPlugins.nvim-cmp nvim-cmp-src);
    nvim-colorizer = plugin "nvim-colorizer" nvim-colorizer-src;
    nvim-dap = (withSrc prev.vimPlugins.nvim-dap nvim-dap-src);
    nvim-dap-ui = (withSrc prev.vimPlugins.nvim-dap-ui nvim-dap-ui-src);
    nvim-dap-virtual-text = (withSrc prev.vimPlugins.nvim-dap-virtual-text nvim-dap-virtual-text-src);
    nvim-jdtls = plugin "nvim-jdtls" nvim-jdtls-src;
    nvim-lspconfig = (withSrc prev.vimPlugins.nvim-lspconfig nvim-lspconfig-src);
    nvim-treesitter = (withSrc prev.vimPlugins.nvim-treesitter nvim-treesitter-src);
    nvim-treesitter-context = plugin "nvim-treesitter-context" nvim-treesitter-context-src;
    nvim-treesitter-playground = (withSrc prev.vimPlugins.playground nvim-treesitter-playground-src);
    nvim-web-devicons = plugin "nvim-web-devicons" nvim-web-devicons-src;
    plenary-nvim = (withSrc prev.vimPlugins.plenary-nvim plenary-nvim-src);
    popup-nvim = (withSrc prev.vimPlugins.popup-nvim popup-nvim-src);
    rust-tools-nvim = plugin "rust-tools" rust-tools-nvim-src;
    telescope-nvim = plugin "telescope-nvim" telescope-nvim-src;
    telescope-dap-nvim = plugin "telescope-dap-nvim" telescope-dap-nvim-src;
    telescope-ui-select = plugin "telescope-ui-select" telescope-ui-select-src;
    tokyonight-nvim = plugin "tokyonight-nvim" tokyonight-nvim-src;
    tree-sitter-lua = plugin "tree-sitter-lua" tree-sitter-lua-src;
    trouble-nvim = plugin "trouble-nvim" trouble-nvim-src;
    which-key-nvim = plugin "which-key-nvim" which-key-nvim-src;
  };
}
