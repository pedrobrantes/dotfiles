{ config, pkgs, lib, ... }:

let
  cfg = config.sops;
in
{
  home.packages = [ pkgs.sops ];

  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    age.sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];

    defaultSecretsMountPoint = if pkgs.stdenv.hostPlatform.isAndroid
      then "${config.home.homeDirectory}/.config/sops-nix/secrets.d"
      else "/run/user/1000/secrets.d";

    defaultSopsFile = ../secrets/secrets.yaml;

    secrets = {
      "gemini_api_key" = {
        sopsFile = ../secrets/api_keys.yaml;
        key = "";
      };
    };
  };

  home.activation.sopsFallbackSecrets = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -f "${cfg.age.keyFile}" ]; then
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: secret: ''
        if [ -n "${secret.path or ""}" ] && [ ! -e "${secret.path}" ]; then
          mkdir -p "$(dirname "${secret.path}")"
          SOPS_AGE_KEY_FILE="${cfg.age.keyFile}" $DRY_RUN_CMD ${pkgs.sops}/bin/sops --decrypt \
            --extract '["${lib.replaceStrings ["/"] ["\"][\""] name}"]' \
            ${secret.sopsFile} > "${secret.path}" 2>/dev/null || true
          chmod ${secret.mode or "0600"} "${secret.path}"
        fi
      '') (lib.filterAttrs (_: s: s.path != null && s.path != "") cfg.secrets))}
    fi
  '';
}
