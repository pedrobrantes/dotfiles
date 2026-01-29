{ inputs, ... }:

{
  xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes
  '';

  nix.registry.nixpkgs.flake = inputs.nixpkgs;

  home.sessionVariables.NIX_PATH = "nixpkgs=${inputs.nixpkgs}";
}
