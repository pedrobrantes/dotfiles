{ pkgs, ... }:

let
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
  home.packages = [ mmTool ];

  programs.bash.initExtra = ''
    # --- Media Manager ---
    mm() {
      mm-internal "${sourceList}" "$1"
    }
  '';
}