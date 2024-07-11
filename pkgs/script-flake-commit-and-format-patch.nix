{pkgs, ...}:
pkgs.writeShellApplication {
  name = "flake-commit-and-format-patch";
  runtimeInputs = with pkgs; [
    coreutils
    git
  ];

  text = ''
    #!/bin/bash

    usage() {
      printf "%s\n\n" "usage: $(basename "$0") <patch-file> "
      printf "%s\n\n" "Commits all current changes with <commit-message> as the commit message and writes a patch to <output-file>."
      exit 1
    }

    if [ $# -ne 1 ]; then
      usage
    else
      git commit -am "chore(update/flake): update nix flake" && git format-patch -1 HEAD --output "$1"
    fi
  '';
}
