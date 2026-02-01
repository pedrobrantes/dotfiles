def test_bat_installed(home_manager_build):
    """Verifies bat installation and aliases."""
    # Check binary (note: binary name is 'bat' in nixpkgs)
    bat_bin = home_manager_build / "home-path/bin/bat"
    assert bat_bin.exists()

def test_bat_alias(home_manager_build):
    """Verifies that 'cat' is aliased to 'bat'."""
    bashrc = home_manager_build / "home-files/.bashrc"
    content = bashrc.read_text()
    # Looking for exact alias definition
    assert 'alias cat="bat"' in content or "alias cat='bat'" in content or "cat=bat" in content
