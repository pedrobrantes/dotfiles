{
  description = "My Personal Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, sops-nix }:
    let
      mkHome = { username, system ? "x86_64-linux" }: home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = { inherit sops-nix; };
        modules = [
          {
            home.username = username;
            home.homeDirectory = "/home/${username}";
          }
          ./home.nix
        ];
      };
    in
    {
      homeConfigurations = {
        "brantes" = mkHome { username = "brantes"; };
      };
    };
}
