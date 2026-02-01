{ pkgs, lib, ... }:

let
  dir = builtins.readDir ./.;

  nixFiles = lib.filterAttrs (name: type:
    type == "regular" &&
    lib.hasSuffix ".nix" name &&
    name != "default.nix"
  ) dir;

  importsList = lib.mapAttrsToList (name: _: ./. + "/${name}") nixFiles;

  # Enforce Test Existence
  programNames = map (name: lib.removeSuffix ".nix" name) (builtins.attrNames nixFiles);
  testRoot = ../tests/programs;
  
  missingTests = builtins.filter (name: 
    !(builtins.pathExists (testRoot + "/test_${name}.py"))
  ) programNames;

in
{
  imports = importsList;

  assertions = [
    {
      assertion = missingTests == [];
      message = ''
        [Test Enforcement] The following programs are enabled but lack a corresponding test file in 'tests/programs/':
        
        ${builtins.concatStringsSep "\n" (map (n: " - tests/programs/test_${n}.py") missingTests)}
        
        Please create these tests or disable the program.
      '';
    }
  ];
}
