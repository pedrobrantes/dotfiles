{ config, pkgs, lib, ... }:

{
  imports = [
    ../../../../home.nix
    ../common.nix
  ];

  home.username = "brantes";
  home.homeDirectory = "/home/brantes";

  sops.defaultSopsFile = ../../../../secrets/secrets.yaml;
  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

  sops.secrets."ssh_keys/smartphone" = {
    path = "${config.home.homeDirectory}/.ssh/id_ed25519";
    mode = "0600";
  };

  programs.zsh.initExtra = ''
    export PROMPT="%F{yellow}%n%f@%F{green}${config.custom.hostName}%f:%F{blue}%~%f%# "
  '';
}
