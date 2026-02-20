{ pkgs, ... }:

let
  # List of trusted media sources (add new sites here!)
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

  # Generate formatted string for the shell helper
  sourceList = builtins.concatStringsSep "\n" (
    map (name: "${name} - ${builtins.getAttr name mediaSources}") (builtins.attrNames mediaSources)
  );
in
{
  programs.bash.initExtra = ''
    # Anki Database Browser
    # Usage: anki-view
    anki-view() {
      local db="/sdcard/AnkiDroid/collection.anki2"
      if [ ! -f "$db" ]; then
        echo "Error: Anki database not found at $db"
        return 1
      fi

      # 1. Select Deck (Listing decks usually doesn't require the collation)
      local deck_name=$(sqlite3 "$db" "SELECT name FROM decks" | fzf --prompt="Select Anki Deck: ")
      [ -z "$deck_name" ] && return

      echo -e "\033[1;34m--- Cards in $deck_name ---\033[0m"
      
      # 2. Query using Python to register the 'unicase' collation on the fly
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

    # Media Source Manager Helper
    # Usage: 
    #   mm list - List saved sources
    #   mm go   - Interactive search using fzf to pick a source
    mm() {
      case "$1" in
        "list")
          echo -e "\033[1;34m--- Saved Media Sources ---\033[0m"
          echo "${sourceList}" | column -t -s "-"
          ;; 
        "go")
          local source=$(echo "${sourceList}" | fzf --prompt="Select Source: " | awk '{print $NF}')
          if [ -n "$source" ]; then
             echo -e "\033[1;32mURL available:\033[0m $source"
             # Copying to clipboard if needed (platform dependent)
             # echo -n "$source" | xclip -selection clipboard 2>/dev/null
          fi
          ;; 
        *)
          echo "Usage: mm [list|go]"
          echo "To download found media: b [URL]"
          ;; 
      esac
    }
  '';
}
