{
pkgs
, dsl
, ...
}:
with dsl;
{
  use."nvim-treesitter.configs".setup = callWith {
    ensure_installed = [
       "nix"
       "rust"
    ];
  };
}
