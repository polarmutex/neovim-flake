{
  packages,
  pkgs,
  lib,
  ...
}: let
  #lsp = [
  #  {
  #    name = "nvim-lspconfig";
  #    dir = "${neovim-plugin-nvim-lspconfig.outPath}";
  #    event = ["BufReadPre" "BufNewFile"];
  #    opts = {
  #      diagnostics = {
  #        underline = true;
  #        update_in_insert = false;
  #        virtual_text = {
  #          spacing = 4;
  #          source = "if_many";
  #          prefix = "●";
  #          # this will set set the prefix to a function that returns the diagnostics icon based on the severity
  #          # this only works on a recent 0.10.0 build. Will be set to "●" when not supported
  #          # prefix = "icons",
  #        };
  #        severity_sort = true;
  #      };
  #      # Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
  #      # Be aware that you also will need to properly configure your LSP server to
  #      # provide the inlay hints.
  #      inlay_hints = {
  #        enabled = true;
  #      };
  #      # Automatically format on save
  #      autoformat = true;
  #      # Enable this to show formatters used in a notification
  #      # Useful for debugging formatter issues
  #      format_notify = false;
  #      # options for vim.lsp.buf.format
  #      # `bufnr` and `filter` is handled by the LazyVim formatter,
  #      # but can be also overridden when specified
  #      format = {
  #        formatting_options = rawLua "nil";
  #        timeout_ms = rawLua "nil";
  #      };
  #      # LSP Server Settings
  #      # @type lspconfig.options
  #      servers = {
  #        beancount = {
  #          cmd = [
  #            #(lib.getExe beancount-language-server)
  #            "/home/polar/repos/personal/beancount-language-server/main/target/release/beancount-language-server"
  #            #"/home/polar/repos/personal/beancount-language-server/develop/target/release/beancount-language-server"
  #            #"--log"
  #          ];
  #          init_options = {
  #            journal_file = "/home/polar/repos/personal/beancount/main/main.beancount";
  #          };
  #        };
  #        clangd = {
  #          cmd = [
  #            (lib.getExe pkgs.clang)
  #            "--background-index"
  #            "--clang-tidy"
  #            "--header-insertion=iwyu"
  #            "--completion-style=detailed"
  #            "--function-arg-placeholders"
  #            "--fallback-style=llvm"
  #          ];
  #          init_options = {
  #            usePlaceholders = true;
  #            completeUnimported = true;
  #            clangdFileStatus = true;
  #          };
  #        };
  #        #gopls = {
  #        #  cmd = [(lib.getExe pkgs.gopls)];
  #        #};
  #        jdtls = {
  #          cmd = [(lib.getExe' pkgs.jdt-language-server "jdt-language-server")];
  #        };
  #        ltex = {
  #          cmd = [(lib.getExe' pkgs.ltex-ls "ltex-ls")];
  #          filetypes = ["markdown"];
  #          settings = {
  #            enabled = ["markdown"];
  #            checkFrequency = "save";
  #            language = "en-US";
  #            diagnosticSeverity = "information";
  #            setenceCacheSize = 5000;
  #            additionalRules = {
  #              enablePickyRules = true;
  #            };
  #          };
  #        };
  #        lua_ls = {
  #          cmd = [(lib.getExe' pkgs.lua-language-server "lua-language-server")];
  #          settings = {
  #            Lua = {
  #              diagnostics = {
  #                globals = [
  #                  # neovim
  #                  "vim"
  #                  # awesomewm
  #                  "awesome"
  #                  "client"
  #                  "screen"
  #                ];
  #              };
  #              format = {
  #                enable = false;
  #              };
  #              workspace = {
  #                checkThirdParty = false;
  #              };
  #              #completion = {
  #              #  callSnippet = "Replace";
  #              #};
  #            };
  #          };
  #        };
  #        nil_ls = {
  #          cmd = [(lib.getExe' pkgs.nil-git "nil")];
  #        };
  #        pyright = {
  #          cmd = [(lib.getExe' pkgs.pyright "pyright-langserver") "--stdio"];
  #          settings = {
  #            python = {
  #              analysis = {
  #                autoSearchPaths = true;
  #                useLibraryCodeForTypes = true;
  #                diagnosticMode = "openFilesOnly";
  #              };
  #            };
  #          };
  #        };
  #        #ruff_lsp = {
  #        #  cmd = [(lib.getExe' pkgs.ruff-lsp "ruff-lsp")];
  #        #};
  #        rust_analyzer = {
  #          cmd = [(lib.getExe pkgs.rust-analyzer)];
  #          settings = rawLua ''
  #            {
  #              ["rust-analyzer"] = {
  #                checkOnSave = {
  #                  command = "clippy";
  #                };
  #              }
  #            }'';
  #        };
  #      };
  #      # you can do any additional lsp server setup here
  #      # return true if you don't want this server to be setup with lspconfig
  #      # @type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
  #      setup = {
  #        # example to setup with typescript.nvim
  #        # tsserver = function(_, opts)
  #        #   require("typescript").setup({ server = opts })
  #        #  return true
  #        # end,
  #        # Specify * to use this function as a fallback for any server
  #        # ["*"] = function(server, opts) end,
  #        jdtls = let
  #          cmd = lib.getExe' pkgs.jdt-language-server "jdt-language-server";
  #          java-debug =
  #            (pkgs.fetchMavenArtifact
  #              {
  #                groupId = "com.microsoft.java";
  #                artifactId = "com.microsoft.java.debug.plugin";
  #                version = "0.48.0";
  #                sha256 = "sha256-vDKoN1MMZChTvt6jlNHl6C/t+F0p3FhMGcGSmI9V7sI=";
  #              })
  #            .jar;
  #        in
  #          rawLua ''function() return require('polarmutex.config.lsp.java').setup("${cmd}","${java-debug}") end'';
  #      };
  #    };
  #    config = rawLua "function(_, opts) require('polarmutex.config.lsp').setup(opts) end";
  #  }
  vars = {
  };
in
  pkgs.vimUtils.buildVimPlugin {
    pname = "polarmutex";
    version = "dev";
    src = ../nvim;

    postUnpack = ''
      #mkdir -p $sourceRoot/lua
      #mv $sourceRoot/lua $sourceRoot/lua
      mkdir -p $sourceRoot/doc
      ${pkgs.lemmy-help}/bin/lemmy-help -fact \
          $sourceRoot/lua/polarmutex/keymaps.lua \
          > $sourceRoot/doc/polarmutex.txt
    '';

    postInstall = let
      inherit (builtins) attrNames attrValues;
      subs =
        lib.concatStringsSep " "
        (lib.lists.zipListsWith (f: t: "--subst-var-by ${f} ${t}") (attrNames vars) (attrValues vars));
    in
      ''
      ''
      + lib.optionalString
      (vars != null)
      ''
        for filename in $(find $out -type f -print)
        do
          substituteInPlace $filename ${subs}
        done
      '';
    meta = with lib; {
      homepage = "";
      description = "polarmutex neovim configuration";
      license = licenses.mit;
      maintainers = [maintainers.polarmutex];
    };
  }
