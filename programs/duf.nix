{ pkgs, ... }:
{
  home.packages = with pkgs; [ duf ];
  programs.bash.shellAliases = {
    df = "duf";
  };
}
