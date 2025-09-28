{ pkgs, ... }:
{
  home.packages = with pkgs; [ doggo ];
  programs.bash.shellAliases = {
    nslookup = "doggo";
    dig = "doggo";
  };
}
