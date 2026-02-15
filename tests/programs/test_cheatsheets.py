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

    # Verify cheat
    cmd_cheat = [str(cheat_path), "--version"]
    res_cheat = subprocess.run(cmd_cheat, capture_output=True, text=True)
    assert res_cheat.returncode == 0
    assert "cheat" in res_cheat.stdout
