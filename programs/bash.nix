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
      csync = "cheat-sync";
    };

    profileExtra = ''
      if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
        . "$HOME/.nix-profile/etc/profile.d/nix.sh"
      fi

      # Switch to Nix bash if interactive and not already bash
      if [ -z "$BASH_VERSION" ] && [ -x "$HOME/.nix-profile/bin/bash" ]; then
        export SHELL="$HOME/.nix-profile/bin/bash"
        exec "$SHELL" -l
      fi
    '';

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
      if [ -f "$BASH_IT/bash_it.sh" ] || [ -d "${config.home.homeDirectory}/.bash_it" ]; then
        export BASH_IT_THEME='pure'
        source "$BASH_IT/bash_it.sh"
        if command -v __bp_install > /dev/null 2>&1; then
          __bp_install
        fi

        pure_prompt() {
          local ps_host="''${bold_blue?}${config.custom.hostName}''${normal?}"
          local ps_user="''${green?}\u''${normal?}"
          local ps_user_mark="''${green?} \$ ''${normal?}"
          local ps_root="''${red?}\u''${red?}"
          local ps_root_mark="''${red?} \$ ''${normal?}"
          local ps_path="''${yellow?}\w''${normal?}"
          local virtualenv_prompt scm_prompt
          virtualenv_prompt="$(virtualenv_prompt)"
          scm_prompt="$(scm_prompt)"
          case "''${EUID:-$UID}" in
            0)
              ps_user_mark="''${ps_root_mark}"
              ps_user="''${ps_root}"
              ;;
          esac
          PS1="''${virtualenv_prompt}''${ps_user}@''${ps_host}''${scm_prompt}:''${ps_path}''${ps_user_mark}"
        }
      fi

      export PS1="\[\033[01;32m\]\u\[\033[00m\]@\[\033[01;34m\]${config.custom.hostName}\[\033[00m\]:\[\033[01;33m\]\w\[\033[00m\]\$ "

      if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
        . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      fi

      if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
        . "$HOME/.nix-profile/etc/profile.d/nix.sh"
      fi

      echo 'Hi, Brantes! '

      # --- Cheat-sync: Automate Git for personal cheatsheets ---
      cheat-sync() {
          local cheats_dir="$HOME/.config/cheat/cheatsheets/personal"
          if [ ! -d "$cheats_dir/.git" ]; then
              echo "Error: Personal cheatsheets directory is not a git repository."
              return 1
          fi
          
          pushd "$cheats_dir" > /dev/null
          git add .
          local msg="update cheats: $(date +'%Y-%m-%d %H:%M:%S')"
          git commit -m "$msg" && git push
          popd > /dev/null
      }

      # --- Cheat wrapper: Support 'cheat nix flake' by converting spaces to hyphens ---
      cheat() {
          if [ "$#" -gt 1 ]; then
              local joined=$(IFS=-; echo "$*")
              command cheat "$joined"
          else
              command cheat "$@"
          fi
      }
    '';
  };

    home.sessionVariables = {

      FZF_DEFAULT_OPTS = "--height=60% --border --no-color";

      _ZO_FZF_OPTS = "--no-color";

      SHELL = "${pkgs.bash}/bin/bash";

    };

  }

  