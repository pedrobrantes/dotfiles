{ config, pkgs, sops-nix, ... }:

{
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  # Env
  home.sessionVariables = {
    EDITOR = "nvim";
    GEMINI_API_KEY = config.sops.secrets.gemini_api_key.path;
  };

  # Packages
  home.packages = with pkgs; [
    git
  ];

  # Programs modules
  imports = [
    sops-nix.homeManagerModules.sops
    ./programs/python.nix
    ./programs/git.nix
    ./programs/syncthing.nix
    ./programs/bitwarden.nix
    ./programs/sops.nix
    ./programs/nix.nix
    ./programs/bash.nix
  ];
}
