{ pkgs, ... }:

{
  home.packages = [
    pkgs.iamb
  ];

  programs.bash.shellAliases = {
    matrix = "iamb";
  };

  # Declarative iamb configuration (~/.config/iamb/config.toml)
  xdg.configFile."iamb/config.toml".text = ''
    [profiles."matrix.org"]
    user_id = "@brantes:matrix.org"

    [settings]
    render_markdown = true
    
    [settings.image_preview]
    protocol = { type = "sixel" }
    
    [settings.notifications]
    enabled = true
    via = "bell"
    
    [settings.message_format]
    markdown = true
    html = true

    [logging]
    level = "info"
  '';
}
