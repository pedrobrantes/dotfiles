{ pkgs, ... }:

{
  home.packages = [
    pkgs.uv
  ];

  programs.bash.shellAliases = {
    uvp = "uv pip";
    uvv = "uv venv";
  };
}