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
    assert "google-calendar" in servers
    assert "notion" in servers
    assert "math" in servers
    assert "audioscrape" in servers
    assert "rss-reader" in servers
    assert "linkedin" in servers
    assert "google-maps" in servers
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
