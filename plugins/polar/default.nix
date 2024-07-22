{
  lib,
  lemmy-help,
  vimUtils,
  vscode-extensions,
  self,
}: let
  vars = {
    java-debug = vscode-extensions.vscjava.vscode-java-debug;
    java-test = vscode-extensions.vscjava.vscode-java-test;
  };
in
  vimUtils.buildVimPlugin {
    pname = "polar";
    version = self.shortRev or self.dirtyRev or "dirty";

    # TODO: use filesets or something similar to filter out unwanted files
    src = "${self}/plugins/polar";

    postUnpack = ''
      #mkdir -p $sourceRoot/lua
      #mv $sourceRoot/lua $sourceRoot/lua
      mkdir -p $sourceRoot/doc
      ${lemmy-help}/bin/lemmy-help -fact \
          $sourceRoot/lua/polar/keymaps.lua \
          > $sourceRoot/doc/polar.txt
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
