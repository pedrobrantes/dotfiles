import subprocess
import pytest

def test_mediainfo_installed(home_manager_build):
    """Verifies that the mediainfo binary is installed."""
    bin_path = home_manager_build / "home-path/bin/mediainfo"
    assert bin_path.exists()
    assert bin_path.is_file()
