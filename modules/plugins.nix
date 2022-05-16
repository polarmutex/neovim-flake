{ pkgs, dsl, ... }:
with dsl; {
  plugins = with pkgs; [

    # lsp
    null-ls-nvim

    # completion framework
    cmp-nvim-lsp
    nvim-cmp
    cmp-buffer

    # lsp things
    vimPlugins.lsp_signature-nvim
    vimPlugins.lspkind-nvim
    vimPlugins.nvim-lspconfig

    # utility functions for lsp
    vimPlugins.plenary-nvim

    # popout for documentation
    vimPlugins.popup-nvim

    # more lsp rust functionality
    #rust-tools

    # for updating rust crates
    vimPlugins.crates-nvim

    # for showing lsp progress
    #fidget

    # themes
    tokyonight-nvim

    # which method am I on
    #vimPlugins.nvim-treesitter-context
    (nvim-treesitter.withPlugins
      # tree sitter with language support
      (plugins:
        with plugins; [
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
  ];

}
