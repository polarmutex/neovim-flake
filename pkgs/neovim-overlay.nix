{
  inputs,
  polar-lua-config,
}: final: prev:
with final.lib; let
  mkNeovim = {
    appName ? null,
    plugins ? [],
    devPlugins ? [],
    extraPackages ? [],
    resolvedExtraLuaPackages ? [],
    extraPython3Packages ? p: [],
    withPython3 ? true,
    withRuby ? false,
    withNodeJs ? false,
    viAlias ? true,
    vimAlias ? true,
  }: let
    defaultPlugin = {
      plugin = null;
      config = null;
      optional = false;
      runtime = {};
    };

    externalPackages = extraPackages ++ [final.sqlite];

    normalizedPlugins = map (x:
      defaultPlugin
      // (
        if x ? plugin
        then x
        else {plugin = x;}
      ))
    plugins;

    neovimConfig = final.neovimUtils.makeNeovimConfig {
      inherit extraPython3Packages withPython3 withRuby withNodeJs viAlias vimAlias;
      plugins = normalizedPlugins;
    };

    nvimConfig = final.stdenv.mkDerivation {
      name = "nvim-config";
      src = ../nvim;

      buildPhase = ''
        mkdir -p $out/nvim
        rm init.lua
      '';

      installPhase = ''
        cp -r * $out/nvim
        rm -r $out/nvim/after
        cp -r after $out/after
        ln -s ${inputs.spell-en-dictionary} $out/nvim/spell/en.utf-8.spl;
        ln -s ${inputs.spell-en-suggestions} $out/nvim/spell/en.utf-8.sug;
      '';
    };

    initLua =
      ''
        vim.loader.enable()
      ''
      + ""
      + (builtins.readFile ../nvim/init.lua)
      + ""
      + optionalString (devPlugins != []) (
        ''
          local dev_pack_path = vim.fn.stdpath('data') .. '/site/pack/dev'
          local dev_plugins_dir = dev_pack_path .. '/opt'
          local dev_plugin_path
        ''
        + strings.concatMapStringsSep
        "\n"
        (plugin: ''
          dev_plugin_path = dev_plugins_dir .. '/${plugin.name}'
          if vim.fn.empty(vim.fn.glob(dev_plugin_path)) > 0 then
            vim.notify('Bootstrapping dev plugin ${plugin.name} ...', vim.log.levels.INFO)
            vim.cmd('!ln -s  ${plugin.path} ' .. dev_plugin_path)
          end
          vim.cmd('packadd! ${plugin.name}')
        '')
        devPlugins
      );

    extraMakeWrapperArgs = builtins.concatStringsSep " " (
      (optional (appName != "nvim" && appName != null && appName != "")
        ''--set NVIM_APPNAME "${appName}"'')
      ++ (optional (externalPackages != [])
        ''--prefix PATH : "${makeBinPath externalPackages}"'')
      ++ [
        ''--set LIBSQLITE_CLIB_PATH "${final.sqlite.out}/lib/libsqlite3.so"''
        ''--set LIBSQLITE "${final.sqlite.out}/lib/libsqlite3.so"''
      ]
    );

    extraMakeWrapperLuaCArgs = optionalString (resolvedExtraLuaPackages != []) ''
      --suffix LUA_CPATH ";" "${
        lib.concatMapStringsSep ";" final.luaPackages.getLuaCPath
        resolvedExtraLuaPackages
      }"'';

    extraMakeWrapperLuaArgs =
      optionalString (resolvedExtraLuaPackages != [])
      ''
        --suffix LUA_PATH ";" "${
          concatMapStringsSep ";" final.luaPackages.getLuaPath
          resolvedExtraLuaPackages
        }"'';
  in
    final.wrapNeovimUnstable inputs.neovim-flake.packages.${prev.system}.neovim (neovimConfig
      // {
        luaRcContent = initLua;
        wrapperArgs =
          escapeShellArgs neovimConfig.wrapperArgs
          + " "
          + extraMakeWrapperArgs
          + " "
          + extraMakeWrapperLuaCArgs
          + " "
          + extraMakeWrapperLuaArgs;
        wrapRc = true;
      });

  all-plugins = with final.nvimPlugins; [
    polar-lua-config
    beancount-nvim
    cmp-dap
    cmp-emoji
    cmp-nvim-lsp
    cmp-path
    conform-nvim
    crates-nvim
    diffview-nvim
    dressing-nvim
    edgy-nvim
    flash-nvim
    friendly-snippets
    gitsigns-nvim
    harpoon
    inc-rename-nvim
    lualine-nvim
    luasnip
    kanagawa-nvim
    mini-indentscope
    neodev-nvim
    neogit
    noice-nvim
    nui-nvim
    nvim-cmp
    nvim-colorizer
    nvim-dap
    nvim-dap-python
    nvim-dap-ui
    nvim-dap-virtual-text
    nvim-jdtls
    nvim-lint
    nvim-navic
    nvim-nio
    nvim-treesitter
    nvim-treesitter-playground
    nvim-web-devicons
    obsidian-nvim
    one-small-step-for-vimkind
    overseer-nvim
    rustaceanvim
    plenary-nvim
    schemastore-nvim
    sqlite-lua
    telescope-nvim
    tokyonight-nvim
    trouble-nvim
    vim-be-good
    vim-illuminate
    which-key-nvim
    yanky-nvim
  ];

  extraPackages = with final; [
    # lua
    lua-language-server
    luajitPackages.luacheck
    stylua

    # markdown
    prettierd
    markdownlint-cli
    # (pkgs.mdformat.withPlugins (p: [
    #   p.mdformat-frontmatter
    #   p.mdformat-gfm
    #   p.mdformat-toc
    # ]))

    #nix
    nil-git
    deadnix
    statix
    alejandra

    # python
    (python311.withPackages (ps:
      with ps; [
        black
        python-lsp-server
        python-lsp-black.overrideAttrs
        (oldAttrs: rec {
          patches =
            oldAttrs.patches
            /*
            fix test failure with black>=24.3.0;
            remove this patch once python-lsp-black>2.0.0
            */
            ++ lib.optional
            (with lib; (versionOlder version "2.0.1") && (versionAtLeast black.version "24.3.0"))
            (fetchpatch {
              url = "https://patch-diff.githubusercontent.com/raw/python-lsp/python-lsp-black/pull/59.patch";
              hash = "sha256-4u0VIS7eidVEiKRW2wc8lJVkJwhzJD/M+uuqmTtiZ7E=";
            });
        })
        python-lsp-ruff
        pydocstyle
        debugpy
      ]))
    ruff
    basedpyright-nixpkgs.basedpyright

    # rust
    rust-analyzer

    # yaml
    nodePackages_latest.yaml-language-server

    # java
    jdt-language-server
  ];

  neovim-polar-dev = mkNeovim {
    plugins = all-plugins;
    devPlugins = [
      {
        name = "git-worktree.nvim";
        path = "~/repos/personal/git-worktree-nvim/v2 ";
      }
      {
        name = "beancount.nvim";
        path = "~/repos/personal/beancount-nvim/master ";
      }
    ];
    inherit extraPackages;
  };

  neovim-polar = mkNeovim {
    plugins =
      all-plugins
      ++ (with final.nvimPlugins; [
        git-worktree-nvim
      ]);
    inherit extraPackages;
  };
in {
  inherit
    neovim-polar-dev
    neovim-polar
    ;
}
