# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  nvim-web-devicons = {
    pname = "nvim-web-devicons";
    version = "b427ac5f9dff494f839e81441fb3f04a58cbcfbc";
    src = fetchFromGitHub {
      owner = "nvim-tree";
      repo = "nvim-web-devicons";
      rev = "b427ac5f9dff494f839e81441fb3f04a58cbcfbc";
      fetchSubmodules = false;
      sha256 = "sha256-w038PU9i1onEBo3x4bo1kDz9Fo46Whd8ZJhyIqxz3I8=";
    };
    date = "2024-01-24";
  };
}
