def test_doggo_installed(home_manager_build):
    doggo_bin = home_manager_build / "home-path/bin/doggo"
    assert doggo_bin.exists()

def test_doggo_aliases(home_manager_build):
    bashrc = home_manager_build / "home-files/.bashrc"
    content = bashrc.read_text()
    assert "nslookup=doggo" in content
    assert "dig=doggo" in content
