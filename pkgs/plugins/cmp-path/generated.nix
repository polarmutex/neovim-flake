# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  cmp-buffer = {
    pname = "cmp-buffer";
    version = "91ff86cd9c29299a64f968ebb45846c485725f23";
    src = fetchFromGitHub {
      owner = "hrsh7th";
      repo = "cmp-path";
      rev = "91ff86cd9c29299a64f968ebb45846c485725f23";
      fetchSubmodules = false;
      deepClone = true;
      leaveDotGit = true;
      sha256 = "sha256-Ne6dgy3za3lj5pjM1fsSanuZs2oV3PanbWvqxKH4Gz4=";
    };
    date = "2022-10-03";
  };
}
