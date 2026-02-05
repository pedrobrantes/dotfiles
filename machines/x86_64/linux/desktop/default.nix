{ config, pkgs, lib, ... }:

{
  imports = [ ../../../../home.nix ];

  home.username = "brantes";
  home.homeDirectory = "/home/brantes";

  sops.defaultSopsFile = ../../../../secrets/secrets.yaml;
  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

  # Reusing desktop key for now, or could define a new one if needed
  sops.secrets."ssh_keys/desktop" = {
    path = "${config.home.homeDirectory}/.ssh/id_ed25519";
    mode = "0600";
  };

  # Generic Linux hostname setup
  home.activation.setHostname = lib.hm.dag.entryAfter ["writeBoundary"] ''
    DESIRED_HOSTNAME="x86_64.linux.desktop"
    if [ "$(hostname)" != "$DESIRED_HOSTNAME" ]; then
      # Only attempt to set hostname if we have sudo and it's not a container/CI environment
      # that prohibits it. In CI, this usually fails or doesn't matter, but let's keep it safe.
      if command -v sudo > /dev/null && [ -z "''${CI:-}" ]; then
         $DRY_RUN_CMD sudo hostname "$DESIRED_HOSTNAME" || true
      fi
    fi
  '';

  programs.docker-cli.enable = true;
}
