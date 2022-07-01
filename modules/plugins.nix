{ pkgs, dsl, ... }:
with dsl; {
  plugins = with pkgs.neovimPlugins; [

    beancount-nvim
    colorizer
    # completion
    nvim-cmp
    cmp-buffer
    cmp-nvim-lsp
    cmp-nvim-lua
    cmp-path

    # lsp
    nvim-lspconfig
    lspkind-nvim
    null-ls-nvim
    fidget
    nvim-jdtls
    #vimPlugins.lsp_signature-nvim

    # git
    neogit
    gitsigns-nvim

    # utility p for lua
    plenary-nvim
    popup-nvim

    # telescope
    telescope-nvim

    # themes
    tokyonight-nvim
    kanagawa-nvim

    # treesitter
    (nvim-treesitter.withPlugins
      # tree sitter with language support
      (plugins:
        with plugins; [
          tree-sitter-astro
          tree-sitter-beancount
          tree-sitter-c
          tree-sitter-cpp
          tree-sitter-go
          tree-sitter-html
          tree-sitter-java
          tree-sitter-json
          tree-sitter-lua
          tree-sitter-markdown
          tree-sitter-nix
          tree-sitter-python
          tree-sitter-rust
          tree-sitter-svelte
          tree-sitter-typescript
        ]))
    nvim-treesitter-playground

    lualine-nvim
  ];
}
