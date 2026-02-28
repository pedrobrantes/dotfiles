def test_gemini_installed(home_manager_build):
    assert (home_manager_build / "home-path/bin/gemini").exists()

def test_gemini_configs_generated(home_manager_build):
    """Verifies that gemini-cli config files are generated in ~/.gemini/."""
    settings = home_manager_build / "home-files/.gemini/settings.json"
    projects = home_manager_build / "home-files/.gemini/projects.json"
    trusted = home_manager_build / "home-files/.gemini/trustedFolders.json"
    
    assert settings.exists()
    assert projects.exists()
    assert trusted.exists()
    
    import json
    settings_data = json.loads(settings.read_text())
    assert settings_data["security"]["auth"]["selectedType"] == "oauth-personal"
    assert "github" in settings_data["mcpServers"]
