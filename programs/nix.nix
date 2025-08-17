{ ... }:

{
  xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes

    nix.gc.automatic = true;
    nix.gc.options = "--delete-older-than 30d";
  '';
}
