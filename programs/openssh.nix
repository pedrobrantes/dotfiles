{ pkgs, ... }:

{
  home.packages = [
    pkgs.openssh
  ];

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "*.ts.net 100.*" = {
        user = "brantes";
        identityFile = "~/.ssh/id_ed25519";
      };

      "galaxy-s10 pedros-tab-s6-lite smartphone tablet" = {
        port = 8022;
      };

      "*" = {
        forwardAgent = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        compression = false;
      };
    };
  };
}
