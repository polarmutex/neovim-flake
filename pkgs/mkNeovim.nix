# Function for creating a Neovim derivation
{
  neovim-unwrapped,
  inputs,
  pkgs,
}:
with pkgs.lib;
  {
    # NVIM_APPNAME - Defaults to 'nvim' if not set.
    # If set to something else, this will also rename the binary.
    appName ? null,
    # List of plugins
    plugins ? [],
    # List of dev plugins (will be bootstrapped) - useful for plugin developers
    # { name = <plugin-name>; url = <git-url>; }
    devPlugins ? [],
    extraPackages ? [], # Extra runtime dependencies (e.g. ripgrep, ...)
    # The below arguments can typically be left as their defaults
    # Additional lua packages (not plugins), e.g. from luarocks.org.
    # e.g. p: [p.jsregexp]
    extraLuaPackages ? p: [],
    extraPython3Packages ? p: [], # Additional python 3 packages
    withPython3 ? true, # Build Neovim with Python 3 support?
    withRuby ? false, # Build Neovim with Ruby support?
    withNodeJs ? false, # Build Neovim with NodeJS support?
    withSqlite ? true, # Add sqlite? This is a dependency for some plugins
    # You probably don't want to create vi or vim aliases
    # if the appName is something different than "nvim"
    viAlias ? appName == "nvim", # Add a "vi" binary to the build output as an alias?
    vimAlias ? appName == "nvim", # Add a "vim" binary to the build output as an alias?
    extraLuaConfig ? "", # Extra Lua configuration
  }: let
    # This is the structure of a plugin definition.
    # Each plugin in the `plugins` argument list can also be defined as this attrset
    defaultPlugin = {
      plugin = null; # e.g. nvim-lspconfig
      config = null; # plugin config
      # If `optional` is set to `false`, the plugin is installed in the 'start' packpath
      # set to `true`, it is installed in the 'opt' packpath, and can be lazy loaded with
      # ':packadd! {plugin-name}
      optional = false;
      runtime = {};
    };

    externalPackages = extraPackages ++ (optionals withSqlite [pkgs.sqlite]);

    # Map all plugins to an attrset { plugin = <plugin>; config = <config>; optional = <tf>; ... }
    normalizedPlugins = map (x:
      defaultPlugin
      // (
        if x ? plugin
        then x
        else {plugin = x;}
      ))
    plugins;

    # This nixpkgs util function creates an attrset
    # that pkgs.wrapNeovimUnstable uses to configure the Neovim build.
    neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
      inherit extraPython3Packages withPython3 withRuby withNodeJs viAlias vimAlias;
      plugins = normalizedPlugins;
    };

    # nvimConfig = pkgs.stdenv.mkDerivation {
    #   name = "nvim-config";
    #   src = ../nvim;
    #
    #   buildPhase = ''
    #     mkdir -p $out/nvim
    #     rm init.lua
    #   '';
    #
    #   installPhase = ''
    #     cp -r * $out/nvim
    #     rm -r $out/nvim/after
    #     cp -r after $out/after
    #     ln -s ${inputs.spell-en-dictionary} $out/nvim/spell/en.utf-8.spl;
    #     ln -s ${inputs.spell-en-suggestions} $out/nvim/spell/en.utf-8.sug;
    #   '';
    # };

    initLua =
      ''
        vim.loader.enable()
      ''
      + ""
      + (builtins.readFile ../plugins/polar/init.lua)
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
      )
      + ''
        -- Extra lua config.
        ${extraLuaConfig}
      '';

    # Add arguments to the Neovim wrapper script
    extraMakeWrapperArgs = builtins.concatStringsSep " " (
      # Set the NVIM_APPNAME environment variable
      (optional (appName != "nvim" && appName != null && appName != "")
        ''--set NVIM_APPNAME "${appName}"'')
      # Add external packages to the PATH
      ++ (optional (externalPackages != [])
        ''--prefix PATH : "${makeBinPath externalPackages}"'')
      # Set the LIBSQLITE_CLIB_PATH if sqlite is enabled
      ++ (optional withSqlite
        ''--set LIBSQLITE_CLIB_PATH "${pkgs.sqlite.out}/lib/libsqlite3.so"'')
      # Set the LIBSQLITE environment variable if sqlite is enabled
      ++ (optional withSqlite
        ''--set LIBSQLITE "${pkgs.sqlite.out}/lib/libsqlite3.so"'')
    );

    # See https://github.com/nix-community/home-manager/blob/master/modules/programs/neovim.nix
    # and https://github.com/NixOS/nixpkgs/blob/623ac957cb99a5647c9cf127ed6b5b9edfbba087/pkgs/applications/editors/neovim/utils.nix#L81.
    luaPackages = neovim-unwrapped.lua.pkgs;
    resolvedExtraLuaPackages = extraLuaPackages luaPackages;

    # Native Lua libraries.
    extraMakeWrapperLuaCArgs =
      optionalString (resolvedExtraLuaPackages != [])
      ''--suffix LUA_CPATH ";" "${concatMapStringsSep ";" luaPackages.getLuaCPath resolvedExtraLuaPackages}"'';

    # Lua libraries.
    extraMakeWrapperLuaArgs =
      optionalString (resolvedExtraLuaPackages != [])
      ''--suffix LUA_PATH ";" "${concatMapStringsSep ";" luaPackages.getLuaPath resolvedExtraLuaPackages}"'';
  in
    pkgs.wrapNeovimUnstable neovim-unwrapped (
      neovimConfig
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
      }
    )
