{
  description = "My Personal Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    bash-it = {
      url = "github:Bash-it/bash-it";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, bash-it }@inputs:
    let
      mkHome = { username, system }: home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = { 
          inherit sops-nix;
          inherit inputs;
        };
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
        "brantes-x86_64-linux" = mkHome { username = "brantes"; system = "x86_64-linux"; };
        "brantes-aarch64-linux" = mkHome { username = "brantes"; system = "aarch64-linux"; };
      };
    };
}
