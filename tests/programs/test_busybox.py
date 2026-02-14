import subprocess
import pytest

def test_busybox_installed(home_manager_build):
    """Verifies that busybox is installed and available in the path."""
    bin_path = home_manager_build / "home-path/bin/busybox"
    assert bin_path.exists()
    assert bin_path.is_file()

    # Verify execution
    cmd = [str(bin_path), "--help"]
    result = subprocess.run(cmd, capture_output=True, text=True)
    assert result.returncode == 0
    assert "BusyBox" in result.stdout
