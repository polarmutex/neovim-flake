{
  pkgs,
  lib,
  ...
}: let
  buildLuaConfigPlugin = {
    configDir,
    moduleName,
    vars ? null,
    replacements ? null,
    excludeFiles ? [],
  }: let
    pname = "${moduleName}";
  in (pkgs.vimUtils.buildVimPluginFrom2Nix {
    inherit pname;
    version = "dev";
    src = configDir;
    postUnpack = ''
      #mkdir -p $sourceRoot/lua
      #mv $sourceRoot/lua $sourceRoot/lua
      mkdir -p $sourceRoot/doc
      ${pkgs.lemmy-help}/bin/lemmy-help -fact \
          $sourceRoot/lua/polarmutex/config/lazy.lua \
          $sourceRoot/lua/polarmutex/config/keymaps.lua \
          > $sourceRoot/doc/polarmutex.txt
    '';
    postInstall = let
      inherit (builtins) attrNames attrValues;
      subs =
        lib.concatStringsSep " "
        (lib.lists.zipListsWith (f: t: "--subst-var-by ${f} ${t}") (attrNames vars) (attrValues vars));
    in
      ''''
      + lib.optionalString
      (vars != null)
      ''
        for filename in $(find $out -type f -print)
        do
          substituteInPlace $filename ${subs}
        done
      '';
    meta = with lib; {
      homepage = "";
      description = "polarmutex neovim configuration";
      license = licenses.mit;
      maintainers = [maintainers.polarmutex];
    };
  });
in
  buildLuaConfigPlugin {
    configDir = ../config;
    moduleName = "polarmutex";
    excludeFiles = []; #if builtins.isNull config then [ ] else [ "user.lua" ];
    vars = {
      "astro.language-server" = lib.getExe pkgs.nodePackages."@astrojs/language-server";
      "beancount.beancount-language-server" = pkgs.beancount-language-server;
      "cpp.clangd" = pkgs.clang-tools;
      "go.gopls" =
        pkgs.gopls;
      "json.jsonls" =
        lib.getExe pkgs.nodePackages.vscode-json-languageserver;
      "java.debug.plugin" =
        (pkgs.fetchMavenArtifact
          {
            groupId = "com.microsoft.java";
            artifactId = "com.microsoft.java.debug.plugin";
            version = "0.34.0";
            sha256 = "sha256-vKvTHA17KPhvxCwI6XdQX3Re2z7vyMhObM9l3QOcrAM=";
          })
        .jar;
      "java.jdt-language-server" =
        pkgs.jdt-language-server;
      "rust.dprint" =
        pkgs.dprint;
      "lua.luacheck" =
        pkgs.luajitPackages.luacheck;
      "lua.sumneko-lua-language-server" =
        pkgs.lua-language-server;
      "lua.stylua" =
        pkgs.stylua;
      "nix.nil" =
        lib.getExe pkgs.nil-git;
      "nix.alejandra" =
        pkgs.alejandra;
      "python.pyright" =
        pkgs.pyright;
      "rust.analyzer" =
        pkgs.lib.getExe pkgs.rust-analyzer;
      "rust.clippy" =
        pkgs.clippy;
      "svelte.svelte-language-server" =
        pkgs.lib.getExe pkgs.nodePackages.svelte-language-server;
      "typescript.typescript-language-server" =
        lib.getExe pkgs.nodePackages.typescript-language-server;

      "neovimPlugin.beancount-nvim" =
        pkgs.neovimPlugins.beancount-nvim;
      "neovimPlugin.cmp-nvim-lsp" =
        pkgs.neovimPlugins.cmp-nvim-lsp;
      "neovimPlugin.cmp-path" =
        pkgs.neovimPlugins.cmp-path;
      "neovimPlugin.cmp-omni" =
        pkgs.neovimPlugins.cmp-omni;
      "neovimPlugin.cmp-calc" =
        pkgs.neovimPlugins.cmp-calc;
      "neovimPlugin.cmp-buffer" =
        pkgs.neovimPlugins.cmp-buffer;
      "neovimPlugin.cmp-cmdline" =
        pkgs.neovimPlugins.cmp-cmdline;
      "neovimPlugin.cmp-dap" =
        pkgs.neovimPlugins.cmp-dap;
      "neovimPlugin.crates-nvim" =
        pkgs.neovimPlugins.crates-nvim;
      "neovimPlugin.diffview-nvim" =
        pkgs.neovimPlugins.diffview-nvim;
      "neovimPlugin.gitsigns-nvim" =
        pkgs.neovimPlugins.gitsigns-nvim;
      "neovimPlugin.gitworktree-nvim" =
        pkgs.neovimPlugins.git-worktree-nvim;
      "neovimPlugin.harpoon" =
        pkgs.neovimPlugins.harpoon;
      "neovimPlugin.heirline-nvim" =
        pkgs.neovimPlugins.heirline-nvim;
      "neovimPlugin.lazy-nvim" =
        pkgs.neovimPlugins.lazy-nvim;
      "neovimPlugin.lspkind-nvim" =
        pkgs.neovimPlugins.lspkind-nvim;
      "neovimPlugin.lspformat-nvim" =
        pkgs.neovimPlugins.lsp-format-nvim;
      "neovimPlugin.neodev-nvim" =
        pkgs.neovimPlugins.neodev-nvim;
      "neovimPlugin.neogit" =
        pkgs.neovimPlugins.neogit;
      "neovimPlugin.noice-nvim" =
        pkgs.neovimPlugins.noice-nvim;
      "neovimPlugin.nui-nvim" =
        pkgs.neovimPlugins.nui-nvim;
      "neovimPlugin.null-ls-nvim" =
        pkgs.neovimPlugins.null-ls-nvim;
      "neovimPlugin.nvim-cmp" =
        pkgs.neovimPlugins.nvim-cmp;
      "neovimPlugin.nvim-colorizer" =
        pkgs.neovimPlugins.nvim-colorizer;
      "neovimPlugin.nvim-dap" =
        pkgs.neovimPlugins.nvim-dap;
      "neovimPlugin.nvim-dap-python" =
        pkgs.neovimPlugins.nvim-dap-python;
      "neovimPlugin.nvim-dap-ui" =
        pkgs.neovimPlugins.nvim-dap-ui;
      "neovimPlugin.nvim-dap-virtual-text" =
        pkgs.neovimPlugins.nvim-dap-virtual-text;
      "neovimPlugin.nvim-lspconfig" =
        pkgs.neovimPlugins.nvim-lspconfig;
      "neovimPlugin.nvim-jdtls" =
        pkgs.neovimPlugins.nvim-jdtls;
      "neovimPlugin.nvim-treesitter" =
        pkgs.nvim-treesitter-master;
      "neovimPlugin.nvim-treesitter-playground" =
        pkgs.neovimPlugins.nvim-treesitter-playground;
      "neovimPlugin.one-small-step-for-vimkind" =
        pkgs.neovimPlugins.one-small-step-for-vimkind;
      "neovimPlugin.plenary-nvim" =
        pkgs.neovimPlugins.plenary-nvim;
      "neovimPlugin.rust-tools-nvim" =
        pkgs.neovimPlugins.rust-tools-nvim;
      "neovimPlugin.telescope-nvim" =
        pkgs.neovimPlugins.telescope-nvim;
      "neovimPlugin.tokyonight-nvim" =
        pkgs.neovimPlugins.tokyonight-nvim;
      "neovimPlugin.vim-be-good" =
        pkgs.neovimPlugins.vim-be-good;
      "neovimPlugin.nvim-web-devicons" =
        pkgs.neovimPlugins.nvim-web-devicons;
    };
  }
