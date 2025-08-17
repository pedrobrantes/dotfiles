{ config, pkgs, ... }:

{
  home.packages = [ pkgs.sops ];

  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    age.sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25520" ];

    # Every input is avaiable in 'config.sops.secrets.<nome>'.
    secrets = {
      "api_keys" = {
        sopsFile = ../secrets/api_keys.yaml;
        format = "yaml";
        key = "";
      };

      # Add new secret on the future
      # "my_api_token" = {
      #   sopsFile = ../secrets/secrets.yaml;
      #   key = "apis_tokens.my_service2";
      # };
    };
  };
}
