# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  crates-nvim = {
    pname = "crates-nvim";
    version = "v0.4.0";
    src = fetchFromGitHub {
      owner = "Saecki";
      repo = "crates.nvim";
      rev = "v0.4.0";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-NBU7oNnACKhRA767fHMZB/xNKg0S2BsqJPg2Wjvx9z0=";
    };
  };
}