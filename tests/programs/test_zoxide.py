def test_zoxide_installed(home_manager_build):
    assert (home_manager_build / "home-path/bin/zoxide").exists()

def test_zoxide_config(home_manager_build):
    bashrc = home_manager_build / "home-files/.bashrc"
    content = bashrc.read_text()
    assert "zoxide init bash" in content
    # zoxide manages the 'cd' alias internally or via the module, check if 'z' alias is common
    assert "cd=z" in content
