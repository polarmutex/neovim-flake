# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  obsidian-nvim = {
    pname = "obsidian-nvim";
    version = "v3.7.6";
    src = fetchFromGitHub {
      owner = "epwalsh";
      repo = "obsidian.nvim";
      rev = "v3.7.6";
      fetchSubmodules = false;
      sha256 = "sha256-RD5EhYv2AZvCywxQYKkPjZPY/jEjl2rEofMVCHO6SJQ=";
    };
  };
}
