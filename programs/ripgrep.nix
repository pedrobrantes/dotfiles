{ pkgs, ... }:
{
  home.packages = with pkgs; [ ripgrep ];
  programs.bash.shellAliases = {
    grep = "rg";
  };
}
