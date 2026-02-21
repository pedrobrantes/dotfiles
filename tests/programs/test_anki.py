def test_anki_installed(home_manager_build):
    """Verifies that the Anki study functions are in the bashrc."""
    bashrc = home_manager_build / "home-files/.bashrc"
    assert bashrc.exists()

    content = bashrc.read_text()
    assert "anki-sync()" in content
    assert "anki-view()" in content
    assert "anki-sync-internal" in content
    assert "anki-view-internal" in content
