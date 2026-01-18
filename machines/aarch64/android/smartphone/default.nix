{ config, pkgs, lib, ... }:

{
  imports = [ ../../../../home.nix ];

  home.username = "brantes";
  home.homeDirectory = "/home/brantes";

  sops.defaultSopsFile = ../../../../secrets/secrets.yaml;
  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

  sops.secrets."ssh_keys/smartphone" = {
    path = "${config.home.homeDirectory}/.ssh/id_ed25519";
    mode = "0600";
  };

  home.activation.setHostname = lib.hm.dag.entryAfter ["writeBoundary"] ''
    CURRENT_HOSTNAME=$(cat /etc/hostname 2>/dev/null || hostname)
    DESIRED_HOSTNAME="smartphone"

    if [ "$CURRENT_HOSTNAME" != "$DESIRED_HOSTNAME" ]; then
      $DRY_RUN_CMD echo "$DESIRED_HOSTNAME" > /etc/hostname
      $DRY_RUN_CMD hostname "$DESIRED_HOSTNAME"
    fi
  '';
}
