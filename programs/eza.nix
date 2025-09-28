{ pkgs, ... }:
{
  home.packages = with pkgs; [ eza ];
  programs.bash.shellAliases = {
    ls = "eza --icons";
  };
}
