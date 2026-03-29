{ pkgs, config, lib, ... }:

{
  home.packages = [
    pkgs.tealdeer
    pkgs.cheat
  ];

  # Declarative configuration for 'cheat'
  xdg.configFile."cheat/conf.yml".text = ''
    editor: nvim
    colorize: true
    style: monokai
    formatter: terminal256
    pager: less -FRX
    cheatpaths:
      - name: community
        path: ${config.home.homeDirectory}/.config/cheat/cheatsheets/community
        tags: [ community ]
        readonly: true
      - name: personal
        path: ${config.home.homeDirectory}/.config/cheat/cheatsheets/personal
        tags: [ personal ]
        readonly: false
  '';

  # Activation script to ensure the personal cheatsheet repo is cloned if missing
  home.activation.cloneCheatsheets = lib.hm.dag.entryAfter ["writeBoundary"] ''
    CHEATS_DIR="${config.home.homeDirectory}/.config/cheat/cheatsheets/personal"
    GIT="${pkgs.git}/bin/git"
    REPO_URL="https://github.com/pedrobrantes/cheatsheets.git"
    
    if [ ! -d "$CHEATS_DIR/.git" ]; then
      if [ -d "$CHEATS_DIR" ] && [ "$(ls -A $CHEATS_DIR)" ]; then
        echo "Cheatsheets directory exists and is not empty. Converting to git repository..."
        cd "$CHEATS_DIR"
        $GIT init -b main
        $GIT remote add origin "$REPO_URL" || $GIT remote set-url origin "$REPO_URL"
        $GIT fetch origin
        $GIT checkout -B main
        $GIT branch --set-upstream-to=origin/main main
      else
        echo "Cloning cheatsheets repository..."
        $GIT clone "$REPO_URL" "$CHEATS_DIR"
      fi
    else
      # If .git exists, ensure branch is main and upstream is set
      cd "$CHEATS_DIR"
      CURRENT_BRANCH=$($GIT rev-parse --abbrev-ref HEAD)
      if [ "$CURRENT_BRANCH" = "master" ]; then
        echo "Fixing branch name: master -> main"
        $GIT branch -m master main
      fi
      $GIT remote set-url origin "$REPO_URL"
      $GIT fetch origin -q
      $GIT branch --set-upstream-to=origin/main main || true
      echo "Restoring missing files from GitHub..."
      $GIT reset --hard origin/main
    fi
  '';
}
