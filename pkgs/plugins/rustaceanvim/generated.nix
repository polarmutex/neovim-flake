# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  rustaceanvim = {
    pname = "rustaceanvim";
    version = "4.7.3";
    src = fetchFromGitHub {
      owner = "mrcjkb";
      repo = "rustaceanvim";
      rev = "4.7.3";
      fetchSubmodules = false;
      sha256 = "sha256-IakMY07RM6ymxGqsr0FCWl1pji1z7hp1xVZhbXmK0fU=";
    };
  };
}
