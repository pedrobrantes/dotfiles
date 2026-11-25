{ config, lib, pkgsUnstable, ... }:

let
  ollamaEnabled = config.programs.custom-ollama.enable or false;

  # Apenas os MCPs essenciais ficam ativos por padrão no opencode para economizar contexto.
  # Todos os outros continuam disponíveis via programs.mcp.servers, mas com enabled = false.
  coreMcpNames = [
    "context7"
    "fetch"
    "exa"
    "grep"
    "obsidian"
  ];

  toOpencodeServer = name: server:
    {
      enabled = builtins.elem name coreMcpNames;
    }
    // (
      if server ? url then
        {
          type = "remote";
          url = server.url;
        }
        // (lib.optionalAttrs (server ? headers) { headers = server.headers; })
      else if server ? command then
        {
          type = "local";
          command = [ server.command ] ++ (server.args or [ ]);
        }
        // (lib.optionalAttrs (server ? env) { environment = server.env; })
      else
        { }
    );

  opencodeMcp = lib.mapAttrs toOpencodeServer config.programs.mcp.servers;

  ollamaProvider = lib.optionalAttrs ollamaEnabled {
    ollama = {
      npm = "@ai-sdk/openai-compatible";
      name = "Ollama (local)";
      options = {
        baseURL = "http://localhost:11434/v1";
      };
      models = {
        "qwen2.5-coder:7b" = {
          name = "Qwen 2.5 Coder 7B (RTX 3060 Ti)";
        };
        "qwen3:8b" = {
          name = "Qwen 3 8B (RTX 3060 Ti)";
        };
      };
    };
  };
in
{
  programs.opencode = {
    enable = true;
    package = pkgsUnstable.opencode;

    settings = {
      autoupdate = false; # Gerenciado declarativamente via Nix/Home Manager
      mcp = opencodeMcp;
      provider = {
        google = {
          options = {
            apiKey = "{file:${config.sops.secrets.gemini_api_key.path}}";
          };
        };
      } // ollamaProvider;
    };

    commands = {
      handoff = ''
        ---
        description: Save a concise HANDOFF.md to seamlessly switch between agy and opencode
        ---

        Create or update `HANDOFF.md` in the current project root with a compact, high-signal summary so another agent (`agy` or `opencode`) can resume immediately without re-reading the full chat:

        1. **Goal**: What we are trying to accomplish.
        2. **Done**: Completed steps and exact modified/created file paths.
        3. **Current State**: Output of `git status --short` and any passing/failing tests.
        4. **Next Steps**: Ordered list of remaining tasks and open decisions.

        Keep it under 60 lines.
      '';

      resume = ''
        ---
        description: Resume work from HANDOFF.md, PROGRESS.md, or current git diff
        ---

        Recover context from the previous session (e.g. after switching from `agy` due to quota):

        1. Read `HANDOFF.md` and/or `PROGRESS.md` if present in the workspace.
        2. Run `git status --short` and `git diff --stat` to inspect uncommitted work.
        3. Summarize where we stopped in 5 bullets and ask (or proceed if unambiguous) with the next step.
      '';
    };
  };

  # Global AGENTS.md compartilhado a partir de ~/.agents/AGENTS.md (fonte única com o agy)
  xdg.configFile."opencode/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.agents/AGENTS.md";

  programs.bash.shellAliases = {
    oc = "opencode";
  };
}
