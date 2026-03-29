import subprocess
import pytest

def test_glow_installed(home_manager_build):
    """Verifies that the glow binary is installed."""
    bin_path = home_manager_build / "home-path/bin/glow"
    assert bin_path.exists()
    assert bin_path.is_file()
