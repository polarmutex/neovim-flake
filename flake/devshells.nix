{
  perSystem = {
    pkgs,
    config,
    ...
  }: {
    devShells = {
      default = pkgs.mkShell {
        name = "neovim-developer-shell";
        inputsFrom = [
        ];
        packages = with pkgs; [
          fd
          jq
          lemmy-help
          npins
          nix-tree
        ];
        shellHook = ''
          #export NVIM_PYTHON_LOG_LEVEL=DEBUG
          #export NVIM_LOG_FILE=/tmp/nvim.log
          #export VIMRUNTIME=

          # ASAN_OPTIONS=detect_leaks=1
          #export ASAN_OPTIONS="log_path=./test.log:abort_on_error=1"

          # for treesitter functionaltests
          #mkdir -p runtime/parser
          #cp -f ${pkgs.vimPlugins.nvim-treesitter.builtGrammars.c}/parser runtime/parser/c.so
        '';
      };
    };
  };
}
