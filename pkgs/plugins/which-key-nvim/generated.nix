# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  which-key-nvim = {
    pname = "which-key-nvim";
    version = "v1.5.1";
    src = fetchFromGitHub {
      owner = "folke";
      repo = "which-key.nvim";
      rev = "v1.5.1";
      fetchSubmodules = false;
      deepClone = true;
      leaveDotGit = true;
      sha256 = "sha256-xcYsdKtCWotL505NE6sOnX0hrSDbDT55tTXTPpD03+Y=";
    };
  };
}
