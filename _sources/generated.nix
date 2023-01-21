# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub }:
{
  plugin-beancount-nvim = {
    pname = "plugin-beancount-nvim";
    version = "493d53ae0cfcc96d2574f6d74edd37c25134e818";
    src = fetchFromGitHub ({
      owner = "polarmutex";
      repo = "beancount.nvim";
      rev = "493d53ae0cfcc96d2574f6d74edd37c25134e818";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-4EsdgpiUkC6TZEKL7EJSjdE/XniZHxFMpVFJA7aRsnY=";
    });
  };
  plugin-cmp-buffer = {
    pname = "plugin-cmp-buffer";
    version = "3022dbc9166796b644a841a02de8dd1cc1d311fa";
    src = fetchFromGitHub ({
      owner = "hrsh7th";
      repo = "cmp-buffer";
      rev = "3022dbc9166796b644a841a02de8dd1cc1d311fa";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-mJgNij0eTnAM3vIbuECF9mZ/J42v6k441z/vUNJRGSc=";
    });
  };
  plugin-cmp-calc = {
    pname = "plugin-cmp-calc";
    version = "50792f34a628ea6eb31d2c90e8df174671e4e7a0";
    src = fetchFromGitHub ({
      owner = "hrsh7th";
      repo = "cmp-calc";
      rev = "50792f34a628ea6eb31d2c90e8df174671e4e7a0";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-yOLDr3E63k1rwacDeWw35/8OPfUb2hBDgZ0Q4Wkjn7Y=";
    });
  };
  plugin-cmp-cmdline = {
    pname = "plugin-cmp-cmdline";
    version = "23c51b2a3c00f6abc4e922dbd7c3b9aca6992063";
    src = fetchFromGitHub ({
      owner = "hrsh7th";
      repo = "cmp-cmdline";
      rev = "23c51b2a3c00f6abc4e922dbd7c3b9aca6992063";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-WyYPNwex0w08oR7dJ0MX6hROL7W48OfzuM+EhA9mC58=";
    });
  };
  plugin-cmp-dap = {
    pname = "plugin-cmp-dap";
    version = "d16f14a210cd28988b97ca8339d504533b7e09a4";
    src = fetchFromGitHub ({
      owner = "rcarriga";
      repo = "cmp-dap";
      rev = "d16f14a210cd28988b97ca8339d504533b7e09a4";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-tumnAAPImLQGKJ3yaQm1xVF1prZo1pZ81hsYlfkRtfc=";
    });
  };
  plugin-cmp-emoji = {
    pname = "plugin-cmp-emoji";
    version = "19075c36d5820253d32e2478b6aaf3734aeaafa0";
    src = fetchFromGitHub ({
      owner = "hrsh7th";
      repo = "cmp-emoji";
      rev = "19075c36d5820253d32e2478b6aaf3734aeaafa0";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-YE9dV+WI08gzbcyA18dufwFoHP7BeWFyLTvj9VCKWPc=";
    });
  };
  plugin-cmp-nvim-lsp = {
    pname = "plugin-cmp-nvim-lsp";
    version = "59224771f91b86d1de12570b4070fe4ad7cd1eeb";
    src = fetchFromGitHub ({
      owner = "hrsh7th";
      repo = "cmp-nvim-lsp";
      rev = "59224771f91b86d1de12570b4070fe4ad7cd1eeb";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-E87EKtMWUJT4RO9JzTh0ZrKbEoRtE1cTdGq4HD6bIFQ=";
    });
  };
  plugin-cmp-nvim-lsp-signature-help = {
    pname = "plugin-cmp-nvim-lsp-signature-help";
    version = "d2768cb1b83de649d57d967085fe73c5e01f8fd7";
    src = fetchFromGitHub ({
      owner = "hrsh7th";
      repo = "cmp-nvim-lsp-signature-help";
      rev = "d2768cb1b83de649d57d967085fe73c5e01f8fd7";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-7jK6NzHAwW+ux4ZMWaaHdDz39Ws5+3bx0EpMjgpk+yA=";
    });
  };
  plugin-cmp-omni = {
    pname = "plugin-cmp-omni";
    version = "8457e4144ea2fc5efbadb7d22250d5ee8f8862ba";
    src = fetchFromGitHub ({
      owner = "hrsh7th";
      repo = "cmp-omni";
      rev = "8457e4144ea2fc5efbadb7d22250d5ee8f8862ba";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-rQvAWD49YerLPu7GW/UOZksvpkv0sBlX1sF8XnrM4l4=";
    });
  };
  plugin-cmp-path = {
    pname = "plugin-cmp-path";
    version = "91ff86cd9c29299a64f968ebb45846c485725f23";
    src = fetchFromGitHub ({
      owner = "hrsh7th";
      repo = "cmp-path";
      rev = "91ff86cd9c29299a64f968ebb45846c485725f23";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-Fm7L5IJ/Dp+lf9qsMHzFLF85oaaU5wXr/rEa5fzI6c8=";
    });
  };
  plugin-crates-nvim = {
    pname = "plugin-crates-nvim";
    version = "707ed7d6f8927a5ec0c241aa793f694f1b05f731";
    src = fetchFromGitHub ({
      owner = "Saecki";
      repo = "crates.nvim";
      rev = "707ed7d6f8927a5ec0c241aa793f694f1b05f731";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-4G0vYwomeRFmrmHZB+p1vpzdAAjAfeyH3EDdg7n/pyQ=";
    });
  };
  plugin-diffview-nvim = {
    pname = "plugin-diffview-nvim";
    version = "5bbcf162d03287296fe393f88da6065db3cf9fd0";
    src = fetchFromGitHub ({
      owner = "sindrets";
      repo = "diffview.nvim";
      rev = "5bbcf162d03287296fe393f88da6065db3cf9fd0";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-RrFkdpgD1KNeEBqW5YVeETSkXN2Qr88PIwWYkcM3cYY=";
    });
  };
  plugin-gitsigns-nvim = {
    pname = "plugin-gitsigns-nvim";
    version = "7b37bd5c2dd4d7abc86f2af096af79120608eeca";
    src = fetchFromGitHub ({
      owner = "lewis6991";
      repo = "gitsigns.nvim";
      rev = "7b37bd5c2dd4d7abc86f2af096af79120608eeca";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-lwIzxHBQ3rZqmwWKyJY9bJ8vAnt6jn5SOX+SugwAc2E=";
    });
  };
  plugin-heirline-nvim = {
    pname = "plugin-heirline-nvim";
    version = "b07ae7e499fecc263f38d1db7feeb2da227df370";
    src = fetchFromGitHub ({
      owner = "rebelot";
      repo = "heirline.nvim";
      rev = "b07ae7e499fecc263f38d1db7feeb2da227df370";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-0L7LzEDVgfSHaBbs+1a7prtqxuljYtUgFgCIDm1xB+s=";
    });
  };
  plugin-lazy-nvim = {
    pname = "plugin-lazy-nvim";
    version = "96d759d1cbd8b0bd0ea0a0c2987f99410272f348";
    src = fetchFromGitHub ({
      owner = "folke";
      repo = "lazy.nvim";
      rev = "96d759d1cbd8b0bd0ea0a0c2987f99410272f348";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-8JM5plFk/lP3Uo5S+MkYV1Hyg+Ck/+10nBh2231zjc0=";
    });
  };
  plugin-lspformat-nvim = {
    pname = "plugin-lspformat-nvim";
    version = "ca0df5c8544e51517209ea7b86ecc522c98d4f0a";
    src = fetchFromGitHub ({
      owner = "lukas-reineke";
      repo = "lsp-format.nvim";
      rev = "ca0df5c8544e51517209ea7b86ecc522c98d4f0a";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-9cY0QLyzkGv7KDVUXMXZj5TKZSSbXL6JN/Al3nhn5ps=";
    });
  };
  plugin-lspkind-nvim = {
    pname = "plugin-lspkind-nvim";
    version = "c68b3a003483cf382428a43035079f78474cd11e";
    src = fetchFromGitHub ({
      owner = "onsails";
      repo = "lspkind.nvim";
      rev = "c68b3a003483cf382428a43035079f78474cd11e";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-LIbh63B+Sbu3/ahSPSa6K/X1Sqq32t9d9p/InaKu01I=";
    });
  };
  plugin-neodev-nvim = {
    pname = "plugin-neodev-nvim";
    version = "34dd33cd283b3a89f70d32c8f55bb5ec4ce2de93";
    src = fetchFromGitHub ({
      owner = "folke";
      repo = "neodev.nvim";
      rev = "34dd33cd283b3a89f70d32c8f55bb5ec4ce2de93";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-WNE0Z8/Je6tf06HVbFH6k7Mn/6n9sBy2BBAQGp0kBOQ=";
    });
  };
  plugin-neogit = {
    pname = "plugin-neogit";
    version = "30265e7a1bdf59361b37e293cdcecc167851c602";
    src = fetchFromGitHub ({
      owner = "TimUntersberger";
      repo = "neogit";
      rev = "30265e7a1bdf59361b37e293cdcecc167851c602";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-ns9x+YLk5NL8Ew0kJX/v8ICOimtNpmsU51nyTXAw8sU=";
    });
  };
  plugin-noice-nvim = {
    pname = "plugin-noice-nvim";
    version = "16b60455867dec069bf41699d690fa01261b4bf6";
    src = fetchFromGitHub ({
      owner = "folke";
      repo = "noice.nvim";
      rev = "16b60455867dec069bf41699d690fa01261b4bf6";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-LdDt42kpiTtBm40hFHjr3lOAR+njVke7WfLU6DdWGR0=";
    });
  };
  plugin-nui-nvim = {
    pname = "plugin-nui-nvim";
    version = "b99e6cb13dc51768abc1c4c8585045a0c0459ef1";
    src = fetchFromGitHub ({
      owner = "MunifTanjim";
      repo = "nui.nvim";
      rev = "b99e6cb13dc51768abc1c4c8585045a0c0459ef1";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-h7RwCFCE7jCw4DYYYtDVmkY8PsiIwDdFbExj1++dhlA=";
    });
  };
  plugin-null-ls-nvim = {
    pname = "plugin-null-ls-nvim";
    version = "33cfeb7a761f08e8535dca722d4b237cabadd371";
    src = fetchFromGitHub ({
      owner = "jose-elias-alvarez";
      repo = "null-ls.nvim";
      rev = "33cfeb7a761f08e8535dca722d4b237cabadd371";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-m+F9WYNhapCgovthMWfZ21y2KA5nCOiaURonphppQ4Q=";
    });
  };
  plugin-nvim-cmp = {
    pname = "plugin-nvim-cmp";
    version = "11a95792a5be0f5a40bab5fc5b670e5b1399a939";
    src = fetchFromGitHub ({
      owner = "hrsh7th";
      repo = "nvim-cmp";
      rev = "11a95792a5be0f5a40bab5fc5b670e5b1399a939";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-JOOQynWqIIWclPB0JnyG2J525xhpjkzsYS0VzqrC2K4=";
    });
  };
  plugin-nvim-colorizer = {
    pname = "plugin-nvim-colorizer";
    version = "36c610a9717cc9ec426a07c8e6bf3b3abcb139d6";
    src = fetchFromGitHub ({
      owner = "norcalli";
      repo = "nvim-colorizer.lua";
      rev = "36c610a9717cc9ec426a07c8e6bf3b3abcb139d6";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-AZveV57JRp+S330jWarDtNxW0seTefmhxfYysVxEsco=";
    });
  };
  plugin-nvim-dap = {
    pname = "plugin-nvim-dap";
    version = "c64a6627bb01eb151da96b28091797beaac09536";
    src = fetchFromGitHub ({
      owner = "mfussenegger";
      repo = "nvim-dap";
      rev = "c64a6627bb01eb151da96b28091797beaac09536";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-fwtii16+ZY8rNIUZiGjnNVlrAv8ddaLbMjJoQNJzKgk=";
    });
  };
  plugin-nvim-dap-python = {
    pname = "plugin-nvim-dap-python";
    version = "d4400d075c21ed8fb8e8ac6a5ff56f58f6e93531";
    src = fetchFromGitHub ({
      owner = "mfussenegger";
      repo = "nvim-dap-python";
      rev = "d4400d075c21ed8fb8e8ac6a5ff56f58f6e93531";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-0OY9/66Wz73BaWv5w+xSIk9If9GFlTo43IQdYhGi28A=";
    });
  };
  plugin-nvim-dap-ui = {
    pname = "plugin-nvim-dap-ui";
    version = "b80227ea56a48177786904f6322abc8b2dc0bc36";
    src = fetchFromGitHub ({
      owner = "rcarriga";
      repo = "nvim-dap-ui";
      rev = "b80227ea56a48177786904f6322abc8b2dc0bc36";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-mXK2eEbEVWSqHcsaisuFAFoPmebJDR69d8/Uy13PUds=";
    });
  };
  plugin-nvim-dap-virtual-text = {
    pname = "plugin-nvim-dap-virtual-text";
    version = "191345947a92a5188d791e9786a5b4f205dcaca3";
    src = fetchFromGitHub ({
      owner = "theHamsta";
      repo = "nvim-dap-virtual-text";
      rev = "191345947a92a5188d791e9786a5b4f205dcaca3";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-9hHRLJdbNdO1evALo1siz4aVNOv16lQ0pxAHSTIkJIY=";
    });
  };
  plugin-nvim-lspconfig = {
    pname = "plugin-nvim-lspconfig";
    version = "85cd2ecacd8805614efe3fb3a5146ac7d0f88a17";
    src = fetchFromGitHub ({
      owner = "neovim";
      repo = "nvim-lspconfig";
      rev = "85cd2ecacd8805614efe3fb3a5146ac7d0f88a17";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-IqCfF2cW4fKWm8FoZVnKB7Wls21kHVM8J0jJvw5h6no=";
    });
  };
  plugin-nvim-treesitter = {
    pname = "plugin-nvim-treesitter";
    version = "da6dc214ddde3fac867bd4a6f4ea51a794b01e18";
    src = fetchFromGitHub ({
      owner = "nvim-treesitter";
      repo = "nvim-treesitter";
      rev = "da6dc214ddde3fac867bd4a6f4ea51a794b01e18";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-YIZRa/tmvp1EG7nJ5IZnGE1hQPqHkE3dnUzE8sUwnWg=";
    });
  };
  plugin-nvim-web-devicons = {
    pname = "plugin-nvim-web-devicons";
    version = "13d06d74afad093d8312fe051633b55f24049c16";
    src = fetchFromGitHub ({
      owner = "nvim-tree";
      repo = "nvim-web-devicons";
      rev = "13d06d74afad093d8312fe051633b55f24049c16";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-15RIQcLxR+G54UlcCoEJjT8sw6Sf6wJxVknGjs2WbYY=";
    });
  };
  plugin-one-small-step-for-vimkind = {
    pname = "plugin-one-small-step-for-vimkind";
    version = "233c8940488d4072f9f8058798984cb68a49a319";
    src = fetchFromGitHub ({
      owner = "jbyuki";
      repo = "one-small-step-for-vimkind";
      rev = "233c8940488d4072f9f8058798984cb68a49a319";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-xVptZkTzjGZu+hDAbgdmCIpAX1EvnIfbxVAv3vVQyF0=";
    });
  };
  plugin-rust-tools-nvim = {
    pname = "plugin-rust-tools-nvim";
    version = "df584e84393ef255f5b8cbd709677d6a3a5bf42f";
    src = fetchFromGitHub ({
      owner = "simrat39";
      repo = "rust-tools.nvim";
      rev = "df584e84393ef255f5b8cbd709677d6a3a5bf42f";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-NxqK2iefl9/QWnC3+s7UZKuxkigK86PNfmoDSZ9KsuE=";
    });
  };
  plugin-telescope-nvim = {
    pname = "plugin-telescope-nvim";
    version = "2f32775405f6706348b71d0bb8a15a22852a61e4";
    src = fetchFromGitHub ({
      owner = "nvim-telescope";
      repo = "telescope.nvim";
      rev = "2f32775405f6706348b71d0bb8a15a22852a61e4";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-U+COZTiqwNtPtH9cUQ99sIOeFwV2qGZDZWQ06vlJyRk=";
    });
  };
  plugin-tokyonight-nvim = {
    pname = "plugin-tokyonight-nvim";
    version = "4071f7fa984859c5de7a1fd27069b99c3a0d802a";
    src = fetchFromGitHub ({
      owner = "folke";
      repo = "tokyonight.nvim";
      rev = "4071f7fa984859c5de7a1fd27069b99c3a0d802a";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-SYNqm+6oefwRObN8QK84RSAKFtBi2ob9u24EwkPbgjk=";
    });
  };
}
