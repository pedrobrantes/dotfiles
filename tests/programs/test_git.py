import shutil
import os

def test_git_package_installed(home_manager_build):
    """Verifies that the git binary is available in the build output."""
    git_bin = home_manager_build / "home-path/bin/git"
    assert git_bin.exists(), f"Git binary not found at {git_bin}"
    assert git_bin.is_file()
    assert os.access(git_bin, os.X_OK), "Git binary is not executable"

def test_git_config_content(home_manager_build):
    """Verifies that the generated git config contains the user name."""
    # Note: home-manager links config files to home-files/.config/...
    git_config = home_manager_build / "home-files/.config/git/config"
    
    assert git_config.exists(), "Git config file not generated"
    
    content = git_config.read_text()
    assert "PedroBrantes" in content, "User name not found in git config"
