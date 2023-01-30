{ self, ... }:
let
in
{
  perSystem =
    { config
    , pkgs
    , inputs'
    , self'
    , system
    , ...
    }:
    let
    in
    {
      # check to see if any config errors ars displayed
      # TODO need to have version with all the config
      checks =
        let
        in
        {
          neovim-check-config =
            pkgs.runCommand "neovim-check-config"
              {
                buildInputs = [
                  pkgs.git
                ];
              } ''
              # We *must* create some output, usually contains test logs for checks
              mkdir -p "$out"
              # Probably want to do something to ensure your config file is read, too
              # need git in path
              export HOME=$TMPDIR
              ${pkgs.neovim-polar}/bin/nvim --headless -c "q" 2> "$out/nvim-config.log"
              if [ -n "$(cat "$out/nvim-config.log")" ]; then
                  while IFS= read -r line; do
                      echo "$line"
                  done < "$out/nvim-config.log"
                  exit 1
              fi
            '';
          neovim-check-health =
            pkgs.runCommand "neovim-check-health"
              {
                buildInputs = [
                  pkgs.git
                ];
              } ''
              # We *must* create some output, usually contains test logs for checks
              mkdir -p "$out"
              # Probably want to do something to ensure your config file is read, too
              # need git in path
              export HOME=$TMPDIR
              ${pkgs.neovim-polar}/bin/nvim --headless -c "lua require('polarmutex.health').nix_check()" -c "q" 2> "$out/nvim-health.log"
              if [ -n "$(cat "$out/nvim-health.log")" ]; then
                  while IFS= read -r line; do
                      echo "$line"
                  done < "$out/nvim-health.log"
                  exit 1
              fi
            '';
        };
    };
}