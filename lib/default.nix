{ pkgs, inputs, plugins, ... }:
{
  inherit (pkgs.lib);

  neovimBuilder = import ./neovim_builder.nix { inherit pkgs; };

  buildPluginOverlay = import ./build_plugin.nix { inherit inputs plugins; };
}
