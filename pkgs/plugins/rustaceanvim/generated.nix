# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  rustaceanvim = {
    pname = "rustaceanvim";
    version = "4.18.2";
    src = fetchFromGitHub {
      owner = "mrcjkb";
      repo = "rustaceanvim";
      rev = "4.18.2";
      fetchSubmodules = false;
      sha256 = "sha256-sWyYEpvXKhYdtGdYobNrSHun4q5Z76UPy6NGnRtv2Qg=";
    };
  };
}
