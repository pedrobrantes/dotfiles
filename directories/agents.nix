{ config, pkgs, lib, ... }:

{
  home.activation.manageAgentsRepo = lib.hm.dag.entryAfter ["writeBoundary"] ''
    AGENTS_DIR="${config.home.homeDirectory}/.agents"
    GIT="${pkgs.git}/bin/git"

    if [ ! -d "$AGENTS_DIR" ]; then
      echo "Cloning agents repository..."
      $DRY_RUN_CMD $GIT clone https://github.com/pedrobrantes/agents.git "$AGENTS_DIR" || echo "Warning: Failed to clone .agents (offline?)."
    elif [ -d "$AGENTS_DIR/.git" ]; then
      cd "$AGENTS_DIR"
      if $GIT fetch origin -q 2>/dev/null; then
        LOCAL=$($GIT rev-parse @)
        REMOTE=$($GIT rev-parse @{u} 2>/dev/null || echo "$LOCAL")
        BASE=$($GIT merge-base @ @{u} 2>/dev/null || echo "$LOCAL")

        if [ "$LOCAL" = "$REMOTE" ]; then
          : # Up to date
        elif [ "$LOCAL" = "$BASE" ]; then
          echo "Updating agents repository (pull --rebase --autostash)..."
          $DRY_RUN_CMD $GIT pull --rebase --autostash -q || echo "Warning: Failed to rebase .agents onto origin. Resolve manually."
        elif [ "$REMOTE" = "$BASE" ]; then
          echo "Note: .agents has local commits ahead of origin (remember to git push)."
        else
          echo "Warning: .agents has diverged from origin. Manual intervention required."
        fi
      else
        echo "Note: Skipping .agents remote fetch (offline or DNS unavailable)."
      fi
    fi
  '';
}
