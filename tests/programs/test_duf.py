def test_duf_installed(home_manager_build):
    assert (home_manager_build / "home-path/bin/duf").exists()

def test_duf_alias(home_manager_build):
    bashrc = home_manager_build / "home-files/.bashrc"
    assert "df=duf" in bashrc.read_text()
