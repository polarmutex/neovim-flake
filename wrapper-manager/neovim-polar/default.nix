{
  pkgs,
  lib,
  config,
  npinCompressedPlugins,
  treesitterGrammars,
  ...
}: {
  /*
  Many things stolen from https://github.com/Gerg-L/mnw
  Many things stolen from https://github.com/viperML/dotfiles/blob/master/modules/wrapper-manager/neovim/default.nix :)
  */
  wrappers.neovim-polar = let
    inherit
      (builtins)
      attrValues
      ;
    inherit
      (lib)
      concatMapStringsSep
      flatten
      ;

    allPlugins = flatten [
      (attrValues npinCompressedPlugins)
      (attrValues treesitterGrammars)
    ];

    packName = "polar-pack";
    packDir =
      pkgs.runCommandLocal "pack-dir" {}
      # bash
      ''
        mkdir -pv $out/pack/${packName}/{start,opt}

        ${concatMapStringsSep "\n" (p: ''
            ln -vsfT ${p} $out/pack/${packName}/${
              if p ? passthru.opt && p.passthru.opt
              then "start"
              else "start"
            }/${p.pname}
          '')
          allPlugins}

        ln -vsfT ${pkgs.polar-init-config} $out/pack/${packName}/start/polar-init-config
      '';
  in {
    basePackage = pkgs.neovim-nightly;
    env = {
      NVIM_SYSTEM_RPLUGIN_MANIFEST = {
        value =
          pkgs.writeText "rplugin.vim"
          #vim
          ''
            " empty
          '';
        force = true;
      };
      NVIM_APPNAME = {
        value = "nvim-polar";
      };
    };
    flags = [
      "-u"
      "NORC"
      "--cmd"
      "set packpath^=${packDir} | set runtimepath^=${packDir}"
    ];
    pathAdd = with pkgs; [
      fswatch # for lsp file watching
      xclip # for clipboard

      # cpp
      clang
      clang-tools
      cpplint
      cppcheck

      # lua
      lua-language-server
      luajitPackages.luacheck
      stylua

      # markdown
      prettierd
      markdownlint-cli
      # (pkgs.mdformat.withPlugins (p: [
      #   p.mdformat-frontmatter
      #   p.mdformat-gfm
      #   p.mdformat-toc
      # ]))

      #nix
      # nil
      nixd
      deadnix
      statix
      alejandra

      # python
      (python311.withPackages (ps:
        with ps; [
          black
          python-lsp-server
          python-lsp-black.overrideAttrs
          (oldAttrs: {
            patches =
              oldAttrs.patches
              /*
              fix test failure with black>=24.3.0;
              remove this patch once python-lsp-black>2.0.0
              */
              ++ lib.optional
              (with lib; (versionOlder version "2.0.1") && (versionAtLeast black.version "24.3.0"))
              (fetchpatch {
                url = "https://patch-diff.githubusercontent.com/raw/python-lsp/python-lsp-black/pull/59.patch";
                hash = "sha256-4u0VIS7eidVEiKRW2wc8lJVkJwhzJD/M+uuqmTtiZ7E=";
              });
          })
          python-lsp-ruff
          pydocstyle
          debugpy
        ]))
      ruff
      basedpyright

      # rust
      rust-analyzer

      # yaml
      nodePackages_latest.yaml-language-server

      # java
      jdt-language-server

      # arduino
      arduino-cli
    ];
    overrideAttrs = old: let
      pname = config.wrappers.neovim-polar.env.NVIM_APPNAME.value;
      inherit (config.wrappers.neovim-polar.basePackage) version;
    in {
      name = "${pname}-${version}";
      passthru =
        (old.passthru or {})
        // {
          inherit packDir;
        };
    };
    postBuild = ''
      export HOME="$(mktemp -d)"
      status="$($out/bin/nvim --headless '+lua =require("polar.health").loaded' '+q' 2>&1)"
      if [[ "$status" != "true" ]]; then
        echo ":: Health check FAILED"
        echo "$status"
        # exit 1
      else
        echo ":: Health check OK"
      fi
    '';
  };
}
