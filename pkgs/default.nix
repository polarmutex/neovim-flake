{inputs, ...}: let
  /*
  wrapperFor returns a wrapper w for a set of pkgs

  wrapper incudes automatic overrides for a callPackage definition
  */
  wrapperFor = _pkgs: _callPackage: path: extraOverrides: let
    # args :: set
    args = builtins.functionArgs (import path);

    usesNvfetcher = builtins.hasAttr "src" args || builtins.hasAttr "sources" args;

    sources = _pkgs.callPackages (path + "/generated.nix") {};

    firstSource = builtins.head (builtins.attrValues sources);

    nvfetcherOverrides =
      if ! usesNvfetcher
      then {}
      else if builtins.hasAttr "sources" args
      then {inherit sources;}
      else builtins.intersectAttrs args firstSource;
  in
    _callPackage path (nvfetcherOverrides // extraOverrides);
in {
  perSystem = {
    config,
    inputs',
    pkgs,
    system,
    ...
  }: let
    w = wrapperFor pkgs;
  in {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        inputs.nvfetcher.overlays.default
        (_final: _prev: {
          mdformat-with-plugins =
            pkgs.python311Packages.mdformat.withPlugins
            (with pkgs.python311Packages; [
              (mdformat-gfm.overridePythonAttrs (prev: {
                src = pkgs.fetchFromGitHub {
                  owner = "hukkin";
                  repo = prev.pname;
                  rev = "master";
                  hash = "sha256-dQsYL2I3bWmdgoxIHhW6e+Sz8kfjD1bR5XZmpmUYCV8=";
                };
              }))
              mdformat-frontmatter
              mdformat-toc
            ]);
          nil-git = inputs'.nil.packages.default;
        })
      ];
    };

    legacyPackages = pkgs;

    packages = let
      # The grammars we care about:
      grammars = {
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
        # proto
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
        # vim = {
        #   owner = "vigoux";
        #   repo = "tree-sitter-viml";
        # };
        vimdoc = {
          owner = "neovim";
        };
        yaml = {
          owner = "ikatyang";
        };
      };
    in {
      default = config.packages.neovim-git;
      # from https://github.com/nix-community/neovim-nightly-overlay
      neovim-git = inputs'.neovim-flake.packages.neovim.override {
        # TODO remove on the next staging -> master update
        inherit ((builtins.getFlake "github:NixOS/nixpkgs/d4758c3f27804693ebb6ddce2e9f6624b3371b08").legacyPackages.${system}) libvterm-neovim;
      };

      polar-lua-config = pkgs.callPackage ./polar-lua-config.nix {inherit (config) packages;};
      neovim-polar = pkgs.callPackage ./neovim-polar.nix {
        inherit (inputs) neovim-flake;
        inherit (config) packages;
      };

      update-tree-sitter-grammars = let
        sources = pkgs.callPackages ./plugins/nvim-treesitter/generated.nix {};
        lockfile = pkgs.lib.importJSON "${sources.nvim-treesitter.src}/lockfile.json";

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
          pkgs.lib.concatMapStringsSep "\n" f
          (pkgs.lib.mapAttrsToList (k: v: {name = k;} // v) attrs);
      in
        pkgs.writeShellApplication {
          name = "update-grammars.sh";
          runtimeInputs = [pkgs.npins];
          text = ''
             rm -rf pkgs/plugins/nvim-treesitter/grammars/*
            ${pkgs.npins}/bin/npins -d pkgs/plugins/nvim-treesitter/grammars init --bare
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
                  -d pkgs/plugins/nvim-treesitter/grammars \
                  add \
                  --name tree-sitter-${name}\
                  github \
                  "${owner}" \
                  "${repo}" \
                  -b "${branch}" \
                  --at "${rev}"
              '')
            }
          '';
        };

      neovim-plugin-beancount-nvim = w pkgs.callPackage ./plugins/beancount-nvim {};
      neovim-plugin-cmp-dap = w pkgs.callPackage ./plugins/cmp-dap {};
      neovim-plugin-cmp-emoji = w pkgs.callPackage ./plugins/cmp-emoji {};
      neovim-plugin-cmp-nvim-lsp = w pkgs.callPackage ./plugins/cmp-nvim-lsp {};
      neovim-plugin-cmp-path = w pkgs.callPackage ./plugins/cmp-path {};
      neovim-plugin-comments-nvim = w pkgs.callPackage ./plugins/comments-nvim {};
      neovim-plugin-conform-nvim = w pkgs.callPackage ./plugins/conform-nvim {};
      neovim-plugin-crates-nvim = w pkgs.callPackage ./plugins/crates-nvim {};
      neovim-plugin-diffview-nvim = w pkgs.callPackage ./plugins/diffview-nvim {};
      neovim-plugin-dressing-nvim = w pkgs.callPackage ./plugins/dressing-nvim {};
      neovim-plugin-edgy-nvim = w pkgs.callPackage ./plugins/edgy-nvim {};
      neovim-plugin-flash-nvim = w pkgs.callPackage ./plugins/flash-nvim {};
      neovim-plugin-friendly-snippets = w pkgs.callPackage ./plugins/friendly-snippets {};
      neovim-plugin-git-worktree-nvim = w pkgs.callPackage ./plugins/git-worktree-nvim {};
      neovim-plugin-gitsigns-nvim = w pkgs.callPackage ./plugins/gitsigns-nvim {};
      neovim-plugin-harpoon = w pkgs.callPackage ./plugins/harpoon {};
      neovim-plugin-lualine-nvim = w pkgs.callPackage ./plugins/lualine-nvim {};
      neovim-plugin-luasnip = w pkgs.callPackage ./plugins/luasnip {};
      neovim-plugin-kanagawa-nvim = w pkgs.callPackage ./plugins/kanagawa-nvim {};
      neovim-plugin-mini-indentscope = w pkgs.callPackage ./plugins/mini-indentscope {};
      neovim-plugin-neodev-nvim = w pkgs.callPackage ./plugins/neodev-nvim {};
      neovim-plugin-neogit = w pkgs.callPackage ./plugins/neogit {};
      neovim-plugin-noice-nvim = w pkgs.callPackage ./plugins/noice-nvim {};
      neovim-plugin-nui-nvim = w pkgs.callPackage ./plugins/nui-nvim {};
      neovim-plugin-null-ls-nvim = w pkgs.callPackage ./plugins/null-ls-nvim {};
      neovim-plugin-nvim-cmp = w pkgs.callPackage ./plugins/nvim-cmp {};
      neovim-plugin-nvim-colorizer = w pkgs.callPackage ./plugins/nvim-colorizer {};
      neovim-plugin-nvim-dap = w pkgs.callPackage ./plugins/nvim-dap {};
      neovim-plugin-nvim-dap-python = w pkgs.callPackage ./plugins/nvim-dap-python {};
      neovim-plugin-nvim-dap-ui = w pkgs.callPackage ./plugins/nvim-dap-ui {};
      neovim-plugin-nvim-dap-virtual-text = w pkgs.callPackage ./plugins/nvim-dap-virtual-text {};
      neovim-plugin-nvim-jdtls = w pkgs.callPackage ./plugins/nvim-jdtls {};
      neovim-plugin-nvim-lint = w pkgs.callPackage ./plugins/nvim-lint {};
      neovim-plugin-nvim-lspconfig = w pkgs.callPackage ./plugins/nvim-lspconfig {};
      neovim-plugin-nvim-navic = w pkgs.callPackage ./plugins/nvim-navic {};
      neovim-plugin-nvim-treesitter = w pkgs.callPackage ./plugins/nvim-treesitter {
        inherit grammars;
        inherit (inputs) nixpkgs;
      };
      neovim-plugin-nvim-treesitter-playground = w pkgs.callPackage ./plugins/nvim-treesitter-playground {};
      neovim-plugin-nvim-web-devicons = w pkgs.callPackage ./plugins/nvim-web-devicons {};
      neovim-plugin-one-small-step-for-vimkind = w pkgs.callPackage ./plugins/one-small-step-for-vimkind {};
      neovim-plugin-overseer-nvim = w pkgs.callPackage ./plugins/overseer-nvim {};
      neovim-plugin-plenary-nvim = w pkgs.callPackage ./plugins/plenary-nvim {};
      neovim-plugin-schemastore-nvim = w pkgs.callPackage ./plugins/schemastore-nvim {};
      neovim-plugin-sqlite-lua = w pkgs.callPackage ./plugins/sqlite-lua {};
      neovim-plugin-telescope-nvim = w pkgs.callPackage ./plugins/telescope-nvim {};
      neovim-plugin-tokyonight-nvim = w pkgs.callPackage ./plugins/tokyonight-nvim {};
      neovim-plugin-trouble-nvim = w pkgs.callPackage ./plugins/trouble-nvim {};
      neovim-plugin-vim-be-good = w pkgs.callPackage ./plugins/vim-be-good {};
      neovim-plugin-vim-illuminate = w pkgs.callPackage ./plugins/vim-illuminate {};
      neovim-plugin-which-key-nvim = w pkgs.callPackage ./plugins/which-key-nvim {};
      neovim-plugin-yanky-nvim = w pkgs.callPackage ./plugins/yanky-nvim {};
    };
  };
}
