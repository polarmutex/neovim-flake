# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  mini-indentscope = {
    pname = "mini-indentscope";
    version = "v0.10.0";
    src = fetchFromGitHub {
      owner = "echasnovski";
      repo = "mini.indentscope";
      rev = "v0.10.0";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-23ccTNVJ4sVy0VMBk8oIqFi0JfC6GBT/22m6lSdFDAM=";
    };
  };
}