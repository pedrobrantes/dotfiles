{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.tailscale
  ];

  systemd.user.services.tailscaled = {
    Unit = {
      Description = "Tailscale node agent";
      After = [ "network.target" ];
    };
    Service = {
      ExecStart = "${pkgs.tailscale}/bin/tailscaled --tun=userspace-networking --socket=${config.home.homeDirectory}/.tailscaled.sock --state=${config.home.homeDirectory}/.tailscale-state";
      Restart = "always";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  programs.bash.initExtra = ''
    tailscale() {
      local socket="${config.home.homeDirectory}/.tailscaled.sock"
      local bin="${pkgs.tailscale}/bin/tailscale"
      
      if [[ "$1" == "up" ]]; then
        shift
        echo "Starting Tailscale with Bitwarden key..."
        "$bin" --socket="$socket" up --authkey="$(bw get password tailscale-auth-key)" "$@"
      else
        "$bin" --socket="$socket" "$@"
      fi
    }
  '';
}
