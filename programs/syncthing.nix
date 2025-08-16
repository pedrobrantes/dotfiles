{ config, pkgs, ... }:

{
  services.syncthing = {
    enable = true;
  };

  home.packages = [
    pkgs.syncthing
  ];
}
