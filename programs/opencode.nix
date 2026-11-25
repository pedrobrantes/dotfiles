{ config, lib, pkgs, ... }:

let
  ollamaEnabled = config.programs.custom-ollama.enable or false;

  # Subset enxuto de MCPs para o opencode (evita estourar contexto em modelos de fallback).
  # O GitHub MCP fica pré-configurado porém desabilitado por padrão (muitos tokens; use `gh` CLI).
  opencodeMcp = {
    context7 = {
      type = "remote";
      url = "https://context7-mcp--upstash.run.tools";
      enabled = true;
    };
    fetch = {
      type = "remote";
      url = "https://server.smithery.ai/smithery-ai/fetch/mcp";
      enabled = true;
    };
    exa = {
      type = "remote";
      url = "https://exa.run.tools";
      enabled = true;
    };
    grep = {
      type = "remote";
      url = "https://grep--vercel.run.tools";
      enabled = true;
    };
    obsidian = {
      type = "local";
      command = [
        "npx"
        "-y"
        "obsidian-mcp"
        "--path"
        "${config.home.homeDirectory}/Sync/Obsidian/My Notes"
      ];
      enabled = true;
    };
    github = {
      type = "remote";
      url = "https://github.run.tools";
      enabled = false;
    };
  };

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
    package = pkgs.opencode;

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

    rules = ''
      # Global Instructions (OpenCode)

      - Respond in the same language as the user (usually PT-BR), keeping code, commits, and technical identifiers in English unless requested otherwise.
      - Be concise and direct. Verify changes with tests/commands before concluding.
      - If a project has `HANDOFF.md` or `PROGRESS.md`, read it when resuming work to recover context from previous sessions (e.g., Antigravity CLI / `agy`).
      - Prefer the `gh` CLI over enabling heavy GitHub MCP tools unless explicitly needed.
      - In `~/.config/home-manager`, remember Nix flakes only see git-tracked files (`git add` new files before running `./switch.sh`) and every module in `programs/` requires a matching `tests/programs/test_<name>.py`.
    '';

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

  programs.bash.shellAliases = {
    oc = "opencode";
  };
}
