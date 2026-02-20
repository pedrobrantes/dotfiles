{ pkgs, ... }:
{
  home.packages = with pkgs; [
    mov-cli
    mpv
  ];
}
