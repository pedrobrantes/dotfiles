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