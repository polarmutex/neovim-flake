{ pkgs, config, lib, ... }:
with lib;
with builtins;

let
  cfg = config.vim.lsp;

  debugpy = pkgs.python3.withPackages (pyPkg: with pyPkg; [ debugpy ]);
in
{

  options.vim.lsp = {
    enable = mkEnableOption "Enable lsp support";

    bash = mkEnableOption "Enable Bash Language Support";
    nix = mkEnableOption "Enable NIX Language Support";
    python = mkEnableOption "Enable Python Support";
    rust = mkEnableOption "Enable Rust Support";
    typescript = mkEnableOption "Enable Typescript/Javascript Support";
    vimscript = mkEnableOption "Enable Vim Script Support";
    yaml = mkEnableOption "Enable yaml support";
    docker = mkEnableOption "Enable docker support";
    css = mkEnableOption "Enable css support";
    html = mkEnableOption "Enable html support";
    clang = mkEnableOption "Enable C/C++ with clang";
    cmake = mkEnableOption "Enable CMake";
    json = mkEnableOption "Enable JSON";

    #lightbulb = mkEnableOption "Enable Light Bulb";
    #variableDebugPreviews = mkEnableOption "Enable variable previews";

  };
  config = mkIf cfg.enable {

    vim.startPlugins = with pkgs.neovimPlugins; [
      nvim-lspconfig
      completion-nvim
      nvim-dap
      telescope-dap
      nvim-treesitter
    ];

  };
}
