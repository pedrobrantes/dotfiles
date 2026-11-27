# AI Agent Lifecycle Hooks

[Versao em Portugues (PT-BR)](./AI_AGENT_HOOKS.pt-BR.md)

## Overview

Lifecycle hooks for AI coding agents follow a thin-adapter design:

- **Core logic** lives in the `~/.agents` repository (`~/.agents/hooks/`, Python 3 stdlib only). See its README for hook details.
- **Agent wiring** lives here. `programs/antigravity.nix` generates `~/.gemini/config/hooks.json`, which calls:

```text
${pkgs.python3}/bin/python3 ~/.agents/hooks/dispatch.py --agent agy --hook <name>
```

## Enabled Hooks (agy)

| Hook | Event | Purpose |
| :--- | :--- | :--- |
| `session-context` | `SessionStart` | Injects branch, `git status`, and `HANDOFF.md`/`PROGRESS.md` excerpts (max 30 lines). |
| `safety-guard` | `PreToolUse` | Mirrors the `opencode.nix` denylist, blocks hardcoded secrets, forces confirmation on push/deploy. Fails closed. |
| `token-guard` | `PreToolUse` | Blocks reads of build/cache dirs and lockfiles, explosive shell commands, and compacts verbose test/diff output. |
| `engineering-guard` | `PreToolUse` | Blocks `./switch.sh` with untracked files or missing `tests/programs/test_<name>.py`; blocks emojis in Markdown. |
| `auto-format` | `PostToolUse` | Formats the edited file (ruff, gofmt, rustfmt, nixfmt, prettier) when available. |
| `audit-telemetry` | `PostToolUse` | Redacted JSONL log with token estimates in `~/.local/share/agent-hooks/` (30-day retention). |
| `quality-hygiene-gate` | `Stop` | Diff-scoped lint and hygiene checks, at most once per turn. |
| `handoff-and-notify` | `Stop` | Desktop notification and auto-handoff snapshot without creating untracked files. |

## Changing Hooks

1. Edit logic and tests in `~/.agents/hooks/`, run `uv run --with pytest pytest ~/.agents/hooks/tests -q`, commit, and push.
2. To add, remove, or retime a hook, edit `antigravityHooks` in `programs/antigravity.nix` and update `tests/programs/test_antigravity.py`.
3. Apply with `./switch.sh`.

## Escape Hatches

- `AGENT_HOOKS_DISABLE_COMPACT=1`: disable output compaction.
- `AGENT_HOOKS_DISABLE_NOTIFY=1`: disable desktop notifications.
- `ALLOW_MD_EMOJI=1`: allow emojis in Markdown.
- Temporarily disable a hook by setting `"enabled": false` for it in the generated config, or remove it from `antigravityHooks`.
