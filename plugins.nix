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

  # LSP
  null-ls-nvim = (withSrc prev.vimPlugins.null-ls-nvim null-ls-nvim-src);
  rnix-lsp = inputs.rnix-lsp.packages.${prev.system}.rnix-lsp;

  # Treesitter
  nvim-treesitter =
    (withSrc prev.vimPlugins.nvim-treesitter nvim-treesitter-src);

  # Telescope
  telescope-nvim = (withSrc prev.vimPlugins.telescope-nvim inputs.telescope-src);

  # Auto-complete
  nvim-cmp = (withSrc prev.vimPlugins.nvim-cmp inputs.nvim-cmp);
  cmp-buffer = (withSrc prev.vimPlugins.cmp-buffer inputs.cmp-buffer);
  cmp-nvim-lsp = withSrc prev.vimPlugins.cmp-nvim-lsp inputs.cmp-nvim-lsp;

  # Colorschemes
  tokyonight-nvim = plugin "tokyonight-nvim" tokyonight-nvim-src;

  # Example of packaging plugin with Nix
  blamer-nvim = plugin "blamer-nvim" blamer-nvim-src;
  colorizer = plugin "colorizer" colorizer-src;
  comment-nvim = plugin "comment-nvim" comment-nvim-src;
  conceal = plugin "conceal" conceal-src;
  dracula = plugin "dracula" dracula-nvim;
  fidget = plugin "fidget" fidget-src;
  neogen = plugin "neogen" neogen-src;
  parinfer-rust-nvim = plugin "parinfer-rust" prev.parinfer-rust;
  rust-tools = plugin "rust-tools" rust-tools-src;
  telescope-ui-select = plugin "telescope-ui-select" telescope-ui-select-src;
  which-key = plugin "which-key" which-key-src;
}
