{pkgs, ...}:
pkgs.writeShellApplication {
  name = "update-nvim-plugin";
  runtimeInputs = with pkgs; [
    git
    mktemp
    npins
  ];

  text = ''
    OLD_VERSION=$(jq -rcn "inputs | .pins | .[] |select(.repository.repo == \"$1\") |  if .version != null then .version else .revision[0:8] end " "pkgs/npins/sources.json")
    ${pkgs.npins}/bin/npins -d pkgs/npins update "$1"
    NEW_VERSION=$(jq -rcn "inputs | .pins | .[] |select(.repository.repo == \"$1\") |  if .version != null then .version else .revision[0:8] end " "pkgs/npins/sources.json")
    git commit -am "chore(plugin/update): $1: $OLD_VERSION -> $NEW_VERSION"
  '';
}
