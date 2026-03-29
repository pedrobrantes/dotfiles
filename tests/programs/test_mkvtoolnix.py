import subprocess
import pytest

def test_mkvtoolnix_installed(home_manager_build):
    """Verifies that mkvmerge (from mkvtoolnix) is installed."""
    bin_path = home_manager_build / "home-path/bin/mkvmerge"
    assert bin_path.exists()
    assert bin_path.is_file()
