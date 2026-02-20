def test_media_manager_installed(home_manager_build):
    """Verifies that the Media Manager function is in the bashrc."""
    bashrc = home_manager_build / "home-files/.bashrc"
    assert bashrc.exists()
    
    content = bashrc.read_text()
    assert "mm()" in content
    assert "archive.org" in content
    assert "--- Saved Media Sources ---" in content