{ config, pkgs, lib, ... }:

let
  hostName = "aarch64.android.tablet";
in
{
  imports = [
    ../../../../home.nix
    ../common.nix
  ];

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
      if command -v proot > /dev/null 2>&1; then
        proot -0 ${pkgs.openssh}/bin/sshd -f ${config.home.homeDirectory}/.ssh/sshd_config
      else
        ${pkgs.openssh}/bin/sshd -f ${config.home.homeDirectory}/.ssh/sshd_config
      fi
    fi
  '';

  programs.bash.initExtra = ''
    export PS1="\[\033[01;33m\]\u\[\033[00m\]@\[\033[01;32m\]${hostName}\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "
    if ! pgrep -x "sshd" > /dev/null; then
      if command -v proot > /dev/null 2>&1; then
        proot -0 ${pkgs.openssh}/bin/sshd -f ${config.home.homeDirectory}/.ssh/sshd_config
      else
        ${pkgs.openssh}/bin/sshd -f ${config.home.homeDirectory}/.ssh/sshd_config
      fi
    fi
  '';
}
