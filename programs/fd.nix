{ pkgs, ... }:
{
  home.packages = with pkgs; [ fd ];
  programs.bash.shellAliases = {
    find = "fd";
  };
}
