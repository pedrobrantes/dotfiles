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

      # 1. Select Deck
      local deck_name=$(sqlite3 "$db" "SELECT name FROM decks" | fzf --prompt="Select Anki Deck: ")
      [ -z "$deck_name" ] && return

      # 2. Get Deck ID
      # Note: Anki stores decks as a JSON-like string in older versions or a table in newer ones.
      # For safety across versions, we search for the deck name in the cards/notes join.
      
      echo -e "\033[1;34m--- Cards in $deck_name ---\033[0m"
      
      # 3. List cards (Front only for selection)
      # We use 'unit separator' (0x1f) logic to split fields
      sqlite3 -separator " | " "$db" "
        SELECT n.flds 
        FROM notes n 
        JOIN cards c ON n.id = c.nid 
        JOIN decks d ON c.did = d.id 
        WHERE d.name = '$deck_name'
      " | sed 's/\x1f/\n--- BACK ---\n/g' | less -R
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
