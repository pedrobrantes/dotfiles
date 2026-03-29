import subprocess
import pytest

def test_httpie_installed(home_manager_build):
    """Verifies that the httpie (http) binary is installed."""
    bin_path = home_manager_build / "home-path/bin/http"
    assert bin_path.exists()
    assert bin_path.is_file()
