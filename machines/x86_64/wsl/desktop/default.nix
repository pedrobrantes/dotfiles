{ config, pkgs, lib, ... }:

{
  imports = [ ../../../../home.nix ];

  home.username = "brantes";
  home.homeDirectory = "/home/brantes";

  sops.defaultSopsFile = ../../../../secrets/secrets.yaml;
  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

  sops.secrets."ssh_keys/desktop" = {
    path = "${config.home.homeDirectory}/.ssh/id_ed25519";
    mode = "0600";
  };

  home.activation.setHostname = lib.hm.dag.entryAfter ["writeBoundary"] ''
    DESIRED_HOSTNAME="x86_64.wsl.desktop"
    if [ "$(hostname)" != "$DESIRED_HOSTNAME" ]; then
      if command -v sudo > /dev/null; then
         $DRY_RUN_CMD sudo hostname "$DESIRED_HOSTNAME"
         $DRY_RUN_CMD sudo sh -c "echo '$DESIRED_HOSTNAME' > /etc/hostname"
      fi
    fi
  '';

  programs.bash.shellAliases = {
      explorer = "explorer.exe";
      winget = "winget.exe";
      notepad = "notepad.exe";
      regedit = "sudo.exe regedit.exe";
      "gpedit.msc" = "eval cmd.exe /C gpedit.msc";
      gpedit = "eval cmd.exe /C gpedit.msc";
      bluetooth = "fsquirt.exe";
      fsquirt = "fsquirt.exe";
      ipconfig = "ipconfig.exe";
      netsh = "sudo.exe netsh.exe";
      "WF.msc" = "eval cmd.exe /C WF.msc";
      wf = "eval cmd.exe /C WF.msc";
      taskmgr = "Taskmgr.exe";
      "taskschd.msc" = "eval cmd.exe /C taskschd.msc";
      taskschd = "eval cmd.exe /C taskschd.msc";
      "Bubbles.scr" = "Bubbles.scr /";
      tree = "tree.com";
      calc = "calc.exe";
      control = "control.exe";
      defrag = "Defrag.exe";
      diskpart = "sudo.exe diskpart.exe";
      diskusage = "sudo.exe diskusage.exe";
      findstr = "findstr.exe";
      label = "label.exe";
      livecaptions = "LiveCaptions.exe";
      everything = "$WIN_PROGRAM_FILES/everything/everything.exe";
      powertoys = "$WIN_PROGRAM_FILES/PowerToys/PowerToys.exe";
      PowerToys = "$WIN_PROGRAM_FILES/PowerToys/PowerToys.exe";
      "powertoys.colorpicker" = "$WIN_PROGRAM_FILES/PowerToys/PowerToys.ColorPickerUI.exe";
      colorpicker = "$WIN_PROGRAM_FILES/PowerToys/PowerToys.ColorPickerUI.exe";
      "powertoys.workspaces" = "$WIN_PROGRAM_FILES/PowerToys/PowerToys.WorkspacesEditor.exe";
      workspaces = "$WIN_PROGRAM_FILES/PowerToys/PowerToys.WorkspacesEditor.exe";
      "powertoys.fancyzones" = "$WIN_PROGRAM_FILES/PowerToys/PowerToys.FancyZones.exe";
      fancyzones = "$WIN_PROGRAM_FILES/PowerToys/PowerToys.FancyZones.exe";
      "powertoys.env" = "$WIN_PROGRAM_FILES/PowerToys/WinUI3Apps/PowerToys.EnvironmentVariables.exe";
      environmentvariables = "$WIN_PROGRAM_FILES/PowerToys/WinUI3Apps/PowerToys.EnvironmentVariables.exe";
      "powertoys.measuretool" = "$WIN_PROGRAM_FILES/PowerToys/WinUI3Apps/PowerToys.MeasureToolUI.exe";
      measuretool = "$WIN_PROGRAM_FILES/PowerToys/WinUI3Apps/PowerToys.MeasureToolUI.exe";
      "powertoys.hosts" = "$WIN_PROGRAM_FILES/PowerToys/WinUI3Apps/PowerToys.Hosts.exe";
      hosts = "$WIN_PROGRAM_FILES/PowerToys/WinUI3Apps/PowerToys.Hosts.exe";
  };

  programs.docker-cli.enable = true;
}
