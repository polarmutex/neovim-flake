{ lib, pkgs, ... }: {
  vimscript = ''
    lua << EOF
    require('polarmutex.options')
    require('polarmutex.lsp')
    require('polarmutex.treesitter')
    EOF
  '';
}
