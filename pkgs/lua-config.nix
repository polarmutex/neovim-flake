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
    luaSrc =
      builtins.filterSource
      (path: type:
        (lib.hasSuffix ".lua" path)
        && ! (lib.lists.any (x: baseNameOf path == x) excludeFiles))
      configDir;
  in (pkgs.vimUtils.buildVimPluginFrom2Nix {
    inherit pname;
    version = "dev";
    src = configDir;
    postUnpack = ''
      mkdir -p $sourceRoot/lua
      mv $sourceRoot/polarmutex $sourceRoot/lua
      mkdir -p $sourceRoot/doc
      ${pkgs.lemmy-help}/bin/lemmy-help -fact \
          $sourceRoot/lua/polarmutex/config/lazy.lua \
          $sourceRoot/lua/polarmutex/config/keymaps.lua \
          > $sourceRoot/doc/polarmutex.txt
    '';
    postInstall = let
      subs =
        lib.concatStringsSep " "
        (lib.lists.zipListsWith (f: t: "--subst-var-by ${f} ${t}") vars replacements);
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

  buildPlugin = pname: src:
  # TODO build neovim plugin
    pkgs.vimUtils.buildVimPluginFrom2Nix {
      inherit pname src;
      version = src.revision;
    };
in
  buildLuaConfigPlugin {
    configDir = ../lua;
    moduleName = "polarmutex";
    excludeFiles = []; #if builtins.isNull config then [ ] else [ "user.lua" ];
    vars = [
      "astro.language-server"
      "beancount.beancount-language-server"
      "cpp.clangd"
      "go.gopls"
      "json.jsonls"
      "java.debug.plugin"
      "java.jdt-language-server"
      "rust.dprint"
      "lua.sumneko-lua-language-server"
      "lua.stylua"
      "nix.nil"
      "nix.alejandra"
      "python.pyright"
      "rust.analyzer"
      "rust.clippy"
      "svelte.svelte-language-server"
      "typescript.typescript-language-server"

      "neovimPlugin.beancount-nvim"
      "neovimPlugin.cmp-nvim-lsp"
      "neovimPlugin.cmp-path"
      "neovimPlugin.cmp-omni"
      "neovimPlugin.cmp-calc"
      "neovimPlugin.cmp-buffer"
      "neovimPlugin.cmp-cmdline"
      "neovimPlugin.cmp-dap"
      "neovimPlugin.crates-nvim"
      "neovimPlugin.diffview-nvim"
      "neovimPlugin.gitsigns-nvim"
      "neovimPlugin.gitworktree-nvim"
      "neovimPlugin.harpoon"
      "neovimPlugin.heirline-nvim"
      "neovimPlugin.lazy-nvim"
      "neovimPlugin.lspkind-nvim"
      "neovimPlugin.lspformat-nvim"
      "neovimPlugin.neodev-nvim"
      "neovimPlugin.neogit"
      "neovimPlugin.noice-nvim"
      "neovimPlugin.nui-nvim"
      "neovimPlugin.null-ls-nvim"
      "neovimPlugin.nvim-cmp"
      "neovimPlugin.nvim-colorizer"
      "neovimPlugin.nvim-dap"
      "neovimPlugin.nvim-dap-python"
      "neovimPlugin.nvim-dap-ui"
      "neovimPlugin.nvim-dap-virtual-text"
      "neovimPlugin.nvim-lspconfig"
      "neovimPlugin.nvim-jdtls"
      "neovimPlugin.nvim-treesitter"
      "neovimPlugin.nvim-treesitter-playground"
      "neovimPlugin.one-small-step-for-vimkind"
      "neovimPlugin.plenary-nvim"
      "neovimPlugin.rust-tools-nvim"
      "neovimPlugin.telescope-nvim"
      "neovimPlugin.tokyonight-nvim"
      "neovimPlugin.vim-be-good"
      "neovimPlugin.nvim-web-devicons"
    ];
    replacements = [
      (lib.getExe pkgs.nodePackages."@astrojs/language-server")
      (pkgs.beancount-language-server)
      (pkgs.clang-tools)
      (pkgs.gopls)
      (lib.getExe pkgs.nodePackages.vscode-json-languageserver)
      (pkgs.fetchMavenArtifact
        {
          groupId = "com.microsoft.java";
          artifactId = "com.microsoft.java.debug.plugin";
          version = "0.34.0";
          sha256 = "sha256-vKvTHA17KPhvxCwI6XdQX3Re2z7vyMhObM9l3QOcrAM=";
        })
      .jar
      (pkgs.jdt-language-server)
      (pkgs.dprint)
      (pkgs.lua-language-server)
      (pkgs.stylua)
      (lib.getExe pkgs.nil)
      (pkgs.alejandra)
      (pkgs.pyright)
      (pkgs.lib.getExe pkgs.rust-analyzer)
      (pkgs.clippy)
      (pkgs.lib.getExe pkgs.nodePackages.svelte-language-server)
      (lib.getExe pkgs.nodePackages.typescript-language-server)

      pkgs.neovimPlugins.beancount-nvim
      pkgs.neovimPlugins.cmp-nvim-lsp
      pkgs.neovimPlugins.cmp-path
      pkgs.neovimPlugins.cmp-omni
      pkgs.neovimPlugins.cmp-calc
      pkgs.neovimPlugins.cmp-buffer
      pkgs.neovimPlugins.cmp-cmdline
      pkgs.neovimPlugins.cmp-dap
      pkgs.neovimPlugins.crates-nvim
      pkgs.neovimPlugins.diffview-nvim
      pkgs.neovimPlugins.gitsigns-nvim
      pkgs.neovimPlugins.git-worktree-nvim
      pkgs.neovimPlugins.harpoon
      pkgs.neovimPlugins.heirline-nvim
      pkgs.neovimPlugins.lazy-nvim
      pkgs.neovimPlugins.lspkind-nvim
      pkgs.neovimPlugins.lsp-format-nvim
      pkgs.neovimPlugins.neodev-nvim
      pkgs.neovimPlugins.neogit
      pkgs.neovimPlugins.noice-nvim
      pkgs.neovimPlugins.nui-nvim
      pkgs.neovimPlugins.null-ls-nvim
      pkgs.neovimPlugins.nvim-cmp
      pkgs.neovimPlugins.nvim-colorizer
      pkgs.neovimPlugins.nvim-dap
      pkgs.neovimPlugins.nvim-dap-python
      pkgs.neovimPlugins.nvim-dap-ui
      pkgs.neovimPlugins.nvim-dap-virtual-text
      pkgs.neovimPlugins.nvim-lspconfig
      (pkgs.neovimPlugins.nvim-jdtls)
      pkgs.nvim-treesitter-master
      pkgs.neovimPlugins.nvim-treesitter-playground
      pkgs.neovimPlugins.one-small-step-for-vimkind
      pkgs.neovimPlugins.plenary-nvim
      pkgs.neovimPlugins.rust-tools-nvim
      pkgs.neovimPlugins.telescope-nvim
      pkgs.neovimPlugins.tokyonight-nvim
      pkgs.neovimPlugins.vim-be-good
      pkgs.neovimPlugins.nvim-web-devicons
    ];
  }
