{
  description = "My Personal Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    bash-it = {
      url = "github:Bash-it/bash-it";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixpkgs-master, home-manager, sops-nix, bash-it }@inputs:
    let
      mkHome = { username, system }:
        let
          config = { allowUnfree = true; };
          pkgs = import nixpkgs { inherit system config; };
          pkgsUnstable = import nixpkgs-unstable { inherit system config; };
          pkgsMaster = import nixpkgs-master { inherit system config; };
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit sops-nix inputs pkgsUnstable pkgsMaster;
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
