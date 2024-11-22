{
  lib,
  lemmy-help,
  neovim-nightly,
  vimUtils,
  vscode-extensions,
}: let
  vars = {
    java-debug = vscode-extensions.vscjava.vscode-java-debug;
    java-test = vscode-extensions.vscjava.vscode-java-test;
  };
in
  vimUtils.buildVimPlugin {
    pname = "src-polar";
    version = "dev";

    # TODO: use filesets or something similar to filter out unwanted files
    src = lib.cleanSourceWith {
      filter = name: _: let bname = baseNameOf name; in bname != "default.nix";
      src = ./.;
    };

    postUnpack = ''
      #mkdir -p $sourceRoot/lua
      #mv $sourceRoot/lua $sourceRoot/lua
      mkdir -p $sourceRoot/doc
      ${lemmy-help}/bin/lemmy-help -fact \
          # $sourceRoot/lua/polar/keymaps.lua \
          > $sourceRoot/doc/polar.txt
        #ln -s {inputs.spell-en-dictionary} $out/nvim/spell/en.utf-8.spl;
        #ln -s {inputs.spell-en-suggestions} $out/nvim/spell/en.utf-8.sug;
    '';

    postInstall = let
      inherit (builtins) attrNames attrValues;
      subs =
        lib.concatStringsSep " "
        (lib.lists.zipListsWith (f: t: "--subst-var-by ${f} ${t}") (attrNames vars) (attrValues vars));

      luaPackages = lp: [
        lp.luassert
        # lp.lua-cjson
      ];
      basePackage = neovim-nightly;
      luaEnv = basePackage.lua.withPackages luaPackages;
      inherit (basePackage.lua.pkgs.luaLib) genLuaPathAbsStr genLuaCPathAbsStr;
    in
      ''
      ''
      + lib.optionalString
      (vars != null)
      ''
        for filename in $(find $out -type f -print)
        do
          substituteInPlace $filename ${subs}
        done

        mkdir -p $out/plugin

        tee $out/plugin/init.lua <<EOF
        -- Don't use LUA_PATH or LUA_CPATH because they leak into the LSP
        package.path = "${genLuaPathAbsStr luaEnv};" .. package.path
        package.cpath = "${genLuaCPathAbsStr luaEnv};" .. package.cpath

        -- No remote plugins
        vim.g.loaded_node_provider = 0
        vim.g.loaded_perl_provider = 0
        vim.g.loaded_python_provider = 0
        vim.g.loaded_python3_provider = 0
        vim.g.loaded_ruby_provider = 0

        require('polar')
        EOF
      '';

    passthru = {opt = false;};

    meta = with lib; {
      homepage = "";
      description = "polarmutex neovim configuration";
      license = licenses.mit;
      maintainers = [maintainers.polarmutex];
    };
  }
