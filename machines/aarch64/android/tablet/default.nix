{ config, pkgs, lib, ... }:

let
  hostName = "aarch64.android.tablet";
in
{
  imports = [ ../../../../home.nix ];

  home.username = "brantes";
  home.homeDirectory = "/home/brantes";

  sops.defaultSopsFile = ../../../../secrets/secrets.yaml;
  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

  sops.secrets."ssh_keys/tablet" = {
    path = "${config.home.homeDirectory}/.ssh/id_ed25519";
    mode = "0600";
  };

  home.sessionVariables = {
    HOSTNAME = hostName;
  };

  programs.zsh.initExtra = ''
    export PROMPT="%F{yellow}%n%f@%F{green}${hostName}%f:%F{blue}%~%f%# "
    if ! pgrep -x "sshd" > /dev/null; then
      ${pkgs.openssh}/bin/sshd -p 8022
    fi
  '';

  programs.bash.initExtra = ''
    export PS1="\[\033[01;33m\]\u\[\033[00m\]@\[\033[01;32m\]${hostName}\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "
    if ! pgrep -x "sshd" > /dev/null; then
      ${pkgs.openssh}/bin/sshd -p 8022
    fi
  '';

  home.file.".termux/boot/start-sshd.sh" = {
    text = ''
      #!/bin/sh
      if ! pgrep -x "sshd" > /dev/null; then
        ${pkgs.openssh}/bin/sshd -p 8022
      fi
    '';
    executable = true;
  };

  xdg.configFile."nix/nix.conf".text = ''
    sandbox = false
    connect-timeout = 20
    max-jobs = 1
  '';

  programs.udocker.enable = true;
}
