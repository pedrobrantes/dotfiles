{ config, pkgs, lib, ... }:

{
  imports = [ ../../../../home.nix ];

  home.username = "brantes";
  home.homeDirectory = "/home/brantes";

  sops.defaultSopsFile = ../../../../secrets/secrets.yaml;
  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

  sops.secrets."ssh_keys/desktop" = {
    path = "${config.home.homeDirectory}/.ssh/id_ed25519";
    mode = "0600";
  };

  home.activation.setHostname = lib.hm.dag.entryAfter ["writeBoundary"] ''
    DESIRED_HOSTNAME="x86_64.wsl.desktop"
    if [ "$(hostname)" != "$DESIRED_HOSTNAME" ]; then
      if command -v sudo > /dev/null; then
         $DRY_RUN_CMD sudo hostname "$DESIRED_HOSTNAME"
         $DRY_RUN_CMD sudo sh -c "echo '$DESIRED_HOSTNAME' > /etc/hostname"
      fi
    fi
  '';
}
