{ config, pkgs, lib, ... }:

{
  home.file.".ssh/sshd_config" = {
    text = ''
      Port 8022
      HostKey ${config.home.homeDirectory}/.ssh/id_ed25519
      AuthorizedKeysFile .ssh/authorized_keys
      PasswordAuthentication yes
      PermitEmptyPasswords no
      ChallengeResponseAuthentication no
      PrintMotd no
      AcceptEnv LANG LC_*
    '';
  };

  home.file.".termux/boot/start-sshd.sh" = {
    text = ''
      #!/bin/sh
      if ! pgrep -x "sshd" > /dev/null; then
        ${pkgs.openssh}/bin/sshd -f ${config.home.homeDirectory}/.ssh/sshd_config
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
