# This file was generated by nvfetcher, please do not modify it manually.
{
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
}: {
  nvim-treesitter = {
    pname = "nvim-treesitter";
    version = "722617e6726c1508adadf83d531f54987c703be0";
    src = fetchFromGitHub {
      owner = "nvim-treesitter";
      repo = "nvim-treesitter";
      rev = "722617e6726c1508adadf83d531f54987c703be0";
      fetchSubmodules = false;
      sha256 = "sha256-jkZ8NuCUjUqHmpr8v1g/dbPDBTO6WRWmEhEJHY9HZWM=";
    };
    date = "2024-03-21";
  };
}
