{ pkgs, ... }:
{
  home.packages = with pkgs; [ bat ];
  programs.bash.shellAliases = {
    cat = "batcat";
  };
}
