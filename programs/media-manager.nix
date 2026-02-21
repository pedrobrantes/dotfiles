{ pkgs, ... }:

let
  # Read the Python script from the scripts directory
  ankiSyncPythonContent = builtins.readFile ../scripts/python/anki_sync.py;

  # Create a standalone binary in the Nix Store
  ankiSyncTool = pkgs.writers.writePython3Bin "anki-sync-internal" { } ankiSyncPythonContent;

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
  home.packages = [ ankiSyncTool ];

  programs.bash.initExtra = ''
    # Anki Sync from Obsidian
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

    # Anki Database Browser
    anki-view() {
      local db="/sdcard/AnkiDroid/collection.anki2"
      local deck_name=$(sqlite3 "$db" "SELECT name FROM decks" | fzf --prompt="Select Deck: ")
      [ -z "$deck_name" ] && return
      python3 -c "
import sqlite3, sys
conn = sqlite3.connect(f'file:{sys.argv[1]}?mode=ro', uri=True)
conn.create_collation('unicase', lambda a, b: (a.lower() > b.lower()) - (a.lower() < b.lower()))
cur = conn.cursor()
query = 'SELECT n.flds FROM notes n JOIN cards c ON n.id = c.nid JOIN decks d ON c.did = d.id WHERE d.name = ?'
cur.execute(query, (sys.argv[2],))
for r in cur.fetchall():
    print(r[0].replace('\x1f', '\n--- BACK ---\n') + '\n' + '-'*40)
" "$db" "$deck_name" | less -R
    }

    mm() {
      case "$1" in
        "list")
          echo -e "\033[1;34m--- Saved Media Sources ---\033[0m"
          echo "${sourceList}" | column -t -s "-"
          ;; 
        "go")
          local source=$(echo "${sourceList}" | fzf --prompt="Select Source: " | awk '{print $NF}')
          if [ -n "$source" ]; then echo -e "\033[1;32mURL available:\033[0m $source"; fi
          ;; 
        *) echo "Usage: mm [list|go]";;
      esac
    }
  '';
}