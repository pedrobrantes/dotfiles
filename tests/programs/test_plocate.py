def test_plocate_installed(home_manager_build):
    assert (home_manager_build / "home-path/bin/plocate").exists()

def test_plocate_alias(home_manager_build):
    bashrc = home_manager_build / "home-files/.bashrc"
    assert "locate=plocate" in bashrc.read_text()
