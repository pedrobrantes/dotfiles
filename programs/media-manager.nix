{ pkgs, ... }:

let
  # Modular Scripts from the store
  ankiSyncTool = pkgs.writers.writePython3Bin "anki-sync-internal" { } 
    (builtins.readFile ../scripts/python/anki_sync.py);

  ankiViewTool = pkgs.writers.writePython3Bin "anki-view-internal" { } 
    (builtins.readFile ../scripts/python/anki_view.py);

  mmTool = pkgs.writeShellScriptBin "mm-internal" 
    (builtins.readFile ../scripts/bash/mm.sh);

  # Configuration Data
  mediaSources = {
    archive = "https://archive.org/details/";
    youtube = "https://www.youtube.com/results?search_query=";
    topflix = "https://topflix.fm/search/";
    documentary = "https://documentaryheaven.com/?s=";
    vidsrc = "https://vidsrc.me/embed/";
    assistir = "https://assistir.biz/?s=";
    upnovelas = "https://upnovelas.com/?s=";
    pobleflix = "https://pobleflix.fast/";
    vizer = "https://vizer.lol/pesquisar/";
    plutotv = "https://pluto.tv/on-demand/";
  };

  sourceList = builtins.concatStringsSep "\n" (
    map (name: "${name} - ${builtins.getAttr name mediaSources}") (builtins.attrNames mediaSources)
  );
in
{
  home.packages = [ ankiSyncTool ankiViewTool mmTool ];

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

    # --- Media Manager ---
    mm() {
      mm-internal "${sourceList}" "$1"
    }
  '';
}
