{ pkgs, ... }:
{
  home.packages = with pkgs; [ fd ];
  programs.bash.shellAliases = {
    find = "fdfind";
    fd = "fdfind";
  };
}
