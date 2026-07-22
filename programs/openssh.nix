{ pkgs, ... }:

{
  home.packages = [
    pkgs.openssh
  ];

  programs.ssh = {
    enable = true;

    matchBlocks = {
      "*.ts.net 100.*" = {
        user = "brantes";
        identityFile = "~/.ssh/id_ed25519";
      };

      "galaxy-s10 pedros-tab-s6-lite smartphone tablet" = {
        port = 8022;
      };
    };
  };
}
