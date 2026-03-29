import subprocess
import pytest

def test_weechat_installed(home_manager_build):
    """Verifies that the weechat binary is installed."""
    bin_path = home_manager_build / "home-path/bin/weechat"
    assert bin_path.exists()
    assert bin_path.is_file()
