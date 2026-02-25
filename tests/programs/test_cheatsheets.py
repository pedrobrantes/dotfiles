import subprocess
import pytest

def test_cheatsheets_installed(home_manager_build):
    tldr_path = home_manager_build / "home-path/bin/tldr"
    cheat_path = home_manager_build / "home-path/bin/cheat"
    
    assert tldr_path.exists()
    assert cheat_path.exists()
    
    # Verify tldr (tealdeer)
    cmd_tldr = [str(tldr_path), "--version"]
    res_tldr = subprocess.run(cmd_tldr, capture_output=True, text=True)
    assert res_tldr.returncode == 0
    assert "tealdeer" in res_tldr.stdout

def test_cheat_config_generated(home_manager_build):
    """Verifies that the cheat config file is generated correctly."""
    config_file = home_manager_build / "home-files/.config/cheat/conf.yml"
    assert config_file.exists()
    
    content = config_file.read_text()
    assert "name: personal" in content
    assert "tags: [ personal ]" in content

def test_cheat_sync_alias(home_manager_build):
    """Verifies that the cheat-sync function is present in bashrc."""
    bashrc = home_manager_build / "home-files/.bashrc"
    content = bashrc.read_text()
    assert "cheat-sync()" in content
    # Checking for alias with flexible quoting
    assert "alias csync=" in content
    assert "cheat-sync" in content
