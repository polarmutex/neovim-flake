# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  dressing-nvim = {
    pname = "dressing-nvim";
    version = "v2.0.1";
    src = fetchFromGitHub {
      owner = "stevearc";
      repo = "dressing.nvim";
      rev = "v2.0.1";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-+/Zt5HkpHGYSV4aC8kVjLKz9ga4+FdxkJGOjnIsIye4=";
    };
  };
}