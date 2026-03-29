import subprocess
import pytest

def test_tailscale_installed(home_manager_build):
    """Verifies that the tailscale binary is installed."""
    bin_path = home_manager_build / "home-path/bin/tailscale"
    assert bin_path.exists()
    assert bin_path.is_file()
