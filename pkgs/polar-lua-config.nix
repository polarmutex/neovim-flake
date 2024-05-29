{
  inputs,
  pkgs,
  lib,
  ...
}: let
  vars = {
    java-debug = pkgs.vscode-extensions.vscjava.vscode-java-debug;
    java-test = pkgs.vscode-extensions.vscjava.vscode-java-test;
  };
in
  pkgs.vimUtils.buildVimPlugin {
    pname = "polarmutex";
    version = "dev";
    src = ../nvim;

    postUnpack = ''
      #mkdir -p $sourceRoot/lua
      #mv $sourceRoot/lua $sourceRoot/lua
      mkdir -p $sourceRoot/doc
      ${pkgs.lemmy-help}/bin/lemmy-help -fact \
          $sourceRoot/lua/polarmutex/keymaps.lua \
          > $sourceRoot/doc/polarmutex.txt
        #ln -s {inputs.spell-en-dictionary} $out/nvim/spell/en.utf-8.spl;
        #ln -s {inputs.spell-en-suggestions} $out/nvim/spell/en.utf-8.sug;
    '';

    postInstall = let
      inherit (builtins) attrNames attrValues;
      subs =
        lib.concatStringsSep " "
        (lib.lists.zipListsWith (f: t: "--subst-var-by ${f} ${t}") (attrNames vars) (attrValues vars));
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
      '';
    meta = with lib; {
      homepage = "";
      description = "polarmutex neovim configuration";
      license = licenses.mit;
      maintainers = [maintainers.polarmutex];
    };
  }
