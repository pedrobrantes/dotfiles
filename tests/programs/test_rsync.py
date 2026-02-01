def test_rsync_installed(home_manager_build):
    assert (home_manager_build / "home-path/bin/rsync").exists()
