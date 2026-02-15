import subprocess
import pytest

def test_sd_installed(home_manager_build):
    bin_path = home_manager_build / "home-path/bin/sd"
    assert bin_path.exists()
    
    cmd = [str(bin_path), "--version"]
    result = subprocess.run(cmd, capture_output=True, text=True)
    assert result.returncode == 0
    assert "sd" in result.stdout
