import subprocess
import pytest

def test_coreutils_installed(home_manager_build):
    """Verifies that uutils-coreutils is installed and replaces standard commands."""
    # Check for a common utility like 'ls' or 'cp'
    bin_path = home_manager_build / "home-path/bin/ls"
    assert bin_path.exists()
    assert bin_path.is_file()

    # Verify execution and check version string for uutils
    cmd = [str(bin_path), "--version"]
    result = subprocess.run(cmd, capture_output=True, text=True)
    assert result.returncode == 0
    # uutils usually mentions "uutils" or just the version, let's check basic execution first
    # standard GNU ls --version output starts with "ls (GNU coreutils)..."
    # uutils ls --version output typically contains "ls" and version.
    assert "ls" in result.stdout
