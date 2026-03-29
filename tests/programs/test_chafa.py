import subprocess
import pytest

def test_chafa_installed(home_manager_build):
    """Verifies that the chafa binary is installed."""
    bin_path = home_manager_build / "home-path/bin/chafa"
    assert bin_path.exists()
    assert bin_path.is_file()
