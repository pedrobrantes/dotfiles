{ config, pkgs, lib, ... }:

let
  devices = {
    smartphone = {
      magicDns = "galaxy-s10";
      sshPort = 8022;
    };
    tablet = {
      magicDns = "pedros-tab-s6-lite";
      sshPort = 8022;
    };
  };

  tailscaleSocket = "${config.home.homeDirectory}/.tailscaled.sock";

  mkSshBlock = alias: dev: {
    hostname = dev.magicDns;
    port = dev.sshPort;
    proxyCommand = "${pkgs.tailscale}/bin/tailscale --socket=${tailscaleSocket} nc %h %p";
  };

  deviceBlocks = lib.mapAttrs mkSshBlock devices;

  magicDnsNames = lib.concatStringsSep " "
    (lib.mapAttrsToList (_: dev: dev.magicDns) devices);
in
{
  home.packages = [ pkgs.openssh ];

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = deviceBlocks // {
      "*.ts.net 100.*" = {
        user = "brantes";
        identityFile = "~/.ssh/id_ed25519";
      };

      "${magicDnsNames}" = {
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
