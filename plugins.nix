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
    cmp-buffer = (withSrc prev.vimPlugins.cmp-buffer cmp-buffer-src);
    cmp-nvim-lsp = withSrc prev.vimPlugins.cmp-nvim-lsp cmp-nvim-lsp-src;
    cmp-nvim-lua = withSrc prev.vimPlugins.cmp-nvim-lua cmp-nvim-lua-src;
    cmp-path = (withSrc prev.vimPlugins.cmp-path cmp-path-src);
    colorizer = plugin "colorizer" colorizer-src;
    comment-nvim = plugin "comment-nvim" comment-nvim-src;
    conceal = plugin "conceal" conceal-src;
    fidget = plugin "fidget" fidget-src;
    gitsigns-nvim = plugin "gitsigns-nvim" gitsigns-nvim-src;
    kanagawa-nvim = plugin "kanagawa-nvim" kanagawa-nvim-src;
    lspkind-nvim = (withSrc prev.vimPlugins.lspkind-nvim lspkind-nvim-src);
    lualine-nvim = (withSrc prev.vimPlugins.lualine-nvim lualine-nvim-src);
    neogit = plugin "neogit" neogit-src;
    null-ls-nvim = plugin "null-ls-nvim" null-ls-nvim-src;
    nvim-cmp = (withSrc prev.vimPlugins.nvim-cmp nvim-cmp-src);
    nvim-jdtls = plugin "nvim-jdtls" nvim-jdtls-src;
    nvim-lspconfig = (withSrc prev.vimPlugins.nvim-lspconfig nvim-lspconfig-src);
    nvim-treesitter = (withSrc prev.vimPlugins.nvim-treesitter nvim-treesitter-src);
    plenary-nvim = (withSrc prev.vimPlugins.plenary-nvim plenary-nvim-src);
    popup-nvim = (withSrc prev.vimPlugins.popup-nvim popup-nvim-src);
    rust-tools = plugin "rust-tools" rust-tools-src;
    telescope-nvim = plugin "telescope-nvim" telescope-nvim-src;
    telescope-ui-select = plugin "telescope-ui-select" telescope-ui-select-src;
    tokyonight-nvim = plugin "tokyonight-nvim" tokyonight-nvim-src;
    which-key = plugin "which-key" which-key-src;
  };
}
