{ config, pkgs, lib, ... }:

{
  xdg.configFile."nix/nix.conf".text = ''
    sandbox = false
    connect-timeout = 20
    max-jobs = 1
  '';

  programs.udocker.enable = true;

  sops.secrets."ssh_public_keys/desktop" = { };
  sops.secrets."ssh_public_keys/smartphone" = { };
  sops.secrets."ssh_public_keys/tablet" = { };

  sops.templates."authorized_keys" = {
    content = ''
      ${config.sops.placeholder."ssh_public_keys/desktop"}
      ${config.sops.placeholder."ssh_public_keys/smartphone"}
      ${config.sops.placeholder."ssh_public_keys/tablet"}
    '';
    path = "${config.home.homeDirectory}/.ssh/authorized_keys";
    mode = "0600";
  };
}
