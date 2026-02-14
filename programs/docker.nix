{ config, lib, pkgs, ... }:

let
  cfg = config.programs.custom-docker-cli;
in
{
  options.programs.custom-docker-cli = {
    enable = lib.mkEnableOption "docker cli tools";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      docker
      docker-compose
    ];
  };
}
