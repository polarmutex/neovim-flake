# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  trouble-nvim = {
    pname = "trouble-nvim";
    version = "v2.8.0";
    src = fetchFromGitHub {
      owner = "folke";
      repo = "trouble.nvim";
      rev = "v2.8.0";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-bDUFU6QD96lU5brr+ED/jHeiOm8vkq7gh1qqB10xP6I=";
    };
  };
}