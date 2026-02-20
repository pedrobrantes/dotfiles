def test_mov_cli_installed(home_manager_build):
    """Verifies mov-cli and mpv installation."""
    mov_bin = home_manager_build / "home-path/bin/mov-cli"
    mpv_bin = home_manager_build / "home-path/bin/mpv"
    
    assert mov_bin.exists()
    assert mpv_bin.exists()
