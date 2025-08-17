{ config, pkgs, ... }:

{
  home.packages = [ pkgs.sops ];

  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    age.sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25520" ];

    defaultSopsFile = ../secrets/secrets.yaml;

    # Every input is avaiable in 'config.sops.secrets.<nome>'.
    secrets = {
      "gemini_api_key" = {
        sopsFile = ../secrets/api_keys.yaml;
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
