# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  rustaceanvim = {
    pname = "rustaceanvim";
    version = "4.22.8";
    src = fetchFromGitHub {
      owner = "mrcjkb";
      repo = "rustaceanvim";
      rev = "4.22.8";
      fetchSubmodules = false;
      sha256 = "sha256-tW4SBMMQScDbax/YNP5CqvmfDywlKNQgYlXh1lHGM9k=";
    };
  };
}
