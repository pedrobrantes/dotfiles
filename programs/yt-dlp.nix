{ pkgs, ... }:
{
  home.packages = [ pkgs.yt-dlp ];
  programs.bash.shellAliases = {
    b = "yt-dlp --downloader aria2c --downloader-args 'aria2c:-x 16 -s 16 -k 1M' --embed-metadata -f 'bestvideo+bestaudio/best' --merge-output-format mp4";
    bmusic = "yt-dlp -x --audio-format mp3 --downloader aria2c --downloader-args 'aria2c:-x 16 -s 16 -k 1M'";
  };
}
