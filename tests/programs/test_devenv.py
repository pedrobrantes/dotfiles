def test_devenv_installed(home_manager_build):
    """Verifies that devenv is installed."""
    bin_path = home_manager_build / "home-path/bin/devenv"
    assert bin_path.exists()
