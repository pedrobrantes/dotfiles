def test_github_cli_installed(home_manager_build):
    assert (home_manager_build / "home-path/bin/gh").exists()
    
# We can't easily test 'gh config get' in a pure build environment without mocking
# or setting up a fake HOME for execution, so we verify binary presence only for now.
