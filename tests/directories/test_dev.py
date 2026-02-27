def test_dev_directory_activation_exists(home_manager_build):
    """
    Verifies that the git binary used in the activation script is available.
    Activation scripts themselves are not executed during the nix build phase.
    """
    git_bin = home_manager_build / "home-path/bin/git"
    assert git_bin.exists()
