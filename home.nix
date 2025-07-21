{ config, pkgs, ... }:

{
  home.stateVersion = "25.05";

  home.username = builtins.getEnv "USER";

  home.homeDirectory = builtins.getEnv "HOME";

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
    ./programs/python.nix
    ./programs/git.nix
  ];
}
