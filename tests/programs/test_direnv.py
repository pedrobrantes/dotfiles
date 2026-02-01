def test_direnv_installed(home_manager_build):
    """Verifies that direnv binary is installed."""
    bin_path = home_manager_build / "home-path/bin/direnv"
    assert bin_path.exists()

def test_direnv_hook_bash(home_manager_build):
    """Verifies that direnv hook is present in bashrc."""
    bashrc = home_manager_build / "home-files/.bashrc"
    content = bashrc.read_text()
    # Home manager uses absolute path, so we check for the hook command part
    assert 'direnv hook bash' in content
