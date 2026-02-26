def test_tmux_installed(home_manager_build):
    """Verifies tmux installation."""
    tmux_bin = home_manager_build / "home-path/bin/tmux"
    assert tmux_bin.exists()
