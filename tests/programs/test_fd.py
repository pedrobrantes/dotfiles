def test_fd_installed(home_manager_build):
    assert (home_manager_build / "home-path/bin/fd").exists()

def test_fd_aliases(home_manager_build):
    bashrc = home_manager_build / "home-files/.bashrc"
    content = bashrc.read_text()
    assert "find=fd" in content
