{ pkgs, ... }:
{
  home.packages = with pkgs; [ htop ];
  programs.bash.shellAliases = {
    top = "htop";
  };
}
