{ pkgs, ... }:
{
  home.packages = with pkgs; [ du-dust ];
  programs.bash.shellAliases = {
    du = "dust --depth 10";
  };
}
