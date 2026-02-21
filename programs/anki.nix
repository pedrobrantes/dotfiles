{ pkgs, ... }:

let
  # Modular Scripts from the store
  ankiSyncTool = pkgs.writers.writePython3Bin "anki-sync-internal" { } 
    (builtins.readFile ../scripts/python/anki_sync.py);

  ankiViewTool = pkgs.writers.writePython3Bin "anki-view-internal" { } 
    (builtins.readFile ../scripts/python/anki_view.py);
in
{
  home.packages = [ ankiSyncTool ankiViewTool ];

  programs.bash.initExtra = ''
    # --- Anki study tools ---
    anki-sync() {
      local db="/sdcard/AnkiDroid/collection.anki2"
      local cards_dir="/mnt/sdcard/Sync/Obsidian/My Notes/2-flashcards"
      if [ ! -f "$db" ]; then echo "Error: Anki DB not found"; return 1; fi
      echo -e "\033[1;34m--- Syncing Obsidian to Anki ---\033[0m"
      for file in "$cards_dir"/*.md; do
        [ -e "$file" ] || continue
        local deck=$(basename "$file" .md)
        echo "Processing: $deck"
        anki-sync-internal "$db" "$deck" "$file"
      done
      echo -e "\033[1;32mSync Complete!\033[0m"
    }

    anki-view() {
      local db="/sdcard/AnkiDroid/collection.anki2"
      if [ ! -f "$db" ]; then echo "Error: Anki DB not found"; return 1; fi
      local deck_name=$(sqlite3 "$db" "SELECT name FROM decks" | fzf --prompt="Select Deck: ")
      [ -z "$deck_name" ] && return
      anki-view-internal "$db" "$deck_name" | less -R
    }
  '';
}
