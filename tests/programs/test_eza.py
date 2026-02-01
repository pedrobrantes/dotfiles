def test_eza_installed(home_manager_build):
    assert (home_manager_build / "home-path/bin/eza").exists()

def test_eza_alias(home_manager_build):
    bashrc = home_manager_build / "home-files/.bashrc"
    # Matches: ls='eza --icons'
    assert "ls='eza --icons'" in bashrc.read_text()
