{pkgs, ...}:
pkgs.writeShellApplication {
  name = "new-nvim-plugin";
  runtimeInputs = with pkgs; [
    git
    mktemp
    npins
  ];

  text = ''
    #!/bin/bash

    usage() {
      printf "%s\n\n" "usage: $(basename "$0") <plugin.name> <plugin.user> <plugin.repo> [plugin.branch]"
      printf "%s\n\n" "Adds new plugin"
      exit 1
    }

    if [ $# -eq 3 ]; then
      ${pkgs.npins}/bin/npins add --name "$1" github "$2" "$3"
    elif [ $# -eq 4 ]; then
      ${pkgs.npins}/bin/npins add --name "$1" github -b "$4" "$2" "$3"
    else
      usage
    fi

    NEW_VERSION=$(jq -rcn "inputs | .pins | .[] |select(.repository.repo == \"$3\") |  if .version != null then .version else .revision[0:8] end " "npins/sources.json")
    git commit -am "chore(plugin/new): $1: init @ $NEW_VERSION"
  '';
}
