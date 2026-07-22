{ pkgs, ... }:

{
  home.packages = [
    pkgs.openssh
  ];

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    extraConfig = ''
      IgnoreUnknown GSSAPIAuthentication
    '';

    matchBlocks = {
      "*.ts.net 100.*" = {
        user = "brantes";
        identityFile = "~/.ssh/id_ed25519";
      };

      "smartphone" = {
        hostname = "galaxy-s10";
        port = 8022;
      };

      "tablet" = {
        hostname = "pedros-tab-s6-lite";
        port = 8022;
      };

      "galaxy-s10 pedros-tab-s6-lite" = {
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
