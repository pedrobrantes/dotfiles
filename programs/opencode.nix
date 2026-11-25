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

  # Política de permissões OpenCode V2 (última regra correspondente vence):
  # 1. Base segura (leitura/busca liberadas no workspace; shell e diretórios externos pedem confirmação)
  # 2. Allowlist de comandos read-only e entrypoints padronizados de verificação (`check`, `test`, `lint`, `fmt`)
  # 3. Denylist rígida no final (sempre bloqueia segredos e comandos destrutivos/financeiros)
  opencodePermissions = [
    # Leitura e edição no workspace
    { action = "read"; resource = "*"; effect = "allow"; }
    { action = "glob"; resource = "*"; effect = "allow"; }
    { action = "grep"; resource = "*"; effect = "allow"; }
    { action = "skill"; resource = "*"; effect = "allow"; }

    # Proteção de arquivos sensíveis (nunca ler ou editar)
    { action = "read"; resource = "*.env"; effect = "deny"; }
    { action = "read"; resource = "*.env.*"; effect = "deny"; }
    { action = "read"; resource = "*id_ed25519*"; effect = "deny"; }
    { action = "read"; resource = "*id_rsa*"; effect = "deny"; }
    { action = "read"; resource = "*age/keys.txt*"; effect = "deny"; }
    { action = "read"; resource = "*sops-nix/secrets*"; effect = "deny"; }
    { action = "read"; resource = "*secrets.d/*"; effect = "deny"; }

    # Limite de diretórios externos
    { action = "external_directory"; resource = "*"; effect = "ask"; }
    { action = "external_directory"; resource = "${config.home.homeDirectory}/.agents/*"; effect = "allow"; }
    { action = "external_directory"; resource = "${config.home.homeDirectory}/.dev/*"; effect = "allow"; }

    # Shell: pede confirmação por padrão
    { action = "shell"; resource = "*"; effect = "ask"; }

    # Shell ALLOW: inspeção read-only
    { action = "shell"; resource = "ls *"; effect = "allow"; }
    { action = "shell"; resource = "cat *"; effect = "allow"; }
    { action = "shell"; resource = "head *"; effect = "allow"; }
    { action = "shell"; resource = "tail *"; effect = "allow"; }
    { action = "shell"; resource = "wc *"; effect = "allow"; }
    { action = "shell"; resource = "stat *"; effect = "allow"; }
    { action = "shell"; resource = "tree *"; effect = "allow"; }
    { action = "shell"; resource = "rg *"; effect = "allow"; }
    { action = "shell"; resource = "fd *"; effect = "allow"; }
    { action = "shell"; resource = "git status *"; effect = "allow"; }
    { action = "shell"; resource = "git diff *"; effect = "allow"; }
    { action = "shell"; resource = "git log *"; effect = "allow"; }
    { action = "shell"; resource = "git branch *"; effect = "allow"; }
    { action = "shell"; resource = "git show *"; effect = "allow"; }

    # Shell ALLOW: verificação/testes locais padronizados (devenv scripts & runners)
    { action = "shell"; resource = "check *"; effect = "allow"; }
    { action = "shell"; resource = "test *"; effect = "allow"; }
    { action = "shell"; resource = "lint *"; effect = "allow"; }
    { action = "shell"; resource = "fmt *"; effect = "allow"; }
    { action = "shell"; resource = "pytest *"; effect = "allow"; }
    { action = "shell"; resource = "uv run pytest *"; effect = "allow"; }
    { action = "shell"; resource = "cargo test *"; effect = "allow"; }
    { action = "shell"; resource = "cargo check *"; effect = "allow"; }
    { action = "shell"; resource = "go test *"; effect = "allow"; }
    { action = "shell"; resource = "npm test *"; effect = "allow"; }
    { action = "shell"; resource = "nix flake check *"; effect = "allow"; }
    { action = "shell"; resource = "devenv test *"; effect = "allow"; }

    # Shell DENY: comandos destrutivos, elevação de privilégio, segredos e billing
    { action = "shell"; resource = "rm -rf /*"; effect = "deny"; }
    { action = "shell"; resource = "rm -rf ~*"; effect = "deny"; }
    { action = "shell"; resource = "git push --force*"; effect = "deny"; }
    { action = "shell"; resource = "git push -f *"; effect = "deny"; }
    { action = "shell"; resource = "git reset --hard*"; effect = "deny"; }
    { action = "shell"; resource = "git clean -fd*"; effect = "deny"; }
    { action = "shell"; resource = "sudo *"; effect = "deny"; }
    { action = "shell"; resource = "sops --decrypt*"; effect = "deny"; }
    { action = "shell"; resource = "gcloud billing *"; effect = "deny"; }
    { action = "shell"; resource = "gcloud projects delete*"; effect = "deny"; }
    { action = "shell"; resource = "dd *"; effect = "deny"; }
    { action = "shell"; resource = "mkfs*"; effect = "deny"; }
  ];

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
      permissions = opencodePermissions;
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

  # OpenCode V2 lê opencode.json (espelha o config.json gerado pelo módulo do Home Manager)
  xdg.configFile."opencode/opencode.json".source =
    config.xdg.configFile."opencode/config.json".source;

  # Global AGENTS.md compartilhado a partir de ~/.agents/AGENTS.md (fonte única com o agy)
  xdg.configFile."opencode/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.agents/AGENTS.md";

  programs.bash.shellAliases = {
    oc = "opencode";
  };
}
