# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  nvim-dap-ui = {
    pname = "nvim-dap-ui";
    version = "v4.0.0";
    src = fetchFromGitHub {
      owner = "rcarriga";
      repo = "nvim-dap-ui";
      rev = "v4.0.0";
      fetchSubmodules = false;
      sha256 = "sha256-cMpJJ2npriAFajLw1SEyDMjKUBFVFvYBr4dmFKoZyKw=";
    };
  };
}
