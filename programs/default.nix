{ pkgs, lib, ... }:

let
  dir = builtins.readDir ./.;

  nixFiles = lib.filterAttrs (name: type:
    type == "regular" &&
    lib.hasSuffix ".nix" name &&
    name != "default.nix"
  ) dir;

  importsList = lib.mapAttrsToList (name: _: ./. + "/${name}") nixFiles;

in
{
  imports = importsList;
}
