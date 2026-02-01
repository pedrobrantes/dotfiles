def test_bitwarden_installed(home_manager_build):
    # bitwarden-cli provides 'bw'
    assert (home_manager_build / "home-path/bin/bw").exists()
