# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  nvim-dap-python = {
    pname = "nvim-dap-python";
    version = "f5b6f3a90aae0284b61fb3565e575267c19a16e6";
    src = fetchFromGitHub {
      owner = "mfussenegger";
      repo = "nvim-dap-python";
      rev = "f5b6f3a90aae0284b61fb3565e575267c19a16e6";
      fetchSubmodules = false;
      sha256 = "sha256-0q1y2TF76lQlUwMTeHm79LAlHuWfwT4U+n6WR+s7Pzc=";
    };
    date = "2024-02-01";
  };
}
