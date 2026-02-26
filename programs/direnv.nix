{ pkgs, ... }:

{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

    stdlib = ''
      use_devenv() {
        watch_file devenv.nix
        watch_file devenv.yaml
        eval "$(devenv print-dev-env)"
      }
    '';
  };
}
