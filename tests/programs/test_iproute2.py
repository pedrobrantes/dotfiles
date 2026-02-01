def test_iproute2_installed(home_manager_build):
    assert (home_manager_build / "home-path/bin/ss").exists()
    assert (home_manager_build / "home-path/bin/ip").exists()

def test_iproute2_aliases(home_manager_build):
    bashrc = home_manager_build / "home-files/.bashrc"
    content = bashrc.read_text()
    assert "netstat=ss" in content
    assert "ips='ip -c -br a'" in content
    assert "ifconfig=ip" in content
