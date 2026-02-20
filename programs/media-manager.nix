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
