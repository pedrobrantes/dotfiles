{ config, lib, pkgs, ... }:

let
  cfg = config.programs.udocker;
in
{
  options.programs.udocker = {
    enable = lib.mkEnableOption "udocker container runtime";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.udocker ];

    programs.bash.shellAliases = {
      docker = "udocker";
    };
  };
}
