{ pkgs, config, inputs, ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;

    initExtra = ''
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
    '';
  };

  home.sessionVariables = {
    FZF_DEFAULT_OPTS = "--height=60% --border --no-color";
    _ZO_FZF_OPTS = "--no-color";
  };
}
