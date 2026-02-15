import subprocess
import pytest

def test_aria2_installed(home_manager_build):
    bin_path = home_manager_build / "home-path/bin/aria2c"
    assert bin_path.exists()
    
    cmd = [str(bin_path), "--version"]
    result = subprocess.run(cmd, capture_output=True, text=True)
    assert result.returncode == 0
    assert "aria2" in result.stdout
