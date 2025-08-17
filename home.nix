{ config, pkgs, sops-nix, ... }:

{
  home.stateVersion = "25.05";

  # Env
  home.sessionVariables = {
    EDITOR = "nvim";
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
  ];
}
