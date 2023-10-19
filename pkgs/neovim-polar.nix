{
  lib,
  packages,
  pkgs,
  ...
}: let
  # NVIM_APPNAME - Defaults to 'nvim'
  appName = null;

  # List of plugins
  plugins = with packages; [
    polar-lua-config
    neovim-plugin-beancount-nvim
    neovim-plugin-cmp-dap
    neovim-plugin-cmp-emoji
    neovim-plugin-cmp-nvim-lsp
    neovim-plugin-cmp-path
    neovim-plugin-crates-nvim
    neovim-plugin-diffview-nvim
    neovim-plugin-dressing-nvim
    neovim-plugin-edgy-nvim
    neovim-plugin-flash-nvim
    neovim-plugin-friendly-snippets
    neovim-plugin-git-worktree-nvim
    neovim-plugin-gitsigns-nvim
    neovim-plugin-harpoon
    neovim-plugin-lualine-nvim
    neovim-plugin-luasnip
    neovim-plugin-kanagawa-nvim
    neovim-plugin-mini-indentscope
    neovim-plugin-neodev-nvim
    neovim-plugin-neogit
    neovim-plugin-noice-nvim
    neovim-plugin-nui-nvim
    neovim-plugin-null-ls-nvim
    neovim-plugin-nvim-cmp
    neovim-plugin-nvim-colorizer
    neovim-plugin-nvim-dap
    neovim-plugin-nvim-dap-python
    neovim-plugin-nvim-dap-ui
    neovim-plugin-nvim-dap-virtual-text
    neovim-plugin-nvim-jdtls
    neovim-plugin-nvim-lspconfig
    neovim-plugin-nvim-navic
    neovim-plugin-nvim-treesitter
    neovim-plugin-nvim-treesitter-playground
    neovim-plugin-nvim-web-devicons
    neovim-plugin-one-small-step-for-vimkind
    neovim-plugin-overseer-nvim
    neovim-plugin-plenary-nvim
    neovim-plugin-sqlite-lua
    neovim-plugin-telescope-nvim
    neovim-plugin-tokyonight-nvim
    neovim-plugin-trouble-nvim
    neovim-plugin-vim-be-good
    neovim-plugin-vim-illuminate
    neovim-plugin-which-key-nvim
    neovim-plugin-yanky-nvim
  ];
  # List of dev plugins (will be bootstrapped)
  devPlugins = [];

  # Extra runtime dependencies (e.g. ripgrep, ...
  externalPackages = with pkgs; [
    # lua
    lua-language-server
    luajitPackages.luacheck
    stylua

    # markdown
    markdownlint-cli
    mdformat-with-plugins

    #nix
    nil-git
    deadnix
    statix
    alejandra

    # python
    ruff
    black
  ];
  # Additional python 3 packages
  extraPython3Packages = p: [];

  wrapRc = true;

  viAlias = true;
  vimAlias = true;

  withPython3 = true;
  withRuby = true;
  withNodeJs = true;

  defaultPlugin = {
    plugin = null; # e.g. nvim-lspconfig
    config = null; # plugin config
    optional = false;
    runtime = {};
  };
  normalizedPlugins = map (x:
    defaultPlugin
    // (
      if x ? plugin
      then x
      else {plugin = x;}
    ))
  plugins;

  neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
    inherit extraPython3Packages withPython3 withRuby withNodeJs viAlias vimAlias;
    plugins = normalizedPlugins;
  };

  customRC =
    ''
      vim.loader.enable()
    ''
    + (builtins.readFile ../nvim/init.lua)
    + neovimConfig.neovimRcContent
    + lib.optionalString (devPlugins != []) (
      ''
        local dev_pack_path = vim.fn.stdpath('data') .. '/site/pack/dev'
        local dev_plugins_dir = dev_pack_path .. '/opt'
        local dev_plugin_path
      ''
      + lib.strings.concatMapStringsSep
      "\n"
      (plugin: ''
        dev_plugin_path = dev_plugins_dir .. '/${plugin.name}'
        if vim.fn.empty(vim.fn.glob(dev_plugin_path)) > 0 then
          vim.notify('Bootstrapping dev plugin ${plugin.name} ...', vim.log.levels.INFO)
          vim.cmd('!${pkgs.git}/bin/git clone ${plugin.url} ' .. dev_plugin_path)
        end
        vim.cmd('packadd! ${plugin.name}')
      '')
      devPlugins
    )
    + ''
    '';

  extraMakeWrapperArgs = builtins.concatStringsSep " " (
    (lib.optional (appName != "nvim" && appName != null && appName != "")
      ''--set NVIM_APPNAME "${appName}"'')
    ++ (lib.optional (externalPackages != [])
      ''--prefix PATH : "${lib.makeBinPath externalPackages}"'')
    ++ (lib.optional wrapRc
      ''--add-flags -u --add-flags "${pkgs.writeText "init.lua" customRC}"'')
    #++ (lib.optional withSqlite
    #  ''--set LIBSQLITE_CLIB_PATH "${pkgs.sqlite.out}/lib/libsqlite3.so"'')
    #++ (lib.optional withSqlite
    #  ''--set LIBSQLITE "${pkgs.sqlite.out}/lib/libsqlite3.so"'')
  );
in
  pkgs.wrapNeovimUnstable packages.neovim-git
  (neovimConfig
    // {
      wrapperArgs =
        lib.escapeShellArgs neovimConfig.wrapperArgs
        + " "
        + extraMakeWrapperArgs;
      wrapRc = true;
    })
