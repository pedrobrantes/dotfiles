# Hooks de Ciclo de Vida para Agentes de IA

[English version](./AI_AGENT_HOOKS.md)

## Visao Geral

Os hooks seguem o padrao de adaptador fino:

- **Logica principal** fica no repositorio `~/.agents` (`~/.agents/hooks/`, apenas Python 3 stdlib). Veja o README de la para detalhes.
- **Conexao com o agente** fica aqui. `programs/antigravity.nix` gera `~/.gemini/config/hooks.json`, que chama:

```text
${pkgs.python3}/bin/python3 ~/.agents/hooks/dispatch.py --agent agy --hook <name>
```

## Hooks Ativos (agy)

| Hook | Evento | Funcao |
| :--- | :--- | :--- |
| `session-context` | `SessionStart` | Injeta branch, `git status` e trechos de `HANDOFF.md`/`PROGRESS.md` (max. 30 linhas). |
| `safety-guard` | `PreToolUse` | Espelha a denylist do `opencode.nix`, bloqueia segredos hardcoded, exige confirmacao em push/deploy. Falha fechado. |
| `token-guard` | `PreToolUse` | Bloqueia leitura de pastas de build/cache e lockfiles, comandos explosivos e compacta saidas verbosas de testes/diff. |
| `engineering-guard` | `PreToolUse` | Bloqueia `./switch.sh` com arquivos untracked ou sem `tests/programs/test_<name>.py`; bloqueia emojis em Markdown. |
| `auto-format` | `PostToolUse` | Formata o arquivo editado (ruff, gofmt, rustfmt, nixfmt, prettier) quando disponivel. |
| `audit-telemetry` | `PostToolUse` | Log JSONL com redacao e estimativa de tokens em `~/.local/share/agent-hooks/` (retencao de 30 dias). |
| `quality-hygiene-gate` | `Stop` | Lint e higiene sobre o diff, no maximo 1x por turno. |
| `handoff-and-notify` | `Stop` | Notificacao desktop e snapshot de auto-handoff sem criar arquivos untracked. |

## Como Alterar

1. Edite logica e testes em `~/.agents/hooks/`, rode `uv run --with pytest pytest ~/.agents/hooks/tests -q`, faca commit e push.
2. Para adicionar, remover ou ajustar timeout de um hook, edite `antigravityHooks` em `programs/antigravity.nix` e atualize `tests/programs/test_antigravity.py`.
3. Aplique com `./switch.sh`.

## Valvulas de Escape

- `AGENT_HOOKS_DISABLE_COMPACT=1`: desativa a compactacao de saida.
- `AGENT_HOOKS_DISABLE_NOTIFY=1`: desativa notificacoes desktop.
- `ALLOW_MD_EMOJI=1`: permite emojis em Markdown.
- Para desativar um hook, remova-o de `antigravityHooks` (ou use `"enabled": false`).
