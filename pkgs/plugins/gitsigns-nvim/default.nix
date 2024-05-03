{
  #date,
  pname,
  src,
  version,
  #
  vimUtils,
}:
vimUtils.buildVimPlugin {
  inherit pname src version;
}
