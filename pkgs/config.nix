{
  inputs,
  pkgs,
  pinned-start-plugins,
  pinned-opt-plugins,
  ...
}: let
  # Custom tree-sitter-beancount from devel branch
  ts-grammars-sources = import ../npins-ts-grammars;
  custom-tree-sitter-beancount = pkgs.tree-sitter.buildGrammar {
    language = "beancount";
    version = "devel-${builtins.substring 0 8 ts-grammars-sources.tree-sitter-beancount.revision}";
    src = ts-grammars-sources.tree-sitter-beancount;
  };
in {
  appName = "nvim-polar";

  inherit (pkgs) neovim;
  # inherit (import sources.neovim-nightly-overlay neovim {});
  extraLuaPackages = p: [p.jsregexp];

  providers = {
    ruby.enable = true;
    python3.enable = true;
    nodeJs.enable = true;
    perl.enable = true;
  };

  # Source lua config
  initLua = ''
    require('polar')
  '';

  desktopEntry = true;

  plugins = {
    dev.polar = {
      pure = ../polar;
      impure = "~/repos/personal/neovim-flake/main/polar";
    };

    start =
      [
        # pinned-plugins.which-key-nvim
        # pinned-plugins.yanky-nvim
        #
        # Add plugins from nixpkgs here
        #
        inputs.self.packages.${pkgs.stdenv.system}.blink-cmp
        # pkgs.vimPlugins.nvim-treesitter.withAllGrammars
        (pkgs.vimPlugins.nvim-treesitter.withPlugins (grammars:
          with grammars; [
            tree-sitter-bash
            custom-tree-sitter-beancount
            tree-sitter-c
            tree-sitter-cmake
            tree-sitter-cpp
            tree-sitter-dockerfile
            tree-sitter-fish
            tree-sitter-git_config
            tree-sitter-git_rebase
            tree-sitter-gitcommit
            tree-sitter-gitignore
            tree-sitter-hcl
            tree-sitter-ini
            tree-sitter-java
            tree-sitter-json
            tree-sitter-lua
            tree-sitter-make
            tree-sitter-markdown
            tree-sitter-markdown-inline
            tree-sitter-mermaid
            tree-sitter-nix
            tree-sitter-puppet
            tree-sitter-python
            tree-sitter-rasi
            tree-sitter-rust
            tree-sitter-toml
            tree-sitter-typescript
            tree-sitter-vimdoc
            tree-sitter-yaml
          ]))
      ]
      ++ pinned-start-plugins;
    opt = pinned-opt-plugins;
  };

  #
  # Runtime dependencies
  #
  extraBinPath = with pkgs; [
    # general
    fd
    fswatch # for lsp file watching
    ripgrep
    xsel # for clipboard
    vscode-langservers-extracted
    inputs.mcp-hub.packages."${system}".default

    # arduino
    # arduino-cli

    # cpp
    clang
    clang-tools
    cpplint
    cppcheck

    # java
    jdt-language-server

    # lua
    lua-language-server
    luajitPackages.luacheck
    stylua

    # markdown
    prettierd
    markdownlint-cli

    #nix
    nil
    nixd
    deadnix
    statix
    alejandra

    # python
    (python313.withPackages (ps:
      with ps; [
        black
        python-lsp-server
        python-lsp-black
        # :.overrideAttrs
        # (oldAttrs: {
        #   patches =
        #     oldAttrs.patches
        #     /*
        #     fix test failure with black>=24.3.0;
        #     remove this patch once python-lsp-black>2.0.0
        #     */
        #     ++ lib.optional
        #     (with lib; (versionOlder version "2.0.1") && (versionAtLeast black.version "24.3.0"))
        #     (fetchpatch {
        #       url = "https://patch-diff.githubusercontent.com/raw/python-lsp/python-lsp-black/pull/59.patch";
        #       hash = "sha256-4u0VIS7eidVEiKRW2wc8lJVkJwhzJD/M+uuqmTtiZ7E=";
        #     });
        # })
        python-lsp-ruff
        pydocstyle
        debugpy
      ]))
    ruff
    basedpyright

    # rust
    rust-analyzer

    # typescript
    vtsls

    # yaml
    nodePackages_latest.yaml-language-server
  ];
}
