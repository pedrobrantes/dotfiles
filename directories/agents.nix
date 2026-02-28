{ config, pkgs, lib, ... }:

{
  home.activation.manageAgentsRepo = lib.hm.dag.entryAfter ["writeBoundary"] ''
    AGENTS_DIR="${config.home.homeDirectory}/.agents"
    GIT="${pkgs.git}/bin/git"

    if [ ! -d "$AGENTS_DIR" ]; then
      echo "Cloning agents repository..."
      $DRY_RUN_CMD $GIT clone https://github.com/pedrobrantes/agents.git "$AGENTS_DIR"
    else
      if [ -d "$AGENTS_DIR/.git" ]; then
        cd "$AGENTS_DIR"
        if [ -z "$($GIT status --porcelain)" ]; then
          $GIT fetch origin -q
          LOCAL=$($GIT rev-parse @)
          REMOTE=$($GIT rev-parse @{u} 2>/dev/null || echo "$LOCAL")
          BASE=$($GIT merge-base @ @{u} 2>/dev/null || echo "$LOCAL")

          if [ "$LOCAL" = "$REMOTE" ]; then
            : # Up to date
          elif [ "$LOCAL" = "$BASE" ]; then
            echo "Updating agents repository (pulling changes)..."
            $DRY_RUN_CMD $GIT pull -q
          else
            echo "Warning: .agents has diverged from origin. Manual intervention required."
          fi
        else
          echo "Warning: .agents has local changes. Skipping automatic update."
        fi
      fi
    fi
  '';
}
