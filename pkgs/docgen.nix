{pkgs, ...}:
pkgs.writeShellApplication {
  name = "docgen";
  runtimeInputs = with pkgs; [
    lemmy-help
  ];
  text = ''
    mkdir -p doc
    lemmy-help -fact config/lua/polarmutex/config/lazy.lua config/lua/polarmutex/plugins/tasks.lua  > config/doc/polarmutex.txt
  '';
}
