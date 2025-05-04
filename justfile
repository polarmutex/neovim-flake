__default:
    just --list

check:
    nix flake check

package profile="default":
    nix build --json --no-link --print-build-logs ".#{{ profile }}"

generate-npins-matrix file:
    jq -cn '[ inputs | .pins | to_entries | .[] | { name: .key, version: (if .value.version != null then .value.version else .value.revision[0:8] end), "sources-file": input_filename } ]' {{file}}

flake-commit-and-format-patch output-file:
    git commit -am "chore(update/flake): update nix flake" && git format-patch -1 HEAD --output {{output-file}}

npins-commit-and-format-patch output-file pin-name version new-version:
    git commit -am "chore(plugin/update): {{pin-name}}: {{version}} -> {{new-version}}" && git format-patch -1 HEAD --output {{output-file}}

npins-version-matrix file pin:
    @jq -rcn 'inputs | .pins | to_entries | .[] | select(.key == "{{pin}}") |  if .value.version != null then .value.version else .value.revision[0:8] end' {{file}}

new-nvim-plugin user repo:
    #!/bin/sh
    npins add --name {{repo}} github {{user}} {{repo}}
    NEW_VERSION=$(jq -rcn 'inputs | .pins | .[] | select(.repository.repo == "{{repo}}" ) |  if .version != null then .version else .revision[0:8] end' npins/sources.json)
    git commit -am "chore(plugin/new): {{repo}}: init @ $NEW_VERSION"

new-nvim-plugin-branch plugin user repo branch:
    #!/bin/sh
    npins add --name {{repo}} github -b {{branch}} {{user}} {{repo}}
    NEW_VERSION=$(jq -rcn 'inputs | .pins | .[] | select(.repository.repo == "{{repo}}" ) | if .version != null then .version else .revision[0:8] end' npins/sources.json)
    git commit -am "chore(plugin/new): {{repo}}: init @ $NEW_VERSION"

update-nvim-plugin repo:
    #!/bin/sh
    OLD_VERSION=$(jq -rcn 'inputs | .pins | .[] |select(.repository.repo == "{{repo}}") | if .version != null then .version else .revision[0:8] end' npins/sources.json)
    npins update {{repo}}
    NEW_VERSION=$(jq -rcn 'inputs | .pins | .[] |select(.repository.repo == "{{repo}}") | if .version != null then .version else .revision[0:8] end' npins/sources.json)
    git commit -am "chore(plugin/update): {{repo}}: $OLD_VERSION -> $NEW_VERSION"

update-treesitter-grammars:
    #!/bin/sh
    # cp npins-ts-grammars/sources.json temp.json
    # rm -rf npins-ts-grammars/*
    # npins -d ./npins-ts-grammars init --bare
    while read -r repo; do
        echo "$repo"
    done < <(jq -c '.pins | .[] | .repository.repo' temp.json)
