{ pkgs
, dsl
, ...
}:
with dsl;
{
  use."nvim-treesitter.configs".setup = callWith {
    ensure_installed = [ ];
    highlight = {
      enable = true;
    };
    indent = {
      enable = true;
    };
    playground = {
      enable = true;
      disable = { };
      updatetime = 25; # Debounced time for highlighting nodes in the playground from source code
      persist_queries = false; # Whether the query persists across vim sessions
      keybindings = { };
    };
  };
}
