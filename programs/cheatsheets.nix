{ pkgs, config, lib, ... }:

{
  home.packages = [
    pkgs.tealdeer
    pkgs.cheat
  ];

  # Declarative configuration for 'cheat'
  xdg.configFile."cheat/conf.yml".text = ''
    editor: nvim
    colorize: true
    style: monokai
    formatter: terminal256
    pager: less -FRX
    cheatpaths:
      - name: community
        path: ${config.home.homeDirectory}/.config/cheat/cheatsheets/community
        tags: [ community ]
        readonly: true
      - name: personal
        path: ${config.home.homeDirectory}/.config/cheat/cheatsheets/personal
        tags: [ personal ]
        readonly: false
  '';

  # Activation script to ensure the personal cheatsheet repo is cloned if missing
  home.activation.cloneCheatsheets = lib.hm.dag.entryAfter ["writeBoundary"] ''
    CHEATS_DIR="${config.home.homeDirectory}/.config/cheat/cheatsheets/personal"
    if [ ! -d "$CHEATS_DIR/.git" ]; then
      echo "Cloning cheatsheets repository..."
      $DRY_RUN_CMD ${pkgs.git}/bin/git clone git@github.com:pedrobrantes/cheatsheets.git "$CHEATS_DIR" || true
    fi
  '';
}
