def test_antigravity_installed(home_manager_build):
    assert (home_manager_build / "home-path/bin/agy").exists()

def test_antigravity_configs_generated(home_manager_build):
    """Verifies that antigravity-cli config files are generated in ~/.gemini/antigravity-cli/."""
    settings = home_manager_build / "home-files/.gemini/antigravity-cli/settings.json"
    
    assert settings.exists()
    
    import json
    settings_data = json.loads(settings.read_text())
    assert settings_data["security"]["auth"]["selectedType"] == "oauth-personal"
    assert "github" in settings_data["mcpServers"]
    assert "discourse" in settings_data["mcpServers"]
    assert "google-calendar" in settings_data["mcpServers"]
    assert "notion" in settings_data["mcpServers"]
    assert "math" in settings_data["mcpServers"]
    assert "audioscrape" in settings_data["mcpServers"]
    assert "rss-reader" in settings_data["mcpServers"]
    assert "linkedin" in settings_data["mcpServers"]
    assert "google-maps" in settings_data["mcpServers"]
    assert "eventbrite" in settings_data["mcpServers"]
    assert "opengraph" in settings_data["mcpServers"]
    
    # Check trustedWorkspaces
    assert "/home/brantes" in settings_data["trustedWorkspaces"]
