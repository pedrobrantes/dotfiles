import json


def test_opencode_installed(home_manager_build):
    """Verifies that the opencode binary is installed."""
    binary = home_manager_build / "home-path/bin/opencode"

    assert binary.exists()
    assert binary.is_file()


def test_opencode_config(home_manager_build):
    """Verifies that opencode V2 config, permissions, shared AGENTS.md, and commands are generated."""
    config_file = home_manager_build / "home-files/.config/opencode/opencode.json"
    assert config_file.exists()

    data = json.loads(config_file.read_text())
    assert data.get("$schema") == "https://opencode.ai/config.json"
    assert data.get("autoupdate") is False
    assert "google" in data.get("provider", {})
    assert data["mcp"]["context7"]["enabled"] is True
    assert data["mcp"]["obsidian"]["enabled"] is True
    assert data["mcp"]["github"]["enabled"] is False

    perms = data.get("permissions", [])
    assert {"action": "read", "resource": "*.env", "effect": "deny"} in perms
    assert {"action": "shell", "resource": "check *", "effect": "allow"} in perms
    assert {"action": "shell", "resource": "git push --force*", "effect": "deny"} in perms

    rules_file = home_manager_build / "home-files/.config/opencode/AGENTS.md"
    assert rules_file.is_symlink()

    handoff_cmd = home_manager_build / "home-files/.config/opencode/command/handoff.md"
    resume_cmd = home_manager_build / "home-files/.config/opencode/command/resume.md"
    assert handoff_cmd.exists()
    assert resume_cmd.exists()
