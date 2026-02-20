def test_fzf_installed(home_manager_build):
    """Verifies that the fzf binary is installed."""
    fzf_bin = home_manager_build / "home-path/bin/fzf"
    assert fzf_bin.exists()
