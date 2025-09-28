{ pkgs, config, inputs, ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      ps = "procs";
      cp = "cp_progress";
      wexec = "watchexec";
      color = "pastel color";
      traceroute = "mtr";
      tracepath = "mtr";
      aria2 = "aria2c";
      hex = "hexyl";
      fzf = "fzf --no-color";
      ips = "ip -c -br a";
      ifconfig = "ip";
      update = "sudo apt update && sudo apt upgrade";
      f = "pay-respects bash";
      python = "python3";
      patterns = "eza ~/.config/fabric/patterns | cat";
      strategies = "eza ~/.config/fabric/strategies | cat";
      extensions = "eza ~/.config/fabric/extensions | cat";
      contexts = "eza ~/.config/fabric/contexts | cat";
      sessions = "eza ~/.config/fabric/sessions | cat";
      summarize = "fabric --pattern summarize --stream";
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
      gadd = "git add";
      gcom = "git commit -m";
      gpull = "git pull";
      gpush = "git push";
      please = "sudo";
      nf = "fastfetch";
      neofetch = "fastfetch";
    };

    initExtra = ''
      # Function for 'cp' with a progress bar using rsync
      cp_progress() {
          if [ "$#" -lt 2 ]; then
              command cp "$@"
              return $?
          fi

          local source="$1"
          local dest="$2"

          if [ -d "$source" ]; then
              echo "Copying directory '$source' to '$dest'..."
              rsync -ah --info=progress2 "$source" "$dest"
          elif [ -f "$source" ]; then
              echo "Copying file '$source' to '$dest'..."
              rsync -ah --info=progress2 "$source" "$dest"
          else
              echo "Copying '$source' to '$dest' (no progress bar)."
              command cp "$@"
          fi
      }

      export BASH_IT="${inputs.bash-it}"
      if [ -d "${config.home.homeDirectory}/.bash_it" ]; then
        export BASH_IT_THEME='pure'
        source "$BASH_IT/bash_it.sh"
      fi

      if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
        . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      fi

      if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
        . "$HOME/.nix-profile/etc/profile.d/nix.sh"
      fi

      echo 'Hi, Brantes! '
    '';
  };

  home.sessionVariables = {
    FZF_DEFAULT_OPTS = "--height=60% --border --no-color";
    _ZO_FZF_OPTS = "--no-color";
  };
}