import subprocess
import pytest

def test_coreutils_installed(home_manager_build):
    bin_path = home_manager_build / "home-path/bin/ls"
    assert bin_path.exists()

    cmd = [str(bin_path), "--version"]
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode == 0:
        assert "ls" in result.stdout or "coreutils" in result.stdout
    else:
        coreutils_bin = home_manager_build / "home-path/bin/coreutils"
        assert coreutils_bin.exists()
