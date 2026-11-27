{ pkgs, pkgsUnstable, config, lib, ... }:

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

  hookDispatcher = "${pkgs.python3}/bin/python3 ${config.home.homeDirectory}/.agents/hooks/dispatch.py --agent agy --hook";

  mkCommandHook = hookName: timeout: {
    type = "command";
    command = "${hookDispatcher} ${hookName}";
    inherit timeout;
  };

  antigravityHooks = {
    "session-context" = {
      SessionStart = [
        (mkCommandHook "session-context" 3)
      ];
    };
    "safety-guard" = {
      PreToolUse = [
        {
          matcher = "run_command|read_file|view_file|write_file|write_to_file|edit_file|replace_file_content|multi_replace_file_content";
          hooks = [ (mkCommandHook "safety-guard" 5) ];
        }
      ];
    };
    "token-guard" = {
      PreToolUse = [
        {
          matcher = "read_file|view_file|run_command";
          hooks = [ (mkCommandHook "token-guard" 5) ];
        }
      ];
    };
    "engineering-guard" = {
      PreToolUse = [
        {
          matcher = "run_command|write_file|write_to_file|edit_file|replace_file_content|multi_replace_file_content";
          hooks = [ (mkCommandHook "engineering-guard" 5) ];
        }
      ];
    };
    "auto-format" = {
      PostToolUse = [
        {
          matcher = "write_file|write_to_file|edit_file|replace_file_content|multi_replace_file_content";
          hooks = [ (mkCommandHook "auto-format" 3) ];
        }
      ];
    };
    "audit-telemetry" = {
      PostToolUse = [
        {
          matcher = "*";
          hooks = [ (mkCommandHook "audit-telemetry" 3) ];
        }
      ];
    };
    "quality-hygiene-gate" = {
      Stop = [
        (mkCommandHook "quality-hygiene-gate" 8)
      ];
    };
    "handoff-and-notify" = {
      Stop = [
        (mkCommandHook "handoff-and-notify" 4)
      ];
    };
  };
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

  # Global Antigravity lifecycle hooks delegating to ~/.agents/hooks/dispatch.py
  home.file.".gemini/config/hooks.json" = {
    force = true;
    text = builtins.toJSON antigravityHooks;
  };
}
