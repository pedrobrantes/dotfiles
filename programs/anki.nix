{ pkgs, ... }:

let
  ankiSyncTool = pkgs.writers.writePython3Bin "anki-sync-internal" { } 
    (builtins.readFile ../scripts/python/anki_sync.py);

  ankiViewTool = pkgs.writers.writePython3Bin "anki-view-internal" { } 
    (builtins.readFile ../scripts/python/anki_view.py);
in
{
  home.packages = [ ankiSyncTool ankiViewTool ];

  programs.bash.initExtra = ''
    # --- Anki API study tools (via AnkiConnect Android) ---
    
    # Sync notes from Obsidian to Anki
    anki-sync() {
      local cards_dir="/mnt/sdcard/Sync/Obsidian/My Notes/2-flashcards"
      echo -e "\033[1;34m--- Syncing Obsidian to Anki (API) ---\033[0m"
      for file in "$cards_dir"/*.md; do
        [ -e "$file" ] || continue
        
        # Get filename without extension
        local base_name=$(basename "$file" .md)
        
        # Format deck name: kebab-case -> Title Case
        # Example: linux-basics -> Linux Basics
        local deck=$(echo "$base_name" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)}1')
        
        echo "Processing: $deck"
        anki-sync-internal "http://localhost:8765" "$deck" "$file"
      done
      echo -e "\033[1;32mSync Complete!\033[0m"
    }

    # Browse Anki decks in terminal
    anki-view() {
      # Use curl to get deck names for fzf selection
      local decks=$(curl -s -X POST http://localhost:8765 -d '{"action": "deckNames", "version": 6}' | python3 -c "import sys, json; print('\n'.join(json.load(sys.stdin)['result']))")
      
      if [ -z "$decks" ]; then
        echo "Error: Could not connect to AnkiConnect. Is the app running?"
        return 1
      fi

      local deck_name=$(echo "$decks" | fzf --prompt="Select Deck: ")
      [ -z "$deck_name" ] && return
      
      anki-view-internal "http://localhost:8765" "$deck_name" | less -R
    }
  '';
}