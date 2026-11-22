def test_opencode_installed(home_manager_build):
    """Verifies that the opencode binary is installed."""
    binary = home_manager_build / "home-path/bin/opencode"

    assert binary.exists()
    assert binary.is_file()
