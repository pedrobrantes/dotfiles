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


  programs.docker-cli.enable = true;
  programs.custom-ollama.enable = true;
}
