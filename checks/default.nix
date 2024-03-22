{
  self,
  inputs,
  ...
}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    # check to see if any config errors ars displayed
    # TODO need to have version with all the config
    checks = let
      pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
        src = self;
        hooks = {
          alejandra = {
            enable = true;
            excludes = [
              "pkgs/plugins/.*/generated.*"
              "tree-sitter-grammars"
            ];
          };
          stylua.enable = true;
          luacheck.enable = true;
        };
        settings = {
        };
      };
    in {
      inherit pre-commit-check;
      neovim-check-config =
        pkgs.runCommand "neovim-check-config"
        {
          buildInputs = [
            pkgs.git
          ];
        } ''
          # We *must* create some output, usually contains test logs for checks
          mkdir -p "$out"
          output=$(HOME=$(realpath .) ${pkgs.neovim-polar}/bin/nvim -mn --headless "+q" 2>&1 >/dev/null)
          if [[ -n $output ]]; then
             echo "ERROR: $output"
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
          output=$(HOME=$(realpath .) ${pkgs.neovim-polar}/bin/nvim -c "lua require('polarmutex.health').nix_check()" -c "q" 2>&1 /dev/null)
          if [ -n "$(cat "$out/nvim-health.log")" ]; then
              while IFS= read -r line; do
                  echo "$line"
              done < "$out/nvim-health.log"
              exit 1
          fi
        '';

      # fixme
      #   neovim-check-treesitter-queries =
      #     pkgs.runCommand "neovim-check-treesitter-queries"
      #     {
      #       buildInputs = [
      #         pkgs.git
      #       ];
      #     }
      #     ''
      #       touch $out
      #       export HOME=$(mktemp -d)
      #       #ln -s ${self'.packages.nvimPlugins-nvim-treesitter}/CONTRIBUTING.md .
      #
      #       ${pkgs.neovim-polar}/bin/nvim --headless "+luafile ${pkgs.nvimPlugins.nvim-treesitter}/scripts/check-queries.lua" # | tee log
      #
      #       #if grep -q Warning log; then
      #       #  echo "Error: warnings were emitted by the check"
      #       #  exit 1
      #       #fi
      #     '';
    };
  };
}
