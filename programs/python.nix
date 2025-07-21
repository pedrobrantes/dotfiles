{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    (python3.withPackages (ppkgs: with ppkgs; [
      pipx # Install pipx
      # Add other Python packages here
    ]))
  ];
}