# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  conform-nvim = {
    pname = "conform-nvim";
    version = "v4.3.0";
    src = fetchFromGitHub {
      owner = "stevearc";
      repo = "conform.nvim";
      rev = "v4.3.0";
      fetchSubmodules = false;
      sha256 = "sha256-vw9uUhnsSj2Iv3NxcoyYpemrj3cGjQT7ezyn7d187Do=";
    };
  };
}
