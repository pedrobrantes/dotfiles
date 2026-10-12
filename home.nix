{ config, pkgs, sops-nix, ... }:

{
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  # Env
  home.sessionVariables = {
    EDITOR = "nvim";
    ANTIGRAVITY_API_KEY = config.sops.secrets.gemini_api_key.path;
  };

  sops.package = (pkgs.callPackage sops-nix {
    pkgs = pkgs.extend (final: prev: {
      go = prev.go_1_26;
      buildGoModule = prev.buildGoModule.override { go = prev.go_1_26; };
    });
  }).sops-install-secrets;

  # Programs modules
  imports = [
    sops-nix.homeManagerModules.sops
    ./programs
    ./directories
  ];
}
