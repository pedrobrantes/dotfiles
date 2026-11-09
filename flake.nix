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

  outputs = { self, nixpkgs, nixpkgs-unstable, nixpkgs-master, home-manager, sops-nix, bash-it, ... }@inputs:
    let
      mkHome = { system, configPath, hostName }:
        let
          config = {
            allowUnfree = true;
            # docker-28.5.2 is flagged insecure in nixpkgs 25.11; permit explicitly
            permittedInsecurePackages = [ "docker-28.5.2" ];
          };
          pkgs = import nixpkgs { inherit system config; };
          pkgsUnstable = import nixpkgs-unstable { inherit system config; };
          pkgsMaster = import nixpkgs-master { inherit system config; };

          lib = pkgs.lib;
          pkgsPr = lib.mapAttrs' (name: value: {
            name = lib.removePrefix "nixpkgs-pr-" name;
            value = import value { inherit system config; };
          }) (lib.filterAttrs (name: _: lib.hasPrefix "nixpkgs-pr-" name) inputs);
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit sops-nix inputs pkgsUnstable pkgsMaster pkgsPr hostName;
          };
          modules = [
            configPath
            sops-nix.homeManagerModules.sops
            ({ ... }: {
              custom.hostName = hostName;
            })
          ];
        };

      targets = {
        "x86_64.wsl.desktop"         = { system = "x86_64-linux";  configPath = ./machines/x86_64/wsl/desktop/default.nix; };
        "x86_64.wsl.notebook"        = { system = "x86_64-linux";  configPath = ./machines/x86_64/wsl/notebook/default.nix; };
        "x86_64.linux.desktop"       = { system = "x86_64-linux";  configPath = ./machines/x86_64/linux/desktop/default.nix; };
        "aarch64.android.smartphone" = { system = "aarch64-linux"; configPath = ./machines/aarch64/android/smartphone/default.nix; };
        "aarch64.android.tablet"     = { system = "aarch64-linux"; configPath = ./machines/aarch64/android/tablet/default.nix; };
      };
    in
    {
      homeConfigurations = nixpkgs.lib.mapAttrs' (hostName: targetCfg: {
        name = "brantes@${hostName}";
        value = mkHome {
          inherit (targetCfg) system configPath;
          inherit hostName;
        };
      }) targets;
    };
}
