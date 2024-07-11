{inputs, ...}: {
  imports = [
    # ./checks.nix
    # ./ci.nix
    ./devshells.nix
    # ./overlays.nix
    ../pkgs
    # inputs.git-hooks.flakeModule
  ];
}
