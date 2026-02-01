def test_uv_installed(home_manager_build):
    """Verifies that the uv binary is available in the build output."""
    uv_bin = home_manager_build / "home-path/bin/uv"
    assert uv_bin.exists()

def test_uv_aliases(home_manager_build):
    """Verifies that uv aliases are present in the bashrc."""
    bashrc = home_manager_build / "home-files/.bashrc"
    content = bashrc.read_text()
    assert "uvp=" in content
