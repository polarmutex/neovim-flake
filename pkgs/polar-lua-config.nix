{
  packages,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) typeOf toJSON;
  nix2vim = "nix2vim";
  trace = it: builtins.trace it it;

  typeConverters = {
    "" = name: it: "${name} = ${nix2lua it}";
    rawLua = name: it: "${name} = ${it}";
    table = name: it: "${name} = ${nix2lua it}";
    callWith = name: it: let
      value =
        if lib.isAttrs it
        then nix2lua it
        else if lib.isList it
        then lib.concatStringsSep ", " (map nix2lua it)
        else toJSON it;
    in "${name}(${value})";
  };

  flatAttrs2Lua = flattened:
    lib.foldl'
    (
      sum: name: let
        it = flattened.${name};
      in
        sum + typeConverters.${it.subtype or ""} name (it.content or it) + "\n"
    )
    ""
    (lib.attrNames flattened);

  nix2lua = args:
    if (args.type or null) == nix2vim
    then let
      subtypes = {
        "" = throw "No method to crate lua from ${args.subtype}";
        callWith = throw "Cannot perform callWith within a structure";
        rawLua = args.content;
        table = nix2lua args.content;
      };
    in
      subtypes.${args.subtype or ""}
    else if lib.isList args
    then "{" + lib.concatMapStringsSep ", " nix2lua args + "}"
    else if lib.isAttrs args && (args.type or null) != "derivation"
    then "{" + lib.concatMapStringsSep ", " (it: "${it} = ${nix2lua args.${it}}") (lib.attrNames args) + "}"
    else toJSON args;

  op = sum: path: val: let
    isCustomValue = val ? type && (val.type == nix2vim || val.type == "derivation");
    pathStr = lib.concatStringsSep "." path;
  in
    if !(lib.isAttrs val) || isCustomValue
    then (sum // {"${pathStr}" = val;})
    else if lib.isFunction val
    then abort "Nix funcitons can not be parsed"
    else (recurse sum path val);

  recurse = sum: path: val:
    lib.foldl'
    (sum: key: op sum (path ++ [key]) val.${key})
    sum
    (builtins.attrNames val);

  mkCustomType = subtype: content: {
    inherit subtype content;
    type = nix2vim;
  };

  toTable = content: mkCustomType "table" content;
  rawLua = content: mkCustomType "rawLua" content;

  lazyPlugins = with packages; let
    core = [
    ];
    lsp = [
      {
        name = "nvim-lspconfig";
        dir = "${neovim-plugin-nvim-lspconfig.outPath}";
        event = ["BufReadPre" "BufNewFile"];
        opts = {
          diagnostics = {
            underline = true;
            update_in_insert = false;
            virtual_text = {
              spacing = 4;
              source = "if_many";
              prefix = "●";
              # this will set set the prefix to a function that returns the diagnostics icon based on the severity
              # this only works on a recent 0.10.0 build. Will be set to "●" when not supported
              # prefix = "icons",
            };
            severity_sort = true;
          };
          # Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
          # Be aware that you also will need to properly configure your LSP server to
          # provide the inlay hints.
          inlay_hints = {
            enabled = true;
          };
          # Automatically format on save
          autoformat = true;
          # Enable this to show formatters used in a notification
          # Useful for debugging formatter issues
          format_notify = false;
          # options for vim.lsp.buf.format
          # `bufnr` and `filter` is handled by the LazyVim formatter,
          # but can be also overridden when specified
          format = {
            formatting_options = rawLua "nil";
            timeout_ms = rawLua "nil";
          };
          # LSP Server Settings
          # @type lspconfig.options
          servers = {
            beancount = {
              cmd = [
                #(lib.getExe beancount-language-server)
                "/home/polar/repos/personal/beancount-language-server/main/target/release/beancount-language-server"
              ];
              init_options = {
                journal_file = "/home/polar/repos/personal/beancount/main/main.beancount";
              };
            };
            clangd = {
              cmd = [
                (lib.getExe pkgs.clang)
                "--background-index"
                "--clang-tidy"
                "--header-insertion=iwyu"
                "--completion-style=detailed"
                "--function-arg-placeholders"
                "--fallback-style=llvm"
              ];
              init_options = {
                usePlaceholders = true;
                completeUnimported = true;
                clangdFileStatus = true;
              };
            };
            #gopls = {
            #  cmd = [(lib.getExe pkgs.gopls)];
            #};
            jdtls = {
              cmd = [(lib.getExe' pkgs.jdt-language-server "jdt-language-server")];
            };
            ltex = {
              cmd = [(lib.getExe' pkgs.ltex-ls "ltex-ls")];
              filetypes = ["markdown"];
              settings = {
                enabled = ["markdown"];
                checkFrequency = "save";
                language = "en-US";
                diagnosticSeverity = "information";
                setenceCacheSize = 5000;
                additionalRules = {
                  enablePickyRules = true;
                };
              };
            };
            lua_ls = {
              cmd = [(lib.getExe' pkgs.lua-language-server "lua-language-server")];
              settings = {
                Lua = {
                  diagnostics = {
                    globals = [
                      # neovim
                      "vim"
                      # awesomewm
                      "awesome"
                      "client"
                      "screen"
                    ];
                  };
                  format = {
                    enable = false;
                  };
                  workspace = {
                    checkThirdParty = false;
                  };
                  #completion = {
                  #  callSnippet = "Replace";
                  #};
                };
              };
            };
            nil_ls = {
              cmd = [(lib.getExe' pkgs.nil-git "nil")];
            };
            pyright = {
              cmd = [(lib.getExe' pkgs.pyright "pyright-langserver") "--stdio"];
              settings = {
                python = {
                  analysis = {
                    autoSearchPaths = true;
                    useLibraryCodeForTypes = true;
                    diagnosticMode = "openFilesOnly";
                  };
                };
              };
            };
            #ruff_lsp = {
            #  cmd = [(lib.getExe' pkgs.ruff-lsp "ruff-lsp")];
            #};
            rust_analyzer = {
              cmd = [(lib.getExe pkgs.rust-analyzer)];
              settings = rawLua ''
                {
                  ["rust-analyzer"] = {
                    checkOnSave = {
                      command = "clippy";
                    };
                  }
                }'';
            };
          };
          # you can do any additional lsp server setup here
          # return true if you don't want this server to be setup with lspconfig
          # @type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
          setup = {
            # example to setup with typescript.nvim
            # tsserver = function(_, opts)
            #   require("typescript").setup({ server = opts })
            #  return true
            # end,
            # Specify * to use this function as a fallback for any server
            # ["*"] = function(server, opts) end,
            jdtls = let
              cmd = lib.getExe' pkgs.jdt-language-server "jdt-language-server";
              java-debug =
                (pkgs.fetchMavenArtifact
                  {
                    groupId = "com.microsoft.java";
                    artifactId = "com.microsoft.java.debug.plugin";
                    version = "0.48.0";
                    sha256 = "sha256-vDKoN1MMZChTvt6jlNHl6C/t+F0p3FhMGcGSmI9V7sI=";
                  })
                .jar;
            in
              rawLua ''function() return require('polarmutex.config.lsp.java').setup("${cmd}","${java-debug}") end'';
          };
        };

        config = rawLua "function(_, opts) require('polarmutex.config.lsp').setup(opts) end";
      }
      {
        name = "null-ls";
        dir = "${neovim-plugin-null-ls-nvim.outPath}";
        event = ["BufReadPre" "BufNewFile"];
        dependencies = [
          {
            name = "plenary.nvim";
            dir = "${neovim-plugin-plenary-nvim.outPath}";
          }
        ];

        opts = rawLua ''
          function()
              local nls = require("null-ls")
              return {
                  sources = {
                      -- docker
                      --nls.builtins.diagnostics.hadolint.with({
                      --    command = "$<del me>{lib.getExe pkgs.hadolint}",
                      --}),
                      -- git
                      --nls.builtins.diagnostics.commitlint.with({
                      --    command = "${lib.getExe pkgs.commitlint}",
                      --    filetypes = { "gitcommit", "NeogitCommitMessage" },
                      --}),

                      -- lua
                      nls.builtins.diagnostics.luacheck.with({
                          command = "${lib.getExe' pkgs.luajitPackages.luacheck "luacheck"}",
                      }),
                      nls.builtins.formatting.stylua.with({
                          command = "${lib.getExe pkgs.stylua}",
                      }),

                      -- markdown
                      nls.builtins.diagnostics.markdownlint.with({
                          command = "${lib.getExe pkgs.markdownlint-cli}",
                      }),
                      nls.builtins.formatting.mdformat.with({
                          command = "${lib.getExe pkgs.mdformat-with-plugins}",
                      }),

                      -- nix
                      nls.builtins.diagnostics.deadnix.with({
                          command = "${lib.getExe pkgs.deadnix}",
                      }),
                      nls.builtins.diagnostics.statix.with({
                          command = "${lib.getExe pkgs.statix}",
                      }),
                      nls.builtins.formatting.alejandra.with({
                          command = "${lib.getExe pkgs.alejandra}",
                      }),

                      -- python
                      nls.builtins.diagnostics.ruff.with({
                          command = "${lib.getExe pkgs.ruff}",
                      }),
                      nls.builtins.formatting.black.with({
                          command = "${lib.getExe pkgs.black}",
                      }),
                      --nls.builtins.diagnostics.mypy,

                      -- yaml
                      --nls.builtins.diagnostics.yamllint.with({
                      --    command = "@yaml.yamllint@/bin/yamllint",
                      --}),
                  },
              }
          end
        '';
      }
    ];
    coding = [
      {
        name = "luasnip";
        dir = "${neovim-plugin-luasnip.outPath}";
        dependencies = [
          {
            name = "friendly-snippets";
            dir = "${neovim-plugin-friendly-snippets.outPath}";
            config = rawLua ''function() require("luasnip.loaders.from_vscode").lazy_load() end'';
          }
        ];
        opts = {
          history = true;
          delete_check_events = "TextChanged";
        };
      }
      {
        name = "nvim-cmp";
        dir = "${neovim-plugin-nvim-cmp.outPath}";
        event = "InsertEnter";
        dependencies = [
          {
            name = "cmp-nvim-lsp";
            dir = "${neovim-plugin-cmp-nvim-lsp.outPath}";
          }
          {
            name = "cmp-path";
            dir = "${neovim-plugin-cmp-path.outPath}";
          }
          {
            name = "cmp-buffer";
            dir = "${neovim-plugin-cmp-buffer.outPath}";
          }
          #{ name = "cmp-dap", dir = "@neovimPlugin.cmp-dap@" },
          #{ dir = "saadparwaiz1/cmp_luasnip" },
          #{ dir = "rafamadriz/friendly-snippets" },
        ];
        config = rawLua "function() require('polarmutex.config.cmp').setup() end";
      }
      {
        name = "beancount-nvim";
        dir = "${neovim-plugin-beancount-nvim.outPath}";
        config = rawLua "function() require('polarmutex.config.beancount-nvim').setup() end";
        ft = "beancount";
      }
      {
        name = "jdtls-nvim";
        dir = "${neovim-plugin-nvim-jdtls.outPath}";
      }
      {
        name = "neodev-nvim";
        dir = "${neovim-plugin-neodev-nvim.outPath}";
        module = "neodev";
        ft = "lua";
      }
      {
        name = "overseer-nvim";
        dir = "${neovim-plugin-overseer-nvim.outPath}";
        config = rawLua "function() require('polarmutex.config.overseer-nvim').setup() end";
      }
    ];
    dap = [
      {
        name = "nvim-dap";
        dir = "${neovim-plugin-nvim-dap.outPath}";
      }
      {
        name = "nvim-dap-ui";
        dir = "${neovim-plugin-nvim-dap-ui}";
      }
      {
        name = "nvim-dap-virtual-text";
        dir = "${neovim-plugin-nvim-dap-virtual-text}";
      }
    ];
    editor = [
      {
        name = "vim-illuminate";
        dir = "${neovim-plugin-vim-illuminate.outPath}";
        event = ["BufReadPost" "BufNewFile"];
        opts = {
          delay = 200;
          large_file_cutoff = 2000;
          large_file_overrides = {
            providers = ["lsp"];
          };
        };
        config = rawLua "function(_, opts) require('polarmutex.config.vim-illuminate').setup(opts) end";
      }
      {
        name = "telescope-nvim";
        dir = "${neovim-plugin-telescope-nvim.outPath}";
        event = "CursorHold";
        config = rawLua "function() require('polarmutex.config.telescope-nvim').setup() end";
      }
      {
        name = "trouble.nvim";
        dir = "${neovim-plugin-trouble-nvim.outPath}";
        cmd = ["TroubleToggle" "Trouble"];
        opts = {use_diagnostic_signs = true;};
      }
      {
        name = "nvim-treesitter";
        dir = "${neovim-plugin-nvim-treesitter.outPath}";
        event = ["BufReadPre" "BufNewFile"];
        config = rawLua "function() require('polarmutex.config.treesitter').setup() end";
        dependencies = [
          {
            name = "nvim-treesitter-playground";
            dir = "${neovim-plugin-nvim-treesitter-playground.outPath}";
            cmd = "TSPlaygroundToggle";
          }
        ];
        #opts = {
        #};
      }
      {
        name = "gitsigns-nvim";
        dir = "${neovim-plugin-gitsigns-nvim.outPath}";
        config = rawLua "function() require('gitsigns').setup({}) end";
        event = ["BufReadPre" "BufNewFile"]; # what should this be?
      }
      {
        name = "gitworktree-nvim";
        dir = "${neovim-plugin-git-worktree-nvim.outPath}";
        event = ["BufReadPre" "BufNewFile"]; # what should this be?
        config = rawLua "function()  require('git-worktree').setup({}) require('telescope').load_extension('git_worktree') end";
      }
      {
        name = "neogit";
        dir = "${neovim-plugin-neogit.outPath}";
        cmd = "Neogit";
        config = rawLua "function()  require('polarmutex.config.neogit').setup() end";
      }
      {
        name = "diffview-nvim";
        dir = "${neovim-plugin-diffview-nvim.outPath}";
        config = rawLua "function()  require('diffview').setup() end";
      }
      {
        name = "harpoon";
        dir = "${neovim-plugin-harpoon.outPath}";
        config = rawLua "function()  require('harpoon').setup({}) require('telescope').load_extension('harpoon') end";
      }
      {
        name = "vim-be-good";
        dir = "${neovim-plugin-vim-be-good.outPath}";
        cmd = "VimBeGood";
      }
      {
        name = "nvim-web-devicons";
        dir = "${neovim-plugin-nvim-web-devicons.outPath}";
      }
      {
        name = "yanky.nvim";
        dir = "${neovim-plugin-yanky-nvim.outPath}";
        dependencies = [
          {
            name = "sqlite.lua";
            dir = "${neovim-plugin-sqlite-lua.outPath}";
          }
        ];
        opts = rawLua ''
          function()
            local mapping = require("yanky.telescope.mapping")
            local mappings = mapping.get_defaults()
            mappings.i["<c-p>"] = nil
            return {
              highlight = { timer = 200 },
              ring = { storage = "sqlite" },
              picker = {
                telescope = {
                  use_default_mappings = false,
                  mappings = mappings,
                },
              },
            }
          end,
        '';
      }
      {
        name = "flash.nvim";
        dir = "${neovim-plugin-flash-nvim.outPath}";
        event = "VeryLazy";
        opts = {};
      }
    ];
    ui = [
      {
        name = "lualine-nvim";
        dir = "${neovim-plugin-lualine-nvim.outPath}";
        event = "VeryLazy";
        config = rawLua "function() require('polarmutex.config.lualine').setup() end";
      }
      {
        name = "nvim-navic";
        dir = "${neovim-plugin-nvim-navic.outPath}";
        lazy = true;
        init = rawLua ''
          function()
            vim.g.navic_silence = true
            require("polarmutex.utils").on_attach(function(client, buffer)
              if client.server_capabilities.documentSymbolProvider then
                require("nvim-navic").attach(client, buffer)
              end
            end)
          end
        '';
        opts = rawLua ''
          function()
            return {
              separator = " ",
              highlight = true,
              depth_limit = 5,
              icons = require("polarmutex.icons").kinds,
            }
          end,
        '';
        config = rawLua "function() require('polarmutex.config.lualine').setup() end";
      }
      {
        name = "noice-nvim";
        dir = "${neovim-plugin-noice-nvim.outPath}";
        event = "VeryLazy";
        dependencies = [
          {
            name = "nui.nvim";
            dir = "${neovim-plugin-nui-nvim.outPath}";
          }
        ];
        opts = {
          lsp = {
            # override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = rawLua ''
              {["vim.lsp.util.convert_input_to_markdown_lines"] = true,
              ["vim.lsp.util.stylize_markdown"] = true,
              ["cmp.entry.get_documentation"] = true,},'';
          };
          routes = [
            {
              filter = {
                event = "msg_show";
                any = [
                  {find = "%d+L, %d+B";}
                  {find = "; after #%d+";}
                  {find = "; before #%d+";}
                ];
              };
              view = "mini";
            }
          ];
          # you can enable a preset for easier configuration
          presets = {
            bottom_search = true; #use a classic bottom cmdline for search
            command_palette = true; # position the cmdline and popupmenu together
            long_message_to_split = true; # long messages will be sent to a split
            inc_rename = true; # enables an input dialog for inc-rename.nvim
          };
        };
        config = rawLua "function(_, opts) require('noice').setup(opts) end";
      }
      {
        name = "dressing-nvim";
        dir = "${neovim-plugin-dressing-nvim.outPath}";
        init = rawLua ''
          function()
              vim.ui.select = function(...)
                require("lazy").load({ plugins = { "dressing-nvim" } })
                return vim.ui.select(...)
              end
              vim.ui.input = function(...)
                require("lazy").load({ plugins = { "dressing-nvim" } })
                return vim.ui.input(...)
              end
          end
        '';
      }
      {
        name = "mini.indentscope";
        dir = "${neovim-plugin-mini-indentscope.outPath}";
        event = ["BufReadPre" "BufNewFile"];
        opts = {
          symbol = "│";
          options = {try_as_border = true;};
        };
        init = rawLua ''
          function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "help",
                    "lazy",
                    "Trouble",
                },
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })
          end
        '';
      }
      {
        name = "edgy.nvim";

        dir = "${neovim-plugin-edgy-nvim.outPath}";
        event = "VeryLazy";
        opts = {
          top = [
            {
              ft = "gitcommit";
              size = {height = 0.5;};
              wo = {signcolumn = "yes:2";};
            }
          ];
          bottom = [
            {
              ft = "noice";
              size = {height = 0.4;};
              filter = rawLua ''function(buf, win) return vim.api.nvim_win_get_config(win).relative == "" end '';
            }
            "Trouble"
            {
              ft = "qf";
              title = "QuickFix";
            }
            {
              ft = "help";
              size = {height = 20;};
              filter = rawLua ''function(buf) return vim.bo[buf].buftype == "help" end'';
            }
            {
              ft = "NeogitStatus";
              size = {height = 0.3;};
              wo = {signcolumn = "yes:2";};
            }
            #      {
            #        title = "Neotest Output";
            #        ft = "neotest-output-panel";
            #        size = {height = 15;};
            #      }
          ];
          left = [
            #      {
            #        title = "Neotest Summary";
            #        ft = "neotest-summary";
            #      }
          ];
        };
      }
      {
        name = "which-key-nvim";
        dir = "${neovim-plugin-which-key-nvim.outPath}";
        event = "VeryLazy";
        config = rawLua ''
          function(_, opts)
              local wk = require("which-key")
              wk.setup(opts)
              wk.register(opts.defaults)
          end
        '';
      }
    ];
    colorschemes = [
      {
        name = "kanagawa-nvim";
        dir = "${neovim-plugin-kanagawa-nvim.outPath}";
        lazy = false;
        config = rawLua "function() require('polarmutex.config.kanagawa-nvim').setup() end";
      }
    ];
  in
    core ++ lsp ++ dap ++ coding ++ editor ++ ui ++ colorschemes;
  vars = {
    "neovimPlugin.lazy-nvim" =
      packages.neovim-plugin-lazy-nvim;
  };
in
  pkgs.vimUtils.buildVimPlugin {
    pname = "polarmutex";
    version = "dev";
    src = ../config;

    postUnpack = ''
      #mkdir -p $sourceRoot/lua
      #mv $sourceRoot/lua $sourceRoot/lua
      mkdir -p $sourceRoot/doc
      ${pkgs.lemmy-help}/bin/lemmy-help -fact \
          $sourceRoot/lua/polarmutex/config/lazy.lua \
          $sourceRoot/lua/polarmutex/keymaps.lua \
          > $sourceRoot/doc/polarmutex.txt
    '';

    postInstall = let
      inherit (builtins) attrNames attrValues;
      subs =
        lib.concatStringsSep " "
        (lib.lists.zipListsWith (f: t: "--subst-var-by ${f} ${t}") (attrNames vars) (attrValues vars));
      lazy-plugins-file = pkgs.writeText "plugins.lua" ("return " + (nix2lua lazyPlugins));
    in
      ''
        cat ${lazy-plugins-file} > $out/lua/polarmutex/plugins.lua
        ${pkgs.luaformatter}/bin/lua-format $out/lua/polarmutex/plugins.lua -i
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
