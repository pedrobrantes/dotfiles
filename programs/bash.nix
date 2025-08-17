{ pkgs, config, ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;

    bash-it = {
      enable = true;
      theme = "pure";
    };

    initExtra = ''
      # Evita que o script pare se não for interativo
      case $- in
        *i*) ;;
          *) return;;
      esac

      # WSL Paths (do seu .bashrc)
      export WIN_SYSTEM32="/mnt/c/windows/system32"
      export WIN_USERPROFILE=$(wslpath "$(cmd.exe /c echo %USERPROFILE%)" | tr -d '\r')
      export WIN_PROGRAM_FILES="/mnt/c/'program files'"
      export PATH=$PATH:"$WIN_PROGRAM_FILES":"$WIN_SYSTEM32"

      # Outras variáveis e configurações (do seu .bashrc e .profile)
      unset MAILCHECK
      export SCM_CHECK=true
      export PIPX_USE_UV=1

      # Sourcing de outros scripts e inicializações de ferramentas
      [ -f ~/.bash_functions ] && . ~/.bash_functions
      [ -f ~/.bash_aliases ] && . ~/.bash_aliases
      [ -f ~/.fabric_configs ] && . ~/.fabric_configs
      [ -f ~/.bash_api ] && . ~/.bash_api

      # Fnm
      FNM_PATH="${config.home.homeDirectory}/.local/share/fnm"
      if [ -d "$FNM_PATH" ]; then
        export PATH="$FNM_PATH:$PATH"
        eval "$(fnm env)"
      fi
      
      # Zoxide
      eval "$(zoxide init bash)"

      # Fzf - Carregando o script padrão
      [ -f ~/.fzf.bash ] && source ~/.fzf.bash

      # Brew
      if [ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
      fi
      
      # Cargo
      . "${config.home.homeDirectory}/.cargo/env"

      # Ghcup
      [ -f "${config.home.homeDirectory}/.ghcup/env" ] && . "${config.home.homeDirectory}/.ghcup/env"

      # Juliaup
      case ":$PATH:" in
        *:${config.home.homeDirectory}/.juliaup/bin:*) ;;
        *) export PATH=${config.home.homeDirectory}/.juliaup/bin''${PATH:+:${PATH}} ;;
      esac
    '';
  };

  home.sessionVariables = {
    FZF_DEFAULT_OPTS = "--height=60% --border --no-color";
    _ZO_FZF_OPTS = "--no-color";
  };
}
