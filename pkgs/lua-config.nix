{
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

  lazyPlugins = with pkgs.neovimPlugins; let
    core = [
    ];
    lsp = [
      {
        name = "nvim-lspconfig";
        dir = "${nvim-lspconfig.outPath}";
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
                "/home/polar/repos/personal/beancount-language-server/master/target/release/beancount-language-server"
              ];
              init_options = {
                journal_file = "/home/polar/repos/personal/beancount/main.beancount";
              };
            };
            clangd = {
              cmd = [
                (lib.getExe pkgs.clang)
                "--background-index"
                "--suggest-missing-includes"
                "--clang-tidy"
                "--header-insertion=iwyu"
              ];
              # Required for lsp-status
              init_options = {
                clangdFileStatus = true;
              };
            };
            #gopls = {
            #  cmd = [(lib.getExe pkgs.gopls)];
            #};
            ltex = {
              cmd = [(lib.getExe pkgs.ltex-ls)];
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
              cmd = [(lib.getExe pkgs.lua-language-server)];
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
              pyright = {
                cmd = [(lib.getExe pkgs.pyright) "--stdio"];
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
            };
            nil_ls = {
              cmd = [(lib.getExe pkgs.nil-git)];
            };
            #java = jdt-language-server;
            #rust = rust-analyzer;
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
          };
        };
        config = rawLua "function(_, opts) require('polarmutex.config.lsp').setup(opts) end";
      }
      {
        name = "null-ls";
        dir = "${null-ls-nvim.outPath}";
        event = ["BufReadPre" "BufNewFile"];
        dependencies = [
          {
            name = "plenary.nvim";
            dir = "${plenary-nvim.outPath}";
          }
        ];

        opts = rawLua ''
          function()
              local nls = require("null-ls")
              return {
                  sources = {
                      -- git
                      --nls.builtins.diagnostics.commitlint.with({
                      --    command = "${lib.getExe pkgs.commitlint}",
                      --    filetypes = { "gitcommit", "NeogitCommitMessage" },
                      --}),

                      -- lua
                      nls.builtins.diagnostics.luacheck.with({
                          command = "${lib.getExe pkgs.luajitPackages.luacheck}",
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
        dir = "${luasnip.outPath}";
        dependencies = [
          {
            name = "friendly-snippets";
            dir = "${friendly-snippets.outPath}";
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
        dir = "${nvim-cmp.outPath}";
        event = "InsertEnter";
        dependencies = [
          {
            name = "cmp-nvim-lsp";
            dir = "${cmp-nvim-lsp.outPath}";
          }
          {
            name = "cmp-path";
            dir = "${cmp-path.outPath}";
          }
          {
            name = "cmp-buffer";
            dir = "${cmp-buffer.outPath}";
          }
          #{ name = "cmp-dap", dir = "@neovimPlugin.cmp-dap@" },
          #{ dir = "saadparwaiz1/cmp_luasnip" },
          #{ dir = "rafamadriz/friendly-snippets" },
        ];
        config = rawLua "function() require('polarmutex.config.cmp').setup() end";
      }
      {
        name = "beancount-nvim";
        dir = "${beancount-nvim.outPath}";
        config = rawLua "function() require('polarmutex.config.beancount-nvim').setup() end";
      }
      {
        name = "jdtls-nvim";
        dir = "${nvim-jdtls.outPath}";
      }
      {
        name = "neodev-nvim";
        dir = "${neodev-nvim.outPath}";
        module = "neodev";
        ft = "lua";
      }
      {
        name = "overseer-nvim";
        dir = "${overseer-nvim.outPath}";
        config = rawLua "function() require('polarmutex.config.overseer-nvim').setup() end";
      }
    ];
    dap = [
      {
        name = "nvim-dap";
        dir = "${nvim-dap.outPath}";
      }
      {
        name = "nvim-dap-ui";
        dir = "${nvim-dap-ui}";
      }
      {
        name = "nvim-dap-virtual-text";
        dir = "${nvim-dap-virtual-text}";
      }
    ];
    editor = [
      {
        name = "vim-illuminate";
        dir = "${vim-illuminate.outPath}";
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
        dir = "${telescope-nvim.outPath}";
        event = "CursorHold";
        config = rawLua "function() require('polarmutex.config.telescope-nvim').setup() end";
      }
      {
        name = "trouble.nvim";
        dir = "${trouble-nvim.outPath}";
        cmd = ["TroubleToggle" "Trouble"];
        opts = {use_diagnostic_signs = true;};
      }
      {
        name = "nvim-treesitter";
        dir = "${pkgs.nvim-treesitter-master.outPath}";
        event = ["BufReadPre" "BufNewFile"];
        config = rawLua "function() require('polarmutex.config.treesitter').setup() end";
        dependencies = [
          {
            name = "nvim-treesitter-playground";
            dir = "${nvim-treesitter-playground.outPath}";
            cmd = "TSPlaygroundToggle";
          }
        ];
        #opts = {
        #};
      }
      {
        name = "gitsigns-nvim";
        dir = "${gitsigns-nvim.outPath}";
        config = rawLua "function() require('gitsigns').setup({}) end";
      }
      {
        name = "gitworktree-nvim";
        dir = "${git-worktree-nvim.outPath}";
        event = ["BufReadPre" "BufNewFile"]; # what should this be?
        config = rawLua "function()  require('git-worktree').setup({}) require('telescope').load_extension('git_worktree') end";
      }
      {
        name = "neogit";
        dir = "${neogit.outPath}";
        cmd = "Neogit";
        config = rawLua "function()  require('polarmutex.config.neogit').setup() end";
      }
      {
        name = "diffview-nvim";
        dir = "${diffview-nvim.outPath}";
        config = rawLua "function()  require('diffview').setup() end";
      }
      {
        name = "harpoon";
        dir = "${harpoon.outPath}";
        config = rawLua "function()  require('harpoon').setup({}) require('telescope').load_extension('harpoon') end";
      }
      {
        name = "vim-be-good";
        dir = "${vim-be-good.outPath}";
        cmd = "VimBeGood";
      }
      {
        name = "nvim-web-devicons";
        dir = "${nvim-web-devicons.outPath}";
      }
      {
        name = "yanky.nvim";
        dir = "${yanky-nvim.outPath}";
        dependencies = [
          {
            name = "sqlite.lua";
            dir = "${sqlite-lua.outPath}";
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
    ];
    ui = [
      {
        name = "lualine-nvim";
        dir = "${lualine-nvim.outPath}";
        event = "VeryLazy";
        config = rawLua "function() require('polarmutex.config.lualine').setup() end";
      }
      {
        name = "nvim-navic";
        dir = "${nvim-navic.outPath}";
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
        dir = "${noice-nvim.outPath}";
        event = "VeryLazy";
        dependencies = [
          {
            name = "nui.nvim";
            dir = "${nui-nvim.outPath}";
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
        dir = "${dressing-nvim.outPath}";
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
        dir = "${mini-indentscope.outPath}";
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
        dir = "${edgy-nvim.outPath}";
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
        dir = "${which-key-nvim.outPath}";
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
        dir = "${kanagawa-nvim.outPath}";
        lazy = false;
        config = rawLua "function() require('polarmutex.config.kanagawa-nvim').setup() end";
      }
    ];
  in
    core ++ lsp ++ dap ++ coding ++ editor ++ ui ++ colorschemes;
  vars = {
    #  "astro.language-server" = lib.getExe pkgs.nodePackages."@astrojs/language-server";
    #  "beancount.beancount-language-server" = pkgs.beancount-language-server;
    #  "cpp.clangd" = pkgs.clang-tools_16;
    #  "git.commitlint" =
    #    pkgs.commitlint;
    #  "go.gopls" =
    #    pkgs.gopls;
    #  "json.jsonls" =
    #    lib.getExe pkgs.nodePackages.vscode-json-languageserver;
    #  "java.debug.plugin" =
    #    (pkgs.fetchMavenArtifact
    #      {
    #        groupId = "com.microsoft.java";
    #        artifactId = "com.microsoft.java.debug.plugin";
    #        version = "0.34.0";
    #        sha256 = "sha256-vKvTHA17KPhvxCwI6XdQX3Re2z7vyMhObM9l3QOcrAM=";
    #      })
    #    .jar;
    #  "java.jdk8" =
    #    pkgs.jdk8;
    #  "java.jdk11" =
    #    pkgs.jdk11;
    #  "java.jdk17" =
    #    pkgs.jdk17;
    #  "java.jdt-language-server" =
    #    pkgs.jdt-language-server;
    #  "lua.luacheck" =
    #    pkgs.luajitPackages.luacheck;
    #  "lua.sumneko-lua-language-server" =
    #    pkgs.lua-language-server;
    #  "lua.stylua" =
    #    pkgs.stylua;
    #  "markdown.markdownlint" =
    #    pkgs.nodePackages.markdownlint-cli;
    #  "markdown.mdformat" =
    #    pkgs.mdformat-with-plugins;
    #  "markdown.ltex" =
    #    pkgs.ltex-ls;
    #  "nix.nil" =
    #    lib.getExe pkgs.nil-git;
    #  "nix.alejandra" =
    #    pkgs.alejandra;
    #  "nix.deadnix" =
    #    pkgs.deadnix;
    #  "nix.statix" =
    #    pkgs.statix;
    #  "python.black" =
    #    pkgs.black;
    #  "python.pyright" =
    #    pkgs.pyright;
    #  "python.ruff" =
    #    pkgs.ruff;
    #  "rust.analyzer" =
    #    pkgs.lib.getExe pkgs.rust-analyzer;
    #  "rust.clippy" =
    #    pkgs.clippy;
    #  "svelte.svelte-language-server" =
    #    pkgs.lib.getExe pkgs.nodePackages.svelte-language-server;
    #  "typescript.typescript-language-server" =
    #    lib.getExe pkgs.nodePackages.typescript-language-server;
    #  "yaml.yamlfix" =
    #    pkgs.yamlfix;
    #  "yaml.yamllint" =
    #    pkgs.yamllint;

    #  "neovimPlugin.beancount-nvim" =
    #    pkgs.neovimPlugins.beancount-nvim;
    #  "neovimPlugin.cmp-nvim-lsp" =
    #    pkgs.neovimPlugins.cmp-nvim-lsp;
    #  "neovimPlugin.cmp-path" =
    #    pkgs.neovimPlugins.cmp-path;
    #  "neovimPlugin.cmp-omni" =
    #    pkgs.neovimPlugins.cmp-omni;
    #  "neovimPlugin.cmp-calc" =
    #    pkgs.neovimPlugins.cmp-calc;
    #  "neovimPlugin.cmp-buffer" =
    #    pkgs.neovimPlugins.cmp-buffer;
    #  "neovimPlugin.cmp-cmdline" =
    #    pkgs.neovimPlugins.cmp-cmdline;
    #  "neovimPlugin.cmp-dap" =
    #    pkgs.neovimPlugins.cmp-dap;
    #  "neovimPlugin.crates-nvim" =
    #    pkgs.neovimPlugins.crates-nvim;
    #  "neovimPlugin.diffview-nvim" =
    #    pkgs.neovimPlugins.diffview-nvim;
    #  "neovimPlugin.gitsigns-nvim" =
    #    pkgs.neovimPlugins.gitsigns-nvim;
    #  "neovimPlugin.gitworktree-nvim" =
    #    pkgs.neovimPlugins.git-worktree-nvim;
    #  "neovimPlugin.harpoon" =
    #    pkgs.neovimPlugins.harpoon;
    "neovimPlugin.lazy-nvim" =
      pkgs.neovimPlugins.lazy-nvim;
    #  "neovimPlugin.lsp-kind-nvim" =
    #    pkgs.neovimPlugins.lsp-kind-nvim;
    #  "neovimPlugin.lsp-format-nvim" =
    #    pkgs.neovimPlugins.lsp-format-nvim;
    #  "neovimPlugin.lsp-inlayhints-nvim" =
    #    pkgs.neovimPlugins.lsp-inlayhints-nvim;
    #  "neovimPlugin.lualine-nvim" =
    #    pkgs.neovimPlugins.lualine-nvim;
    #  "neovimPlugin.neodev-nvim" =
    #    pkgs.neovimPlugins.kanagawa-nvim;
    #  "neovimPlugin.kanagawa-nvim" =
    #    pkgs.neovimPlugins.neodev-nvim;
    #  "neovimPlugin.neogit" =
    #    pkgs.neovimPlugins.neogit;
    #  "neovimPlugin.noice-nvim" =
    #    pkgs.neovimPlugins.noice-nvim;
    #  "neovimPlugin.nui-nvim" =
    #    pkgs.neovimPlugins.nui-nvim;
    #  "neovimPlugin.null-ls-nvim" =
    #    pkgs.neovimPlugins.null-ls-nvim;
    #  "neovimPlugin.nvim-cmp" =
    #    pkgs.neovimPlugins.nvim-cmp;
    #  "neovimPlugin.nvim-colorizer" =
    #    pkgs.neovimPlugins.nvim-colorizer;
    #  "neovimPlugin.nvim-dap" =
    #    pkgs.neovimPlugins.nvim-dap;
    #  "neovimPlugin.nvim-dap-python" =
    #    pkgs.neovimPlugins.nvim-dap-python;
    #  "neovimPlugin.nvim-dap-ui" =
    #    pkgs.neovimPlugins.nvim-dap-ui;
    #  "neovimPlugin.nvim-dap-virtual-text" =
    #    pkgs.neovimPlugins.nvim-dap-virtual-text;
    #  "neovimPlugin.nvim-lspconfig" =
    #    pkgs.neovimPlugins.nvim-lspconfig;
    #  "neovimPlugin.nvim-jdtls" =
    #    pkgs.neovimPlugins.nvim-jdtls;
    #  "neovimPlugin.nvim-treesitter" =
    #    pkgs.nvim-treesitter-master;
    #  "neovimPlugin.nvim-treesitter-playground" =
    #    pkgs.neovimPlugins.nvim-treesitter-playground;
    #  "neovimPlugin.one-small-step-for-vimkind" =
    #    pkgs.neovimPlugins.one-small-step-for-vimkind;
    #  "neovimPlugin.overseer-nvim" =
    #    pkgs.neovimPlugins.overseer-nvim;
    #  "neovimPlugin.plenary-nvim" =
    #    pkgs.neovimPlugins.plenary-nvim;
    #  "neovimPlugin.rust-tools-nvim" =
    #    pkgs.neovimPlugins.rust-tools-nvim;
    #  "neovimPlugin.telescope-nvim" =
    #    pkgs.neovimPlugins.telescope-nvim;
    #  "neovimPlugin.tokyonight-nvim" =
    #    pkgs.neovimPlugins.tokyonight-nvim;
    #  "neovimPlugin.vim-be-good" =
    #    pkgs.neovimPlugins.vim-be-good;
    #  "neovimPlugin.nvim-web-devicons" =
    #    pkgs.neovimPlugins.nvim-web-devicons;
  };
in
  pkgs.vimUtils.buildVimPluginFrom2Nix {
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
