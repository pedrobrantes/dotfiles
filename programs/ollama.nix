{ config, lib, pkgsUnstable, ... }:

let
  cfg = config.programs.custom-ollama;
in
{
  options.programs.custom-ollama = {
    enable = lib.mkEnableOption "ollama service and tools";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgsUnstable.ollama
    ];
  };
}
