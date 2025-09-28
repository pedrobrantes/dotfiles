{ pkgs, ... }:
{
  home.packages = with pkgs; [ hyperfine ];
  programs.bash.shellAliases = {
    benchmark = "hyperfine";
  };
}
