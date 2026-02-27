{ config, pkgs, lib, ... }:

{
  home.activation.manageDevTemplates = lib.hm.dag.entryAfter ["writeBoundary"] ''
    DEV_DIR="${config.home.homeDirectory}/.dev"
    GIT="${pkgs.git}/bin/git"

    if [ ! -d "$DEV_DIR" ]; then
      echo "Cloning .dev repository..."
      $DRY_RUN_CMD $GIT clone https://github.com/pedrobrantes/dev.git "$DEV_DIR"
    else
      if [ -d "$DEV_DIR/.git" ]; then
        cd "$DEV_DIR"
        if [ -z "$($GIT status --porcelain)" ]; then
          $GIT fetch origin -q
          LOCAL=$($GIT rev-parse @)
          REMOTE=$($GIT rev-parse @{u} 2>/dev/null || echo "$LOCAL")
          BASE=$($GIT merge-base @ @{u} 2>/dev/null || echo "$LOCAL")

          if [ "$LOCAL" = "$REMOTE" ]; then
            : # Up to date
          elif [ "$LOCAL" = "$BASE" ]; then
            echo "Updating .dev repository (pulling changes)..."
            $DRY_RUN_CMD $GIT pull -q
          else
            echo "Warning: .dev has diverged from origin. Manual intervention required."
          fi
        else
          echo "Warning: .dev has local changes. Skipping automatic update."
        fi
      fi
    fi
  '';
}
