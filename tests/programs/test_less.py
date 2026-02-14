import subprocess
import pytest

def test_less_installed(home_manager_build):
    """Verifies that less is installed and available in the path."""
    bin_path = home_manager_build / "home-path/bin/less"
    assert bin_path.exists()
    assert bin_path.is_file()

    # Verify execution
    cmd = [str(bin_path), "--version"]
    result = subprocess.run(cmd, capture_output=True, text=True)
    assert result.returncode == 0
    assert "less" in result.stdout
