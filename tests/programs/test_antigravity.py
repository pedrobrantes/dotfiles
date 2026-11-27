def test_antigravity_installed(home_manager_build):
    assert (home_manager_build / "home-path/bin/agy").exists()

def test_antigravity_configs_generated(home_manager_build):
    """Verifies that antigravity-cli config files and mcp_config.json are generated."""
    settings = home_manager_build / "home-files/.gemini/antigravity-cli/settings.json"
    mcp_config = home_manager_build / "home-files/.gemini/antigravity-cli/mcp_config.json"
    global_mcp_config = home_manager_build / "home-files/.gemini/config/mcp_config.json"
    
    assert settings.exists()
    assert mcp_config.exists()
    assert global_mcp_config.exists()
    
    import json
    settings_data = json.loads(settings.read_text())
    mcp_data = json.loads(mcp_config.read_text())

    assert settings_data["security"]["auth"]["selectedType"] == "oauth-personal"
    
    servers = mcp_data["mcpServers"]
    assert "github" in servers
    assert "discourse" in servers
    assert "google-workspace" in servers
    assert "classroom" in servers
    assert "google-developer-knowledge" in servers
    assert "notion" in servers
    assert "math" in servers
    assert "audioscrape" in servers
    assert "rss-reader" in servers
    assert "linkedin" in servers
    assert "eventbrite" in servers
    assert "opengraph" in servers
    assert "grep" in servers
    assert "huggingface" in servers
    assert "supabase" in servers
    assert "figma" in servers
    assert "stripe" in servers
    assert "serverUrl" in servers["github"]
    
    # Check trustedWorkspaces
    assert "/home/brantes" in settings_data["trustedWorkspaces"]


def test_antigravity_hooks_generated(home_manager_build):
    """Verifies global ~/.gemini/config/hooks.json is generated with expected lifecycle hooks."""
    import json

    hooks_file = home_manager_build / "home-files/.gemini/config/hooks.json"
    assert hooks_file.exists()

    hooks_data = json.loads(hooks_file.read_text())
    expected_hooks = {
        "session-context": "SessionStart",
        "safety-guard": "PreToolUse",
        "token-guard": "PreToolUse",
        "engineering-guard": "PreToolUse",
        "auto-format": "PostToolUse",
        "audit-telemetry": "PostToolUse",
        "quality-hygiene-gate": "Stop",
        "handoff-and-notify": "Stop",
    }
    for name, event_key in expected_hooks.items():
        assert name in hooks_data, f"Missing hook: {name}"
        assert event_key in hooks_data[name], f"Hook {name} missing event {event_key}"
        assert ".agents/hooks/dispatch.py --agent agy --hook " in json.dumps(hooks_data[name])
