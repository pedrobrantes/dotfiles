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
        echo "Cheatsheets directory exists and is not empty. Converting to git repository (Declarative Fix)..."
        cd "$CHEATS_DIR"
        $DRY_RUN_CMD $GIT init -b main
        $DRY_RUN_CMD $GIT remote add origin "$REPO_URL" || $DRY_RUN_CMD $GIT remote set-url origin "$REPO_URL"
        $DRY_RUN_CMD $GIT fetch origin
        $DRY_RUN_CMD $GIT checkout -B main
        $DRY_RUN_CMD $GIT branch --set-upstream-to=origin/main main || true
      else
        echo "Cloning cheatsheets repository..."
        $DRY_RUN_CMD $GIT clone "$REPO_URL" "$CHEATS_DIR"
      fi
    fi
  '';
}
