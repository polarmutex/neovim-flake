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

      (buildPlugin "beancount-nvim" pkgs.neovimPlugins.beancount-nvim)
      (buildPlugin "cmp-nvim-lsp" pkgs.neovimPlugins.cmp-nvim-lsp)
      (buildPlugin "cmp-path" pkgs.neovimPlugins.cmp-path)
      (buildPlugin "cmp-omni" pkgs.neovimPlugins.cmp-omni)
      (buildPlugin "cmp-calc" pkgs.neovimPlugins.cmp-calc)
      (buildPlugin "cmp-buffer" pkgs.neovimPlugins.cmp-buffer)
      (buildPlugin "cmp-cmdine" pkgs.neovimPlugins.cmp-cmdline)
      (buildPlugin "cmp-dap" pkgs.neovimPlugins.cmp-dap)
      (buildPlugin "crates-nvim" pkgs.neovimPlugins.crates-nvim)
      (buildPlugin "diffview-nvim" pkgs.neovimPlugins.diffview-nvim)
      (buildPlugin "gitsigns-nvim" pkgs.neovimPlugins.gitsigns-nvim)
      (buildPlugin "git-worktree-nvim" pkgs.neovimPlugins.git-worktree-nvim)
      (buildPlugin "harpoon" pkgs.neovimPlugins.harpoon)
      (buildPlugin "heirline-nvim" pkgs.neovimPlugins.heirline-nvim)
      (buildPlugin "lazy-nvim" pkgs.neovimPlugins.lazy-nvim)
      (buildPlugin "lspkind-nvim" pkgs.neovimPlugins.lspkind-nvim)
      (buildPlugin "lsp-format-nvim" pkgs.neovimPlugins.lsp-format-nvim)
      (buildPlugin "neodev-nvim" pkgs.neovimPlugins.neodev-nvim)
      (buildPlugin "neogit" pkgs.neovimPlugins.neogit)
      (buildPlugin "noice-nvim" pkgs.neovimPlugins.noice-nvim)
      (buildPlugin "nui-nvim" pkgs.neovimPlugins.nui-nvim)
      (buildPlugin "null-ls" pkgs.neovimPlugins.null-ls-nvim)
      (buildPlugin "nvim-cmp" pkgs.neovimPlugins.nvim-cmp)
      (buildPlugin "nvim-colorizer" pkgs.neovimPlugins.nvim-colorizer)
      (buildPlugin "nvim-dap" pkgs.neovimPlugins.nvim-dap)
      (buildPlugin "nvim-dap-python" pkgs.neovimPlugins.nvim-dap-python)
      (buildPlugin "nvim-dap-ui" pkgs.neovimPlugins.nvim-dap-ui)
      (buildPlugin "nvim-dap-virtual-text" pkgs.neovimPlugins.nvim-dap-virtual-text)
      (buildPlugin "nvim-lspconfig" pkgs.neovimPlugins.nvim-lspconfig)
      (buildPlugin "nvim-jdtls" pkgs.neovimPlugins.nvim-jdtls)
      pkgs.nvim-treesitter-master
      (buildPlugin "nvim-treesitter-playground" pkgs.neovimPlugins.nvim-treesitter-playground)
      (buildPlugin "one-small-step-for-vimkind" pkgs.neovimPlugins.one-small-step-for-vimkind)
      (buildPlugin "plenary-nvim" pkgs.neovimPlugins.plenary-nvim)
      (buildPlugin "rust-tools-nvim" pkgs.neovimPlugins.rust-tools-nvim)
      (buildPlugin "telescope-nvim" pkgs.neovimPlugins.telescope-nvim)
      (buildPlugin "tokyonight-nvim" pkgs.neovimPlugins.tokyonight-nvim)
      (buildPlugin "vim-be-good" pkgs.neovimPlugins.vim-be-good)
      (buildPlugin "nvim-web-devicons" pkgs.neovimPlugins.nvim-web-devicons)
    ];
  }
