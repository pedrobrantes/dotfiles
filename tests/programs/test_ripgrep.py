def test_ripgrep_installed(home_manager_build):
    assert (home_manager_build / "home-path/bin/rg").exists()

def test_ripgrep_alias(home_manager_build):
    bashrc = home_manager_build / "home-files/.bashrc"
    assert "grep=rg" in bashrc.read_text()
