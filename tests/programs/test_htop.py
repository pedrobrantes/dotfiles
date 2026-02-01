def test_htop_installed(home_manager_build):
    assert (home_manager_build / "home-path/bin/htop").exists()

def test_htop_alias(home_manager_build):
    bashrc = home_manager_build / "home-files/.bashrc"
    assert "top=htop" in bashrc.read_text()
