{ config, pkgs, lib, ... }:

{
  home.activation.manageDevTemplates = lib.hm.dag.entryAfter ["writeBoundary"] ''
    DEV_DIR="${config.home.homeDirectory}/.dev"
    GIT="${pkgs.git}/bin/git"

    if [ ! -d "$DEV_DIR" ]; then
      echo "Cloning .dev repository..."
      $DRY_RUN_CMD $GIT clone https://github.com/pedrobrantes/dev.git "$DEV_DIR" || echo "Warning: Failed to clone .dev (offline?)."
    elif [ -d "$DEV_DIR/.git" ]; then
      cd "$DEV_DIR"
      if $GIT fetch origin -q 2>/dev/null; then
        LOCAL=$($GIT rev-parse @)
        REMOTE=$($GIT rev-parse @{u} 2>/dev/null || echo "$LOCAL")
        BASE=$($GIT merge-base @ @{u} 2>/dev/null || echo "$LOCAL")

        if [ "$LOCAL" = "$REMOTE" ]; then
          : # Up to date
        elif [ "$LOCAL" = "$BASE" ]; then
          echo "Updating .dev repository (pull --rebase --autostash)..."
          $DRY_RUN_CMD $GIT pull --rebase --autostash -q || echo "Warning: Failed to rebase .dev onto origin. Resolve manually."
        elif [ "$REMOTE" = "$BASE" ]; then
          echo "Note: .dev has local commits ahead of origin (remember to git push)."
        else
          echo "Warning: .dev has diverged from origin. Manual intervention required."
        fi
      else
        echo "Note: Skipping .dev remote fetch (offline or DNS unavailable)."
      fi
    fi
  '';
}
