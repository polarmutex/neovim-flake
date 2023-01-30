{
  description = "Tutorial Flake accompanying vimconf talk.";

  # Input source for our derivation
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    flake-parts.url = "github:hercules-ci/flake-parts";

    #neovim = { url = "github:neovim/neovim?dir=contrib&rev=47e60da7210209330767615c234ce181b6b67a08"; };
    neovim = { url = "github:neovim/neovim?dir=contrib"; };
  };

  outputs =
    { self
    , nixpkgs
    , neovim
    , flake-parts
    , ...
    } @ inputs:
    flake-parts.lib.mkFlake { inherit inputs; }
      {
        systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];

        imports = [
          ./checks
        ];

        flake = {
          overlays.default = final: prev:
            let
              #sources = prev.callPackage ./_sources/generated.nix { };
              #buildPlugin = source:
              #  # TODO build neovim plugin
              #  prev.vimUtils.buildVimPluginFrom2Nix {
              #    inherit (source) pname version src;
              #  };
              #generatedPluginSources = with prev.lib;
              #  mapAttrs'
              #    (n:
              #      nameValuePair
              #        (removePrefix "'plugin-" (removeSuffix "'" n)))
              #    (filterAttrs (n: _: hasPrefix "'plugin-" n)
              #      sources);
              #generatedPlugins = with prev.lib;
              #  mapAttrs (_: buildPlugin) generatedPluginSources;
              #withSrc = pkg: src: pkg.overrideAttrs (_: {inherit src;});
              # Grammar builder function
              #buildGrammar = prev.callPackage "${inputs.nixpkgs}/pkgs/development/tools/parsing/tree-sitter/grammar.nix" {};
              # Build grammars that were fetched using nvfetcher
              #generatedGrammars = with prev.lib;
              #  mapAttrs
              #  (n: v:
              #    buildGrammar {
              #      language = removePrefix "tree-sitter-" n;
              #      inherit (v) version;
              #      src = v.src;
              #    })
              #  (filterAttrs (n: _: hasPrefix "tree-sitter-" n) sources);
              #treesitter-all = (withSrc prev.vimPlugins.nvim-treesitter final.neovimPlugins.nvim-treesitter).withAllGrammars.overrideAttrs (_: let
              #  treesitter-parser-paths = prev.symlinkJoin {
              #    name = "treesitter-parsers";
              #    paths = treesitter.dependencies;
              #  };
              #in {
              #  postPatch = ''
              #    mkdir -p parser
              #    cp -r ${treesitter-parser-paths.outPath}/parser/*.so parser
              #  '';
              #});
              #nvim-treesitter-plugin = prev.vimPlugins.nvim-treesitter.withPlugins (
              #  p:
              #    with p; [
              #      astro
              #      bash
              #      #generatedGrammars.tree-sitter-beancount
              #      beancount
              #      c
              #      cmake
              #      cpp
              #      diff
              #      dockerfile
              #      fish
              #      gitcommit
              #      gitignore
              #      go
              #      help
              #      html
              #      java
              #      javascript
              #      json
              #      lua
              #      make
              #      markdown
              #      markdown_inline
              #      mermaid
              #      nix
              #      proto
              #      python
              #      tree-sitter-query
              #      regex
              #      rust
              #      svelte
              #      teal
              #      toml
              #      typescript
              #      vim
              #      yaml
              #    ]
              #);
              #treesitter =
              #  nvim-treesitter-plugin.overrideAttrs
              #  (_: let
              #    treesitter-parser-paths = prev.symlinkJoin {
              #      name = "treesitter-parsers";
              #      paths = nvim-treesitter-plugin.dependencies;
              #    };
              #  in {
              #    postPatch = ''
              #      mkdir -p parser
              #      cp -r ${treesitter-parser-paths.outPath}/parser/*.so parser
              #    '';
              #  });
            in
            rec {
              neovim-lua-config-polar = final.callPackage ./pkgs/lua-config.nix { };
              neovim-polar = final.callPackage ./pkgs/neovim-polar.nix { inherit neovim; };
              nvim-treesitter-master = final.callPackage ./pkgs/nvim-treesitter.nix {
                inherit nixpkgs;
                nvim-treesitter-git = prev.neovimPlugins.nvim-treesitter;
                treesitterGrammars = final.treesitterGrammars;
              };
            };
        };
        perSystem =
          { config
          , pkgs
          , inputs'
          , self'
          , system
          , ...
          }:
          let
            overlays = with inputs; [
              neovim.overlay
              self.overlays.default
              # Keeping this out of the exposed overlay, I don't want to
              # expose nvfetcher-generated stuff, that's annoying.
              (_final: _prev: {
                neovimPlugins = import ./plugins;
              })
              (_final: _prev: {
                treesitterGrammars = import ./tree-sitter-grammars;
              })
            ];
          in
          {
            _module.args = {
              pkgs = import nixpkgs {
                inherit system overlays;
              };
            };

            packages = with pkgs; {
              default = pkgs.neovim-polar;
              inherit neovim-lua-config-polar neovim-polar nvim-treesitter-master;
            };

            apps = {
              defaultApp = {
                type = "app";
                program = "${pkgs.neovim-polar}/bin/nvim";
              };
              update-treesitter-parsers = {
                type = "app";
                program = pkgs.nvim-treesitter-master.update-grammars;
              };
            };

            devShells = {
              default = pkgs.mkShell {
                packages = builtins.attrValues {
                  inherit (pkgs) lemmy-help npins;
                };
              };
            };
          };
      };
}
#//
#flake-utils.lib.eachDefaultSystem
# awesome fails on arch darwin
#(system: let
#  pkgs =
#    import nixpkgs
#    {
#      inherit system;
#      overlays = [
#        self.overlays.default
#      ];
#      config = {
#        permittedInsecurePackages = [
#          # jdt-language-server
#          "openjdk-headless-16+36"
#          "openjdk-headless-15.0.1-ga"
#          "openjdk-headless-14.0.2-ga"
#          "openjdk-headless-13.0.2-ga"
#          "openjdk-headless-12.0.2-ga"
#        ];
#        # jdt-language-server
#        allowUnsupportedSystem = true;
#      };
#    };
