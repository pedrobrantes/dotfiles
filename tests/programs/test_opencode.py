import json


def test_opencode_installed(home_manager_build):
    """Verifies that the opencode binary is installed."""
    binary = home_manager_build / "home-path/bin/opencode"

    assert binary.exists()
    assert binary.is_file()


def test_opencode_config(home_manager_build):
    """Verifies that opencode config.json, shared AGENTS.md symlink, and handoff commands are generated."""
    config_file = home_manager_build / "home-files/.config/opencode/config.json"
    assert config_file.exists()

    data = json.loads(config_file.read_text())
    assert data.get("$schema") == "https://opencode.ai/config.json"
    assert data.get("autoupdate") is False
    assert "google" in data.get("provider", {})
    assert data["mcp"]["context7"]["enabled"] is True
    assert data["mcp"]["obsidian"]["enabled"] is True
    assert data["mcp"]["github"]["enabled"] is False

    rules_file = home_manager_build / "home-files/.config/opencode/AGENTS.md"
    assert rules_file.is_symlink()

    handoff_cmd = home_manager_build / "home-files/.config/opencode/command/handoff.md"
    resume_cmd = home_manager_build / "home-files/.config/opencode/command/resume.md"
    assert handoff_cmd.exists()
    assert resume_cmd.exists()
