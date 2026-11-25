{ pkgsUnstable, config, lib, ... }:

let
  # Converte programs.mcp.servers (formato padrão: url / command+args)
  # para o formato esperado pelo Antigravity (serverUrl / command+args).
  toAntigravityServer = _name: server:
    if server ? url then
      { serverUrl = server.url; }
      // (lib.optionalAttrs (server ? headers) { headers = server.headers; })
    else
      lib.removeAttrs server [ "disabled" ];

  antigravityMcpServers = lib.mapAttrs toAntigravityServer config.programs.mcp.servers;
in
{
  home.packages = [
    pkgsUnstable.antigravity-cli
  ];

  # Global AGENTS.md compartilhado a partir de ~/.agents/AGENTS.md
  home.file.".gemini/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.agents/AGENTS.md";

  # Antigravity-cli configurations in ~/.gemini/antigravity-cli/
  home.file.".gemini/antigravity-cli/settings.json" = {
    force = true;
    text = builtins.toJSON {
      security = {
        auth = {
          selectedType = "oauth-personal";
        };
      };
      general = {
        previewFeatures = true;
      };
      trustedWorkspaces = [
        "${config.home.homeDirectory}/.config/home-manager"
        config.home.homeDirectory
      ];
    };
  };

  # Antigravity MCP configuration in ~/.gemini/antigravity-cli/mcp_config.json
  home.file.".gemini/antigravity-cli/mcp_config.json" = {
    force = true;
    text = builtins.toJSON {
      mcpServers = antigravityMcpServers;
    };
  };

  # Also alias to ~/.gemini/config/mcp_config.json for global Antigravity discovery
  home.file.".gemini/config/mcp_config.json" = {
    force = true;
    text = config.home.file.".gemini/antigravity-cli/mcp_config.json".text;
  };
}
