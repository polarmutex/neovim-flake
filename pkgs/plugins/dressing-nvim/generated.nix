# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  dressing-nvim = {
    pname = "dressing-nvim";
    version = "v2.2.0";
    src = fetchFromGitHub {
      owner = "stevearc";
      repo = "dressing.nvim";
      rev = "v2.2.0";
      fetchSubmodules = false;
      sha256 = "sha256-6TOn7BG32YYHJx2oRRqOtlVb5oF6mZb0wwP10Ljmon0=";
    };
  };
}
