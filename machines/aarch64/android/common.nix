{ config, pkgs, lib, ... }:

{
  home.file.".ssh/sshd_config" = {
    text = ''
      Port 8022
      HostKey ${config.home.homeDirectory}/.ssh/sshd_host_ed25519_key
      AuthorizedKeysFile .ssh/authorized_keys
      PasswordAuthentication yes
      PermitEmptyPasswords no
      ChallengeResponseAuthentication no
      PrintMotd no
      UsePrivilegeSeparation no
      StrictModes no
      UseDNS no
      AcceptEnv LANG LC_*
      SetEnv PATH=${config.home.homeDirectory}/.nix-profile/bin:/data/data/com.termux/files/usr/bin:/bin:/usr/bin
    '';
  };

  home.activation.generateSshdHostKey = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    HOST_KEY="${config.home.homeDirectory}/.ssh/sshd_host_ed25519_key"
    if [ ! -f "$HOST_KEY" ]; then
      ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -f "$HOST_KEY" -N ""
    fi
    $DRY_RUN_CMD mkdir -p /var/empty
  '';

  home.file.".termux/boot/start-sshd.sh" = {
    text = ''
      #!/bin/sh
      if ! pgrep -x "sshd" > /dev/null; then
        if command -v proot > /dev/null 2>&1; then
          nohup proot -0 ${pkgs.openssh}/bin/sshd -f ${config.home.homeDirectory}/.ssh/sshd_config > /dev/null 2>&1 &
        else
          nohup ${pkgs.openssh}/bin/sshd -f ${config.home.homeDirectory}/.ssh/sshd_config > /dev/null 2>&1 &
        fi
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
