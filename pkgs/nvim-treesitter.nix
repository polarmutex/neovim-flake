{
  pkgs,
  lib,
  nvim-treesitter-git,
  stdenv,
  nixpkgs,
  treesitterGrammars,
  ...
}: let
  src = pkgs.neovimPlugins.nvim-treesitter;

  lockfile = lib.importJSON "${src}/lockfile.json";

  # The grammars we care about:
  grammars = {
    astro = {
      owner = "virchau13";
    };
    bash = {
      owner = "tree-sitter";
    };
    beancount = {
      owner = "polarmutex";
    };
    c = {
      owner = "tree-sitter";
    };
    cmake = {
      owner = "uyha";
    };
    cpp = {
      owner = "tree-sitter";
    };
    diff = {
      owner = "the-mikedavis";
      branch = "main";
    };
    dockerfile = {
      owner = "camdencheek";
      branch = "main";
    };
    gitcommit = {
      owner = "gbprod";
      branch = "main";
    };
    git_rebase = {
      owner = "the-mikedavis";
      repo = "tree-sitter-git-rebase";
    };
    go = {
      owner = "tree-sitter";
    };
    # fixme help = {
    #  owner = "neovim";
    #  repo = "tree-sitter-vimdoc";
    #};
    html = {
      owner = "tree-sitter";
    };
    java = {
      owner = "tree-sitter";
    };
    javascript = {
      owner = "tree-sitter";
    };
    json = {
      owner = "tree-sitter";
    };
    lua = {
      owner = "MunifTanjim";
      branch = "main";
    };
    make = {
      owner = "alemuller";
      branch = "main";
    };
    markdown = {
      owner = "MDeiml";
      repo = "tree-sitter-markdown";
      branch = "split_parser";
      location = "tree-sitter-markdown";
    };
    markdown_inline = {
      owner = "MDeiml";
      repo = "tree-sitter-markdown";
      branch = "split_parser";
      location = "tree-sitter-markdown-inline";
    };
    mermaid = {
      owner = "monaqa";
    };
    nix = {
      owner = "cstrahan";
    };
    python = {
      owner = "tree-sitter";
    };
    query = {
      owner = "nvim-treesitter";
      branch = "main";
    };
    regex = {
      owner = "tree-sitter";
    };
    rust = {
      owner = "tree-sitter";
    };
    svelte = {
      owner = "Himujjal";
    };
    toml = {
      owner = "ikatyang";
    };
    typescript = {
      owner = "tree-sitter";
      location = "typescript";
    };
    vim = {
      owner = "vigoux";
      repo = "tree-sitter-viml";
    };
    yaml = {
      owner = "ikatyang";
    };
  };

  allGrammars =
    builtins.mapAttrs
    (name: value: rec {
      inherit (value) owner;
      repo =
        if value ? "repo"
        then value.repo
        else "tree-sitter-${name}";
      rev =
        if value ? "rev"
        then value.rev
        else lockfile."${name}".revision;
      branch =
        if value ? "branch"
        then value.branch
        else "master";
    })
    grammars;

  foreachSh = attrs: f:
    lib.concatMapStringsSep "\n" f
    (lib.mapAttrsToList (k: v: {name = k;} // v) attrs);

  update-grammars = pkgs.writeShellApplication {
    name = "update-grammars.sh";
    runtimeInputs = [pkgs.npins];
    text = ''
       rm -rf tree-sitter-grammars/*
      ${pkgs.npins}/bin/npins -d tree-sitter-grammars init --bare
       ${
        foreachSh allGrammars ({
          name,
          owner,
          repo,
          branch,
          rev,
          ...
        }: ''
          echo "Updating treesitter parser for ${name}"
          ${pkgs.npins}/bin/npins \
            -d tree-sitter-grammars \
            add \
            --name tree-sitter-${name}\
            github \
            "${owner}" \
            "${repo}" \
            -b "${branch}" \
            --at "${rev}"
        '')
      }
      ${pkgs.npins}/bin/npins -d tree-sitter-grammars add --name tree-sitter-beancount-devel github polarmutex tree-sitter-beancount -b devel
    '';
  };

  buildGrammar = pkgs.callPackage "${nixpkgs}/pkgs/development/tools/parsing/tree-sitter/grammar.nix" {};

  # Build grammars that were fetched using nvfetcher
  generatedGrammars = with lib;
    mapAttrsToList
    (n: v:
      buildGrammar {
        #language = removePrefix "tree-sitter-" n;
        language = n;
        version = treesitterGrammars."tree-sitter-${n}".revision;
        src = treesitterGrammars."tree-sitter-${n}";
        name = "tree-sitter-${n}-grammar";
        location =
          if v ? "location"
          then v.location
          else null;

        #passthru.parserName = "${lib.strings.replaceStrings ["-"] ["_"] (lib.strings.removePrefix "tree-sitter-" n)}";
        passthru.parserName = n;
      })
    grammars;
in
  stdenv.mkDerivation {
    name = "nvim-treesitter";

    inherit src;

    installPhase = lib.concatStringsSep "\n" (lib.lists.flatten (
      [
        "mkdir $out"
        "cp -r {autoload,doc,lua,parser-info,parser,plugin,queries,lockfile.json} $out"
      ]
      ++ (map
        (drv: ''
          cp ${drv}/parser $out/parser/${drv.parserName}.so
        '')
        generatedGrammars)
    ));

    dontFixup = true;

    passthru = {
      inherit update-grammars;
    };
  }
