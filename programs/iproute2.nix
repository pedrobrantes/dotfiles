{ pkgs, ... }:
{
  home.packages = with pkgs; [ iproute2 ];
  programs.bash.shellAliases = {
    netstat = "ss";
    ips = "ip -c -br a";
    ifconfig = "ip";
  };
}