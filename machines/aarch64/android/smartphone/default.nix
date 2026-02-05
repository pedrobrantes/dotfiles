{ config, pkgs, lib, ... }:

let
  hostName = "aarch64.android.smartphone";
in
{
  imports = [ ../../../../home.nix ];

  home.username = "brantes";
  home.homeDirectory = "/home/brantes";

  sops.defaultSopsFile = ../../../../secrets/secrets.yaml;
  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

  sops.secrets."ssh_keys/smartphone" = {
    path = "${config.home.homeDirectory}/.ssh/id_ed25519";
    mode = "0600";
  };

  home.sessionVariables = {
    HOSTNAME = hostName;
  };

  programs.zsh.initExtra = ''
    export PROMPT="%F{yellow}%n%f@%F{green}${hostName}%f:%F{blue}%~%f%# "
  '';

  programs.bash.initExtra = ''
    export PS1="\[\033[01;33m\]\u\[\033[00m\]@\[\033[01;32m\]${hostName}\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "
  '';

  xdg.configFile."nix/nix.conf".text = ''
    sandbox = false
    connect-timeout = 20
    max-jobs = 1
  '';

  programs.udocker.enable = true;
}
