{ pkgs, ... }:

{
  home.packages = [
    pkgs.magic-wormhole-rs
  ];

  programs.bash = {
    shellAliases = {
      wormhole = "wormhole-rs";
    };
  };
}
