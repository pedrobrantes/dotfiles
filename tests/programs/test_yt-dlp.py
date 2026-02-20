def test_yt_dlp_installed(home_manager_build):
    """Verifies yt-dlp installation and aliases."""
    bin_path = home_manager_build / "home-path/bin/yt-dlp"
    assert bin_path.exists()

def test_yt_dlp_aliases(home_manager_build):
    bashrc = home_manager_build / "home-files/.bashrc"
    content = bashrc.read_text()
    assert "alias b=" in content
    assert "alias bmusic=" in content
