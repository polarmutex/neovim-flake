# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  conform-nvim = {
    pname = "conform-nvim";
    version = "v5.5.0";
    src = fetchFromGitHub {
      owner = "stevearc";
      repo = "conform.nvim";
      rev = "v5.5.0";
      fetchSubmodules = false;
      sha256 = "sha256-Xqxz/AdB1KkzCbwA31PsCY2niWNU9jgEznym51YvRVU=";
    };
  };
}
