{ config, pkgs, lib, sops-nix, ... }:

{
  imports = [
    sops-nix.homeManagerModules.sops
    ./programs
    ./directories
  ];

  options.custom.hostName = lib.mkOption {
    type = lib.types.str;
    description = "The target machine hostname (arch.os.device)";
  };

  config = {
    home.stateVersion = "25.05";
    programs.home-manager.enable = true;

    # Env
    home.sessionVariables = {
      EDITOR = "nvim";
      ANTIGRAVITY_API_KEY = config.sops.secrets.gemini_api_key.path;
      HOSTNAME = config.custom.hostName;
    };

    sops.package = (pkgs.callPackage sops-nix {
      pkgs = pkgs.extend (final: prev: {
        go = prev.go_1_26;
        buildGoModule = prev.buildGoModule.override { go = prev.go_1_26; };
      });
    }).sops-install-secrets;

    # Dynamic system hostname activation hook
    home.activation.setHostname = lib.hm.dag.entryAfter ["writeBoundary"] ''
      DESIRED_HOSTNAME="${config.custom.hostName}"
      CURRENT_HOSTNAME="$(cat /proc/sys/kernel/hostname 2>/dev/null || ${pkgs.hostname}/bin/hostname 2>/dev/null || true)"
      if [ -n "$CURRENT_HOSTNAME" ] && [ "$CURRENT_HOSTNAME" != "$DESIRED_HOSTNAME" ]; then
        if command -v sudo > /dev/null 2>&1 && [ -z "''${CI:-}" ]; then
           $DRY_RUN_CMD sudo ${pkgs.hostname}/bin/hostname "$DESIRED_HOSTNAME" 2>/dev/null || $DRY_RUN_CMD sudo hostname "$DESIRED_HOSTNAME" 2>/dev/null || true
           $DRY_RUN_CMD sudo sh -c "echo '$DESIRED_HOSTNAME' > /etc/hostname" 2>/dev/null || true
        fi
      fi
    '';
  };
}
