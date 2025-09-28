{ pkgs, ... }:
{
  home.packages = with pkgs; [ plocate ];
  programs.bash.shellAliases = {
    locate = "plocate";
  };
}
