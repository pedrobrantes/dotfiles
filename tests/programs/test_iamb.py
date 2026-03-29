import subprocess
import pytest

def test_iamb_installed(home_manager_build):
    """Verifies that the iamb binary is installed."""
    bin_path = home_manager_build / "home-path/bin/iamb"
    assert bin_path.exists()
    assert bin_path.is_file()

def test_iamb_alias(home_manager_build):
    """Verifies that the 'matrix' alias is present in bashrc."""
    bashrc = home_manager_build / "home-files/.bashrc"
    content = bashrc.read_text()
    assert "alias matrix=" in content
    assert "iamb" in content
