# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  inc-rename-nvim = {
    pname = "inc-rename-nvim";
    version = "e1fdd51ca13b8e13dff478b5ba601f38d59efc34";
    src = fetchFromGitHub {
      owner = "smjonas";
      repo = "inc-rename.nvim";
      rev = "e1fdd51ca13b8e13dff478b5ba601f38d59efc34";
      fetchSubmodules = false;
      sha256 = "sha256-sYl7+mciQ4cTGdZYSJJdlVy+ntRw+k5GDKxkpt7Kws8=";
    };
    date = "2024-05-02";
  };
}
