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
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: secret: let
        secretPath = if (secret.path != null && secret.path != "")
          then secret.path
          else "${cfg.defaultSecretsMountPoint}/${name}";
      in ''
        if [ ! -e "${secretPath}" ]; then
          mkdir -p "$(dirname "${secretPath}")"
          SOPS_AGE_KEY_FILE="${cfg.age.keyFile}" $DRY_RUN_CMD ${pkgs.sops}/bin/sops --decrypt \
            --extract '["${lib.replaceStrings ["/"] ["\"][\""] name}"]' \
            ${secret.sopsFile} > "${secretPath}" 2>/dev/null || true
          chmod ${secret.mode or "0600"} "${secretPath}"
        fi
      '') cfg.secrets)}

      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (tName: template: ''
        mkdir -p "$(dirname "${template.path}")"
        TMP_FILE=$(mktemp)
        cp "${template.file}" "$TMP_FILE"
        ${lib.concatStringsSep "\n" (lib.mapAttrsToList (sName: secret: let
          secretPath = if (secret.path != null && secret.path != "")
            then secret.path
            else "${cfg.defaultSecretsMountPoint}/${sName}";
          placeholder = cfg.placeholder."${sName}";
        in ''
          if [ -f "${secretPath}" ]; then
            SECRET_VAL=$(cat "${secretPath}")
            ${pkgs.python3}/bin/python3 -c "
import sys
content = open(sys.argv[1]).read()
placeholder = sys.argv[2]
val = sys.argv[3]
new_content = content.replace(placeholder, val)
open(sys.argv[1], 'w').write(new_content)
" "$TMP_FILE" "${placeholder}" "$SECRET_VAL"
          fi
        '') cfg.secrets)}
        $DRY_RUN_CMD cp "$TMP_FILE" "${template.path}"
        $DRY_RUN_CMD chmod ${template.mode or "0600"} "${template.path}"
        rm -f "$TMP_FILE"
      '') cfg.templates)}
    fi
  '';
}
