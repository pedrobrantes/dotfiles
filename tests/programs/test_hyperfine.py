def test_hyperfine_installed(home_manager_build):
    assert (home_manager_build / "home-path/bin/hyperfine").exists()

def test_hyperfine_alias(home_manager_build):
    bashrc = home_manager_build / "home-files/.bashrc"
    assert "benchmark=hyperfine" in bashrc.read_text()
