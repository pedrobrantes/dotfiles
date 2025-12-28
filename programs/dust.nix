{ pkgs, ... }:
{
  home.packages = with pkgs; [ dust ];
  programs.bash.shellAliases = {
    du = "dust --depth 10";
  };
}
