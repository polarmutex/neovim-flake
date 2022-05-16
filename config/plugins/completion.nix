{ pkgs, dsl, ... }:
with dsl;
{
  use.cmp.setup = callWith {
    mapping = {
      "['<C-n>']" = rawLua
        "require('cmp').mapping.select_next_item({ behavior = require('cmp').SelectBehavior.Insert })";
      "['<C-p>']" = rawLua
        "require('cmp').mapping.select_prev_item({ behavior = require('cmp').SelectBehavior.Insert })";
      "['<Down>']" = rawLua
        "require('cmp').mapping.select_next_item({ behavior = require('cmp').SelectBehavior.Select })";
      "['<Up>']" = rawLua
        "require('cmp').mapping.select_prev_item({ behavior = require('cmp').SelectBehavior.Select })";
      "['<C-d>']" = rawLua "require('cmp').mapping.scroll_docs(-4)";
      "['<C-f>']" = rawLua "require('cmp').mapping.scroll_docs(4)";
      "['<C-Space>']" = rawLua "require('cmp').mapping.complete()";
      "['<C-e>']" = rawLua "require('cmp').mapping.close()";
      "['<CR>']" = rawLua
        "require('cmp').mapping.confirm({ behavior = require('cmp').ConfirmBehavior.Replace, select = true, })";
    };
    sources = [
      { name = "nvim_lsp"; }
      { name = "buffer"; }
    ];
  };

}
