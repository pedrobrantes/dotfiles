def test_dust_installed(home_manager_build):
    assert (home_manager_build / "home-path/bin/dust").exists()

def test_dust_alias(home_manager_build):
    bashrc = home_manager_build / "home-files/.bashrc"
    # Matches: du='dust --depth 10'
    assert "du='dust --depth 10'" in bashrc.read_text()
