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
    CURRENT_HOSTNAME="$(cat /proc/sys/kernel/hostname 2>/dev/null || ${pkgs.hostname}/bin/hostname 2>/dev/null || true)"
    if [ -n "$CURRENT_HOSTNAME" ] && [ "$CURRENT_HOSTNAME" != "$DESIRED_HOSTNAME" ]; then
      # Only attempt to set hostname if we have sudo and it's not a container/CI environment
      # that prohibits it. In CI, this usually fails or doesn't matter, but let's keep it safe.
      if command -v sudo > /dev/null 2>&1 && [ -z "''${CI:-}" ]; then
         $DRY_RUN_CMD sudo ${pkgs.hostname}/bin/hostname "$DESIRED_HOSTNAME" 2>/dev/null || $DRY_RUN_CMD sudo hostname "$DESIRED_HOSTNAME" 2>/dev/null || true
         $DRY_RUN_CMD sudo sh -c "echo '$DESIRED_HOSTNAME' > /etc/hostname" 2>/dev/null || true
      fi
    fi
  '';

  programs.docker-cli.enable = true;
  programs.custom-ollama.enable = true;
}
