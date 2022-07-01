{ lib, pkgs, ... }: {
  lua = ''
    require('polarmutex.profile')

    local ok, plenary_reload = pcall(require, "plenary.reload")
    if not ok then
      reloader = require
    else
      reloader = plenary_reload.reload_module
    end

    P = function(v)
      print(vim.inspect(v))
      return v
    end

    RELOAD = function(...)
      return reloader(...)
    end

    R = function(name)
      RELOAD(name)
      return require(name)
    end

    -- enable filetype.lua
    vim.g.do_filetype_lua = 1

    --vim.opt.runtimepath:append("~/repos/personal/beancount.nvim/master")
    require('polarmutex.options')
    require('polarmutex.mappings')
    require('polarmutex.lsp')
    require('polarmutex.treesitter')
  '';
}
